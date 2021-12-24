unit studio_client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, XMLPropStorage, Spin, TplProgressBarUnit, DCPrijndael,
  DCPsha512, NetSocket, UOSEngine, UOSPlayer, LiveTimer, lNet, ueled,
  uETilePanel;

type

  { TFStudioClient }

  TFStudioClient = class(TForm)
    aes: TDCP_rijndael;
    autorun: TTimer;
    FCode: TEdit;
    Label1: TLabel;
    cTytul: TLabel;
    Label3: TLabel;
    live: TLiveTimer;
    mon: TNetSocket;
    OpenDialog: TOpenDialog;
    ping_pong: TTimer;
    pp2: TplProgressBar;
    pp1: TplProgressBar;
    propstorage: TXMLPropStorage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ppause: TTimer;
    ppp: TTimer;
    timer_start: TTimer;
    uELED1: TuELED;
    uELED2: TuELED;
    uELED3: TuELED;
    uELED4: TuELED;
    uELED5: TuELED;
    uELED6: TuELED;
    uELED7: TuELED;
    uETilePanel1: TuETilePanel;
    uos: TUOSEngine;
    player: TUOSPlayer;
    procedure autorunTimer(Sender: TObject);
    procedure FCodeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure playerAfterStart(Sender: TObject);
    procedure playerAfterStop(Sender: TObject);
    procedure ppauseTimer(Sender: TObject);
    procedure pppTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure timer_startTimer(Sender: TObject);
  private
    lista: TStrings;
    CANAL: integer;
    led_kolor: TColor;
    wektor_czasu: integer;
    key: string;
    VAR_UOS: boolean;
    VAR_PAUSE: integer;
    mem: TMemoryStream;
    function GetKey: string;
    procedure PutKey(aKey: string);
    procedure SendMessage(aKomenda: string; aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure zablokowanie_uslug;
    procedure odblokowanie_uslug;
    procedure update_pp(aTimeAct,aFilmLength,aFilmPos,aStat: integer; aPosSingle: single);
    procedure setposition(aPosSingle: single);
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
  timer_start.Enabled:=true;
end;

procedure TFStudioClient.FormCreate(Sender: TObject);
begin
  //mem:=TMemoryStream.Create;
  VAR_UOS:=uos.LoadLibrary;
  if not VAR_UOS then
  begin
    uELED7.Color:=clRed;
    uELED7.Active:=true;
  end;
  lista:=TStringList.Create;
  SetConfDir('studio-jahu-client');
  propstorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  propstorage.Active:=true;
  Caption:='Studio JAHU Client ('+dm.aVER+')';
  if not mon.Active then autorun.Enabled:=true;
end;

procedure TFStudioClient.FormDestroy(Sender: TObject);
begin
  uos.UnLoadLibrary;
  lista.Free;
  //mem.Free;
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

  host:=CONST_DOMENA;
  if host='sun' then host:='127.0.0.1';
  if host='127.0.0.1' then host:='sun';

  mon.MaxBuffer:=CONST_MAX_BUFOR;
  mon.Connect;
  if mon.Active then exit;

  autorun.Enabled:=not mon.Active;
  uEled1.Active:=mon.Active;
end;

procedure TFStudioClient.FCodeChange(Sender: TObject);
begin
  SendMessage('{STUDIO}','GET_CANAL$'+FCode.Text);
end;

procedure TFStudioClient.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  player.Stop;
  mon.Disconnect;
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
  s,s2: string;
  a1,a2,i: integer;
  indeks_czas,film_stat,czas_aktualny,film_duration,film_pos: integer;
  nazwa_programu,opis_programu,film_filename,tytul_filmu: string;
  pom1,pom2: string;
  posit: single;
  FormatSettings: TFormatSettings;
begin
  //writeln(aMsg);
  s:=GetLineToStr(aMsg,1,'$');
  if s='{READ_ALL}' then
  begin
    indeks_czas:=StrToInt(GetLineToStr(aMsg,3,'$'));
    nazwa_programu:=GetLineToStr(aMsg,4,'$');
    opis_programu:=GetLineToStr(aMsg,5,'$');
    film_stat:=StrToInt(GetLineToStr(aMsg,6,'$','0'));
    film_filename:=GetLineToStr(aMsg,7,'$','');
    czas_aktualny:=StrToInt(GetLineToStr(aMsg,8,'$','0'));
    film_duration:=StrToInt(GetLineToStr(aMsg,9,'$','0'));
    film_pos:=StrToInt(GetLineToStr(aMsg,10,'$','0'));
    tytul_filmu:=GetLineToStr(aMsg,11,'$');
    pom1:=GetLineToStr(aMsg,12,'$');
    s2:=GetLineToStr(aMsg,13,'$');
    if s2='' then posit:=0 else
    begin
      FormatSettings.DecimalSeparator:='.';
      posit:=StrToFloat(s2,FormatSettings);
    end;
    lista.Clear;
    i:=1;
    while true do
    begin
      pom2:=GetLineToStr(pom1,i,'|');
      if pom2='' then break;
      lista.AddStrings(pom2);
      inc(i);
    end;
    if (lista.Count>indeks_czas) and (indeks_czas>-1) then cTytul.Caption:=lista[indeks_czas] else cTytul.Caption:='';
    update_pp(czas_aktualny,film_duration,film_pos,film_stat,posit);
  end else
  if s='{RAMKA_PP}' then
  begin
    film_stat:=StrToInt(GetLineToStr(aMsg,3,'$','0'));
    film_filename:=GetLineToStr(aMsg,4,'$','');
    czas_aktualny:=StrToInt(GetLineToStr(aMsg,5,'$','0'));
    film_duration:=StrToInt(GetLineToStr(aMsg,6,'$','0'));
    film_pos:=StrToInt(GetLineToStr(aMsg,7,'$','0'));
    s2:=GetLineToStr(aMsg,8,'$');
    if s2='' then posit:=0 else
    begin
      FormatSettings.DecimalSeparator:='.';
      posit:=StrToFloat(s2,FormatSettings);
    end;
    update_pp(czas_aktualny,film_duration,film_pos,film_stat,posit);
  end else
  if s='{INDEX_CZASU}' then
  begin
    indeks_czas:=StrToInt(GetLineToStr(aMsg,3,'$'));
    if (lista.Count>indeks_czas) and (indeks_czas>-1) then cTytul.Caption:=lista[indeks_czas] else cTytul.Caption:='';
  end else
  if s='{STUDIO_PLAY_STOP}' then
  begin
    s2:=GetLineToStr(aMsg,3,'$','00000');
    uELED2.Active:=s2[1]='1';
    uELED3.Active:=s2[2]='1';
    uELED4.Active:=s2[3]='1';
    uELED5.Active:=s2[4]='1';
    uELED6.Active:=s2[5]='1';
  end else
  if s='{KEY-NEW}' then
  begin
    key:=GetLineToStr(aMsg,2,'$');
    try a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); except a1:=0; end;
    PutKey(key);
    //mon.SendString('{GET_CHAT}');
    odblokowanie_uslug;
    SendMessage('{STUDIO}','GET_CANAL$'+FCode.Text);
    SendMessageNoKey('{READ_ALL}');
    SendMessage('{INFO}','ALL');
  end else
  if s='{KEY-OK}' then
  begin
    //mon.SendString('{GET_CHAT}');
    odblokowanie_uslug;
    SendMessage('{STUDIO}','GET_CANAL$'+FCode.Text);
    SendMessageNoKey('{READ_ALL}');
    SendMessage('{INFO}','ALL');
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
    led_kolor:=clYellow;
    uELED1.Color:=led_kolor;
  end else
  if s='{SERVER-EXIST}' then
  begin
    led_kolor:=clBlue;
    uELED1.Color:=led_kolor;
    SendMessage('{STUDIO}','GET_CANAL$'+FCode.Text);
  end else
  if s='{USERS_COUNT}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
  end else
  if s='{STUDIO}' then
  begin
    s2:=GetLineToStr(aMsg,3,'$'); //key
    if s2<>key then exit;
    s2:=GetLineToStr(aMsg,4,'$'); //komenda
    if s2='SET_CANAL' then
    begin
      a1:=StrToInt(GetLineToStr(aMsg,5,'$','0'));
      if a1>0 then
      begin
        CANAL:=a1;
        if FCode.Enabled then FCode.Enabled:=false;
        uELED3.Color:=clBlue;
        uELED4.Color:=clBlue;
        uELED5.Color:=clBlue;
        uELED6.Color:=clBlue;
        uELED3.LedType:=ledRound;
        uELED4.LedType:=ledRound;
        uELED5.LedType:=ledRound;
        uELED6.LedType:=ledRound;
        case CANAL of
          1: uELED3.Color:=clYellow;
          2: uELED4.Color:=clYellow;
          3: uELED5.Color:=clYellow;
          4: uELED6.Color:=clYellow;
        end;
        case CANAL of
          1: uELED3.LedType:=ledSquare;
          2: uELED4.LedType:=ledSquare;
          3: uELED5.LedType:=ledSquare;
          4: uELED6.LedType:=ledSquare;
        end;
      end;
    end;
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
  mon.SendString('{LOGIN}$'+key);
end;

procedure TFStudioClient.ping_pongTimer(Sender: TObject);
begin
  if mon.Active then SendMessageNoKey('{PING}');
end;

procedure TFStudioClient.playerAfterStart(Sender: TObject);
begin
  ppp.Enabled:=true;
end;

procedure TFStudioClient.playerAfterStop(Sender: TObject);
begin
  ppp.Enabled:=false;
  pp1.Position:=0;
  pp2.Position:=0;
end;

procedure TFStudioClient.ppauseTimer(Sender: TObject);
begin
  if TimeToInteger(player.PositionTime)>VAR_PAUSE then
  begin
    ppause.Enabled:=false;
    player.Pause;
  end;
end;

procedure TFStudioClient.pppTimer(Sender: TObject);
var
  aa,bb: single;
begin
  aa:=pp1.Position;
  bb:=pp2.Position;
  player.GetMeterEx(aa,bb);
  pp1.Position:=round(aa);
  pp2.Position:=round(bb);
end;

procedure TFStudioClient.SpeedButton1Click(Sender: TObject);
begin
  if (CANAL>0) and (CANAL<5) then SendMessage('{STUDIO_PLAY_STOP}',IntToStr(CANAL)+'$'+FCode.Text+'$0');
end;

procedure TFStudioClient.SpeedButton2Click(Sender: TObject);
begin
  if (CANAL>0) and (CANAL<5) then SendMessage('{STUDIO_PLAY_STOP}',IntToStr(CANAL)+'$'+FCode.Text+'$1');
end;

procedure TFStudioClient.SpeedButton3Click(Sender: TObject);
var
  plik: string;
begin
  if not VAR_UOS then exit;
  if OpenDialog.Execute then
  begin
    plik:=OpenDialog.FileName;
    if FileExists(plik) then
    begin
      player.Stop;
      mem:=TMemoryStream.Create;
      mem.LoadFromFile(plik);
      player.Start(mem);
      player.Pause;
      SendMessageNoKey('{READ_ALL}');
      uELED7.Active:=true;
    end;
  end;
end;

procedure TFStudioClient.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  mon.SendString('{GET_VECTOR}');
end;

function TFStudioClient.GetKey: string;
var
  s,s2: string;
begin
  s:=propstorage.ReadString('KEY','');
  s2:=DecryptString(s,dm.GetHashCode(3),true);
  if s='' then result:='' else result:=s2;
end;

procedure TFStudioClient.PutKey(aKey: string);
begin
  propstorage.WriteString('KEY',EncryptString(aKey,dm.GetHashCode(3),128));
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
  SendMessageNoKey('{SET_ACTIVE}','4$1');
  uELED1.Color:=led_kolor;
  uEled1.Active:=true;
end;

procedure TFStudioClient.update_pp(aTimeAct, aFilmLength, aFilmPos,
  aStat: integer; aPosSingle: single);
var
  bPos,bMax: boolean;
  aa,bb: TTime;
begin
  //writeln(aStat,' (',mplayer.Running,' ',mplayer.Playing,' ',mplayer.Paused,')');
  if not player.Busy then exit;
  if aStat=0 then
  begin
    VAR_PAUSE:=aFilmPos;
    //player.Pause;
    ppause.Enabled:=true;
  end else begin
    if aStat=1 then
    begin
      ppause.Enabled:=false;
      setposition(aPosSingle);
      player.Replay;
    end else if aStat=2 then
    begin
      VAR_PAUSE:=aFilmPos;
      //player.Pause;
      ppause.Enabled:=true;
    end;
    //mplayer.SetPositionEx(aFilmPos,aFilmLength);
    //mplayer.Position:=IntegerToTime(aFilmPos)*SecsPerDay;
  end;
  {timer_pp.Enabled:=false;
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
  end;}
end;

procedure TFStudioClient.setposition(aPosSingle: single);
begin
  player.SeekSeconds(aPosSingle);
end;

end.

