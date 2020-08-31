unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP, AsyncProcess, IniFiles, lcltype;

type
  TArchitektPrzycisk = record
    funkcja_wewnetrzna: integer;
    kod_wewnetrzny: word;
    operacja_zewnetrzna: boolean; //wykonaj spawdzenie na zewnątrz (pojedyńczy klik, podwójny klik)
    klik,dwuklik: word; //jaki kod ma zostać wywołany w obu przypadkach (0 - funkcja nieaktywna)
  end;

  TArchitekt = record
    p1,p2,p3,p4,p5: TArchitektPrzycisk;
    suma45: boolean; //przycisk piąty ma zachowywać się dokładnie tak jak czwarty!
  end;

  TArchitektPilot = record
    t1,t2,t3,t4: TArchitekt;
  end;

  { TYoutubeTimer }

  TYoutubeTimer = class(TThread)
  private
    czas: TTime;
    plik: string;
    ss: string;
    procedure act_on;
    procedure act_off;
    procedure run(aTime: TTime);
    procedure zapisz(aCzas: TTime);
    procedure zapisz_str(aCzas: string);
  public
    constructor Create(aCzas: TTime; aPlik: string = '');
    procedure Execute; override;
  end;

  { Tdm }

  Tdm = class(TDataModule)
    http2: TNetSynHTTP;
    proc1: TAsyncProcess;
    http: TNetSynHTTP;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    ini: TIniFile;
  public
    procedure Init;
    function GetHashCode(ANr: integer): string;
    procedure SetConfig(AName: string; AValue: boolean);
    procedure SetConfig(AName: string; AValue: integer);
    procedure SetConfig(AName: string; AValue: int64);
    procedure SetConfig(AName: string; AValue: string);
    function GetConfig(AName: string; ADefault: boolean = false): boolean;
    function GetConfig(AName: string; ADefault: integer = 0): integer;
    function GetConfig(AName: string; ADefault: int64 = 0): int64;
    function GetConfig(AName: string; ADefault: string = ''): string;
    procedure GetInformationsForYoutube(aLink: string; var aTitle,aDescription,aKeywords: string);
    function GetTitleForYoutube(aLink: string): string;
    procedure zeruj_przycisk(var aKontrolka: TArchitektPrzycisk);
    procedure zeruj(var aKontrolka: TArchitekt);
    function pilot_wczytaj: TArchitektPilot;
    function www_zapis(aTxt: TStrings): boolean;
    procedure www_odczyt(aTxt: TStrings);
  end;

const
  www_url = 'https://studiojahu.duckdns.org/youtube_player.php';
  www_pin = '674364ggHGDS6763g3dGYGD76673g2gH';

var
  music_no: integer = 0;

var
  dm: Tdm;
  v_klawisze: TArchitekt;
  sciezka_db: string = '';
  _C_DATETIME: array [1..3] of word;
  _DEV_ON: boolean = false;
  _FULL_SCREEN: boolean = false;
  _DEF_MULTIMEDIA_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_FORMAT: integer = 0;
  _DEF_FULLSCREEN_MEMORY: boolean = false;
  _DEF_COOKIES_FILE_YT: string = '';
  _FORCE_SHUTDOWNMODE: boolean = false;

function FirstMinusToGeneratePlane(s: string; wykonaj_kod: boolean = true): string;

implementation

uses
  ecode, synacode, main;

{$R *.lfm}

function FirstMinusToGeneratePlane(s: string; wykonaj_kod: boolean): string;
begin
  if wykonaj_kod then
  begin
    if s='' then result:='' else if s[1]='-' then
    begin
      delete(s,1,1);
      s:='  '+s;
    end;
  end;
  result:=s;
end;

{ TYoutubeTimer }

procedure TYoutubeTimer.act_on;
begin
  Form1.uELED10.Active:=true;
end;

procedure TYoutubeTimer.act_off;
begin
  Form1.uELED10.Active:=false;
end;

procedure TYoutubeTimer.run(aTime: TTime);
var
  t,r: TTime;
begin
  while true do
  begin
    t:=time;
    if t<=aTime then
    begin
      r:=aTime-t;
      if r<0 then r:=0;
      zapisz(r);
    end else break;
    sleep(200);
  end;
end;

procedure TYoutubeTimer.zapisz(aCzas: TTime);
var
  s: string;
begin
  s:=FormatDateTime('hh:mm:ss',aCzas);
  if s<>ss then
  begin
    ss:=s;
    zapisz_str(s);
  end;
end;

procedure TYoutubeTimer.zapisz_str(aCzas: string);
var
  f: text;
begin
  assignfile(f,plik);
  rewrite(f);
  writeln(f,aCzas);
  closefile(f);
end;

constructor TYoutubeTimer.Create(aCzas: TTime; aPlik: string);
begin
  czas:=aCzas;
  plik:=aPlik;
  FreeOnTerminate:=true;
  inherited Create(false);
end;

procedure TYoutubeTimer.Execute;
begin
  synchronize(@act_on);
  if plik='' then plik:='/tmp/youtube_timer.txt';
  run(czas);
  synchronize(@act_off);
end;

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  Init;
  ini:=TIniFile.Create(MyConfDir('config.ini'));
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  ini.Free;
end;

procedure Tdm.Init;
begin
  SetConfDir('youtube_player');
end;

function Tdm.GetHashCode(ANr: integer): string;
begin
  case ANr of
    1: result:='yusd6ydh7w8tgdyhgdys87d3'; //pliki dostępu z zaszyfrowanym adresem IP
    2: result:='y3498sdbngHGy87yNYSm8398'; //transmisja sieciowa TCP
  end;
end;

procedure Tdm.SetConfig(AName: string; AValue: boolean);
begin
  ini.WriteBool('Zmienne',AName,AValue);
end;

procedure Tdm.SetConfig(AName: string; AValue: integer);
begin
  ini.WriteInteger('Zmienne',AName,AValue);
end;

procedure Tdm.SetConfig(AName: string; AValue: int64);
begin
  ini.WriteInt64('Zmienne',AName,AValue);
end;

procedure Tdm.SetConfig(AName: string; AValue: string);
begin
  ini.WriteString('Zmienne',AName,AValue);
end;

function Tdm.GetConfig(AName: string; ADefault: boolean): boolean;
begin
  result:=ini.ReadBool('Zmienne',AName,ADefault);
end;

function Tdm.GetConfig(AName: string; ADefault: integer): integer;
begin
  result:=ini.ReadInteger('Zmienne',AName,ADefault);
end;

function Tdm.GetConfig(AName: string; ADefault: int64): int64;
begin
  result:=ini.ReadInt64('Zmienne',AName,ADefault);
end;

function Tdm.GetConfig(AName: string; ADefault: string): string;
begin
  result:=ini.ReadString('Zmienne',AName,ADefault);
end;

procedure Tdm.GetInformationsForYoutube(aLink: string; var aTitle,
  aDescription, aKeywords: string);
var
  s: string;
  a: integer;
begin
  http.execute(aLink,s);
  a:=pos('meta name="title"',s);
  if a>0 then delete(s,1,a+16);
  a:=pos('content="',s);
  if a>0 then delete(s,1,a+8);
  a:=pos('"',s);
  aTitle:=copy(s,1,a-1);
  aTitle:=DecodeHTMLAmp(aTitle);

  a:=pos('meta name="description"',s);
  if a>0 then delete(s,1,a+22);
  a:=pos('content="',s);
  if a>0 then delete(s,1,a+8);
  a:=pos('"',s);
  aDescription:=copy(s,1,a-1);
  aDescription:=DecodeHTMLAmp(aDescription);

  a:=pos('meta name="keywords"',s);
  if a>0 then delete(s,1,a+19);
  a:=pos('content="',s);
  if a>0 then delete(s,1,a+8);
  a:=pos('"',s);
  aKeywords:=copy(s,1,a-1);
  aKeywords:=DecodeHTMLAmp(aKeywords);
end;

function Tdm.GetTitleForYoutube(aLink: string): string;
var
  vTitle,vDescription,vKeywords: string;
begin
  GetInformationsForYoutube(aLink,vTitle,vDescription,vKeywords);
  result:=vTitle;
end;

procedure Tdm.zeruj_przycisk(var aKontrolka: TArchitektPrzycisk);
begin
  aKontrolka.kod_wewnetrzny:=0;
  aKontrolka.funkcja_wewnetrzna:=0;
  aKontrolka.operacja_zewnetrzna:=false;
  aKontrolka.klik:=0;
  aKontrolka.dwuklik:=0;
end;

procedure Tdm.zeruj(var aKontrolka: TArchitekt);
begin
  zeruj_przycisk(aKontrolka.p1);
  zeruj_przycisk(aKontrolka.p2);
  zeruj_przycisk(aKontrolka.p3);
  zeruj_przycisk(aKontrolka.p4);
  zeruj_przycisk(aKontrolka.p5);
  aKontrolka.suma45:=false;
end;

function Tdm.pilot_wczytaj: TArchitektPilot;
var
  f: file of TArchitekt;
  a: TArchitektPilot;
  s: string;
  b: boolean;
begin
  s:=MyConfDir('keys.dat');
  b:=FileExists(s);
  if b then
  begin
    assignfile(f,s);
    reset(f);
  end;
  if b then read(f,a.t1) else zeruj(a.t1);
  if b then read(f,a.t2) else zeruj(a.t2);
  if b then read(f,a.t3) else zeruj(a.t3);
  if b then read(f,a.t4) else zeruj(a.t4);
  result:=a;
end;

function Tdm.www_zapis(aTxt: TStrings): boolean;
var
  s: string;
  a: integer;
begin
  s:=aTxt.Text;
  s:=StringReplace(s,'''','{$C1}',[rfReplaceAll]);
  s:=StringReplace(s,'"','{$C2}',[rfReplaceAll]);
  s:=StringReplace(s,';','{$C3}',[rfReplaceAll]);
  s:=StringReplace(s,':','{$C4}',[rfReplaceAll]);
  s:=StringReplace(s,'&','{$C5}',[rfReplaceAll]);
  aTxt.Clear;
  aTxt.AddText(s);
  s:='';
  http2.OpenSession;
  http2.execute(www_url,s);
  http2.UrlData:='tryb=0&pin='+www_pin+'&oper=1&zapis='+EncodeURL(aTxt.Text);
  http2.execute(www_url,s);
  http2.CloseSession;
  a:=pos('<pre>',s);
  delete(s,1,a+4);
  a:=pos('</pre>',s);
  delete(s,a,maxint);
  result:=trim(s)='OK';
end;

procedure Tdm.www_odczyt(aTxt: TStrings);
var
  s: string;
  a: integer;
begin
  aTxt.Clear;
  http2.OpenSession;
  http2.execute(www_url,s);
  http2.UrlData:='tryb=0&pin='+www_pin+'&oper=2&zapis=';
  http2.execute(www_url,s);
  http2.CloseSession;
  a:=pos('<pre>',s);
  delete(s,1,a+4);
  a:=pos('</pre>',s);
  delete(s,a,maxint);
  s:=trim(s);
  s:=StringReplace(s,'{$C1}','''',[rfReplaceAll]);
  s:=StringReplace(s,'{$C2}','"',[rfReplaceAll]);
  s:=StringReplace(s,'{$C3}',';',[rfReplaceAll]);
  s:=StringReplace(s,'{$C4}',':',[rfReplaceAll]);
  s:=StringReplace(s,'{$C5}','&',[rfReplaceAll]);
  aTxt.AddText(s);
end;

end.

