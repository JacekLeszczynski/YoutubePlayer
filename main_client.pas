unit main_client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, TplProgressBarUnit, NetSocket, ExtMessage, LiveTimer,
  lNet, Types;

type

  { TFClient }

  TFClient = class(TForm)
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    Memo1: TMemo;
    timer_pp: TIdleTimer;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    czas_atomowy: TLiveTimer;
    mess: TExtMessage;
    PageControl1: TPageControl;
    pp: TplProgressBar;
    StatusBar1: TStatusBar;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet1: TTabSheet;
    tcp: TNetSocket;
    timer_stop: TTimer;
    timer_start: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure tcpConnect(aSocket: TLSocket);
    procedure tcpCryptString(var aText: string);
    procedure tcpDecryptString(var aText: string);
    procedure tcpDisconnect(aSocket: TLSocket);
    procedure tcpError(const aMsg: string; aSocket: TLSocket);
    procedure tcpReceiveString(aMsg: string; aSocket: TLSocket);
    procedure tcpTimeVector(aTimeVector: integer);
    procedure timer_ppTimer(Sender: TObject);
    procedure timer_startTimer(Sender: TObject);
    procedure timer_stopTimer(Sender: TObject);
    procedure restart;
  private
    wektor_czasu: integer;
    procedure zakladki(aStart: boolean = true);
    procedure update_pp(aTimeAct,aFilmLength,aFilmPos,aStat: integer);
  public

  end;

var
  FClient: TFClient;

implementation

uses
  ecode, serwis, LCLType;

var
  indeks_czas: integer = -1;

{$R *.lfm}

{ TFClient }

procedure TFClient.BitBtn1Click(Sender: TObject);
var
  ss,s: string;
  i: integer;
  b: boolean;
begin
  if tcp.Active then tcp.Disconnect;
  if CheckBox1.Checked then
  begin
    tcp.Host:='localhost';
    if not tcp.Connect then mess.ShowInformation('Nie mogę się połączyć ze lokalnym serwisem, być może nie jest jeszcze uruchomiony.');
  end else
  if Memo1.Lines.Count=0 then
  begin
    tcp.Host:='studiojahu.duckdns.org';
    if not tcp.Connect then mess.ShowInformation('Nie mogę się połączyć ze lokalnym serwisem, być może nie jest jeszcze uruchomiony.');
  end else begin
    b:=false;
    ss:=DecryptString(Memo1.Text,dm.GetHashCode(1));
    i:=1;
    while true do
    begin
      s:=GetLineToStr(ss,i,',');
      if s='' then break;
      if ecode.IsDigit(s[1]) then
      begin
        b:=true;
        break;
      end;
      inc(i);
    end;
    if not b then
    begin
      mess.ShowInformation('Podany klucz jest niewłaściwy.');
      exit;
    end;
    tcp.Host:=s;
    if not tcp.Connect then mess.ShowInformation('Nie mogę się połączyć ze zdalnym serwisem, być może nie jest jeszcze uruchomiony.^^Możesz spróbować później, w czasie trwania transmisji.');
  end;
end;

procedure TFClient.FormCreate(Sender: TObject);
begin
  zakladki;
end;

procedure TFClient.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  if Index=indeks_czas then ListBox1.Canvas.Brush.Color:=clYellow
                       else ListBox1.Canvas.Brush.Color:=clWhite;
  ListBox1.Canvas.FillRect(ARect);
  ListBox1.Canvas.Font.Bold:=false;
  ListBox1.Canvas.Font.Color:=clGray;
  if Index=indeks_czas then
  begin
    ListBox1.Canvas.Font.Bold:=true;
    ListBox1.Canvas.Font.Color:=clBlack;
  end;
  ListBox1.Canvas.TextRect(ARect,2,ARect.Top+2,ListBox1.Items[Index]);
end;

procedure TFClient.tcpConnect(aSocket: TLSocket);
begin
  StatusBar1.Panels[0].Text:='Połączenie: OK';
  timer_start.Enabled:=true;
  zakladki(false);
end;

procedure TFClient.tcpCryptString(var aText: string);
begin
  aText:=EncryptString(aText,dm.GetHashCode(2));
end;

procedure TFClient.tcpDecryptString(var aText: string);
begin
  aText:=DecryptString(aText,dm.GetHashCode(2));
end;

procedure TFClient.tcpDisconnect(aSocket: TLSocket);
begin
  restart;
end;

procedure TFClient.tcpError(const aMsg: string; aSocket: TLSocket);
begin
  if pos('connection refused',aMsg)>0 then
    mess.ShowInformation('Nie mogę się połączyć ze zdalnym serwisem, być może nie jest jeszcze uruchomiony.^^Możesz spróbować później, w czasie trwania transmisji.')
  else
    mess.ShowWarning('Wystąpił błąd gniazda o takim komunikacie:^^'+aMsg);
end;

procedure TFClient.tcpReceiveString(aMsg: string; aSocket: TLSocket);
var
  l,i: integer;
  ss,s,pom1,pom2: string;
  czas_aktualny,film_duration,film_pos,film_stat: integer;
  film_filename: string;
begin
  l:=1;
  while true do
  begin
    ss:=GetLineToStr(aMsg,l,#10);
    if ss='' then break;
    s:=GetLineToStr(ss,1,'$');

    if s='{EXIT}' then
    begin
      timer_stop.Enabled:=true;
      break;
    end else
    if s='{READ_ALL}' then
    begin
      indeks_czas:=StrToInt(GetLineToStr(ss,2,'$'));
      Label3.Caption:=GetLineToStr(ss,3,'$');
      Label5.Caption:=GetLineToStr(ss,4,'$');
      film_stat:=StrToInt(GetLineToStr(ss,5,'$','0'));
      film_filename:=GetLineToStr(ss,6,'$','');
      czas_aktualny:=StrToInt(GetLineToStr(ss,7,'$','0'));
      film_duration:=StrToInt(GetLineToStr(ss,8,'$','0'));
      film_pos:=StrToInt(GetLineToStr(ss,9,'$','0'));
      Label7.Caption:=GetLineToStr(ss,10,'$');
      pom1:=GetLineToStr(ss,11,'$');
      ListBox1.Clear;
      i:=1;
      while true do
      begin
        pom2:=GetLineToStr(pom1,i,'|');
        if pom2='' then break;
        ListBox1.Items.AddStrings(pom2);
        inc(i);
      end;
      if ListBox1.Items.Count>indeks_czas then ListBox1.ItemIndex:=indeks_czas;
      update_pp(czas_aktualny,film_duration,film_pos,film_stat);
    end else
    if s='{RAMKA_PP}' then
    begin
      film_stat:=StrToInt(GetLineToStr(ss,2,'$','0'));
      film_filename:=GetLineToStr(ss,3,'$','');
      czas_aktualny:=StrToInt(GetLineToStr(ss,4,'$','0'));
      film_duration:=StrToInt(GetLineToStr(ss,5,'$','0'));
      film_pos:=StrToInt(GetLineToStr(ss,6,'$','0'));
      update_pp(czas_aktualny,film_duration,film_pos,film_stat);
    end else
    if s='{INDEX_CZASU}' then
    begin
      indeks_czas:=StrToInt(GetLineToStr(ss,2,'$'));
      ListBox1.Refresh;
      if ListBox1.Items.Count>indeks_czas then ListBox1.ItemIndex:=indeks_czas;
    end;

    inc(l);
  end;
end;

procedure TFClient.tcpTimeVector(aTimeVector: integer);
begin
  wektor_czasu:=aTimeVector;
  czas_atomowy.Correction:=wektor_czasu;
  StatusBar1.Panels[1].Text:='Różnica czasu: '+IntToStr(wektor_czasu);
end;

procedure TFClient.timer_ppTimer(Sender: TObject);
var
  a: integer;
  b: boolean;
  aa: TTime;
begin
  a:=czas_atomowy.GetIndexTime;
  pp.Position:=a;
  aa:=IntegerToTime(a);
  b:=a<3600000;
  if b then Label9.Caption:=FormatDateTime('nn:ss',aa) else Label9.Caption:=FormatDateTime('h:nn:ss',aa);
end;

procedure TFClient.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  tcp.GetTimeVector;
  tcp.SendString('{READ_ALL}');
end;

procedure TFClient.timer_stopTimer(Sender: TObject);
begin
  timer_stop.Enabled:=false;
  tcp.Disconnect;
  restart;
  Application.ProcessMessages;
end;

procedure TFClient.restart;
begin
  zakladki;
  indeks_czas:=-1;
  StatusBar1.Panels[0].Text:='Połączenie: Brak';
  StatusBar1.Panels[1].Text:='Różnica czasu: ---';
  Label3.Caption:='';
  Label5.Caption:='';
  Label7.Caption:='';
  ListBox1.Clear;
end;

procedure TFClient.zakladki(aStart: boolean);
begin
  if aStart then
  begin
    TabSheet1.TabVisible:=true;
    TabSheet2.TabVisible:=false;
    TabSheet3.TabVisible:=false;
    PageControl1.ActivePageIndex:=0;
  end else begin
    TabSheet1.TabVisible:=false;
    TabSheet2.TabVisible:=true;
    TabSheet3.TabVisible:=false;
    PageControl1.ActivePageIndex:=1;
  end;
end;

procedure TFClient.update_pp(aTimeAct, aFilmLength, aFilmPos, aStat: integer);
var
  bPos,bMax: boolean;
  aa,bb: TTime;
begin
  timer_pp.Enabled:=false;
  if czas_atomowy.Active then czas_atomowy.Stop;
  if aStat=0 then
  begin
    pp.Max:=1;
    pp.Position:=0;
    Label9.Caption:='-:--';
    Label10.Caption:='-:--';
  end else begin
    if aStat=1 then czas_atomowy.Start(aTimeAct-aFilmPos);
    pp.Max:=aFilmLength;
    pp.Position:=aFilmPos;
    aa:=IntegerToTime(aFilmLength);
    bb:=IntegerToTime(aFilmPos);
    bMax:=aFilmLength<3600000;
    bPos:=aFilmPos<3600000;
    if bPos then Label9.Caption:=FormatDateTime('nn:ss',bb) else Label9.Caption:=FormatDateTime('h:nn:ss',bb);
    if bMax then Label10.Caption:=FormatDateTime('nn:ss',aa) else Label10.Caption:=FormatDateTime('h:nn:ss',aa);
    timer_pp.Enabled:=aStat=1;
  end;
end;

end.

