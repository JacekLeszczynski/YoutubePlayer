unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP, ZTransaction, DBSchemaSyncSqlite,
  YoutubeDownloader, ZQueryPlus, DBSchemaSync, AsyncProcess, IniFiles, DB,
  lcltype, ZConnection, ZSqlProcessor, ZDataset, ZStoredProcedure, ZSqlUpdate,
  Process;

type

  TUzupelnijDaty_ListaFilmow = record
    id: integer;
    link: string;
    nazwa: string;
    data: TDate;
    data_ok: boolean;
    status: integer; //0-wolny, 1-do_zrobienia, 2-zrobiony
  end;

  { TExecuteCommand }

  TExecuteCommand = class(TThread)
  private
    vc: string;
  public
    constructor Create(aCommand: string);
    procedure Execute; override;
  end;

  { TUzupelnijDate }
  TUzupelnijDate = class(TThread)
  private
    proc: TAsyncProcess;
    debug: boolean;
    cookies: string;
    vId: integer;
    vLink: string;
    vNazwa: string;
    vData: TDate;
    vDataOk: boolean;
    vError: boolean;
    function GetTitleForYoutube(aLink: string): string;
    function GetDateForYoutube(aLink: string; var aData: TDate): boolean;
    procedure run;
    procedure odczytaj_dane;
    procedure zapisz_dane;
  public
    vIndeks: integer;
    constructor Create(aId: integer; aIndex: integer; aCookies: string = ''; aDebug: boolean = false);
    procedure Execute; override;
  end;

  { TUzupelnijDaty }

  TUzupelnijDaty = class(TThread)
  private
    debug: boolean;
    cookies: string;
    LW: integer; //liczba wątków
    wolny_indeks: integer;
    vIndeks: integer;
    proc: TAsyncProcess;
    fnazwa,str: string;
    fid,frc: integer;
    feof: boolean;
    flink: string;
    fdata: TDate;
    zrobione: boolean;
    vError: boolean;
    function GetTitleForYoutube(aLink: string): string;
    function GetDateForYoutube(aLink: string; var aData: TDate): boolean;
    procedure act_on;
    procedure act_off;
    procedure run;
    procedure uaktualnij;
    procedure open;
    procedure close;
    procedure pobierz_link;
    procedure zapisz_nazwe;
    procedure zapisz_date;
    procedure zapisz_nodate;
    procedure nastepny_rekord;
    (* część dot. wielu wątków *)
    procedure run_watki;
    procedure zwolnij_dane;
    procedure test;
    procedure test2;
    procedure dodaj_do_listy;
    procedure zapisz_wykonane;
  public
    constructor Create(aLiczbaWatkow: integer = 1; aCookiesFile: string = ''; aDebug: boolean = false);
    procedure Execute; override;
  end;

  { Tdm }

  Tdm = class(TDataModule)
    add_rec: TZSQLProcessor;
    add_rec0: TZSQLProcessor;
    add_rec2: TZSQLProcessor;
    db: TZConnection;
    dbpilot2code: TStringField;
    dbpilot2delay: TLongintField;
    dbpilot2exec: TStringField;
    dbpilot2exec2: TStringField;
    dbpilot2id: TLargeintField;
    dbpilot2level: TLongintField;
    dbpilot2value: TLongintField;
    dbpilotcode: TStringField;
    dbpilotdelay: TLongintField;
    dbpilotexec: TStringField;
    dbpilotexec2: TStringField;
    dbpilotid: TLargeintField;
    dbpilotlevel: TLongintField;
    dbpilotvalue: TLongintField;
    filmy_datydata_uploaded: TDateField;
    filmy_datydata_uploaded_noexist: TSmallintField;
    filmy_datyid: TLargeintField;
    filmy_datylink: TStringField;
    filmy_datynazwa: TStringField;
    film_rozautosort: TSmallintField;
    film_rozautosortdesc: TSmallintField;
    film_rozchroniony: TSmallintField;
    film_rozcrypted: TSmallintField;
    film_rozdirectory: TStringField;
    film_rozfilm_id: TLargeintField;
    film_rozformatfile: TLongintField;
    film_rozid: TLargeintField;
    film_rozignoruj: TSmallintField;
    film_rozluks_jednostka: TStringField;
    film_rozluks_kontener: TStringField;
    film_rozluks_wielkosc: TLargeintField;
    film_roznazwa: TStringField;
    film_roznoarchive: TSmallintField;
    film_roznomemtime: TSmallintField;
    film_roznormalize_audio: TSmallintField;
    film_roznovideo: TSmallintField;
    film_rozpoczekalnia_zapis_czasu: TSmallintField;
    film_rozsort: TLongintField;
    ini_get_binwartosc: TBlobField;
    ini_get_boolwartosc: TSmallintField;
    ini_get_int64wartosc: TLargeintField;
    ini_get_intwartosc: TLongintField;
    ini_get_stringwartosc: TMemoField;
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
    http_yt: TNetSynHTTP;
    http2: TNetSynHTTP;
    last_id: TZQuery;
    proc1: TAsyncProcess;
    http: TNetSynHTTP;
    roz_add: TZQuery;
    roz_del: TZQuery;
    roz_del1: TZSQLProcessor;
    roz_del2: TZSQLProcessor;
    roz_upd: TZQuery;
    schemasync: TDBSchemaSyncSqlite;
    tasma: TZQuery;
    tasma_add: TZQuery;
    UpdFilmData: TZQuery;
    youtube: TYoutubeDownloader;
    zapis_add: TZQuery;
    tasma_clear: TZSQLProcessor;
    trans: TZTransaction;
    roz_id: TZQueryPlus;
    filmy_id: TZQueryPlus;
    czasy_id: TZQueryPlus;
    roz_dane: TZReadOnlyQuery;
    dbpilot: TZQuery;
    SumNoAct: TZStoredProc;
    FilmInfo: TZStoredProc;
    ini_get_string: TZQuery;
    ini_set_string: TZQuery;
    ini_get_bool: TZQuery;
    ini_set_bool: TZQuery;
    ini_get_int: TZQuery;
    ini_set_int: TZQuery;
    ini_get_int64: TZQuery;
    ini_set_int64: TZQuery;
    filmy_daty: TZQuery;
    dbpilot2: TZQuery;
    UpdFilmNazwa: TZQuery;
    UpdFilmNoData: TZQuery;
    film_title: TZQuery;
    roz_add_crypted: TZStoredProc;
    roz_del_crypted: TZStoredProc;
    film_link: TZQuery;
    blok_add: TZQuery;
    ini_set_bin: TZQuery;
    ini_get_bin: TZQuery;
    ZUpdateSQL1: TZUpdateSQL;
    procedure czasy_idBeforeOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbAfterConnect(Sender: TObject);
    procedure dbBeforeConnect(Sender: TObject);
    procedure dbBeforeDisconnect(Sender: TObject);
    procedure filmBeforeOpen(DataSet: TDataSet);
    procedure filmy_datyBeforeOpen(DataSet: TDataSet);
    procedure filmy_idBeforeOpen(DataSet: TDataSet);
    procedure filmy_idBeforeOpenII(Sender: TObject);
    procedure film_linkBeforeOpen(DataSet: TDataSet);
    procedure film_titleBeforeOpen(DataSet: TDataSet);
    procedure roz_idBeforeOpen(DataSet: TDataSet);
    procedure ZUpdateSQL1BeforeInsertSQL(Sender: TObject);
    procedure ZUpdateSQL1BeforeModifySQL(Sender: TObject);
  private
    ini: TIniFile;
    memTytul,memKomentarz: string;
    memCytat: boolean;
  public
    MajorVersion,MinorVersion,Release,Build: integer;
    aVER: string;
    UD_LISTA: TList;
    UD_COUNT: integer;
    procedure Init;
    function GetLastID: integer;
    procedure SetConfig(AName: string; AValue: boolean);
    procedure SetConfig(AName: string; AValue: integer);
    procedure SetConfig(AName: string; AValue: int64);
    procedure SetConfig(AName: string; AValue: string);
    procedure SetConfig(AName: string; const AValue: TMemoryStream);
    function GetConfig(AName: string; ADefault: boolean = false): boolean;
    function GetConfig(AName: string; ADefault: integer = 0): integer;
    function GetConfig(AName: string; ADefault: int64 = 0): int64;
    function GetConfig(AName: string; ADefault: string = ''): string;
    function GetConfig(AName: string; AValue: TMemoryStream): boolean;
    function GetTitleForYoutube(aLink: string): string;
    function www_zapis(aTxt: TStrings): boolean;
    procedure www_odczyt(aTxt: TStrings);
    function rozbij_adres_youtube(aWWW: string): string;
    function zloz_adres_youtube(aAdres: string; aTimeInteger: integer): string;
    function GetOGGFileInfo(const filename: string; var title, artist, album: string): Boolean;
    function SetOGGFileInfo(const filename, title, artist, album: string): Boolean;
    function GetLuksKontenerFilename(aNazwaRozdzialu,aDomyslnyKatalog,aKontenerLuks: string): string;
    function ReadLogoFileName(aResolution: string): string;
    procedure UpdateCookiesYtFile;
    procedure UpdateSrtCzolowka(aTytul,aKomentarz: string);
    procedure UpdateSrtCytat;
  end;

const
  CONST_MAX_BUFOR = 65535;
  CONST_DOMENA = 'pistudio.duckdns.org';
  CONST_DEFAULT_INFO_DELAY = 30;
  CONST_PASS = '645wr36d7f84u598j5dr2us7di39dj4j';
  CONST_COOKIES_FILE_YT = '/tmp/studio-jahu-tmp/cookies.txt';

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
  cytaty_id: integer = 0;
  _LICZNIK_DATA_LEN: integer = 0;
  _DEF_UPDATE_MENU: boolean;
  _FORCE_CLOSE: boolean = false;
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
  _DEF_FULLSCREEN_ALT1: boolean = false;
  _DEF_FULLSCREEN_MEMORY: boolean = false;
  _DEF_FULLSCREEN_CURSOR_OFF: boolean = false;
  _DEF_COOKIES_YT: string = '';
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
  _DEF_DOWNLOADER_ENGINE: integer = 0;
  _DEF_YT_AUTOSELECT: boolean = false;
  _DEF_YT_AS_QUALITY: integer = 0;
  _DEF_YT_AS_QUALITY_PLAY: integer = 0;
  _DEF_PANEL: boolean = false;
  _DEF_CONFIG_MEMORY: array [0..1] of integer = (0,0);
  _DEF_COUNT_PROCESS_UPDATE_DATA: integer = 0;
  _DEF_DEBUG: boolean = false;
  _DEF_YOUTUBE_APIKEY: string = '';
  _DEF_YOUTUBE_VIDEOID: string = '';
  _DEF_YOUTUBE_LIVECHATID: string = '';
  _MEM_YOUTUBE_LIVECHAT_PYTANIE: string = '';
  _DEF_INFOTEXT_MPLAYER_NOACTIVE: string = '';
  _DEF_CONSOLE: boolean = false;
  _DEF_SUDO_PASSWORD: string = '';
  _FORCE_STREAM_RECORD: boolean = false;
  _SHUTDOWN_TIMER_NOW: boolean = false;

var
  CON_OBS: boolean = false;

var (* MPLAYER2 *)
  (* Poniższe linie dotyczą filmu który jest komentowany *)
  mplayer2_logo_picture: TMemoryStream;
  mplayer2_logo_czas: string = '';
  mplayer2_logo_czas_exist: string = '';
  mplayer2_logo_720x480: string = '--lavfi-complex=[vid1][vid2]overlay=W-w-5:H-h-350[vo] --external-file=';  //obrazek 87x87
  mplayer2_logo_1280x720: string = '--lavfi-complex=[vid1][vid2]overlay=W-w-72:H-h-579[vo] --external-file=';  //obrazek 87x87
  mplayer2_logo_1920x1280: string = '--lavfi-complex=[vid1][vid2]overlay=W-w-110:H-h-870[vo] --external-file='; //obrazek 130x130
  mplayer2_text: string = '--sub-align-x=left --sub-justify=center --sub-margin-x=50 --sub-margin-y=50 --sub-scale=0.5';
  (* Reszta *)
  mplayer2_control: integer = 0;
  mplayer2_fm: integer = 0; //0 - nic, 1 - czołówka, 2 - film główny, 3 - zakończenie
  mplayer2_czas_first: integer = 0;
  mplayer2_automute: boolean = false;
  mplayer2_czas_stop: integer = 0;
  mplayer2_czas: integer = 0;
  mplayer2_czas_last: integer = -1;
  mplayer2_rec: record
    id,id_filmu,czas,pozycja,komenda,nowa_pozycja,code: integer;
    czas_odebrany: TTime;
    nick,opis,pilot,execute,mem: string;
  end;

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
  ecode, keystd, synacode, main, lazfileutils;

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

{ TExecuteCommand }

constructor TExecuteCommand.Create(aCommand: string);
begin
  vc:=aCommand;
  FreeOnTerminate:=true;
  inherited Create(false);
end;

procedure TExecuteCommand.Execute;
var
  p: TProcess;
  a: integer;
begin
  p:=TProcess.Create(nil);
  p.Options:=[poWaitOnExit];
  p.ShowWindow:=swoHIDE;
  p.CommandLine:=vc;
  a:=pos('sh ',vc);
  if a<>1 then p.CurrentDirectory:=ExtractFilePath(vc);
  try
    p.Execute;
    p.Terminate(0);
  finally
    p.Free;
  end;
end;

{ TUzupelnijDate }

function TUzupelnijDate.GetTitleForYoutube(aLink: string): string;
var
  ss: TStrings;
  s: string;
  i: integer;
begin
  (* TITLE *)
  proc.Parameters.Clear;
  try
    if cookies<>'' then
    begin
      proc.Parameters.Add('--cookies');
      proc.Parameters.Add(cookies);
    end;
    proc.Parameters.Add('-e');
    proc.Parameters.Add(aLink);
    proc.Execute;
    if proc.Output.NumBytesAvailable>0 then
    begin
      ss:=TStringList.Create;
      try
        ss.LoadFromStream(proc.Output);
        if debug then writeln('DEBUG: F: GetTitleForYoutube (wątek: TUzupelnijDate) ID=',vId);
        {for i:=0 to ss.Count-1 do
        begin
          s:=trim(ss[i]);
          if s='' then continue;
          if debug then writeln('DEBUG: var = "',s,'"');
          if pos('WARNING:',s)>0 then continue;
          if pos('FutureWarning:',s)>0 then continue;
          if pos('inner =',s)>0 then continue;
          if pos('ERROR:',s)>0 then
          begin
            vError:=true;
            break;
          end;
          result:=s;
          if debug then writeln('DEBUG: Result = "',s,'"');
          break;
        end;}
        result:=ss[ss.Count-1];
      finally
        ss.Free;
      end;
    end;
  finally
    try proc.Terminate(0) except end;
  end;
end;

function TUzupelnijDate.GetDateForYoutube(aLink: string; var aData: TDate
  ): boolean;
var
  ss: TStrings;
  s,data: string;
  i: integer;
  r,m,d: word;
begin
  (*
  Znane problemy nie wciągnięte do kodu:
    ERROR: [youtube] bcj_LIuzfL0: This video has been removed for violating YouTube's Community Guidelines
  *)
  (* DATE *)
  proc.Parameters.Clear;
  try
    if cookies<>'' then
    begin
      proc.Parameters.Add('--cookies');
      proc.Parameters.Add(cookies);
    end;
    proc.Parameters.Add('--get-filename');
    proc.Parameters.Add('--output');
    proc.Parameters.Add('"%(upload_date)s"');
    proc.Parameters.Add(aLink);
    proc.Execute;
    if proc.Output.NumBytesAvailable>0 then
    begin
      ss:=TStringList.Create;
      try
        ss.LoadFromStream(proc.Output);
        if debug then writeln('DEBUG: F: GetDateForYoutube (wątek: TUzupelnijDate) ID=',vId);
        {for i:=0 to ss.Count-1 do
        begin
          s:=trim(ss[i]);
          if s='' then continue;
          if debug then writeln('DEBUG: var = "',s,'"');
          if pos('WARNING:',s)>0 then continue;
          if pos('Install PhantomJS to workaround the issue.',s)>0 then continue;
          if pos('FutureWarning:',s)>0 then continue;
          if pos('inner =',s)>0 then continue;
          data:=s;
          if debug then writeln('DEBUG: Result = "',data,'"');
          break;
        end;}
        data:=ss[ss.Count-1];
      finally
        ss.Free;
      end;
    end;
  finally
    try proc.Terminate(0) except end;
  end;
  try
    if data<>'' then if data[1]='"' then delete(data,1,1);
    r:=strtoint(copy(data,1,4));
    m:=strtoint(copy(data,5,2));
    d:=strtoint(copy(data,7,2));
    aData:=EncodeDate(r,m,d);
    result:=true;
  except
    on E: Exception do
    begin
      if debug then
      begin
        writeln('Error: '+E.Message);
        writeln('Prawdopodobnie jest jakiś problem z zamianą ciagu "'+data+'" na datę.');
        writeln('Podgląd zmiennych:');
        writeln('  data = ',data);
        writeln('  r = ',r);
        writeln('  m = ',m);
        writeln('  d = ',d);
      end;
      result:=false;
    end;
  end;
end;

procedure TUzupelnijDate.run;
begin
  synchronize(@odczytaj_dane);
  if vNazwa='' then
  begin
    try
      vNazwa:=GetTitleForYoutube(vLink);
    except
      vError:=true;
    end;
    sleep(200);
  end else vNazwa:='';
  if not vError then
  begin
    try
      vDataOk:=GetDateForYoutube(vLink,vData);
    except
      vDataOk:=false;
    end;
  end;
  sleep(200);
  synchronize(@zapisz_dane);
end;

procedure TUzupelnijDate.odczytaj_dane;
var
  a: ^TUzupelnijDaty_ListaFilmow;
begin
  a:=dm.UD_LISTA[vIndeks];
  vLink:=a^.link;
  vNazwa:=a^.nazwa;
  vData:=a^.data;
end;

procedure TUzupelnijDate.zapisz_dane;
var
  a: ^TUzupelnijDaty_ListaFilmow;
begin
  a:=dm.UD_LISTA[vIndeks];
  if vError then
  begin
    a^.status:=0;
    exit;
  end;
  a^.nazwa:=vNazwa;
  if vDataOk then
  begin
    a^.data:=vData;
    a^.data_ok:=vDataOk;
  end else a^.data_ok:=false;
  a^.status:=2;
end;

constructor TUzupelnijDate.Create(aId: integer; aIndex: integer;
  aCookies: string; aDebug: boolean);
begin
  vId:=aId;
  vIndeks:=aIndex;
  cookies:=aCookies;
  debug:=aDebug;
  vError:=false;
  FreeOnTerminate:=true;
  inherited Create(false);
end;

procedure TUzupelnijDate.Execute;
begin
  proc:=TAsyncProcess.Create(nil);
  //proc.Executable:='youtube-dl';
  proc.Executable:='yt-dlp';
  //case FEngine of
  //  enDefault,enDefBoost: proc.Executable:='youtube-dl';
  //  enDefPlus:            proc.Executable:='yt-dlp';
  //end;
  proc.Options:=[poWaitOnExit,poUsePipes,poNoConsole,poStderrToOutPut];
  proc.Priority:=ppNormal;
  proc.ShowWindow:=swoNone;
  try
    run;
  finally
    proc.Free;
  end;
end;

{ TUzupelnijDaty }

function TUzupelnijDaty.GetTitleForYoutube(aLink: string): string;
var
  ss: TStrings;
  s: string;
  i: integer;
begin
  (* TITLE *)
  proc.Parameters.Clear;
  try
    if cookies<>'' then
    begin
      proc.Parameters.Add('--cookies');
      proc.Parameters.Add(cookies);
    end;
    proc.Parameters.Add('-e');
    proc.Parameters.Add(aLink);
    proc.Execute;
    if proc.Output.NumBytesAvailable>0 then
    begin
      ss:=TStringList.Create;
      try
        ss.LoadFromStream(proc.Output);
        if debug then writeln('DEBUG: F: GetTitleForYoutube (wątek: TUzupelnijDate) Link: ',aLink);
        for i:=0 to ss.Count-1 do
        begin
          s:=trim(ss[i]);
          if s='' then continue;
          if debug then writeln('DEBUG: var = "',s,'"');
          if pos('WARNING:',s)>0 then continue;
          if pos('FutureWarning:',s)>0 then continue;
          if pos('inner =',s)>0 then continue;
          if pos('ERROR:',s)>0 then
          begin
            vError:=true;
            break;
          end;
          result:=s;
          if debug then writeln('DEBUG: Result = "',s,'"');
          break;
        end;
      finally
        ss.Free;
      end;
    end;
  finally
    try proc.Terminate(0) except end;
  end;
end;

function TUzupelnijDaty.GetDateForYoutube(aLink: string; var aData: TDate
  ): boolean;
var
  ss: TStrings;
  s,data: string;
  i: integer;
  r,m,d: word;
begin
  (* DATE *)
  proc.Parameters.Clear;
  try
    if cookies<>'' then
    begin
      proc.Parameters.Add('--cookies');
      proc.Parameters.Add(cookies);
    end;
    proc.Parameters.Add('--get-filename');
    proc.Parameters.Add('--output');
    proc.Parameters.Add('"%(upload_date)s"');
    proc.Parameters.Add(aLink);
    proc.Execute;
    if proc.Output.NumBytesAvailable>0 then
    begin
      ss:=TStringList.Create;
      try
        ss.LoadFromStream(proc.Output);
        if debug then writeln('DEBUG: F: GetDateForYoutube (wątek: TUzupelnijDate) Link: ',aLink);
        for i:=0 to ss.Count-1 do
        begin
          s:=trim(ss[i]);
          if s='' then continue;
          if debug then writeln('DEBUG: var = "',s,'"');
          if pos('WARNING:',s)>0 then continue;
          if pos('FutureWarning:',s)>0 then continue;
          if pos('inner =',s)>0 then continue;
          data:=s;
          if debug then writeln('DEBUG: Result = "',data,'"');
          break;
        end;
      finally
        ss.Free;
      end;
    end;
  finally
    try proc.Terminate(0) except end;
  end;
  try
    if data<>'' then if data[1]='"' then delete(data,1,1);
    r:=strtoint(copy(data,1,4));
    m:=strtoint(copy(data,5,2));
    d:=strtoint(copy(data,7,2));
    aData:=EncodeDate(r,m,d);
    result:=true;
  except
    result:=false;
  end;
end;

procedure TUzupelnijDaty.act_on;
begin
  Form1.Label14.Caption:='0%';
  Form1.uELED6.Active:=true;
  Form1.Label14.Visible:=true;
end;

procedure TUzupelnijDaty.act_off;
begin
  Form1.uELED6.Active:=false;
  Form1.Label14.Visible:=false;
  Form1.filmy_refresh;
end;

procedure TUzupelnijDaty.run;
var
  nazwa,link,s1,s2: string;
  b,e,e2: boolean;
  data: TDate;
  aa,licznik: integer;
begin
  if feof then exit;
  aa:=frc;
  licznik:=0;
  while not feof do
  begin
    synchronize(@pobierz_link);
    nazwa:=fnazwa;
    link:=flink;
    e:=false;
    e2:=false;
    vError:=false;
    if link<>'' then
    begin
      b:=false;
      if pos('/ipfs.io/',link)>0 then b:=true;
      if not b then
      begin
        try
          if nazwa='' then nazwa:=GetTitleForYoutube(link);
          try
            b:=GetDateForYoutube(link,data);
          except
            e2:=true;
          end;
        except
          e:=true;
        end;
      end;
      if not e then
      begin
        if (fnazwa='') and (nazwa<>'') then
        begin
          fnazwa:=nazwa;
          synchronize(@zapisz_nazwe);
        end;
        if (not e2) and b then
        begin
          fdata:=data;
          synchronize(@zapisz_date);
        end else synchronize(@zapisz_nodate);
      end;
    end;
    s2:=s1;
    inc(licznik);
    s1:=IntToStr(round(licznik*100/aa))+'%';
    if not e then
    begin
      if s1<>s2 then
      begin
        str:=s1;
        synchronize(@uaktualnij);
      end;
      synchronize(@nastepny_rekord);
    end;
  end;
end;

procedure TUzupelnijDaty.uaktualnij;
begin
  Form1.Label14.Caption:=str;
end;

procedure TUzupelnijDaty.open;
begin
  dm.filmy_daty.Open;
  frc:=dm.filmy_daty.RecordCount;
  feof:=dm.filmy_daty.EOF;
end;

procedure TUzupelnijDaty.close;
begin
  dm.filmy_daty.Close;
end;

procedure TUzupelnijDaty.pobierz_link;
begin
  fid:=dm.filmy_datyid.AsInteger;
  fnazwa:=dm.filmy_datynazwa.AsString;
  flink:=dm.filmy_datylink.AsString;
end;

procedure TUzupelnijDaty.zapisz_nazwe;
begin
  dm.filmy_daty.Edit;
  dm.filmy_datynazwa.AsString:=fnazwa;
  dm.filmy_daty.Post;
end;

procedure TUzupelnijDaty.zapisz_date;
begin
  dm.filmy_daty.Edit;
  dm.filmy_datydata_uploaded.AsDateTime:=fdata;
  dm.filmy_daty.Post;
end;

procedure TUzupelnijDaty.zapisz_nodate;
begin
  dm.filmy_daty.Edit;
  dm.filmy_datydata_uploaded_noexist.AsInteger:=1;
  dm.filmy_daty.Post;
end;

procedure TUzupelnijDaty.nastepny_rekord;
begin
  dm.filmy_daty.Next;
  feof:=dm.filmy_daty.EOF;
end;

procedure TUzupelnijDaty.run_watki;
var
  nazwa,link,s1,s2: string;
  b: boolean;
  data: TDate;
  aa,licznik: integer;
begin
  if feof then exit;
  wolny_indeks:=-1;
  aa:=frc;
  licznik:=0;
  while not feof do
  begin
    synchronize(@pobierz_link);
    nazwa:=fnazwa;
    link:=flink;
    if (link<>'') and ((pos('https://www.youtube.com/',link)>0) or (pos('https://youtu.be/',link)>0)) then
    begin
      b:=false;
      if pos('/ipfs.io/',link)>0 then b:=true;
      if not b then
      begin
        while true do
        begin
          synchronize(@zapisz_wykonane);
          sleep(200);
          synchronize(@test);
          if wolny_indeks>-1 then break;
          sleep(500);
        end;
        synchronize(@dodaj_do_listy);
      end;
    end;
    s2:=s1;
    inc(licznik);
    s1:=IntToStr(round(licznik*100/aa))+'%';
    if s1<>s2 then
    begin
      str:=s1;
      synchronize(@uaktualnij);
    end;
    synchronize(@nastepny_rekord);
  end;
  zrobione:=false;
  while true do
  begin
    synchronize(@test2);
    if zrobione then break;
    sleep(500);
  end;
  synchronize(@zapisz_wykonane);
end;

procedure TUzupelnijDaty.zwolnij_dane;
var
  a: TList;
  b: ^TUzupelnijDaty_ListaFilmow;
  i: integer;
begin
  a:=dm.UD_LISTA;
  for i:=a.Count-1 downto 0 do
  begin
    b:=a[i];
    dispose(b);
    a.Delete(i);
  end;
  dm.UD_COUNT:=-1;
end;

procedure TUzupelnijDaty.test;
var
  a: TList;
  b: ^TUzupelnijDaty_ListaFilmow;
  x,i: integer;
begin
  wolny_indeks:=-1;
  x:=-1;
  a:=dm.UD_LISTA;
  (* przeszukuję wolne indeksy, które już są *)
  for i:=0 to dm.UD_COUNT-1 do
  begin
    b:=a[i];
    if b^.status=0 then
    begin
      x:=i;
      break;
    end;
  end;
  (* jeśli znalazłem, ustawiam i wychodzę *)
  if x>-1 then
  begin
    wolny_indeks:=x;
    exit;
  end;
  (* sprawdzam, czy mogę dodać nowy *)
  if dm.UD_COUNT<LW then
  begin
    inc(dm.UD_COUNT);
    new(b);
    x:=a.Add(b);
  end;
  (* jeśli udało się dodać, ustawiam i wychodzę *)
  if x>-1 then wolny_indeks:=x;
end;

procedure TUzupelnijDaty.test2;
var
  a: TList;
  b: ^TUzupelnijDaty_ListaFilmow;
  x,i: integer;
begin
  zrobione:=true;
  a:=dm.UD_LISTA;
  (* przeszukuję wolne indeksy, które już są *)
  for i:=0 to dm.UD_COUNT-1 do
  begin
    b:=a[i];
    if b^.status=1 then
    begin
      zrobione:=false;
      break;
    end;
  end;
end;

procedure TUzupelnijDaty.dodaj_do_listy;
var
  a: TList;
  b: ^TUzupelnijDaty_ListaFilmow;
  c: TUzupelnijDate;
begin
  a:=dm.UD_LISTA;
  b:=a[wolny_indeks];
  b^.id:=fid;
  b^.link:=flink;
  b^.nazwa:=fnazwa;
  b^.status:=1;
  c:=TUzupelnijDate.Create(fid,wolny_indeks,cookies,debug);
end;

procedure TUzupelnijDaty.zapisz_wykonane;
var
  a: TList;
  b: ^TUzupelnijDaty_ListaFilmow;
  i: integer;
begin
  a:=dm.UD_LISTA;
  for i:=0 to a.Count-1 do
  begin
    b:=a[i];
    if b^.status=2 then
    begin
      if b^.nazwa<>'' then
      begin
        dm.UpdFilmNazwa.ParamByName('id').AsInteger:=b^.id;
        dm.UpdFilmNazwa.ParamByName('nazwa').AsString:=b^.nazwa;
        dm.UpdFilmNazwa.ExecSQL;
      end;
      if b^.data_ok then
      begin
        dm.UpdFilmData.ParamByName('id').AsInteger:=b^.id;
        dm.UpdFilmData.ParamByName('data').AsDate:=b^.data;
        dm.UpdFilmData.ExecSQL;
      end else begin
        dm.UpdFilmNoData.ParamByName('id').AsInteger:=b^.id;
        dm.UpdFilmNoData.ExecSQL;
      end;
      b^.status:=0;
    end;
  end;
end;

constructor TUzupelnijDaty.Create(aLiczbaWatkow: integer; aCookiesFile: string;
  aDebug: boolean);
begin
  if dm.UD_COUNT>-1 then exit;
  dm.UD_COUNT:=0;
  LW:=aLiczbaWatkow;
  cookies:=aCookiesFile;
  debug:=aDebug;
  FreeOnTerminate:=true;
  inherited Create(false);
end;

procedure TUzupelnijDaty.Execute;
begin
  synchronize(@act_on);
  synchronize(@open);
  if LW=0 then
  begin
    if frc<5 then LW:=1 else LW:=8;
  end;
  if LW=1 then
  begin
    proc:=TAsyncProcess.Create(nil);
    proc.Executable:='yt-dlp';
    //case FEngine of
    //  enDefault,enDefBoost: proc.Executable:='youtube-dl';
    //  enDefPlus:            proc.Executable:='yt-dlp';
    //end;
    proc.Options:=[poWaitOnExit,poUsePipes,poNoConsole];
    proc.Priority:=ppNormal;
    proc.ShowWindow:=swoNone;
  end;
  try
    if LW=1 then run else run_watki;
  finally
    synchronize(@close);
    synchronize(@act_off);
    if LW=1 then proc.Free;
    synchronize(@zwolnij_dane);
  end;
end;

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  UD_LISTA:=TList.Create;
  memTytul:='';
  memKomentarz:='';
  memCytat:=false;
  mplayer2_logo_picture:=TMemoryStream.Create;
  Init;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  UD_LISTA.Free;
  mplayer2_logo_picture.Free;
end;

procedure Tdm.czasy_idBeforeOpen(DataSet: TDataSet);
begin
  czasy_id.ClearDefs;
  if czasy_id.Tag=1 then czasy_id.AddDef('--join','join filmy f on f.id=c.film and (f.rozdzial is null or f.rozdzial in (select id from rozdzialy where noarchive=0))');
end;

procedure Tdm.dbAfterConnect(Sender: TObject);
var
  s: string;
  a,b,c: integer;
begin
  //trans.PingStart;
  last_id.SQL.Clear;
  s:=upcase(db.Protocol);
  a:=0;
  b:=pos('MARIADB',s);
  c:=pos('MYSQL',s);
  if a>0 then last_id.SQL.Add('select last_insert_rowid();') else
  if (b>0) or (c>0) then last_id.SQL.Add('select LAST_INSERT_ID();');
end;

procedure Tdm.dbBeforeConnect(Sender: TObject);
begin
  db.AutoEncodeStrings:=false;
end;

procedure Tdm.dbBeforeDisconnect(Sender: TObject);
begin
  //trans.PingStop;
end;

procedure Tdm.filmBeforeOpen(DataSet: TDataSet);
begin
  film.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.filmy_datyBeforeOpen(DataSet: TDataSet);
begin
  filmy_daty.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.filmy_idBeforeOpen(DataSet: TDataSet);
begin
  filmy_id.ClearDefs;
  if filmy_id.Tag=1 then filmy_id.AddDef('--where','where rozdzial is null or rozdzial in (select id from rozdzialy where noarchive=0)');
end;

procedure Tdm.filmy_idBeforeOpenII(Sender: TObject);
begin
  filmy_id.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.film_linkBeforeOpen(DataSet: TDataSet);
begin
  film_link.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.film_titleBeforeOpen(DataSet: TDataSet);
begin
  film_title.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.roz_idBeforeOpen(DataSet: TDataSet);
begin
  roz_id.ClearDefs;
  case roz_id.Tag of
    1: roz_id.AddDef('--where','where id>0 and noarchive<>1');
    2: roz_id.AddDef('--where','where id>0');
  end;
end;

procedure Tdm.ZUpdateSQL1BeforeInsertSQL(Sender: TObject);
begin
  ZUpdateSQL1.Params.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.ZUpdateSQL1BeforeModifySQL(Sender: TObject);
begin
  ZUpdateSQL1.Params.ParamByName('pass').AsString:=globalny_h1;
end;

procedure Tdm.Init;
begin
  UD_COUNT:=-1;
  {$IFDEF APP} SetConfDir('studio-jahu-player-youtube'); {$ENDIF}
end;

function Tdm.GetLastID: integer;
begin
  last_id.Open;
  result:=last_id.Fields[0].AsInteger;
  last_id.Close;
end;

var
  NEW_VECTOR: string = '';

procedure Tdm.SetConfig(AName: string; AValue: boolean);
var
  a: integer;
begin
  if AValue then a:=1 else a:=0;
  ini_set_bool.ParamByName('zmienna').AsString:=AName;
  ini_set_bool.ParamByName('wartosc').AsInteger:=a;
  ini_set_bool.ExecSQL;
end;

procedure Tdm.SetConfig(AName: string; AValue: integer);
begin
  ini_set_int.ParamByName('zmienna').AsString:=AName;
  ini_set_int.ParamByName('wartosc').AsInteger:=AValue;
  ini_set_int.ExecSQL;
end;

procedure Tdm.SetConfig(AName: string; AValue: int64);
begin
  ini_set_int64.ParamByName('zmienna').AsString:=AName;
  ini_set_int64.ParamByName('wartosc').AsLargeInt:=AValue;
  ini_set_int64.ExecSQL;
end;

procedure Tdm.SetConfig(AName: string; AValue: string);
begin
  ini_set_string.ParamByName('zmienna').AsString:=AName;
  ini_set_string.ParamByName('wartosc').AsString:=AValue;
  ini_set_string.ExecSQL;
end;

procedure Tdm.SetConfig(AName: string; const AValue: TMemoryStream);
begin
  ini_set_bin.ParamByName('zmienna').AsString:=AName;
  if AValue=nil then ini_set_bin.ParamByName('wartosc').Clear else ini_set_bin.ParamByName('wartosc').LoadFromStream(AValue,ftBlob);
  ini_set_bin.ExecSQL;
end;

function Tdm.GetConfig(AName: string; ADefault: boolean): boolean;
begin
  ini_get_bool.ParamByName('zmienna').AsString:=AName;
  ini_get_bool.Open;
  if ini_get_boolwartosc.IsNull then result:=ADefault else if ini_get_boolwartosc.AsInteger=1 then result:=true else result:=false;
  ini_get_bool.Close;
end;

function Tdm.GetConfig(AName: string; ADefault: integer): integer;
begin
  ini_get_int.ParamByName('zmienna').AsString:=AName;
  ini_get_int.Open;
  if ini_get_intwartosc.IsNull then result:=ADefault else result:=ini_get_intwartosc.AsInteger;
  ini_get_int.Close;
end;

function Tdm.GetConfig(AName: string; ADefault: int64): int64;
begin
  ini_get_int64.ParamByName('zmienna').AsString:=AName;
  ini_get_int64.Open;
  if ini_get_int64wartosc.IsNull then result:=ADefault else result:=ini_get_int64wartosc.AsLargeInt;
  ini_get_int64.Close;
end;

function Tdm.GetConfig(AName: string; ADefault: string): string;
begin
  ini_get_string.ParamByName('zmienna').AsString:=AName;
  ini_get_string.Open;
  if ini_get_stringwartosc.IsNull then result:=ADefault else result:=ini_get_stringwartosc.AsString;
  ini_get_string.Close;
end;

function Tdm.GetConfig(AName: string; AValue: TMemoryStream): boolean;
begin
  result:=false;
  ini_get_bin.ParamByName('zmienna').AsString:=AName;
  ini_get_bin.Open;
  if ini_get_binwartosc.IsNull then result:=false else
  begin
    ini_get_binwartosc.SaveToStream(AValue);
    result:=true;
  end;
  ini_get_bin.Close;
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

function Tdm.GetOGGFileInfo(const filename: string; var title, artist,
  album: string): Boolean;
var
  f: TMemIniFile;
begin
  Result := False;

  f := TMemIniFile.Create(filename);
  try
    title := f.ReadString('info', 'title', '');
    artist := f.ReadString('info', 'artist', '');
    album := f.ReadString('info', 'album', '');

    Result := (title <> '') or (artist <> '') or (album <> '');
  finally
    f.Free;
  end;
end;

function Tdm.SetOGGFileInfo(const filename, title, artist, album: string
  ): Boolean;
var
  f: TMemIniFile;
begin
  Result := False;

  f := TMemIniFile.Create(filename);
  try
    f.WriteString('info', 'title', title);
    f.WriteString('info', 'artist', artist);
    f.WriteString('info', 'album', album);

    f.UpdateFile;
    Result := True;
  finally
    f.Free;
  end;
end;

function Tdm.GetLuksKontenerFilename(aNazwaRozdzialu, aDomyslnyKatalog,
  aKontenerLuks: string): string;
var
  s: string;
  i: integer;
begin
  if UpCase(aKontenerLuks)='[AUTO]' then
  begin
    s:=aNazwaRozdzialu;
    for i:=length(s) downto 1 do
    begin
      if s[i]=_FF then s[i]:='_' else
      if s[i]=':' then s[i]:='_';
    end;
    s:=s+'.cr';
  end else result:=aKontenerLuks;
  result:=s;
end;

procedure RemoveAllFilesInDirectory(const DirectoryPath: string);
var
  SearchRec: TSearchRec;
  FilePath: string;
begin
  if FindFirst(IncludeTrailingPathDelimiter(DirectoryPath) + '*', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      FilePath := IncludeTrailingPathDelimiter(DirectoryPath) + SearchRec.Name;
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      begin
        if (SearchRec.Attr and faDirectory) = 0 then
          DeleteFile(FilePath)
        else
          RemoveAllFilesInDirectory(FilePath); // Rekurencyjnie usuń pliki w podkatalogach
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

function Tdm.ReadLogoFileName(aResolution: string): string;
const
  source = '/tmp/studio-jahu-tmp/logo/logo.png';
var
  plik: string;
  x: TProcess;
begin
  if mplayer2_logo_czas='' then
  begin
    result:='';
    exit;
  end;

  plik:='/tmp/studio-jahu-tmp/logo/logo_'+aResolution+'_'+mplayer2_logo_czas+'.png';
  plik:=StringReplace(plik,' ','_',[rfReplaceAll]);

  if (mplayer2_logo_czas_exist='') or (mplayer2_logo_czas<>mplayer2_logo_czas_exist) then
  begin
    if FileExists(plik) then
    begin
      mplayer2_logo_czas_exist:=mplayer2_logo_czas;
      result:=plik;
      exit;
    end else begin
      if not DirectoryExists('/tmp/studio-jahu-tmp') then
      begin
        mkdir('/tmp/studio-jahu-tmp');
        mkdir('/tmp/studio-jahu-tmp/logo');
      end else begin
        if DirectoryExists('/tmp/studio-jahu-tmp/logo') then RemoveAllFilesInDirectory('/tmp/studio-jahu-tmp/logo') else mkdir('/tmp/studio-jahu-tmp/logo');
      end;
      mplayer2_logo_czas_exist:=mplayer2_logo_czas;
    end;
  end;

  if not FileExists(plik) then
  begin
    mplayer2_logo_picture.Position:=0;
    mplayer2_logo_picture.SaveToFile(source);
    x:=TProcess.Create(self);
    try
      x.Options:=[poWaitOnExit];
      x.ShowWindow:=swoHIDE;
      x.Executable:='convert';
      x.Parameters.Add(source);
      x.Parameters.Add('-resize');
      x.Parameters.Add(aResolution);
      x.Parameters.Add(plik);
      x.Execute;
      x.Terminate(0);
    finally
      x.Free;
    end;
    DeleteFile(source);
  end;
  result:=plik;
end;

procedure Tdm.UpdateCookiesYtFile;
var
  ss: TStringList;
begin
  if trim(_DEF_COOKIES_YT)='' then
  begin
    if FileExists(CONST_COOKIES_FILE_YT) then DeleteFile(CONST_COOKIES_FILE_YT);
  end else begin
    if not DirectoryExists('/tmp/studio-jahu-tmp') then mkdir('/tmp/studio-jahu-tmp');
    ss:=TStringList.Create;
    try
      ss.AddText(_DEF_COOKIES_YT);
      ss.SaveToFile(CONST_COOKIES_FILE_YT);
    finally
      ss.Free;
    end;
  end;
end;

procedure Tdm.UpdateSrtCzolowka(aTytul, aKomentarz: string);
var
  ss: TStringList;
  s: string;
begin
  if (aTytul=memTytul) and (aKomentarz=memkomentarz) then exit;
  memTytul:=aTytul;
  memKomentarz:=aKomentarz;
  if not DirectoryExists('/tmp/studio-jahu-tmp') then mkdir('/tmp/studio-jahu-tmp');
  ss:=TStringList.Create;
  try
    ss.Add('1');
    ss.Add('00:00:22,000 --> 00:00:28,000');
    s:=StringReplace(aTytul,'^',#10,[rfReplaceAll]);
    ss.AddText(s);
    ss.Add('');
    ss.Add('2');
    ss.Add('00:00:28,000 --> 00:00:32,000');
    s:=StringReplace(aKomentarz,'^',#10,[rfReplaceAll]);
    ss.AddText(s);
    ss.SaveToFile('/tmp/studio-jahu-tmp/czolowka.srt');
  finally
    ss.Free;
  end;
end;

procedure Tdm.UpdateSrtCytat;
var
  ss: TStringList;
  s: string;
begin
  if memCytat then exit;
  memCytat:=true;
  if not DirectoryExists('/tmp/studio-jahu-tmp') then mkdir('/tmp/studio-jahu-tmp');
  ss:=TStringList.Create;
  try
    ss.Add('1');
    ss.Add('00:00:00,000 --> 05:00:00,000');
    ss.Add('Fragment filmu komentowany jest');
    ss.Add('na prawie dozwolonego cytatu.');
    ss.SaveToFile('/tmp/studio-jahu-tmp/cytat.srt');
  finally
    ss.Free;
  end;
end;

end.

