unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, NetSocket, LiveTimer, ExtMessage, lNet,
  ueled, uETilePanel;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    BitBtn1: TSpeedButton;
    BitBtn3: TSpeedButton;
    CheckZawszeNaWierzchu: TCheckBox;
    czas_atomowy: TLiveTimer;
    EditNick: TEdit;
    Image1: TImage;
    ImageList: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    mess: TExtMessage;
    mon: TNetSocket;
    BitBtn2: TSpeedButton;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    autorun: TTimer;
    timer_wait: TTimer;
    timer_start: TTimer;
    timer_stop: TTimer;
    propstorage: TXMLPropStorage;
    uELED1: TuELED;
    uETilePanel1: TuETilePanel;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckZawszeNaWierzchuChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure monConnect(aSocket: TLSocket);
    procedure monCryptString(var aText: string);
    procedure monDecryptString(var aText: string);
    procedure monDisconnect;
    procedure monProcessMessage;
    procedure monReceiveString(aMsg: string; aSocket: TLSocket);
    procedure monTimeVector(aTimeVector: integer);
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
  public

  end;

var
  FMonitor: TFMonitor;

implementation

uses
  ecode, serwis;

var
  C_KONIEC: boolean = false;

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

procedure TFMonitor.Memo1Change(Sender: TObject);
var
  a: integer;
begin
  a:=length(Memo1.Text);
  Label2.Caption:='Pytanie: ('+IntToStr(a)+' z 250 znaków)';
  if a>250 then Label2.Font.Color:=clRed else Label2.Font.Color:=clBlack;
  BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo1.Text))>0);
end;

procedure TFMonitor.autorunTimer(Sender: TObject);
begin
  autorun.Enabled:=not mon.Connect;
end;

procedure TFMonitor.BitBtn1Click(Sender: TObject);
begin
  Memo1.PasteFromClipboard;
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
  timer_wait.Enabled:=true;
  s:=Memo1.Text;
  if s<>'' then
  begin
    mon.SendString('{PYTANIE}$'+key+'$'+trim(EditNick.Text)+'$'+s);
    Memo1.Clear;
  end;
  Memo1.SetFocus;
end;

procedure TFMonitor.BitBtn3Click(Sender: TObject);
begin
  C_KONIEC:=true;
  close;
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
  l: integer;
  ss,s: string;
  cam: integer;
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
    if s='{KEY-NEW}' then
    begin
      key:=GetLineToStr(ss,2,'$');
      propstorage.WriteString('key-ident',key);
      dt:=-1;
      BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo1.Text))>0);
    end else
    if s='{KEY-OK}' then
    begin
      dt:=-1;
      BitBtn2.Enabled:=(not timer_wait.Enabled) and (length(trim(Memo1.Text))>0);
    end;

    inc(l);
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
  dt:=TimeToInteger+10000;
  BitBtn2.Enabled:=false;
  BitBtn2.Caption:='[czekaj 10 sek]';
end;

procedure TFMonitor.timer_waitStopTimer(Sender: TObject);
begin
  BitBtn2.Enabled:=length(trim(Memo1.Text))>0;
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
  if C_KONIEC then exit;
  czas_atomowy.Stop;
  StatusBar1.Panels[0].Text:='Połączenie: Brak';
  StatusBar1.Panels[1].Text:='Różnica czasu: ---';
  autorun.Enabled:=not mon.Connect;
end;

end.

