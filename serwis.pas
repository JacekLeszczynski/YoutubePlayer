unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP, ZTransaction, DBSchemaSyncSqlite,
  YoutubeDownloader, ZQueryPlus, DBSchemaSync, AsyncProcess, IniFiles, DB,
  lcltype, ZConnection, ZSqlProcessor, ZDataset;

type
{  TArchitektPrzycisk = record
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
  end;}

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
    db: TZConnection;
    dbini: TZSQLProcessor;
    dbpilotcode: TStringField;
    dbpilotexec: TStringField;
    dbpilotid: TLargeintField;
    dbpilotlevel: TLongintField;
    dbpilotvalue: TLongintField;
    pyt_getile: TLargeintField;
    roz_daneautosort: TSmallintField;
    roz_daneautosortdesc: TSmallintField;
    roz_danedirectory: TStringField;
    roz_danefilm_id: TLargeintField;
    roz_daneformatfile: TLongintField;
    roz_daneid: TLargeintField;
    roz_danenazwa: TStringField;
    roz_danenoarchive: TSmallintField;
    roz_danenomemtime: TSmallintField;
    roz_danenormalize_audio: TSmallintField;
    roz_danenovideo: TSmallintField;
    roz_danesort: TLongintField;
    schemacustom: TDBSchemaSync;
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
    pyt_add: TZQuery;
    pyt_get: TZQuery;
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
    roz_dane: TZReadOnlyQuery;
    dbpilot: TZQuery;
    all1: TZQuery;
    all0: TZQuery;
    procedure czasy_idBeforeOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbAfterConnect(Sender: TObject);
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
    procedure SetConfig(AName: string; AValue: boolean);
    procedure SetConfig(AName: string; AValue: integer);
    procedure SetConfig(AName: string; AValue: int64);
    procedure SetConfig(AName: string; AValue: string);
    function GetConfig(AName: string; ADefault: boolean = false): boolean;
    function GetConfig(AName: string; ADefault: integer = 0): integer;
    function GetConfig(AName: string; ADefault: int64 = 0): int64;
    function GetConfig(AName: string; ADefault: string = ''): string;
    function GetTitleForYoutube(aLink: string): string;
    function www_zapis(aTxt: TStrings): boolean;
    procedure www_odczyt(aTxt: TStrings);
    function rozbij_adres_youtube(aWWW: string): string;
    function zloz_adres_youtube(aAdres: string; aTimeInteger: integer): string;
  end;

const
  CONST_MAX_BUFOR = 65535;
  CONST_DOMENA = 'pistudio.duckdns.org';

var
  CUSTOM_DB: boolean = false;
  music_no: integer = 0;
  CONST_UP_FILE_BUFOR: integer = 10240;
  CONST_DW_FILE_BUFOR: integer = 10240;
  www_url: string = 'https://'+CONST_DOMENA+'/sendfile.php';
  www_pin: string = '674364ggHGDS6763g3dGYGD76673g2gH';
  CLIPBOARD_PLAY: boolean = false;
  EXTFILE_PLAY: boolean = false;

var
  dm: Tdm;
  sciezka_db: string = '';
  ankieta_id: integer = 0;
  cytaty_id: integer = 0;
  _C_DATETIME: array [1..3] of smallint;
  _DEV_ON: boolean = false;
  _FULL_SCREEN: boolean = false;
  _DEF_SHUTDOWN_MODE: integer = 0;
  _DEF_CACHE: integer = 0;
  _DEF_CACHE_PREINIT: integer = 0;
  _DEF_ONLINE_CACHE: integer = 0;
  _DEF_ONLINE_CACHE_PREINIT: integer = 0;
  _DEF_MULTIDESKTOP: string = '';
  _DEF_MULTIDESKTOP_LEFT: integer = -1;
  _DEF_MULTIMEDIA_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_SAVE_DIR: string = '';
  _DEF_SCREENSHOT_FORMAT: integer = 0;
  _DEF_ENGINE_PLAYER: integer = 0;
  _DEF_ACCEL_PLAYER: integer = 0;
  _DEF_AUDIO_DEVICE: string = 'default';
  _DEF_AUDIO_DEVICE_MONITOR: string = 'default';
  _DEF_FULLSCREEN_MEMORY: boolean = false;
  _DEF_FULLSCREEN_CURSOR_OFF: boolean = false;
  _DEF_COOKIES_FILE_YT: string = '';
  _DEF_GREEN_SCREEN: boolean = false;
  _SET_GREEN_SCREEN: boolean = false;
  _DEF_VIEW_SCREEN: boolean = false;
  _SET_VIEW_SCREEN: boolean = false;
  _DEF_LAMP_FORMS: boolean = true;
  _SET_LAMP_FORMS: boolean = false;
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
  _DEF_YT_AS_QUALITY_PLAY: integer = 0;
  _DEF_PANEL: boolean = false;
  _DEF_CONFIG_MEMORY: array [0..1] of integer = (0,0);

const
  _genre = 195;
  _genre1: array [0..194] of string = (
    '0',   '1',   '2',   '3',   '4',   '5',   '6',   '7',   '8',   '9',
   '10',  '11',  '12',  '13',  '14',  '15',  '16',  '17',  '18',  '19',
   '20',  '21',  '22',  '23',  '24',  '25',  '26',  '27',  '28',  '29',
   '30',  '31',  '32',  '33',  '34',  '35',  '36',  '37',  '38',  '39',
   '40',  '41',  '42',  '43',  '44',  '45',  '46',  '47',  '48',  '49',
   '50',  '51',  '52',  '53',  '54',  '55',  '56',  '57',  '58',  '59',
   '60',  '61',  '62',  '63',  '64',  '65',  '66',  '67',  '68',  '69',
   '70',  '71',  '72',  '73',  '74',  '75',  '76',  '77',  '78',  '79',
   '80',  '81',  '82',  '83',  '84',  '85',  '86',  '87',  '88',  '89',
   '90',  '91',  '92',  '93',  '94',  '95',  '96',  '97',  '98',  '99',
  '100', '101', '102', '103', '104', '105', '106', '107', '108', '109',
  '110', '111', '112', '113', '114', '115', '116', '117', '118', '119',
  '120', '121', '122', '123', '124', '125', '126', '127', '128', '129',
  '130', '131', '132', '133', '134', '135', '136', '137', '138', '139',
  '140', '141', '142', '143', '144', '145', '146', '147', '148', '149',
  '150', '151', '152', '153', '154', '155', '156', '157', '158', '159',
  '160', '161', '162', '163', '164', '165', '166', '167', '168', '169',
  '170', '171', '172', '173', '174', '175', '176', '177', '178', '179',
  '180', '181', '182', '183', '184', '185', '186', '187', '188', '189',
  '190', '191', '255',  'CR',  'RX'
  );
  _genre2: array [0..194] of string = (
  'Blues', 'Classic Rock', 'Country', 'Dance', 'Disco', 'Funk', 'Grunge', 'Hip-Hop',
  'Jazz', 'Metal', 'New Age', 'Oldies', 'Other', 'Pop', 'R&B', 'Rap', 'Reggae', 'Rock',
  'Techno', 'Industrial', 'Alternative', 'Ska', 'Death Metal', 'Pranks', 'Soundtrack',
  'Euro-Techno', 'Ambient', 'Trip-Hop', 'Vocal', 'Jazz+Funk', 'Fusion', 'Trance',
  'Classical', 'Instrumental', 'Acid', 'House', 'Game', 'Sound Clip', 'Gospel', 'Noise',
  'Alt. Rock', 'Bass', 'Soul', 'Punk', 'Space', 'Meditative', 'Instrumental Pop',
  'Instrumental Rock', 'Ethnic', 'Gothic', 'Darkwave', 'Techno-Industrial', 'Electronic',
  'Pop-Folk', 'Eurodance', 'Dream', 'Southern Rock', 'Comedy', 'Cult', 'Gangsta Rap',
  'Top 40', 'Christian Rap', 'Pop/Funk', 'Jungle', 'Native American', 'Cabaret', 'New Wave',
  'Psychedelic', 'Rave', 'Showtunes', 'Trailer', 'Lo-Fi', 'Tribal', 'Acid Punk', 'Acid Jazz',
  'Polka', 'Retro', 'Musical', 'Rock & Roll', 'Hard Rock', 'Folk', 'Folk-Rock', 'National Folk',
  'Swing', 'Fast-Fusion', 'Bebop', 'Latin', 'Revival', 'Celtic', 'Bluegrass', 'Avantgarde',
  'Gothic Rock', 'Progressive Rock', 'Psychedelic Rock', 'Symphonic Rock', 'Slow Rock',
  'Big Band', 'Chorus', 'Easy Listening', 'Acoustic', 'Humour', 'Speech', 'Chanson',
  'Opera', 'Chamber Music', 'Sonata', 'Symphony', 'Booty Bass', 'Primus', 'Porn Groove',
  'Satire', 'Slow Jam', 'Club', 'Tango', 'Samba', 'Folklore', 'Ballad', 'Power Ballad',
  'Rhythmic Soul', 'Freestyle', 'Duet', 'Punk Rock', 'Drum Solo', 'A Cappella', 'Euro-House',
  'Dance Hall', 'Goa', 'Drum & Bass', 'Club-House', 'Hardcore', 'Terror', 'Indie', 'BritPop',
  'Afro-Punk', 'Polsk Punk', 'Beat', 'Christian Gangsta Rap', 'Heavy Metal', 'Black Metal',
  'Crossover', 'Contemporary Christian', 'Christian Rock', 'Merengue', 'Salsa', 'Thrash Metal',
  'Anime', 'JPop', 'Synthpop', 'Abstract', 'Art Rock', 'Baroque', 'Bhangra', 'Big Beat',
  'Breakbeat', 'Chillout', 'Downtempo', 'Dub', 'EBM', 'Eclectic', 'Electro', 'Electroclash',
  'Emo', 'Experimental', 'Garage', 'Global', 'IDM', 'Illbient', 'Industro-Goth', 'Jam Band',
  'Krautrock', 'Leftfield', 'Lounge', 'Math Rock', 'New Romantic', 'Nu-Breakz', 'Post-Punk',
  'Post-Rock', 'Psytrance', 'Shoegaze', 'Space Rock', 'Trop Rock', 'World Music', 'Neoclassical',
  'Audiobook',  'Audio Theatre', 'Neue Deutsche Welle', 'Podcast', 'Indie Rock', 'G-Funk',
  'Dubstep', 'Garage Rock', 'Psybient', 'None', 'Cover', 'Remix'
  );

function FirstMinusToGeneratePlane(s: string; wykonaj_kod: boolean = true): string;
function GenreToIndex(aGenre: string): integer;

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
      s:=trim(s);
      s:='  ^ '+s;
    end;
  end;
  result:=s;
end;

function GenreToIndex(aGenre: string): integer;
var
  i: integer;
  a: integer;
begin
  a:=-1;
  for i:=0 to _genre-1 do if _genre2[i]=aGenre then
  begin
    a:=i;
    break;
  end;
  result:=a;
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

procedure Tdm.dbAfterConnect(Sender: TObject);
var
  s: string;
  a,b,c: integer;
begin
  last_id.SQL.Clear;
  s:=upcase(db.Protocol);
  b:=pos('MARIADB',s);
  c:=pos('MYSQL',s);
  if a>0 then last_id.SQL.Add('select last_insert_rowid();') else
  if (b>0) or (c>0) then last_id.SQL.Add('select LAST_INSERT_ID();');
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

var
  NEW_VECTOR: string = '';

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
  result:=youtube.GetTitleForYoutube(aLink);
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

