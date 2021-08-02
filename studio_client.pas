unit studio_client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, XMLPropStorage, DCPrijndael, DCPsha512, NetSocket, lNet,
  ueled, uETilePanel;

type

  { TFStudioClient }

  TFStudioClient = class(TForm)
    aes: TDCP_rijndael;
    autorun: TTimer;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    FCode: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    mon: TNetSocket;
    ping_pong: TTimer;
    propstorage: TXMLPropStorage;
    StatusBar1: TStatusBar;
    timer_start: TTimer;
    uELED1: TuELED;
    uELED2: TuELED;
    uETilePanel1: TuETilePanel;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure monConnect(aSocket: TLSocket);
    procedure monCryptBinary(const indata; var outdata; var size: longword);
    procedure monDecryptBinary(const indata; var outdata; var size: longword);
    procedure monDisconnect;
    procedure monProcessMessage;
    procedure monReceiveString(aMsg: string; aSocket: TLSocket;
      aBinSize: integer; var aReadBin: boolean);
    procedure monStatus(aActive, aCrypt: boolean);
    procedure monTimeVector(aTimeVector: integer);
    procedure ping_pongTimer(Sender: TObject);
    procedure timer_startTimer(Sender: TObject);
  private
    led_kolor: TColor;
    wektor_czasu: integer;
    key: string;
    function GetKey(aToken: string = ''): string;
    procedure SendMessage(aKomenda: string; aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure zablokowanie_uslug;
    procedure odblokowanie_uslug;
  public
  end;

var
  FStudioClient: TFStudioClient;

implementation

uses
  ecode, serwis;

var
  CONST_RUN_BLOCK: boolean = false; //blokada zamykania programu zanim się do końca nie uruchomi!

{$R *.lfm}

{ TFStudioClient }

procedure TFStudioClient.monCryptBinary(const indata; var outdata;
  var size: longword);
var
  vec,klucz: string;
begin
  size:=CalcBuffer(size,16);
  dm.DaneDoSzyfrowania(vec,klucz);
  aes.Init(klucz[1],128,@vec[1]);
  aes.Encrypt(indata,outdata,size);
  aes.Burn;
end;

procedure TFStudioClient.monConnect(aSocket: TLSocket);
begin
  led_kolor:=clRed;
  CONST_RUN_BLOCK:=true;
  dm.DaneDoSzyfrowaniaClear;
  StatusBar1.Panels[0].Text:='Połączenie: OK';
  timer_start.Enabled:=true;
end;

procedure TFStudioClient.FormCreate(Sender: TObject);
begin
  SetConfDir('studio-jahu-client');
  propstorage.FileName:=MyConfDir('ustawienia.xml');
  propstorage.Active:=true;
  Caption:='Studio JAHU Client ('+dm.aVER+')';
  if not mon.Active then autorun.Enabled:=true;
end;

procedure TFStudioClient.FormShow(Sender: TObject);
begin
  {$IFDEF WINDOWS}propstorage.Restore;{$ENDIF}
end;

procedure TFStudioClient.autorunTimer(Sender: TObject);
var
  host: string;
begin
  autorun.Enabled:=false;
  led_kolor:=clRed;
  uEled1.Color:=clSilver;
  uEled1.Active:=true;
  application.ProcessMessages;

  host:='studiojahu.duckdns.org';
  if host='sun' then host:='127.0.0.1';
  if host='127.0.0.1' then host:='sun';

  mon.MaxBuffer:=CONST_MAX_BUFOR;
  mon.Connect;
  if mon.Active then exit;

  autorun.Enabled:=not mon.Active;
  uEled1.Active:=mon.Active;
end;

procedure TFStudioClient.BitBtn1Click(Sender: TObject);
begin
  SendMessage('{STUDIO_PLAY_STOP}',FCode.Text+'$0');
end;

procedure TFStudioClient.BitBtn2Click(Sender: TObject);
begin
  SendMessage('{STUDIO_PLAY_STOP}',FCode.Text+'$1');
end;

procedure TFStudioClient.BitBtn3Click(Sender: TObject);
begin
  SendMessage('{STUDIO_PLAY_STOP}',FCode.Text+'$2');
end;

procedure TFStudioClient.BitBtn4Click(Sender: TObject);
begin
  SendMessage('{STUDIO_PLAY_STOP}',FCode.Text+'$3');
end;

procedure TFStudioClient.BitBtn5Click(Sender: TObject);
begin
  SendMessage('{STUDIO_PLAY_STOP}',FCode.Text+'$4');
end;

procedure TFStudioClient.monDecryptBinary(const indata; var outdata;
  var size: longword);
var
  vec,klucz: string;
begin
  dm.DaneDoSzyfrowania(vec,klucz);
  aes.Init(klucz[1],128,@vec[1]);
  aes.Decrypt(indata,outdata,size);
  aes.Burn;
end;

procedure TFStudioClient.monDisconnect;
begin
  zablokowanie_uslug;
  //BitBtn1.Enabled:=false;
  //MenuItem36.Enabled:=false;
  //BitBtn2.Enabled:=false;
  //BitBtn3.Enabled:=false;
  uEled1.Active:=false;
  dm.DaneDoSzyfrowaniaClear;
  //restart;
end;

procedure TFStudioClient.monProcessMessage;
begin
  Application.ProcessMessages;
end;

procedure TFStudioClient.monReceiveString(aMsg: string; aSocket: TLSocket;
  aBinSize: integer; var aReadBin: boolean);
var
  s: string;
  a1: integer;
begin
  s:=GetLineToStr(aMsg,1,'$');
  if s='{KEY-NEW}' then
  begin
    key:=GetLineToStr(aMsg,2,'$');
    try a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); except a1:=0; end;
    //mon.SendString('{GET_CHAT}');
    odblokowanie_uslug;
  end else
  if s='{VECTOR_OK}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector;
    mon.GetTimeVector;
    //if studio_run then mon.SendString('{READ_MON}');
  end else
  if s='{VECTOR_IS_NEW}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector(GetLineToStr(aMsg,2,'$'));
    mon.GetTimeVector;
    //if studio_run then mon.SendString('{READ_MON}');
  end else
  if s='{SERVER-NON-EXIST}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','-100'));
    if a1<>-100 then StatusBar1.Panels[1].Text:='Ilość końcówek: '+IntToStr(a1);
    led_kolor:=clYellow;
    uELED1.Color:=led_kolor;
  end else
  if s='{SERVER-EXIST}' then
  begin
    led_kolor:=clRed;
    uELED1.Color:=led_kolor;
  end else
  if s='{USERS_COUNT}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    StatusBar1.Panels[1].Text:='Ilość końcówek: '+IntToStr(a1);
  end;
end;

procedure TFStudioClient.monStatus(aActive, aCrypt: boolean);
begin
  ping_pong.Enabled:=aActive;
end;

procedure TFStudioClient.monTimeVector(aTimeVector: integer);
begin
  CONST_RUN_BLOCK:=false;
  //BitBtn1.Enabled:=mon.Port<>4680;
  //MenuItem36.Enabled:=true;
  //BitBtn2.Enabled:=true;
  //BitBtn3.Enabled:=true;
  wektor_czasu:=aTimeVector;
  key:=GetKey;
  mon.SendString('{LOGIN}$'+key+'$TMP');
end;

procedure TFStudioClient.ping_pongTimer(Sender: TObject);
begin
  if mon.Active then SendMessageNoKey('{PING}');
end;

procedure TFStudioClient.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  mon.SendString('{GET_VECTOR}');
end;

function TFStudioClient.GetKey(aToken: string): string;
begin
  result:='';
end;

procedure TFStudioClient.SendMessage(aKomenda: string; aValue: string);
var
  s: string;
begin
  if aValue='' then s:=aKomenda+'$'+key else s:=aKomenda+'$'+key+'$'+aValue;
  //if cDebug then debug.Debug('SendString: "'+s+'"');
  mon.SendString(s);
end;

procedure TFStudioClient.SendMessageNoKey(aKomenda: string; aValue: string);
var
  s: string;
begin
  if aValue='' then s:=aKomenda else s:=aKomenda+'$'+aValue;
  //if cDebug then debug.Debug('SendStringNoKey: "'+s+'"');
  mon.SendString(s);
end;

procedure TFStudioClient.zablokowanie_uslug;
begin

end;

procedure TFStudioClient.odblokowanie_uslug;
begin
  uELED1.Color:=led_kolor;
  uEled1.Active:=true;
end;

end.

