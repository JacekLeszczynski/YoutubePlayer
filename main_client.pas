unit main_client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, NetSocket, ExtMessage, lNet, Types;

type

  { TFClient }

  TFClient = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ListBox1: TListBox;
    mess: TExtMessage;
    PageControl1: TPageControl;
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
    procedure timer_startTimer(Sender: TObject);
    procedure timer_stopTimer(Sender: TObject);
    procedure restart;
  private
    wektor_czasu: integer;
    procedure zakladki(aStart: boolean = true);
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
  b:=false;
  ss:=DecryptString(Edit1.Text,dm.GetHashCode(1));
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
  if not tcp.Connect then
    mess.ShowInformation('Nie mogę się połączyć ze zdalnym serwisem, być może nie jest jeszcze uruchomiony.^^Możesz spróbować później, w czasie trwania transmisji.');
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
      Label7.Caption:=GetLineToStr(ss,5,'$');
      pom1:=GetLineToStr(ss,6,'$');
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
  StatusBar1.Panels[1].Text:='Różnica czasu: '+IntToStr(wektor_czasu);
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
    TabSheet3.TabVisible:=true;
    PageControl1.ActivePageIndex:=1;
  end;
end;

end.

