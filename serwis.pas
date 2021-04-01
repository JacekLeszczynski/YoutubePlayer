unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP, ZTransaction, DBSchemaSyncSqlite,
  AsyncProcess, IniFiles, DB, lcltype, ZConnection, ZSqlProcessor, ZDataset;

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
    add_rec: TZSQLProcessor;
    add_rec0: TZSQLProcessor;
    add_rec2: TZSQLProcessor;
    cr: TZSQLProcessor;
    czasy2: TZQuery;
    czasy_id: TZQuery;
    czasy_up_id: TZQuery;
    db: TZConnection;
    dbini: TZSQLProcessor;
    del_all: TZSQLProcessor;
    del_czasy_film: TZSQLProcessor;
    film: TZQuery;
    filmy2: TZQuery;
    filmy3: TZQuery;
    filmyidnext: TZSQLProcessor;
    filmy_id: TZQuery;
    http_yt: TNetSynHTTP;
    http2: TNetSynHTTP;
    ikeyadd: TZQuery;
    last_id: TZQuery;
    pakowanie_db: TZSQLProcessor;
    proc1: TAsyncProcess;
    http: TNetSynHTTP;
    pytaniaczas1: TLargeintField;
    pytaniaid1: TLargeintField;
    pytaniapytanie1: TMemoField;
    pyt_add: TZQuery;
    pyt_get: TZQuery;
    pyt_getile: TLargeintField;
    rename_id: TZSQLProcessor;
    rename_id0: TZSQLProcessor;
    rename_id1: TZSQLProcessor;
    rename_id2: TZSQLProcessor;
    roz2: TZQuery;
    roz_add: TZQuery;
    roz_del: TZQuery;
    roz_del1: TZSQLProcessor;
    roz_del2: TZSQLProcessor;
    roz_id: TZQuery;
    roz_upd: TZQuery;
    schemasync: TDBSchemaSyncSqlite;
    tasma: TZQuery;
    tasma_add: TZQuery;
    tasma_clear: TZSQLProcessor;
    trans: TZTransaction;
    update_sort: TZSQLProcessor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbBeforeConnect(Sender: TObject);
  private
    ini: TIniFile;
  public
    aVER: string;
    procedure Init;
    function GetHashCode(ANr: integer): string;
    procedure DaneDoSzyfrowaniaServer(var aVector,aKey: string);
    procedure DaneDoSzyfrowania(var aVector,aKey: string);
    procedure DaneDoSzyfrowaniaSetNewVector(aNewVector: string = '');
    procedure DaneDoSzyfrowaniaClear;
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
  ankieta_id: integer = 0;
  cytaty_id: integer = 0;
  _TRYB_SERWERA: integer = 1;
  _C_DATETIME: array [1..3] of word;
  _DEV_ON: boolean = false;
  _FULL_SCREEN: boolean = false;
  _DEF_MULTIMEDIA_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_FORMAT: integer = 0;
  _DEF_FULLSCREEN_MEMORY: boolean = false;
  _DEF_COOKIES_FILE_YT: string = '';
  _DEF_GREEN_SCREEN: boolean = false;
  _SET_GREEN_SCREEN: boolean = false;
  _DEF_POLFAN: boolean = false;
  _FORCE_SHUTDOWNMODE: boolean = false;
  _MPLAYER_LOCALTIME: boolean = false;
  _MPLAYER_FORCESTART0_BOOL: boolean = false;
  _MPLAYER_FORCESTART0: integer = 0;
  _MONITOR_CAM: integer = 0;
  _MONITOR_ALARM: integer = 0;
  _BLOCK_MUSIC_KEYS: boolean = false;

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
  s:=FormatDateTime('nn:ss',aCzas);
  //s:=FormatDateTime('nnss',aCzas);
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

procedure Tdm.dbBeforeConnect(Sender: TObject);
begin
  db.AutoEncodeStrings:=false;
end;

procedure Tdm.Init;
begin
  SetConfDir('youtube_player');
end;

function Tdm.GetHashCode(ANr: integer): string;
begin
  case ANr of
    1: result:='yusd6ydh7w8tgdyhgdys87d3'; //pliki dostępu z zaszyfrowanym adresem IP
    2: result:='h448s7S5Dj9r8jsdi8jik6si'; //transmisja sieciowa TCP
  end;
end;

const
  START_VECTOR = 'erujuie8783irei0';

var
  NEW_VECTOR: string = '';

procedure Tdm.DaneDoSzyfrowaniaServer(var aVector, aKey: string);
begin
  aVector:=START_VECTOR;
  aKey:='7f64h7g8D763ER43';
end;

procedure Tdm.DaneDoSzyfrowania(var aVector, aKey: string);
begin
  if NEW_VECTOR='' then aVector:=START_VECTOR else aVector:=NEW_VECTOR;
  aKey:='7f64h7g8D763ER43';
end;

procedure Tdm.DaneDoSzyfrowaniaSetNewVector(aNewVector: string);
begin
  if aNewVector='' then NEW_VECTOR:=START_VECTOR else NEW_VECTOR:=aNewVector;
end;

procedure Tdm.DaneDoSzyfrowaniaClear;
begin
  NEW_VECTOR:='';
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
  ss: TStrings;
  s,s1,s2,cookie: string;
  a,i: integer;
begin
  if (_DEF_COOKIES_FILE_YT<>'') and (http_yt.Headers.Count=0) then
  begin
    ss:=TStringList.Create;
    try
      (* dołączam dane cookies do połączenia jeśli istnieją*)
      if FileExists(_DEF_COOKIES_FILE_YT) then
      begin
        cookie:='';
        ss.LoadFromFile(_DEF_COOKIES_FILE_YT);
        for i:=0 to ss.Count-1 do
        begin
          s:=ss[i];
          s1:=GetLineToStr(s,6,#9);
          s2:=GetLineToStr(s,7,#9);
          if cookie='' then cookie:='cookie: '+s1+'='+s2 else cookie:=cookie+'; '+s1+'='+s2;
        end;
        http_yt.Headers.Clear;
        http_yt.Headers.Add(cookie);
      end;
    finally
      ss.Free;
    end;
  end;

  http_yt.execute(aLink,s);

  http_yt.StrDeleteStart(s,'meta name="title"');
  http_yt.StrDeleteStart(s,'content="');
  a:=pos('"',s);
  aTitle:=copy(s,1,a-1);
  aTitle:=DecodeHTMLAmp(aTitle);

  http_yt.StrDeleteStart(s,'meta name="description"');
  http_yt.StrDeleteStart(s,'content="');
  a:=pos('"',s);
  aDescription:=copy(s,1,a-1);
  aDescription:=DecodeHTMLAmp(aDescription);

  http_yt.StrDeleteStart(s,'meta name="keywords"');
  http_yt.StrDeleteStart(s,'content="');
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

