unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, TplProgressBarUnit, NetSocket, LiveTimer,
  ExtMessage, lNet, ueled, uETilePanel, Types;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    BitBtn1: TSpeedButton;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    CheckZawszeNaWierzchu: TCheckBox;
    czas_atomowy: TLiveTimer;
    EditNick: TEdit;
    ImageList: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    mess: TExtMessage;
    mon: TNetSocket;
    BitBtn2: TSpeedButton;
    Panel1: TPanel;
    pp: TplProgressBar;
    StatusBar1: TStatusBar;
    autorun: TTimer;
    timer_pp: TIdleTimer;
    timer_wait: TTimer;
    timer_start: TTimer;
    timer_stop: TTimer;
    propstorage: TXMLPropStorage;
    uELED1: TuELED;
    uETilePanel1: TuETilePanel;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure CheckZawszeNaWierzchuChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure monConnect(aSocket: TLSocket);
    procedure monCryptString(var aText: string);
    procedure monDecryptString(var aText: string);
    procedure monDisconnect;
    procedure monProcessMessage;
    procedure monReceiveString(aMsg: string; aSocket: TLSocket);
    procedure monTimeVector(aTimeVector: integer);
    procedure timer_ppTimer(Sender: TObject);
    procedure timer_startTimer(Sender: TObject);
    procedure timer_stopTimer(Sender: TObject);
    procedure timer_waitStartTimer(Sender: TObject);
    procedure timer_waitStopTimer(Sender: TObject);
    procedure timer_waitTimer(Sender: TObject);
  private
    dt: integer;
    wektor_czasu: integer;
    key: string;
    procedure restart;
    procedure update_pp(aTimeAct,aFilmLength,aFilmPos,aStat: integer);
    procedure send_message(aValue: string);
    procedure PanelPytanie(aValue: boolean = false);
    procedure reset_tak_nie(aWlacz: boolean; aTemat: string = '');
  public

  end;

var
  FMonitor: TFMonitor;

implementation

uses
  ecode, serwis, lcltype;

var
  C_KONIEC: boolean = false;
  indeks_czas: integer = -1;

{$R *.lfm}

{ TFMonitor }

procedure TFMonitor.monCryptString(var aText: string);
begin
  aText:=EncryptString(aText,dm.GetHashCode(2));
end;

procedure TFMonitor.monConnect(aSocket: TLSocket);
begin
  uEled1.Active:=true;
  StatusBar1.Panels[0].Text:='Połączenie: OK';
  timer_start.Enabled:=true;
end;

procedure TFMonitor.FormShow(Sender: TObject);
begin
  if not mon.Active then autorun.Enabled:=true;
end;

procedure TFMonitor.ListBox1DrawItem(Control: TWinControl; Index: Integer;
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

procedure TFMonitor.Memo1Change(Sender: TObject);
var
  a: integer;
begin
  a:=length(Memo1.Text);
  Label2.Caption:='Pytanie: ('+IntToStr(a)+' z 250 znaków)';
  if a>250 then Label2.Font.Color:=clRed else Label2.Font.Color:=clBlack;
  BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo1.Text))>0);
end;

procedure TFMonitor.Memo2Change(Sender: TObject);
var
  a: integer;
begin
  a:=length(Memo2.Text);
  Label2.Caption:='Chat - Wiadomość: ('+IntToStr(a)+' z 100 znaków)';
  if a>100 then Label2.Font.Color:=clRed else Label2.Font.Color:=clBlack;
  BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo2.Text))>0);
end;

procedure TFMonitor.autorunTimer(Sender: TObject);
begin
  autorun.Enabled:=not mon.Connect;
end;

procedure TFMonitor.BitBtn2Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  if trim(EditNick.Text)='' then
  begin
    mess.ShowWarning('Pole NICK jest obowiązkowe!');
    EditNick.SetFocus;
    exit;
  end;
  if Memo2.Visible then
  begin
    if length(Memo2.Text)>100 then
    begin
      mess.ShowWarning('Zbyt duża ilość znaków do wysłania!');
      Memo2.SetFocus;
      exit;
    end;
    if length(trim(Memo2.Text))=0 then
    begin
      mess.ShowWarning('Pusty tekst do wysłania - przerywam!');
      Memo2.SetFocus;
      exit;
    end;
  end else begin
    if length(Memo1.Text)>250 then
    begin
      mess.ShowWarning('Zbyt duża ilość znaków do wysłania!');
      Memo1.SetFocus;
      exit;
    end;
    if length(trim(Memo1.Text))=0 then
    begin
      mess.ShowWarning('Pusty tekst do wysłania - przerywam!');
      Memo1.SetFocus;
      exit;
    end;
  end;
  if Memo2.Visible then
  begin
    timer_wait.Enabled:=true;
    send_message(Memo2.Text);
  end else begin
    timer_wait.Enabled:=true;
    s:=Memo1.Text;
    if s<>'' then
    begin
      mon.SendString('{PYTANIE}$'+key+'$'+trim(EditNick.Text)+'$'+s);
      Memo1.Clear;
    end;
    Memo1.SetFocus;
  end;
end;

procedure TFMonitor.BitBtn3Click(Sender: TObject);
begin
  if BitBtn3.Font.Style=[] then
  begin
    BitBtn3.Font.Style:=[fsBold];
    BitBtn4.Font.Style:=[];
    BitBtn3.Caption:='TAK';
    BitBtn4.Caption:='Nie';
    mon.SendString('{INTERAKCJA}$'+key+'${TAK_NIE}$1');
    mess.ShowInformation('Zagłosowałeś na TAK - dziękuję za oddanie głosu.^Podczas całego głosowania swój głos możesz zmienić, głosując ponownie.');
  end;
end;

procedure TFMonitor.BitBtn4Click(Sender: TObject);
begin
  if BitBtn4.Font.Style=[] then
  begin
    BitBtn3.Font.Style:=[];
    BitBtn4.Font.Style:=[fsBold];
    BitBtn3.Caption:='Tak';
    BitBtn4.Caption:='NIE';
    mon.SendString('{INTERAKCJA}$'+key+'${TAK_NIE}$0');
    mess.ShowInformation('Zagłosowałeś na NIE - dziękuję za oddanie głosu.^Podczas całego głosowania swój głos możesz zmienić, głosując ponownie.');
  end;
end;

procedure TFMonitor.CheckZawszeNaWierzchuChange(Sender: TObject);
begin
  if CheckZawszeNaWierzchu.Checked then FormStyle:=fsStayOnTop else FormStyle:=fsNormal;
end;

procedure TFMonitor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  C_KONIEC:=true;
  if mon.Active then
  begin
    mon.Disconnect;
    sleep(250);
  end;
end;

procedure TFMonitor.FormCreate(Sender: TObject);
begin
  Caption:='Studio JAHU - Monitor (ver. '+dm.aVER+')';
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
end;

procedure TFMonitor.monDecryptString(var aText: string);
begin
  aText:=DecryptString(aText,dm.GetHashCode(2));
end;

procedure TFMonitor.monDisconnect;
begin
  uEled1.Active:=false;
  BitBtn2.Enabled:=false;
  restart;
end;

procedure TFMonitor.monProcessMessage;
begin
  Application.ProcessMessages;
end;

procedure TFMonitor.monReceiveString(aMsg: string; aSocket: TLSocket);
var
  i: integer;
  s,pom1,pom2: string;
  cam: integer;
  czas_aktualny,film_duration,film_pos,film_stat: integer;
  film_filename: string;
  b: boolean;
begin
  s:=GetLineToStr(aMsg,1,'$');

  if s='{EXIT}' then timer_stop.Enabled:=true else
  if s='{KEY-NEW}' then
  begin
    key:=GetLineToStr(aMsg,2,'$');
    propstorage.WriteString('key-ident',key);
    dt:=-1;
    BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo1.Text))>0);
    mon.SendString('{READ_ALL}');
    mon.SendString('{INFO}$'+key+'$ALL');
  end else
  if s='{KEY-OK}' then
  begin
    dt:=-1;
    BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo1.Text))>0);
    mon.SendString('{READ_ALL}');
    mon.SendString('{INFO}$'+key+'$ALL');
  end else
  if s='{READ_ALL}' then
  begin
    indeks_czas:=StrToInt(GetLineToStr(aMsg,2,'$'));
    Label5.Caption:=GetLineToStr(aMsg,3,'$');
    Label7.Caption:=GetLineToStr(aMsg,4,'$');
    film_stat:=StrToInt(GetLineToStr(aMsg,5,'$','0'));
    film_filename:=GetLineToStr(aMsg,6,'$','');
    czas_aktualny:=StrToInt(GetLineToStr(aMsg,7,'$','0'));
    film_duration:=StrToInt(GetLineToStr(aMsg,8,'$','0'));
    film_pos:=StrToInt(GetLineToStr(aMsg,9,'$','0'));
    Label8.Caption:=GetLineToStr(aMsg,10,'$');
    pom1:=GetLineToStr(aMsg,11,'$');
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
  if s='{INF1}' then
  begin
    b:=StrToInt(GetLineToStr(aMsg,2,'$','0'))=1;
    PanelPytanie(b);
  end else
  if s='{INF2}' then
  begin
    b:=StrToInt(GetLineToStr(aMsg,2,'$','0'))=1;
    pom1:=GetLineToStr(aMsg,3,'$','');
    reset_tak_nie(b,pom1);
  end else
  if s='{RAMKA_PP}' then
  begin
    film_stat:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    film_filename:=GetLineToStr(aMsg,3,'$','');
    czas_aktualny:=StrToInt(GetLineToStr(aMsg,4,'$','0'));
    film_duration:=StrToInt(GetLineToStr(aMsg,5,'$','0'));
    film_pos:=StrToInt(GetLineToStr(aMsg,6,'$','0'));
    update_pp(czas_aktualny,film_duration,film_pos,film_stat);
  end else
  if s='{INDEX_CZASU}' then
  begin
    indeks_czas:=StrToInt(GetLineToStr(aMsg,2,'$'));
    ListBox1.Refresh;
    if ListBox1.Items.Count>indeks_czas then ListBox1.ItemIndex:=indeks_czas;
  end;
end;

procedure TFMonitor.monTimeVector(aTimeVector: integer);
begin
  wektor_czasu:=aTimeVector;
  czas_atomowy.Correction:=wektor_czasu;
  czas_atomowy.Start;
  StatusBar1.Panels[1].Text:='Różnica czasu: '+IntToStr(wektor_czasu);
  key:=propstorage.ReadString('key-ident','');
  mon.SendString('{LOGIN}$'+key);
end;

procedure TFMonitor.timer_ppTimer(Sender: TObject);
var
  a: integer;
  b: boolean;
  aa: TTime;
begin
  a:=czas_atomowy.GetIndexTime;
  pp.Position:=a;
  aa:=IntegerToTime(a);
  b:=a<3600000;
  if b then Label10.Caption:=FormatDateTime('nn:ss',aa) else Label10.Caption:=FormatDateTime('h:nn:ss',aa);
end;

procedure TFMonitor.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  mon.GetTimeVector;
  mon.SendString('{READ_MON}');
end;

procedure TFMonitor.timer_stopTimer(Sender: TObject);
begin
  timer_stop.Enabled:=false;
  C_KONIEC:=true;
  mon.Disconnect;
  close;
end;

procedure TFMonitor.timer_waitStartTimer(Sender: TObject);
begin
  if Memo2.Visible then
  begin
    dt:=TimeToInteger+2000;
    BitBtn2.Enabled:=false;
    BitBtn2.Caption:='[czekaj 2 sek]';
  end else begin
    dt:=TimeToInteger+10000;
    BitBtn2.Enabled:=false;
    BitBtn2.Caption:='[czekaj 10 sek]';
  end;
end;

procedure TFMonitor.timer_waitStopTimer(Sender: TObject);
begin
  if Memo2.Visible then BitBtn2.Enabled:=length(trim(Memo2.Text))>0
                   else BitBtn2.Enabled:=length(trim(Memo1.Text))>0;
  BitBtn2.Caption:='Wyślij';
end;

procedure TFMonitor.timer_waitTimer(Sender: TObject);
var
  a: integer;
begin
  a:=dt-TimeToInteger;
  if a<0 then a:=0;
  if a=0 then timer_wait.Enabled:=false else BitBtn2.Caption:='[czekaj '+FormatFloat('0',a/1000)+' sek]';
end;

procedure TFMonitor.restart;
begin
  indeks_czas:=-1;
  Label5.Caption:='';
  Label7.Caption:='';
  Label8.Caption:='';
  ListBox1.Clear;
  if C_KONIEC then exit;
  czas_atomowy.Stop;
  StatusBar1.Panels[0].Text:='Połączenie: Brak';
  StatusBar1.Panels[1].Text:='Różnica czasu: ---';
  autorun.Enabled:=not mon.Connect;
end;

procedure TFMonitor.update_pp(aTimeAct, aFilmLength, aFilmPos, aStat: integer);
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
    Label10.Caption:='-:--';
    Label11.Caption:='-:--';
    indeks_czas:=-1;
    ListBox1.Refresh;
    if ListBox1.Items.Count>indeks_czas then ListBox1.ItemIndex:=indeks_czas;
  end else begin
    if aStat=1 then czas_atomowy.Start(aTimeAct-aFilmPos);
    pp.Max:=aFilmLength;
    pp.Position:=aFilmPos;
    aa:=IntegerToTime(aFilmLength);
    bb:=IntegerToTime(aFilmPos);
    bMax:=aFilmLength<3600000;
    bPos:=aFilmPos<3600000;
    if bPos then Label10.Caption:=FormatDateTime('nn:ss',bb) else Label10.Caption:=FormatDateTime('h:nn:ss',bb);
    if bMax then Label11.Caption:=FormatDateTime('nn:ss',aa) else Label11.Caption:=FormatDateTime('h:nn:ss',aa);
    timer_pp.Enabled:=aStat=1;
  end;
end;

procedure TFMonitor.send_message(aValue: string);
var
  s: string;
begin
  if not uELED1.Active then exit;
  s:=trim(aValue);
  if s='' then exit;
  mon.SendString('{PYTANIE_CHAT}$'+key+'$'+trim(EditNick.Text)+'$'+s);
  Memo2.Clear;
end;

procedure TFMonitor.PanelPytanie(aValue: boolean);
begin
  if aValue then
  begin
    Label2.Visible:=false;
    Label14.Visible:=true;
    Memo2.Visible:=true;
    Memo2Change(nil);
    timer_wait.Enabled:=false;
  end else begin
    Label2.Visible:=true;
    Label14.Visible:=false;
    Memo2.Visible:=false;
    Memo1Change(nil);
    timer_wait.Enabled:=false;
  end;
end;

procedure TFMonitor.reset_tak_nie(aWlacz: boolean; aTemat: string);
begin
  if aWlacz then Label15.Caption:=aTemat else Label15.Caption:='';
  BitBtn3.Font.Style:=[];
  BitBtn4.Font.Style:=[];
  BitBtn3.Caption:='Tak';
  BitBtn4.Caption:='Nie';
  BitBtn3.Enabled:=aWlacz;
  BitBtn4.Enabled:=aWlacz;
end;

end.

