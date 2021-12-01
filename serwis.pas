unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP, ZTransaction, DBSchemaSyncSqlite,
  YoutubeDownloader, ZQueryPlus, AsyncProcess, IniFiles, DB, lcltype,
  ZConnection, ZSqlProcessor, ZDataset;

type
  TArchitektPrzycisk = record
    funkcja_wewnetrzna: integer;
    kod_wewnetrzny: word;
    operacja_zewnetrzna: boolean; //wykonaj spawdzenie na zewnątrz (pojedyńczy klik, podwójny klik)
    klik,dwuklik: word; //jaki kod ma zostać wywołany w obu przypadkach (0 - funkcja nieaktywna)
    komenda0,komenda1,komenda2: shortstring;
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
    conn_mem: TZConnection;
    cr: TZSQLProcessor;
    czasy2: TZQuery;
    czasy_up_id: TZQuery;
    db: TZConnection;
    dbini: TZSQLProcessor;
    del_all: TZSQLProcessor;
    del_czasy_film: TZSQLProcessor;
    film: TZQuery;
    filmy2: TZQuery;
    filmy3: TZQuery;
    filmyidnext: TZSQLProcessor;
    http_yt: TNetSynHTTP;
    http2: TNetSynHTTP;
    ikeyadd: TZQuery;
    last_id: TZQuery;
    m_create: TZSQLProcessor;
    m_emotki: TZQuery;
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
    roz_upd: TZQuery;
    schemasync: TDBSchemaSyncSqlite;
    tasma: TZQuery;
    tasma_add: TZQuery;
    youtube: TYoutubeDownloader;
    zapis_add: TZQuery;
    tasma_clear: TZSQLProcessor;
    trans: TZTransaction;
    trans_mem: TZTransaction;
    update_sort: TZSQLProcessor;
    roz_id: TZQueryPlus;
    filmy_id: TZQueryPlus;
    czasy_id: TZQueryPlus;
    procedure czasy_idBeforeOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbBeforeConnect(Sender: TObject);
    procedure filmy_idBeforeOpen(DataSet: TDataSet);
    procedure roz_idBeforeOpen(DataSet: TDataSet);
  private
    ini: TIniFile;
  public
    CONST_EMOTKI: boolean;
    MajorVersion,MinorVersion,Release,Build: integer;
    aVER: string;
    procedure Init;
    procedure refresh_db_emotki;
    function GetHashCode(ANr: integer; aStare: boolean = false): string;
    procedure DaneDoSzyfrowaniaServer(var aVector,aKey: string);
    procedure DaneDoSzyfrowania(var aVector,aKey: string; aUDP: boolean = false);
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
    function GetTitleForYoutube(aLink: string): string;
    procedure zeruj_przycisk(var aKontrolka: TArchitektPrzycisk);
    procedure zeruj(var aKontrolka: TArchitekt);
    function pilot_wczytaj: TArchitektPilot;
    function www_zapis(aTxt: TStrings): boolean;
    procedure www_odczyt(aTxt: TStrings);
    function rozbij_adres_youtube(aWWW: string): string;
    function zloz_adres_youtube(aAdres: string; aTimeInteger: integer): string;
  end;

const
  CONST_MAX_BUFOR = 65535;
  CONST_DOMENA = 'pistudio.duckdns.org';

var
  music_no: integer = 0;
  CONST_UP_FILE_BUFOR: integer = 10240;
  CONST_DW_FILE_BUFOR: integer = 10240;
  www_url: string = 'https://'+CONST_DOMENA+'/sendfile.php';
  www_pin: string = '674364ggHGDS6763g3dGYGD76673g2gH';
  CLIPBOARD_PLAY: boolean = false;

var
  dm: Tdm;
  v_klawisze: TArchitekt;
  sciezka_db: string = '';
  ankieta_id: integer = 0;
  cytaty_id: integer = 0;
  _C_DATETIME: array [1..3] of word;
  _DEV_ON: boolean = false;
  _FULL_SCREEN: boolean = false;
  _DEF_MULTIMEDIA_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_FORMAT: integer = 0;
  _DEF_ENGINE_PLAYER: integer = 0;
  _DEF_FULLSCREEN_MEMORY: boolean = false;
  _DEF_FULLSCREEN_CURSOR_OFF: boolean = false;
  _DEF_COOKIES_FILE_YT: string = '';
  _DEF_GREEN_SCREEN: boolean = false;
  _SET_GREEN_SCREEN: boolean = false;
  _DEF_POLFAN: boolean = false;
  _FORCE_SHUTDOWNMODE: boolean = false;
  _MPLAYER_LOCALTIME: boolean = false;
  _MPLAYER_FORCESTART0_BOOL: boolean = false;
  _MPLAYER_FORCESTART0: integer = 0;
  _MPLAYER_CLIPBOARD_MEMORY: string = '';
  _MONITOR_CAM: integer = 0;
  _MONITOR_ALARM: integer = 0;
  _BLOCK_MUSIC_KEYS: boolean = false;
  _SETUP_INDEX: integer = 0;
  _STUDIO_PLAY_BLOCKED_0: boolean = false;
  _STUDIO_PLAY_BLOCKED_1: boolean = false;
  _STUDIO_PLAY_BLOCKED_2: boolean = false;
  _STUDIO_PLAY_BLOCKED_3: boolean = false;
  _STUDIO_PLAY_BLOCKED_4: boolean = false;
  _DEF_YT_AUTOSELECT: boolean = false;
  _DEF_YT_AS_QUALITY: integer = 0;
  _DEF_SHARED_C: integer = 0;
  _DEF_SHARED_S: integer = 0;

function FirstMinusToGeneratePlane(s: string; wykonaj_kod: boolean = true): string;

implementation

uses
  ecode, keystd, synacode, main;

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
  {$IFDEF MONITOR}
  conn_mem.Connect;
  m_create.Execute;
  refresh_db_emotki;
  {$ENDIF}
end;

procedure Tdm.czasy_idBeforeOpen(DataSet: TDataSet);
begin
  czasy_id.ClearDefs;
  if czasy_id.Tag=1 then czasy_id.AddDef('--join','join filmy f on f.id=c.film and (f.rozdzial is null or f.rozdzial in (select id from rozdzialy where noarchive=0))');
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  {$IFDEF MONITOR} conn_mem.Disconnect; {$ENDIF}
  ini.Free;
end;

procedure Tdm.dbBeforeConnect(Sender: TObject);
begin
  db.AutoEncodeStrings:=false;
end;

procedure Tdm.filmy_idBeforeOpen(DataSet: TDataSet);
begin
  filmy_id.ClearDefs;
  if filmy_id.Tag=1 then filmy_id.AddDef('--where','where rozdzial is null or rozdzial in (select id from rozdzialy where noarchive=0)');
end;

procedure Tdm.roz_idBeforeOpen(DataSet: TDataSet);
begin
  roz_id.ClearDefs;
  case roz_id.Tag of
    1: roz_id.AddDef('--where','where id>0 and noarchive<>1');
    2: roz_id.AddDef('--where','where id>0');
  end;
end;

procedure Tdm.refresh_db_emotki;
var
  plik: string;
  f: textfile;
  s,s1,s2: string;
begin
  plik:=MyConfDir('img'+_FF+'img.conf');
  CONST_EMOTKI:=FileExists(plik);
  if not CONST_EMOTKI then
  begin
    m_emotki.Open;
    trans_mem.StartTransaction;
    while not m_emotki.IsEmpty do m_emotki.Delete;
    trans_mem.Commit;
    m_emotki.Close;
    exit;
  end;
  assignfile(f,plik);
  reset(f);
  m_emotki.Open;
  trans_mem.StartTransaction;
  while not m_emotki.IsEmpty do m_emotki.Delete;
  while not eof(f) do
  begin
    readln(f,s);
    s1:=GetLineToStr(s,1,#9);
    if s1='' then continue;
    if s1[1]<>'<' then continue;
    s2:=GetLineToStr(s,2,#9);
    m_emotki.Append;
    m_emotki.FieldByName('nazwa').AsString:=s1;
    m_emotki.FieldByName('plik').AsString:=s2;
    m_emotki.Post;
  end;
  trans_mem.Commit;
  m_emotki.Close;
  closefile(f);
end;

procedure Tdm.Init;
begin
  {$IFDEF APP} SetConfDir('studio-jahu-player-youtube'); {$ENDIF}
  {$IFDEF MONITOR} SetConfDir('studio-jahu-komunikator'); {$ENDIF}
end;

function Tdm.GetHashCode(ANr: integer; aStare: boolean): string;
begin
  //aStare:=not aStare;
  if aStare then
  begin
    case ANr of
      1: result:='yusd6ydh7w8tgdyhgdys87d3'; //pliki dostępu z zaszyfrowanym adresem IP
      2: result:='h448s7S5Dj9r8jsdi8jik6si'; //transmisja sieciowa TCP
      3: result:='6763467dghhDHDyd7767GH78'; //kodowanie własnego klucza w komunikatorze
      4: result:='766dsyda73yyHUHydhud7838'; //kodowanie kluczy kontaktów w komunikatorze
      5: result:='7238yudf78yDYkd98HJ8ud89'; //kodowanie certyfikatów (kluczy do archiwizacji - import/export)
      6: result:='67jhredehJi8duuid8D878d9'; //kodowanie wizytówek (import/export)
    end;
    exit;
  end;
  case ANr of
    1: result:=globalny_h1; //pliki dostępu z zaszyfrowanym adresem IP
    2: result:=globalny_h2; //transmisja sieciowa TCP
    3: result:=globalny_h3; //kodowanie własnego klucza w komunikatorze
    4: result:=globalny_h4; //kodowanie kluczy kontaktów w komunikatorze
    5: result:=globalny_h5; //kodowanie certyfikatów (kluczy do archiwizacji - import/export)
    6: result:=globalny_h6; //kodowanie wizytówek (import/export)
    7: result:=globalny_h7; //kodowanie wizytówek typu Link-File (import/export)
  end;
end;

var
  NEW_VECTOR: string = '';

procedure Tdm.DaneDoSzyfrowaniaServer(var aVector, aKey: string);
begin
  aVector:=globalny_vec;
  aKey:=globalny_key;
end;

procedure Tdm.DaneDoSzyfrowania(var aVector, aKey: string; aUDP: boolean);
begin
  if aUDP then aVector:=globalny_vec else if NEW_VECTOR='' then aVector:=globalny_vec else aVector:=NEW_VECTOR;
  aKey:=globalny_key;
end;

procedure Tdm.DaneDoSzyfrowaniaSetNewVector(aNewVector: string);
begin
  if aNewVector='' then NEW_VECTOR:=globalny_vec else NEW_VECTOR:=aNewVector;
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

function Tdm.GetTitleForYoutube(aLink: string): string;
var
  vTitle,vDescription,vKeywords: string;
begin
  youtube.GetInformationsForAll(aLink,vTitle,vDescription,vKeywords);
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
  http2.UrlData:='tryb=0&id=1&pin='+www_pin+'&oper=1&seg=1&zapis='+EncodeURL(aTxt.Text);
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
  http2.UrlData:='tryb=0&id=1&pin='+www_pin+'&oper=2&seg=1&zapis=';
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

function Tdm.rozbij_adres_youtube(aWWW: string): string;
var
  s,s1,s2,s3,s4,s5,s6,pom: string;
  i: integer;
begin
  (*
    https://youtu.be/gdmRDThm1-8?t=2618  (43:38)
    https://www.youtube.com/watch?v=clbt12upuaA
  *)
  s:=StringReplace(aWWW,'//',#9,[]);
  s1:=GetLineToStr(s,1,#9);
  s2:=GetLineToStr(s,2,#9);
  if (s1<>'http:') and (s1<>'https:') then
  begin
    result:='';
    exit;
  end;
  s3:=GetLineToStr(s2,1,'/');
  if (s3<>'youtu.be') and (s3<>'www.youtube.com') and (s3<>'www.youtu.be') and (s3<>'youtube.com') then
  begin
    result:='';
    exit;
  end;
  s3:=GetLineToStr(aWWW,1,'?');
  s4:=GetLineToStr(aWWW,2,'?');
  result:=s3;
  i:=0;
  pom:='';
  while true do
  begin
    inc(i);
    s5:=GetLineToStr(s4,i,'&');
    s6:=GetLineToStr(s5,1,'=');
    if s6='' then
    begin
      result:=s3+pom;
      exit;
    end;
    if s6='t' then break else
    begin
      pom:=pom+'?'+s5;
      continue;
    end;
  end;
  result:=s3+pom;
end;

function Tdm.zloz_adres_youtube(aAdres: string; aTimeInteger: integer): string;
var
  b: boolean;
  s: string;
  a: integer;
begin
  s:=rozbij_adres_youtube(aAdres);
  if s='' then result:='' else
  if aTimeInteger=0 then result:=s else
  if pos('?',s)>0 then
    result:=s+'&t='+IntToStr(Trunc(aTimeInteger/1000))
  else
    result:=s+'?t='+IntToStr(Trunc(aTimeInteger/1000));
end;

end.

