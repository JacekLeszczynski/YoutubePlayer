unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Menus, XMLPropStorage, DBGrids, ZDataset, ZSqlMonitor, MPlayerCtrl,
  CsvParser, ExtMessage, UOSEngine, UOSPlayer, NetSocket, LiveTimer,
  Presentation, ConsMixer, DirectoryPack, FullscreenMenu, ExtShutdown,
  DBGridPlus, upnp, YoutubeDownloader, ExtSharedCommunication, ZQueryPlus,
  VideoConvert, Types, db, asyncprocess, process, Grids, ComCtrls, DBCtrls,
  ueled, uEKnob, uETilePanel, TplProgressBarUnit, lNet, rxclock, DCPrijndael,
  LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    all0: TZQuery;
    all1: TZQuery;
    BExit: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    czasyactive: TSmallintField;
    czasyautor: TStringField;
    czasyczas2: TLongintField;
    czasyczas_do: TLongintField;
    czasyczas_od: TLongintField;
    czasyc_flagi: TStringField;
    czasyfile_audio: TStringField;
    czasyfilm: TLargeintField;
    czasyid: TLargeintField;
    czasymute: TSmallintField;
    czasynazwa: TStringField;
    czasystatus: TLongintField;
    czasywstawka_filmowa_czas_id: TLargeintField;
    czasy_notnullautor: TStringField;
    czasy_notnullczas2: TLongintField;
    czasy_notnullczas_do: TLongintField;
    czasy_notnullczas_od: TLongintField;
    czasy_notnullfilm: TLargeintField;
    czasy_notnullid: TLargeintField;
    czasy_notnullnazwa: TStringField;
    DBGrid2: TDBGridPlus;
    aes: TDCP_rijndael;
    db_rozautosort: TSmallintField;
    db_rozautosortdesc: TSmallintField;
    db_rozchroniony: TSmallintField;
    db_rozdirectory: TStringField;
    db_rozfilm_id: TLargeintField;
    db_rozformatfile: TLongintField;
    db_rozid: TLargeintField;
    db_roznazwa: TStringField;
    db_roznoarchive: TSmallintField;
    db_roznomemtime: TSmallintField;
    db_roznormalize_audio: TSmallintField;
    db_roznovideo: TSmallintField;
    db_rozsort: TLongintField;
    Edit2: TEdit;
    filmyaudio: TLongintField;
    filmyaudioeq: TStringField;
    filmydata_uploaded: TDateField;
    filmydata_uploaded_noexist: TSmallintField;
    filmyduration: TLongintField;
    filmyfile_audio: TStringField;
    filmyfile_subtitle: TStringField;
    filmyglosnosc: TLongintField;
    filmyid: TLargeintField;
    filmylang: TStringField;
    filmylink: TStringField;
    filmynazwa: TStringField;
    filmynotatki: TMemoField;
    filmyosd: TLongintField;
    filmyplik: TStringField;
    filmyposition: TLongintField;
    filmypredkosc: TLongintField;
    filmyresample: TLongintField;
    filmyrozdzial: TLargeintField;
    filmystart0: TLongintField;
    filmystatus: TLongintField;
    filmytonacja: TLongintField;
    filmytranspose: TLongintField;
    filmywektor_yt_1: TLongintField;
    filmywektor_yt_2: TLongintField;
    filmywektor_yt_3: TLongintField;
    filmywektor_yt_4: TLongintField;
    filmywsp_czasu_yt: TLongintField;
    filmywzmocnienie: TSmallintField;
    film_playaudio: TLongintField;
    film_playaudioeq: TStringField;
    film_playdata_uploaded: TDateField;
    film_playdata_uploaded_noexist: TSmallintField;
    film_playduration: TLongintField;
    film_playfile_audio: TStringField;
    film_playfile_subtitle: TStringField;
    film_playglosnosc: TLongintField;
    film_playid: TLargeintField;
    film_playlang: TStringField;
    film_playlink: TStringField;
    film_playnazwa: TStringField;
    film_playnotatki: TMemoField;
    film_playosd: TLongintField;
    film_playplik: TStringField;
    film_playposition: TLongintField;
    film_playpredkosc: TLongintField;
    film_playresample: TLongintField;
    film_playrozdzial: TLargeintField;
    film_playstart0: TLongintField;
    film_playstatus: TLongintField;
    film_playtonacja: TLongintField;
    film_playtranspose: TLongintField;
    film_playwektor_yt_1: TLongintField;
    film_playwektor_yt_2: TLongintField;
    film_playwektor_yt_3: TLongintField;
    film_playwektor_yt_4: TLongintField;
    film_playwsp_czasu_yt: TLongintField;
    film_playwzmocnienie: TSmallintField;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    MenuItem105: TMenuItem;
    MenuItem106: TMenuItem;
    MenuItem107: TMenuItem;
    MenuItem108: TMenuItem;
    MenuItem109: TMenuItem;
    MenuItem110: TMenuItem;
    MenuItem111: TMenuItem;
    MenuItem112: TMenuItem;
    MenuItem113: TMenuItem;
    MenuItem114: TMenuItem;
    MenuItem115: TMenuItem;
    MenuItem116: TMenuItem;
    MenuItem117: TMenuItem;
    MenuItem118: TMenuItem;
    MenuItem119: TMenuItem;
    MenuItem120: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem9: TMenuItem;
    npilot: TNetSocket;
    Panel13: TPanel;
    pop_tray: TPopupMenu;
    pp_cache: TplProgressBar;
    Process1: TProcess;
    ReadRozautosort: TSmallintField;
    ReadRozautosortdesc: TSmallintField;
    ReadRozdirectory: TStringField;
    ReadRozfilm_id: TLargeintField;
    ReadRozformatfile: TLongintField;
    ReadRozid: TLargeintField;
    ReadRoznazwa: TStringField;
    ReadRoznoarchive: TSmallintField;
    ReadRoznomemtime: TSmallintField;
    ReadRoznormalize_audio: TSmallintField;
    ReadRoznovideo: TSmallintField;
    ReadRozsort: TLongintField;
    SelectDir: TSelectDirectoryDialog;
    shared: TExtSharedCommunication;
    czasy_notnull: TZQuery;
    DBGrid3: TDBGrid;
    DBText1: TDBText;
    DirectoryPack1: TDirectoryPack;
    cShutdown: TExtShutdown;
    fmenu: TFullscreenMenu;
    ImageList2: TImageList;
    Label10: TLabel;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItem98: TMenuItem;
    MenuItem99: TMenuItem;
    mixer: TConsMixer;
    cRozdzialy: TPanel;
    OpenDialog1: TOpenDialog;
    Panel12: TPanel;
    PlayCB: TSpeedButton;
    pop_roz: TPopupMenu;
    RxClock1: TRxClock;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SoundLevel: TEdit;
    MenuItem63: TMenuItem;
    MenuItem65: TMenuItem;
    Presentation: TPresentation;
    Label7: TLabel;
    MenuItem15: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem64: TMenuItem;
    miPlayer: TMenuItem;
    miRecord: TMenuItem;
    miPresentation: TMenuItem;
    N6: TMenuItem;
    SaveDialogFilm: TSaveDialog;
    SelDirPic: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    tAutor: TTimer;
    test_czas22: TZQuery;
    tObsOffTimer: TTimer;
    tcp_timer: TTimer;
    tbk: TTimer;
    autorun: TTimer;
    Timer2: TTimer;
    TrayIcon1: TTrayIcon;
    tPytanie: TTimer;
    tzegar: TTimer;
    timer_obrazy: TTimer;
    timer_info_tasmy: TIdleTimer;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memory_1: TSpeedButton;
    Memory_2: TSpeedButton;
    Memory_3: TSpeedButton;
    Memory_4: TSpeedButton;
    MenuItem36: TMenuItem;
    N1: TMenuItem;
    oo: TplProgressBar;
    Panel10: TuETilePanel;
    Panel11: TuETilePanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    Play: TSpeedButton;
    PlayRec: TSpeedButton;
    podpowiedz: TLabel;
    podpowiedz2: TLabel;
    pp: TplProgressBar;
    ProgressBar1: TProgressBar;
    Rewind: TSpeedButton;
    Stop: TSpeedButton;
    filmy_roz: TZQuery;
    LiveTimer: TLiveTimer;
    MenuItem34: TMenuItem;
    rfilmy: TIdleTimer;
    filmyc_plik_exist: TBooleanField;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    uEKnob1: TuEKnob;
    uELED1: TuELED;
    uELED10: TuELED;
    uELED11: TuELED;
    uELED12: TuELED;
    uELED13: TuELED;
    uELED14: TuELED;
    uELED15: TuELED;
    uELED16: TuELED;
    uELED17: TuELED;
    uELED18: TuELED;
    uELED19: TuELED;
    uELED2: TuELED;
    uELED20: TuELED;
    uELED3: TuELED;
    uELED4: TuELED;
    uELED5: TuELED;
    uELED6: TuELED;
    uELED9: TuELED;
    UOSalarm: TUOSPlayer;
    UOSpodklad: TUOSPlayer;
    UOSszum: TUOSPlayer;
    upnp: TUpnp;
    vcc: TVideoConvert;
    youtube: TYoutubeDownloader;
    ytdir: TSelectDirectoryDialog;
    MenuItem25: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    DBLookupComboBox1: TDBLookupComboBox;
    db_roz: TZQuery;
    ds_roz: TDataSource;
    czasy_od_id: TZQuery;
    czasy_max: TZQuery;
    czasy_nast: TZQuery;
    czasy_przed: TZQuery;
    czasy_po: TZQuery;
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TuETilePanel;
    DBGrid1: TDBGridPlus;
    ds_test_czas: TDataSource;
    Label2: TLabel;
    N3: TMenuItem;
    OpenDialogCsv: TOpenDialog;
    Panel8: TuETilePanel;
    oo_mouse: TIdleTimer;
    Splitter2: TSplitter;
    test_czas: TZQuery;
    csv: TCsvParser;
    pp_mouse: TIdleTimer;
    ImageList1: TImageList;
    ds_filmy: TDataSource;
    ds_czasy: TDataSource;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    pop_czasy: TPopupMenu;
    test_czas2: TZQuery;
    restart_csv: TTimer;
    UOSEngine: TUOSEngine;
    UOSPlayer: TUOSPlayer;
    N2: TMenuItem;
    mess: TExtMessage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mplayer: TMPlayerControl;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel6: TPanel;
    pop_lista: TPopupMenu;
    Splitter1: TSplitter;
    PropStorage: TXMLPropStorage;
    filmy: TZQueryPlus;
    film_play: TZQueryPlus;
    ReadRoz: TZReadOnlyQuery;
    czasy: TZQueryPlus;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem75Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure mplayerCacheing(ASender: TObject; APosition, ADuration,
      ACache: single);
    procedure SpeedButton1Click(Sender: TObject);
    procedure tObsOffTimerStartTimer(Sender: TObject);
    procedure tObsOffTimerStopTimer(Sender: TObject);
    procedure _REFRESH_CZASY(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure cShutdownBeforeShutdown(Sender: TObject);
    procedure csvAfterRead(Sender: TObject);
    procedure csvBeforeRead(Sender: TObject);
    procedure csvRead(Sender: TObject; NumberRec, PosRec: integer; sName,
      sValue: string; var Stopped: boolean);
    procedure czasyBeforeOpen(DataSet: TDataSet);
    procedure czasyCalcFields(DataSet: TDataSet);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3PrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
    procedure DBLookupComboBox1DropDown(Sender: TObject);
    procedure DBLookupComboBox1Select(Sender: TObject);
    procedure db_rozAfterScroll(DataSet: TDataSet);
    procedure db_roznazwaGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure ds_filmyDataChange(Sender: TObject; Field: TField);
    procedure filmyBeforeOpen(DataSet: TDataSet);
    procedure filmyBeforeOpenII(Sender: TObject);
    procedure filmyCalcFields(DataSet: TDataSet);
    procedure film_playBeforeOpen(DataSet: TDataSet);
    procedure film_playBeforeOpenII(Sender: TObject);
    procedure fmenuBefore(aItemIndex: integer);
    procedure fmenuExecute(aItemIndex: integer; aResult: integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem104Click(Sender: TObject);
    procedure MenuItem105Click(Sender: TObject);
    procedure MenuItem107Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem112Click(Sender: TObject);
    procedure MenuItem113Click(Sender: TObject);
    procedure MenuItem114Click(Sender: TObject);
    procedure MenuItem116Click(Sender: TObject);
    procedure MenuItem117Click(Sender: TObject);
    procedure MenuItem118Click(Sender: TObject);
    procedure MenuItem119Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem35Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem37Click(Sender: TObject);
    procedure MenuItem38Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem42Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem44Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem47Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem62Click(Sender: TObject);
    procedure MenuItem63Click(Sender: TObject);
    procedure MenuItem65Click(Sender: TObject);
    procedure MenuItem67Click(Sender: TObject);
    procedure MenuItem68Click(Sender: TObject);
    procedure MenuItem70Click(Sender: TObject);
    procedure MenuItem71Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem77Click(Sender: TObject);
    procedure MenuItem78Click(Sender: TObject);
    procedure MenuItem79Click(Sender: TObject);
    procedure MenuItem80Click(Sender: TObject);
    procedure MenuItem81Click(Sender: TObject);
    procedure MenuItem82Click(Sender: TObject);
    procedure MenuItem83Click(Sender: TObject);
    procedure MenuItem86Click(Sender: TObject);
    procedure MenuItem92Click(Sender: TObject);
    procedure MenuItem93Click(Sender: TObject);
    procedure miPlayerClick(Sender: TObject);
    procedure mplayerBeforePlay(ASender: TObject; AFilename: string);
    procedure mplayerBeforeStop(Sender: TObject);
    procedure mplayerGrabImage(ASender: TObject; AFilename: String);
    procedure mplayerPause(Sender: TObject);
    procedure mplayerPlay(Sender: TObject);
    procedure mplayerPlaying(ASender: TObject; APosition, ADuration: single);
    procedure mplayerReplay(Sender: TObject);
    procedure mplayerSetPosition(Sender: TObject);
    procedure mplayerStop(Sender: TObject);
    procedure npilotConnect(aSocket: TLSocket);
    procedure npilotReceiveString(aMsg: string; aSocket: TLSocket;
      aBinSize: integer; var aReadBin: boolean);
    procedure npilotStatus(aActive, aCrypt: boolean);
    procedure ooMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ooMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure oo_mouseStartTimer(Sender: TObject);
    procedure oo_mouseTimer(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure PlayCBClick(Sender: TObject);
    procedure PlayCBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayClick(Sender: TObject);
    procedure PlayRecClick(Sender: TObject);
    procedure ppMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pp_mouseStartTimer(Sender: TObject);
    procedure pp_mouseTimer(Sender: TObject);
    procedure PresentationClick(aButton: integer; var aTestDblClick: boolean);
    procedure PropStorageRestoringProperties(Sender: TObject);
    procedure PropStorageSavingProperties(Sender: TObject);
    procedure restart_csvTimer(Sender: TObject);
    procedure RewindClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure rfilmyTimer(Sender: TObject);
    procedure sharedMessage(Sender: TObject; AMessage: string);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure tAutorStartTimer(Sender: TObject);
    procedure tAutorStopTimer(Sender: TObject);
    procedure tAutorTimer(Sender: TObject);
    procedure tbkStopTimer(Sender: TObject);
    procedure tbkTimer(Sender: TObject);
    procedure tcpProcessMessage;
    procedure test_czasBeforeOpen(DataSet: TDataSet);
    procedure tObsOffTimerTimer(Sender: TObject);
    procedure Timer2StartTimer(Sender: TObject);
    procedure Timer2StopTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure timer_info_tasmyTimer(Sender: TObject);
    procedure timer_obrazyTimer(Sender: TObject);
    procedure tPytanieStartTimer(Sender: TObject);
    procedure tPytanieStopTimer(Sender: TObject);
    procedure tPytanieTimer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure tzegarTimer(Sender: TObject);
    procedure uEKnob1Change(Sender: TObject);
    procedure uEKnob1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure uELED1Click(Sender: TObject);
    procedure uELED2Click(Sender: TObject);
    procedure uELED3Click(Sender: TObject);
    procedure vccFileRendered(aId: integer; aSourceFileName,
      aDestinationFileName: string);
    procedure vccThreadsCount(aCount: integer);
    procedure youtubeDlFinish(aLink, aFileName, aDir: string; aTag: integer);
    procedure youtubeDlPosition(aPosition: integer; aSpeed: int64; aTag: integer
      );
    procedure youtubeStart(Sender: TObject);
    procedure youtubeStop(Sender: TObject);
    procedure _AUDIOMENU(Sender: TObject);
    procedure _OPEN_CLOSE(DataSet: TDataSet);
    procedure _OPEN_CLOSE_TEST(DataSet: TDataSet);
    procedure _OSDMENU(Sender: TObject);
    procedure _PLAY_MEMORY(Sender: TObject);
    procedure _ROZ_OPEN_CLOSE(DataSet: TDataSet);
    procedure _SAMPLERATEMENU(Sender: TObject);
  private
    cmute: boolean;
    cctimer: integer;
    cctimer_opt: integer;
    const_mplayer_param: string;
    film_tytul: string;
    film_tytul1: string;
    film_tytul2: string;
    film_autor: string;
    lista_wybor,klucze_wybor: TStrings;
    canals: TStrings;
    cenzura,szum,mem_alarm: TMemoryStream;
    trans_tytul,trans_code: string;
    trans_opis: TStrings;
    trans_film_tytul: string;
    trans_film_czasy: TStrings;
    trans_indeksy: TStrings;
    key_ignore: TStringList;
    KeyPytanie: string;
    tak_nie_k,tak_nie_v: TStringList;
    auto_play_id: integer;
    auto_play_sort: boolean;
    auto_play_sort_desc: boolean;
    force_deinterlace: boolean;
    www1,www2: string;
    def_pilot: TStringList;
    def_pilot_values: TStringList;
    def_pilot1: TStringList;
    def_pilot1_values: TStringList;
    def_pilot2: TStringList;
    def_pilot2_values: TStringList;
    def_pilot3: TStringList;
    def_pilot3_values: TStringList;
    local_obs_off_timer: integer;
    komenda_nr_2: string;
    local_delay_timer_opoznienie: integer;
    procedure AutoGenerateYT2Czasy(aList: string);
    procedure pilot_wczytaj;
    procedure pilot_wykonaj(aCode: string);
    procedure pilot_wykonaj(aCode: integer; aButton: string; aOpoznienie: integer = 0);
    procedure zaswiec_kamerke(aCam: integer);
    procedure filmy_reopen;
    procedure zapisz(komenda: integer);
    procedure play_alarm;
    procedure TextToScreen(aString: string; aLength,aRows: integer; var aText: TStrings);
    procedure ComputerOff;
    procedure UpdateFilmToRoz(aRestore: boolean = false);
    procedure SeekPlay(aCzas: integer);
    function db_open: boolean;
    procedure db_close;
    function get_last_id: integer;
    procedure usun_pozycje_czasu(wymog_potwierdzenia: boolean);
    procedure komenda_up;
    procedure komenda_down;
    procedure go_czas2;
    procedure resize_update_grid;
    procedure test_play;
    procedure test(APositionForce: single = 0.0);
    procedure czasy_edycja_188;
    procedure czasy_edycja_190;
    procedure czasy_edycja_191;
    procedure czasy_edycja_146;
    procedure reset_oo;
    procedure update_pp_oo;
    procedure play_memory(nr: integer);
    procedure zmiana(aTryb: integer = 0);
    procedure PictureToVideo(aDir,aFilename,aExt: string);
    function mplayer_obraz_normalize(aPosition: integer): integer;
    procedure dodaj_czas(aIdFilmu,aCzas: integer; aComment: string = '');
    procedure zrob_zdjecie(aForce: boolean = false);
    procedure zrob_zdjecie_do_paint;
    procedure obraz_next;
    procedure obraz_prior;
    procedure go_przelaczpokazywanieczasu;
    procedure go_beep;
    procedure SetCursorOnPresentation(aHideCursor: boolean);
    procedure szumload(aNo: integer = -1);
    procedure szumplay;
    procedure szumpause;
    procedure tab_lamp_zapisz(aNr: integer = 0);
    procedure tab_lamp_odczyt(aOnlyRefreshLamp: boolean = false);
    procedure dodaj_pozycje_na_koniec_listy(aSkopiujTemat: boolean = false);
    procedure zablokuj_aktualny_i_dodaj_pozycje_na_koniec_listy(aSkopiujTemat: boolean = false);
    procedure DeleteFilm(aDB: boolean = true; aFile: boolean = true; aBezPytan: boolean = false);
    procedure sciagnij_film(aDownloadAll: boolean = false);
    procedure scisz10;
    procedure zglosnij10;
    procedure menu_rozdzialy(aOn: boolean = true);
    procedure dodaj_film(aLink: string = '');
    procedure update_mute(aMute: boolean = false);
    procedure _mplayerBeforePlay(Sender: TObject; AFileName: string);
    procedure _mpvBeforePlay(Sender: TObject; AFileName: string);
    procedure _ustaw_cookies;
    procedure ppause(aNr: integer);
    procedure pplay(aNr: integer; aForce: boolean = false);
    procedure playpause(aPlayForce: boolean = false);
    function GetCanal(aKey: string): integer;
    procedure wykonaj_komende(aCommand: string);
    function GetMCMT(aOdPoczatku: boolean = false): string;
    function SetMCMT(aSciezka: string = ''): string;
    procedure PlayMute;
    procedure audio_device_refresh;
    procedure ReadVariableFromDatabase(aRozdzial,aFilm: TDataSet);
    procedure ClearVariable;
    procedure PlayFromParameter(aParam: string);
    function przelicz_czas(aCzas: TTime):TTime;
    function get_wektor_yt(czas,w11,w12,w21,w22,d1,d2: integer): integer;
    function roz2dir(id: integer): string;
    function filename2roz2filename(r1,r2: integer; f1,f2: string): string;
    procedure zapisz_fragment_filmu(do_konca: boolean = false);
    procedure zapisz_indeks_czasu(aIndeks: integer);
    procedure czasy_id_info;
    procedure UpdateFilmDuration(aDuration: integer);
    function TimeToText(aTime: TTime): string;
    procedure UstawPodgladSortowania;
  protected
    //procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  public
    parametr: string;
    procedure go_fullscreen(aOff: boolean = false);
    procedure RunParameter(aStr: string);
    function GetPrivateIndexPlay: integer;
    function GetPrivateIndexCzas: integer;
    function GetPrivateVvObrazy: boolean;
    procedure SetPrivatePStatusIgnore(aNewStatus: boolean);
    function GetPrivatePStatusIgnore: boolean;
    function GetPrivateCzasNastepny: integer;
    function GetPrivateCzasAktualny: integer;
    procedure filmy_refresh;
    procedure film_play_refresh;
  end;

var
  Form1: TForm1;

implementation

uses
  ecode, serwis, lista, czas, lista_wyboru, config, IniFiles,
  ZCompatibility, LCLIntf, Clipbrd, ZAbstractRODataset, panel,
  zapis_tasmy, audioeq, panmusic, rozdzial, podglad,
  yt_selectfiles, ImportDirectoryYoutube, screen_unit, conf_ogg, FormLamp,
  PlikiZombi;

type
  TMemoryLamp = record
    active: boolean;
    rozdzial,indeks,indeks_czasu: integer;
    time: single;
    zmiana: boolean;
  end;
  TYoutubeElement = record
    link: string;
    film: integer;
    dir: string;
    audio,video: integer;
  end;
  PYoutubeElement = ^TYoutubeElement;

var
  YoutubeElement: TYoutubeElement;
  YoutubeIsProcess: boolean = false;

var
  indeks_rozd: integer = -1;
  indeks_play: integer = -1;
  indeks_czas: integer = -1;
  indeks_def_volume: integer;
  force_position: boolean = false;
  force_end: integer = 0;
  rec: record
    typ: string[1];
    id,sort,asort,film,czas_od,czas_do,czas2,rozdzial,status: integer;
    osd,audio,resample,start0,transpose,predkosc,tonacja,wsp_czasu_yt: integer;
    nazwa,autor,link,plik,dir: string;
    wzmocnienie,glosnosc,position: integer;
    audioeq,file_audio,lang,file_subtitle: string;
    s1,s2,s3,s4,s5: string;
    mute: boolean;
    nomemtime,noarchive,novideo,normalize_audio: integer;
    autosortdesc,w1,w2,w3,w4,formatfile: integer;
  end;
  mem_lamp: array [1..4] of TMemoryLamp;
  ytdl_id: integer;
  _yt_d1,_yt_d2: string;
  tryb: integer = 1;

var
  tasma_s1: string = '';
  tasma_s2: string = '';
  precord: boolean = false;
  pstatus_ignore: boolean = false;

var
  test_force: boolean = false;
  stop_force: boolean = false;
  czas_aktualny: integer = -1;
  czas_nastepny: integer = -1;
  czas_nastepny2: integer = -1;
  czas_aktualny_nazwa: string;
  czas_aktualny_indeks: integer = -1;
  bcenzura: boolean = false;
  auto_memory: array [1..4] of integer;
  vv_duration: integer = 0;
  vv_wzmocnienie: boolean = false;
  vv_glosnosc: integer = 0;
  vv_obrazy: boolean = false;
  vv_transmisja: boolean = false;
  vv_szum: boolean = false;
  vv_normalize: boolean = false;
  vv_normalize_not: boolean = false;
  vv_osd: integer = 0;
  vv_audio: integer = 0;
  vv_lang: string = '';
  vv_resample: integer = 0;
  vv_audioeq: string = '';
  vv_audio1: string = '';
  vv_audio2: string = '';
  vv_mute: boolean = false;
  vv_old_mute: boolean = false;
  vv_link: string = '';
  vv_plik: string = '';
  vv_novideo: boolean = false;
  vv_transpose: integer = 0;
  vv_predkosc: integer = 0;
  vv_tonacja: integer = 0;

{$R *.lfm}

function str_46(str: string): string;
var
  s: string;
  i,l: integer;
begin
  s:=str;
  l:=trunc((42-length(s))/2)+3;
  for i:=1 to l do s:=' '+s;
  result:=s;
end;

procedure tekst_46(s: string; ss: TStringList);
var
  s1,s2,s3: string;
  i: integer;
  b: boolean;
begin
  s1:=s;
  while length(s1)>42 do
  begin
    (* szukam pierwszej spacji od końca *)
    b:=false;
    for i:=42 downto 1 do if s1[i]=' ' then
    begin
      b:=true;
      s2:=trim(copy(s1,1,i));
      s3:=trim(copy(s1,i,maxint));
      break;
    end;
    if b then
    begin
      ss.Add(str_46(s2));
      s1:=s3;
    end;
  end;
  s1:=trim(s1);
  ss.Add(str_46(s1));
end;

{ TForm1 }

procedure TForm1.PlayClick(Sender: TObject);
begin
  if Edit1.Text='' then exit;
  if vv_obrazy and mplayer.Paused then obraz_next else
  if mplayer.Running then playpause(true) else
  begin
    mplayer.Filename:=Edit1.Text;
    mplayer.Play;
  end;
end;

procedure TForm1.PlayRecClick(Sender: TObject);
begin
  if precord and miPresentation.Checked then exit;
  precord:=not precord;
  if precord then
  begin
    PlayRec.ImageIndex:=40;
  end else begin
    PlayRec.ImageIndex:=39;
  end;
  if precord then
  begin
    tasma_s1:='';
    tasma_s2:='';
    dm.tasma_clear.Execute;
    LiveTimer.Start;
  end else LiveTimer.Stop;
end;

function DelHtml(aHtml: string): string;
var
  s: string;
  a,i: integer;
begin
  s:='';
  a:=0;
  for i:=1 to length(aHtml) do if aHtml[i]='<' then inc(a) else if aHtml[i]='>' then dec(a) else if a=0 then s:=s+aHtml[i];
  result:=s;
end;

procedure TForm1.czasy_edycja_188;
var
  b: integer;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  b:=MiliSecToInteger(round(mplayer.GetPositionOnlyRead*1000));
  if vv_obrazy then
  begin
    //dec(b,10);
    if b<0 then b:=0;
  end;
  czasy.FieldByName('czas_od').AsInteger:=b;
  czasy.Post;
  test;
end;

procedure TForm1.czasy_edycja_190;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  czasy.FieldByName('czas_do').AsInteger:=MiliSecToInteger(round(mplayer.GetPositionOnlyRead*1000));
  czasy.Post;
  test;
end;

procedure TForm1.czasy_edycja_191;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  czasy.FieldByName('czas_do').Clear;
  czasy.Post;
  test;
end;

procedure TForm1.czasy_edycja_146;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  czasy.FieldByName('czas2').AsInteger:=MiliSecToInteger(round(mplayer.GetPositionOnlyRead*1000));
  czasy.Post;
end;

procedure TForm1.reset_oo;
begin
  oo.Min:=0;
  oo.Max:=10;
  oo.Position:=0;
  Label5.Caption:='-:--';
  Label6.Caption:='-:--';
end;

procedure TForm1.update_pp_oo;
begin
  if _SET_VIEW_SCREEN then
  begin
    FPodglad.pp.Max:=pp.Max;
    FPodglad.pp.Position:=pp.Position;
    FPodglad.oo.Max:=oo.Max;
    FPodglad.oo.Position:=oo.Position;
    FPodglad.Label3.Caption:=Label3.Caption;
    FPodglad.Label4.Caption:=Label4.Caption;
    FPodglad.Label5.Caption:=Label5.Caption;
    FPodglad.Label6.Caption:=Label6.Caption;
  end;
  if _DEF_PANEL then
  begin
    FPanel.pp.Max:=pp.Max;
    FPanel.pp.Position:=pp.Position;
    FPanel.oo.Max:=oo.Max;
    FPanel.oo.Position:=oo.Position;
    FPanel.Label3.Caption:=Label3.Caption;
    FPanel.Label4.Caption:=Label4.Caption;
    FPanel.Label5.Caption:=Label5.Caption;
    FPanel.Label6.Caption:=Label6.Caption;
  end;
end;

procedure TForm1.play_memory(nr: integer);
var
  t: single;
  r,i,i2: integer;
  czas: TTime;
  nazwa,link,plik: string;
  s,s1: string;
  vStart0: boolean;
begin
  if not mem_lamp[nr].active then exit;
  r:=mem_lamp[nr].rozdzial;
  i:=mem_lamp[nr].indeks;
  i2:=mem_lamp[nr].indeks_czasu;
  t:=mem_lamp[nr].time;
  czas:=MiliSecToTime(round(t*1000));
  if _SET_GREEN_SCREEN then FScreen.MemReset;
  if mplayer.Running and (indeks_play=i) then mplayer.Position:=t else
  begin
    if mplayer.Running then Stop.Click;
    //application.ProcessMessages;
    {ustawienia dot. list}
    db_roz.First;
    db_roz.Locate('id',r,[]);
    filmy_reopen;
    //filmy.First;
    filmy.Locate('id',i,[]);
    czasy.First;
    czasy.Locate('id',i2,[]);
    {uruchomienie filmu}
    dm.film.ParamByName('id').AsInteger:=i;
    dm.film.Open;
    nazwa:=dm.film.FieldByName('nazwa').AsString;
    link:=dm.film.FieldByName('link').AsString;
    plik:=dm.film.FieldByName('plik').AsString;
    ReadVariableFromDatabase(db_roz,dm.film);
    vStart0:=dm.film.FieldByName('start0').AsInteger=1;
    //if czasymute.IsNull then vv_mute:=false else vv_mute:=czasymute.AsInteger=1;
    //vv_old_mute:=vv_mute;
    dm.film.Close;
    s:=plik;
    if (s='') or (not FileExists(s)) then s:=link;
    Edit1.Text:=s;
    film_tytul:=nazwa;
    if vStart0 then
    begin
      force_position:=true;
      _MPLAYER_FORCESTART0:=TimeToInteger(czas)
    end else begin
      s1:=FormatDateTime('hh:nn:ss.z',czas);
      force_position:=false;
      if mplayer.Engine=meMPV then const_mplayer_param:='--start='+s1 else const_mplayer_param:='-ss '+s1;
    end;
    indeks_rozd:=r;
    indeks_play:=i;
    indeks_czas:=i2;
    Play.Click;
  end;
  if MenuItem26.Checked then
  begin
    mem_lamp[nr].active:=false;
    case nr of
      1: Memory_1.ImageIndex:=27;
      2: Memory_2.ImageIndex:=29;
      3: Memory_3.ImageIndex:=31;
      4: Memory_4.ImageIndex:=33;
    end;
    if _SET_VIEW_SCREEN then
    begin
      FPodglad.Memory_1.ImageIndex:=Memory_1.ImageIndex;
      case nr of
        1: FPodglad.Memory_1.ImageIndex:=Memory_1.ImageIndex;
        2: FPodglad.Memory_2.ImageIndex:=Memory_2.ImageIndex;
        3: FPodglad.Memory_3.ImageIndex:=Memory_3.ImageIndex;
        4: FPodglad.Memory_4.ImageIndex:=Memory_4.ImageIndex;
      end;
    end;
  end;
end;

procedure TForm1.zmiana(aTryb: integer);
var
  a: integer;
begin
  a:=tryb;
  if aTryb=0 then
  begin
    uELED1.Active:=false;
    uELED2.Active:=false;
    if _DEF_LAMP_FORMS and _SET_LAMP_FORMS then
    begin
      FLamp1.uELED2.Active:=false;
      FLamp2.uELED2.Active:=false;
    end;
  end else begin
    tryb:=aTryb;
    uELED1.Active:=tryb=1;
    uELED2.Active:=tryb=2;
    if _DEF_LAMP_FORMS and _SET_LAMP_FORMS then
    begin
      FLamp1.uELED2.Active:=tryb=2;
      FLamp2.uELED2.Active:=tryb=2;
    end;
  end;
  if _DEF_GREEN_SCREEN then if _SET_GREEN_SCREEN then fscreen.film(uELED2.Active);
  //if (a=1) and (tryb=2) then Presentation.SendKey(ord('Q'));
  //if (a=2) and (tryb=1) then Presentation.SendKey(ord('X'));
  //if (a=1) and (tryb=2) then wykonaj_komende('obs-cli --password 123ikpd sceneitem show "KAMERA + VIDEO" Video');
  //if (a=2) and (tryb=1) then wykonaj_komende('obs-cli --password 123ikpd sceneitem hide "KAMERA + VIDEO" Video');
end;

procedure TForm1.PictureToVideo(aDir, aFilename, aExt: string);
var
  vstatus: integer;
begin
  {Stworzenie filmu}
  if FileExists(aFilename) then DeleteFile(aFilename);
  dm.proc1.CurrentDirectory:=aDir;
  dm.proc1.Executable:='/bin/sh';
  dm.proc1.Parameters.Clear;
  dm.proc1.Parameters.Add('-c');
  dm.proc1.Parameters.Add('ffmpeg -pattern_type glob -i '''+aExt+''' -vf "setpts=5*PTS" "'+aFilename+'"');
  //dm.proc1.Parameters.Add('ffmpeg -pattern_type glob -i '''+aExt+''' "'+aFilename+'"');
  dm.proc1.Execute;
  {Dodanie filmu do bazy danych}
  filmy.Append;
  filmy.FieldByName('nazwa').AsString:='Film z obrazów';
  filmy.FieldByName('link').Clear;
  filmy.FieldByName('plik').AsString:=aFilename;
  filmy.FieldByName('rozdzial').AsInteger:=db_rozid.AsInteger;
  vstatus:=0;
  SetBit(vstatus,0,true);
  filmystatus.AsInteger:=vstatus;
  filmy.Post;
end;

const
  _LICZNIK = 200;

function TForm1.mplayer_obraz_normalize(aPosition: integer): integer;
var
  a,a1: integer;
begin
  a:=aPosition;
  a1:=a div _LICZNIK;
  if a1<1 then a:=0 else a:=a1*_LICZNIK+120;
  result:=a;
end;

procedure TForm1.dodaj_czas(aIdFilmu, aCzas: integer; aComment: string);
var
  id: integer;
begin
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  if aComment='' then czasy.FieldByName('nazwa').AsString:='..' else
    czasy.FieldByName('nazwa').AsString:=aComment;
  czasy.FieldByName('czas_od').AsInteger:=aCzas;
  czasy.FieldByName('status').AsInteger:=0;
  czasy.Post;
  dm.last_id.Open;
  id:=dm.last_id.Fields[0].AsInteger;
  dm.last_id.Close;
  czasy.Refresh;
  test;
end;

procedure TForm1.zrob_zdjecie(aForce: boolean);
var
  a,b: integer;
begin
  if (not aForce and miRecord.Checked) then exit;
  if vv_obrazy then exit;
  b:=MiliSecToInteger(Round(mplayer.GetPositionOnlyRead*1000));
  begin
    dec(b,10);
    if b<0 then b:=0;
  end;
  czasy_max.Open;
  if czasy_max.IsEmpty then a:=0 else
  begin
    if czasy_max.FieldByName('czas_do').IsNull then
      a:=czasy_max.FieldByName('czas_od').AsInteger
    else
    a:=czasy_max.FieldByName('czas_do').AsInteger;
  end;
  czasy_max.Close;
  if b<a then dodaj_czas(filmy.FieldByName('id').AsInteger,a,'[fotka]')
         else dodaj_czas(filmy.FieldByName('id').AsInteger,b,'[fotka]');
  mplayer.GrabImage;
end;

procedure TForm1.zrob_zdjecie_do_paint;
var
  e: string;
  t1,t2: TStrings;
begin
  if vv_obrazy then exit;
  e:='*.png;*.jpg';
  t1:=TStringList.Create;
  t2:=TStringList.Create;
  try
    DirectoryPack1.ExecuteFiles(_DEF_SCREENSHOT_SAVE_DIR,e,t1);
    mplayer.GrabImage;
    DirectoryPack1.ExecuteFiles(_DEF_SCREENSHOT_SAVE_DIR,e,t2);
  finally
    t1.Free;
    t2.Free;
  end;
end;

procedure TForm1.obraz_next;
var
  a: single;
begin
  if not mplayer.Running then exit;
  a:=IntegerToTime(mplayer_obraz_normalize(TimeToInteger(mplayer.Position/SecsPerDay)+_LICZNIK))*SecsPerDay;
  mplayer.Position:=a;
end;

procedure TForm1.obraz_prior;
var
  a: integer;
  b: single;
begin
  if not mplayer.Running then exit;
  b:=mplayer_obraz_normalize(TimeToInteger(mplayer.Position/SecsPerDay)-(_LICZNIK*1));
  b:=IntegerToTime(a)*SecsPerDay;
  mplayer.Position:=b;
end;

procedure TForm1.go_fullscreen(aOff: boolean);
begin
  if (not Panel1.Visible) or aOff then
  begin
    _DEF_FULLSCREEN_CURSOR_OFF:=false;
    if Panel1.Visible then exit;
    DBGrid3.Visible:=false;
    Screen.Cursor:=crDefault;
    Panel1.Visible:=true;
    Panel4.Align:=alLeft;
    Splitter1.Visible:=true;
    Panel3.Visible:=true;
    Menuitem21.Visible:=true;
    Menuitem22.Visible:=true;
    Menuitem28.Visible:=true;
    Menuitem27.Visible:=true;
    Menuitem15.Visible:=_DEV_ON;
    Form1.WindowState:=wsNormal;
    Form1.WindowState:=wsFullScreen;
    Form1.WindowState:=wsNormal;
    //Form1.FormStyle:=fsNormal;
  end else begin
    _DEF_FULLSCREEN_CURSOR_OFF:=true;
    if (not mplayer.Running) and (not _DEF_FULLSCREEN_MEMORY) then exit;
    DBGrid3.Visible:=_DEF_FULLSCREEN_MEMORY and (not mplayer.Running);
    Menuitem21.Visible:=false;
    Menuitem22.Visible:=false;
    Menuitem28.Visible:=false;
    Menuitem27.Visible:=false;
    Menuitem15.Visible:=false;
    Panel1.Visible:=false;
    Panel4.Align:=alClient;
    Splitter1.Visible:=false;
    Panel3.Visible:=false;
    Form1.WindowState:=wsFullScreen;
    //Form1.FormStyle:=fsStayOnTop;
  end;
end;

procedure TForm1.go_przelaczpokazywanieczasu;
var
  a: integer;
begin
  if MenuItem49.Checked then begin MenuItem51.Checked:=true; a:=2; end else
  if MenuItem51.Checked then begin MenuItem52.Checked:=true; a:=3; end else
  if MenuItem52.Checked then begin MenuItem49.Checked:=true; a:=0; end;
  if mplayer.Running then mplayer.SetOSDLevel(a);
end;

procedure TForm1.go_beep;
var
  res: TResourceStream;
begin
  UOSPlayer.Stop;
  try
    cenzura:=TMemoryStream.Create;
    res:=TResourceStream.Create(hInstance,'BEEP',RT_RCDATA);
    cenzura.LoadFromStream(res);
  finally
    res.Free;
  end;
  UOSPlayer.Volume:=1;
  UOSPlayer.Start(cenzura);
end;

procedure TForm1.SetCursorOnPresentation(aHideCursor: boolean);
begin
  if aHideCursor then
  begin
    mplayer.Cursor:=crNone;
    Splitter1.Cursor:=crNone;
    Panel1.Cursor:=crNone;
    Label1.Cursor:=crNone;
    Edit1.Cursor:=crNone;
    Panel6.Cursor:=crNone;
  end else begin
    mplayer.Cursor:=crDefault;
    Splitter1.Cursor:=crHSplit;
    Panel1.Cursor:=crDefault;
    Label1.Cursor:=crDefault;
    Edit1.Cursor:=crDefault;
    Panel6.Cursor:=crDefault;
  end;
end;

procedure TForm1.csvAfterRead(Sender: TObject);
begin
  case TCsvParser(Sender).Tag of
    0: begin
         dm.trans.Commit;
         db_roz.Refresh;
       end;
    1: restart_csv.Enabled:=true;
    2: begin
         dm.trans.Commit;
         db_roz.Refresh;
         lista_wybor.Clear;
         klucze_wybor.Clear;
       end;
  end;
end;

procedure TForm1.autorunTimer(Sender: TObject);
var
  i,a: integer;
  a1,a2: integer;
begin
  autorun.Enabled:=false;
  if _FORCE_CLOSE then
  begin
    mess.ShowWarning('BRAK POŁĄCZENIA Z BAZĄ DANYCH','Nie można wznowić połączenia z bazą danych, program zostaje zatrzymany.');
    close;
    exit;
  end;
  npilot.Connect;
  if _DEF_MULTIDESKTOP<>'' then
  begin
    a:=Left;
    a1:=StrToInt(GetLineToStr(_DEF_MULTIDESKTOP,1,'-'));
    a2:=StrToInt(GetLineToStr(_DEF_MULTIDESKTOP,2,'-'));
    _DEF_MULTIDESKTOP_LEFT:=a1;
    if a>=a1 then a:=a-a2;
    Left:=a;
  end;
  if parametr<>'' then RunParameter(parametr);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  a: integer;
  t: TBookMark;
begin
  all1.ExecSQL;
  a:=czasyid.AsInteger;
  t:=czasy.GetBookmark;
  czasy.Refresh;
  try
    czasy.GotoBookmark(t);
  except
    czasy.Locate('id',a,[]);
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  a: integer;
  t: TBookMark;
begin
  all0.ExecSQL;
  a:=czasyid.AsInteger;
  t:=czasy.GetBookmark;
  czasy.Refresh;
  try
    czasy.GotoBookmark(t);
  except
    czasy.Locate('id',a,[]);
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  a: integer;
begin
  czasy.Edit;
  a:=czasyactive.AsInteger;
  if a=1 then a:=0 else a:=1;
  czasyactive.AsInteger:=a;
  czasy.Post;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  max,a: integer;
begin
  if not mplayer.Running then
  begin
    mess.ShowInformation('Film musi być odpalony!');
    exit;
  end;
  max:=mplayer.SingleMpToInteger(mplayer.Duration);
  dm.FilmInfo.ParamByName('a_film_id').AsInteger:=filmyid.AsInteger;
  dm.FilmInfo.ParamByName('a_duration').AsInteger:=max;
  dm.FilmInfo.Open;
  a:=dm.FilmInfo.Fields[0].AsInteger;
  dm.FilmInfo.Close;
  mess.ShowInformation('Długość filmu z wyłączonymi fragmentami to:^'+FormatDateTime('hh:nn:ss',IntegerToTime(a)));
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.Checked then DBGrid2.Options:=[dgTitles,dgColumnResize,dgColumnMove,dgColLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgConfirmDelete,dgCancelOnExit,dgMultiselect,dgDisableDelete,dgDisableInsert,dgDisplayMemoText]
                       else DBGrid2.Options:=[dgTitles,dgColumnResize,dgColumnMove,dgColLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgConfirmDelete,dgCancelOnExit,dgDisableDelete,dgDisableInsert,dgDisplayMemoText];
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
var
  a,i: integer;
  s: string;
begin
  s:=IntToStr(filmy.Tag);
  a:=Column.Index+1;
  for i:=1 to 3 do
  begin
    if i=a then
    begin
      if s[i]='2' then s[i]:='3' else s[i]:='2';
    end else s[i]:='1';
  end;
  filmy.Tag:=StrToInt(s);
  filmy.DisableControls;
  filmy.Close;
  filmy.Open;
  filmy.EnableControls;
  UstawPodgladSortowania;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  filmy.DisableControls;
  filmy.Close;
  filmy.Open;
  filmy.EnableControls;
end;

procedure TForm1.Edit2Enter(Sender: TObject);
begin
  Form1.KeyPreview:=false;
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
  Form1.KeyPreview:=true;
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
var
  a: TUzupelnijDaty;
begin
  if uELED6.Active then exit;
  a:=TUzupelnijDaty.Create(10);
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var
  id1,id2: integer;
  q: TZQuery;
begin
  id1:=filmyid.AsLargeInt;
  filmy.Next;
  id2:=filmyid.AsLargeInt;
  if id1=id2 then exit;
  q:=TZQuery.Create(self);
  try
    dm.trans.StartTransaction;
    q.Connection:=dm.db;
    q.SQL.Add('update filmy set id=:nowe where id=:stare');
    q.Prepare;
    q.ParamByName('stare').AsLargeInt:=id2;
    q.ParamByName('nowe').AsLargeInt:=0;
    q.ExecSQL;
    q.ParamByName('stare').AsLargeInt:=id1;
    q.ParamByName('nowe').AsLargeInt:=id2;
    q.ExecSQL;
    q.ParamByName('stare').AsLargeInt:=0;
    q.ParamByName('nowe').AsLargeInt:=id1;
    q.ExecSQL;
    q.Unprepare;
    dm.trans.Commit;
  finally
    q.Free;
    if dm.db.InTransaction then
    begin
      dm.trans.Rollback;
      filmy.DisableControls;
      filmy.Refresh;
      filmy.Locate('id',id1,[]);
      filmy.EnableControls;
    end else begin
      filmy.DisableControls;
      filmy.Refresh;
      filmy.Locate('id',id2,[]);
      filmy.EnableControls;
    end;
  end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  FPlikiZombi:=TFPlikiZombi.Create(self);
  FPlikiZombi.Show;
end;

procedure TForm1.MenuItem75Click(Sender: TObject);
var
  s,czas: string;
  ss: TStringList;
  a,b,c,d,i: integer;
begin
  s:=filmylink.AsString;
  s:=s+'&t='+IntToStr(trunc(czasyczas_od.AsInteger/1000));
  if mess.ShowConfirmationYesNo('Czy złożyć link z dodatkowymi informacjami?') then
  begin
    if (filmyduration.AsInteger=0) and (not mplayer.Running) then
    begin
      mess.ShowInformation('Ten film musi być odpalony choć raz do odczytania informacji o długości filmu.^Zrób to i spróbuj jeszcze raz jak to zrobisz.');
      exit;
    end;
    ss:=TStringList.Create;
    if CheckBox4.Checked then
    begin
      d:=0;
      try
        ss.Add('Link do fragmentu filmu z Youtube:');
        ss.Add('Tytuł filmu: '+filmynazwa.AsString);
        ss.Add('Link zawiera kilka indeksów:');
        if DBGrid2.SelectedRows.Count>0 then
        begin
          with DBGrid2.DataSource.DataSet do
          begin
            for i:=0 to DBGrid2.SelectedRows.Count-1 do
            begin
              GotoBookmark(Pointer(DBGrid2.SelectedRows.Items[i]));
              czasy_nast.ParamByName('czas_aktualny').AsInteger:=czasyczas_od.AsInteger;
              czasy_nast.Open;
              if czasy_nast.IsEmpty then c:=filmyduration.AsInteger-czasyczas_od.AsInteger
                                    else c:=czasy_nast.FieldByName('czas_od').AsInteger-czasyczas_od.AsInteger;
              czasy_nast.Close;
              d:=d+c;
              ss.Add('Opis fragmentu: '+czasynazwa.AsString+' ('+TimeToText(IntegerToTime(c))+')');
            end;
          end;
        end;
        ss.Add('Link: '+s);
        ss.Add('Czas trwania całości fragmentu: '+TimeToText(IntegerToTime(d)));
        ClipBoard.AsText:=ss.Text;
      finally
        ss.Free;
      end;
    end else begin
      czasy_nast.ParamByName('czas_aktualny').AsInteger:=czasyczas_od.AsInteger;
      czasy_nast.Open;
      if czasy_nast.IsEmpty then c:=filmyduration.AsInteger-czasyczas_od.AsInteger
                            else c:=czasy_nast.FieldByName('czas_od').AsInteger-czasyczas_od.AsInteger;
      czasy_nast.Close;
      czas:=TimeToText(c);
      try
        ss.Add('Link do fragmentu filmu z Youtube:');
        ss.Add('Tytuł filmu: '+filmynazwa.AsString);
        ss.Add('Opis fragmentu: '+czasynazwa.AsString);
        ss.Add('Link: '+s);
        ss.Add('Czas trwania fragmentu: '+czas);
        ClipBoard.AsText:=ss.Text;
      finally
        ss.Free;
      end;
    end;
  end else begin
    ClipBoard.AsText:=s;
  end;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
var
  id1,id2: integer;
  q: TZQuery;
begin
  id1:=filmyid.AsLargeInt;
  filmy.Prior;
  id2:=filmyid.AsLargeInt;
  if id1=id2 then exit;
  q:=TZQuery.Create(self);
  try
    dm.trans.StartTransaction;
    q.Connection:=dm.db;
    q.SQL.Add('update filmy set id=:nowe where id=:stare');
    q.Prepare;
    q.ParamByName('stare').AsLargeInt:=id1;
    q.ParamByName('nowe').AsLargeInt:=0;
    q.ExecSQL;
    q.ParamByName('stare').AsLargeInt:=id2;
    q.ParamByName('nowe').AsLargeInt:=id1;
    q.ExecSQL;
    q.ParamByName('stare').AsLargeInt:=0;
    q.ParamByName('nowe').AsLargeInt:=id2;
    q.ExecSQL;
    q.Unprepare;
    dm.trans.Commit;
  finally
    q.Free;
    if dm.db.InTransaction then
    begin
      dm.trans.Rollback;
      filmy.DisableControls;
      filmy.Refresh;
      filmy.Locate('id',id1,[]);
      filmy.EnableControls;
    end else begin
      filmy.DisableControls;
      filmy.Refresh;
      filmy.Locate('id',id2,[]);
      filmy.EnableControls;
    end;
  end;
end;

procedure TForm1.mplayerCacheing(ASender: TObject; APosition, ADuration,
  ACache: single);
var
  vDurationInt: integer;
  a,b,c,d,n: integer;
  aa,bb,cc: TTime;
  bPos: boolean;
begin
  if not UELED20.Active then exit;
  {kod dotyczy kontrolki "pp_cache"}
  if ADuration=0 then exit;
  vDurationInt:=mplayer.SingleMpToInteger(ADuration);
  {if vDurationInt<>vv_duration then UpdateFilmDuration(vDurationInt);
  if (_MPLAYER_FORCESTART0>0) and (APosition>0) and (not _MPLAYER_FORCESTART0_BOOL) then
  begin
    _MPLAYER_FORCESTART0_BOOL:=true;
    mplayer.Position:=mplayer.IntegerToSingleMp(_MPLAYER_FORCESTART0);
    _MPLAYER_FORCESTART0:=0;
    _MPLAYER_FORCESTART0_BOOL:=false;
    exit;
  end;}
  aa:=ADuration/SecsPerDay;
  bb:=(APosition+ACache)/SecsPerDay;
  cc:=ACache/SecsPerDay;
  a:=TimeToInteger(aa-bb);
  b:=TimeToInteger(bb);
  c:=TimeToInteger(cc);
  d:=Round(ACache*1000);
  if d>30000 then d:=30000;
  pp_cache.Min:=0;
  pp_cache.Max:=30000;
  pp_cache.Position:=d;
  pp.Refresh;
  bPos:=c<3600000;
  if bPos then Label16.Caption:=FormatDateTime('nn:ss',cc) else Label16.Caption:=FormatDateTime('h:nn:ss',cc);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Edit2.Text:='';
end;

procedure TForm1.tObsOffTimerStartTimer(Sender: TObject);
begin
  local_obs_off_timer:=local_delay_timer_opoznienie;
  Label13.Caption:=IntToStr(local_obs_off_timer);
  Label13.Visible:=true;
  uELED11.Active:=true;
end;

procedure TForm1.tObsOffTimerStopTimer(Sender: TObject);
begin
  Label13.Visible:=false;
  uELED11.Active:=false;
end;

procedure TForm1._REFRESH_CZASY(Sender: TObject);
var
  a: integer;
  t: TBookMark;
begin
  a:=czasyid.AsInteger;
  t:=czasy.GetBookmark;
  czasy.DisableControls;
  try
    czasy.Close;
    czasy.Open;
    try
      czasy.GotoBookmark(t);
    except
      czasy.Locate('id',a,[]);
    end;
  finally
    czasy.EnableControls;
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: miPlayer.Checked:=true;
    1: miRecord.Checked:=true;
    2: miPresentation.Checked:=true;
  end;
  if miPresentation.Checked then
  begin
    _C_DATETIME[1]:=-1;
    _C_DATETIME[2]:=-1;
    _C_DATETIME[3]:=-1;
    zmiana(tryb);
  end else zmiana;
  tzegar.Enabled:=miPresentation.Checked;
  if not miPresentation.Checked then szumpause;

  if _DEF_GREEN_SCREEN then
  begin
    if miPresentation.Checked then
    begin
      if not _SET_GREEN_SCREEN then
      begin
        FScreen:=TFScreen.Create(self);
        FScreen.Show;
        _SET_GREEN_SCREEN:=true;
      end;
    end else begin
      if _SET_GREEN_SCREEN then
      begin
        FScreen.Free;
        _SET_GREEN_SCREEN:=false;
      end;
    end;
  end;
  if _DEF_VIEW_SCREEN then
  begin
    if miPresentation.Checked then
    begin
      if not _SET_VIEW_SCREEN then
      begin
        FPodglad:=TFPodglad.Create(self);
        FPodglad.Show;
        _SET_VIEW_SCREEN:=true;
      end;
    end else begin
      if _SET_VIEW_SCREEN then
      begin
        FPodglad.Free;
        _SET_VIEW_SCREEN:=false;
      end;
    end;
  end;
  if _DEF_LAMP_FORMS then
  begin
    if miPresentation.Checked then
    begin
      if not _SET_LAMP_FORMS then
      begin
        FLamp1:=TFLamp.Create(self);
        FLamp2:=TFLamp.Create(self);
        FLamp1.Label1.Caption:='Kamerka Nr 1';
        FLamp2.Label1.Caption:='Kamerka Nr 2';
        FLamp1.FormStyle:=fsSystemStayOnTop;
        FLamp2.FormStyle:=fsSystemStayOnTop;
        FLamp1.Show;
        FLamp2.Show;
        _SET_LAMP_FORMS:=true;
      end;
    end else begin
      if _SET_LAMP_FORMS then
      begin
        FLamp1.Free;
        FLamp2.Free;
        _SET_LAMP_FORMS:=false;
      end;
    end;
  end;
  SetCursorOnPresentation(miPresentation.Checked and mplayer.Running);
end;

procedure TForm1.cShutdownBeforeShutdown(Sender: TObject);
begin
  case _DEF_SHUTDOWN_MODE of
    0: cShutDown.Mode:=smNone;
    1: cShutDown.Mode:=smQDbusKDE;
    2: cShutDown.Mode:=smGnome;
    3: cShutDown.Mode:=smShutdownP1;
    4: cShutDown.Mode:=smShutdownP2;
  end;
end;

procedure TForm1.csvBeforeRead(Sender: TObject);
begin
  case TCsvParser(Sender).Tag of
    0: begin
         dm.trans.StartTransaction;
         dm.del_all.Execute;
       end;
    1: begin
         lista_wybor.Clear;
         klucze_wybor.Clear;
       end;
    2: dm.trans.StartTransaction;
  end;
end;

procedure TForm1.csvRead(Sender: TObject; NumberRec, PosRec: integer; sName,
  sValue: string; var Stopped: boolean);
var
  i,id: integer;
begin
  if PosRec=1 then rec.typ:=sValue;
  if rec.typ='R' then {ROZDZIAŁY}
  begin
    case PosRec of
       1: rec.typ:=sValue;
       2: rec.id:=StrToInt(sValue);
       3: rec.nazwa:=sValue;
       4: if sValue='' then rec.asort:=0 else rec.asort:=StrToInt(sValue);
       5: if (sValue='') or (sValue='[null]') then rec.film:=-1 else rec.film:=StrToInt(sValue);
       6: rec.nomemtime:=StrToInt(sValue);
       7: rec.noarchive:=StrToInt(sValue);
       8: rec.novideo:=StrToInt(sValue);
       9: rec.normalize_audio:=StrToInt(sValue);
      10: rec.dir:=sValue;
      11: rec.autosortdesc:=StrToInt(sValue);
      12: rec.formatfile:=StrToInt(sValue);
    end;
    if PosRec=12 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             dm.add_rec0.ParamByName('id').AsInteger:=rec.id;
             dm.add_rec0.ParamByName('nazwa').AsString:=rec.nazwa;
             dm.add_rec0.ParamByName('autosort').AsInteger:=rec.asort;
             if rec.film=-1 then dm.add_rec0.ParamByName('film').Clear else dm.add_rec0.ParamByName('film').AsInteger:=rec.film;
             dm.add_rec0.ParamByName('nomemtime').AsInteger:=rec.nomemtime;
             dm.add_rec0.ParamByName('noarchive').AsInteger:=rec.noarchive;
             dm.add_rec0.ParamByName('novideo').AsInteger:=rec.novideo;
             dm.add_rec0.ParamByName('normalize_audio').AsInteger:=rec.normalize_audio;
             if rec.dir='' then dm.add_rec0.ParamByName('directory').Clear else dm.add_rec0.ParamByName('directory').AsString:=rec.dir;
             dm.add_rec0.ParamByName('autosortdesc').AsInteger:=rec.autosortdesc;
             dm.add_rec0.ParamByName('formatfile').AsInteger:=rec.formatfile;
             dm.add_rec0.Execute;
           end;
      end; {case}
    end; {if PosRec=x}
  end else
  if rec.typ='F' then {FILMY}
  begin
    case PosRec of
       1: rec.typ:=sValue;
       2: rec.id:=StrToInt(sValue);
       3: if sValue='[null]' then rec.link:='' else rec.link:=sValue;
       4: if sValue='[null]' then rec.plik:='' else rec.plik:=sValue;
       5: if sValue='[null]' then rec.rozdzial:=-1 else rec.rozdzial:=StrToInt(sValue);
       6: rec.nazwa:=sValue;
       7: if sValue='[null]' then rec.wzmocnienie:=-1 else rec.wzmocnienie:=StrToInt(sValue);
       8: if sValue='[null]' then rec.glosnosc:=-1 else rec.glosnosc:=StrToInt(sValue);
       9: if sValue='[null]' then rec.status:=0 else rec.status:=StrToInt(sValue);
      10: if sValue='[null]' then rec.osd:=0 else rec.osd:=StrToInt(sValue);
      11: if sValue='[null]' then rec.audio:=0 else rec.audio:=StrToInt(sValue);
      12: if sValue='[null]' then rec.resample:=0 else rec.resample:=StrToInt(sValue);
      13: if sValue='[null]' then rec.audioeq:='' else rec.audioeq:=sValue;
      14: if sValue='[null]' then rec.file_audio:='' else rec.file_audio:=sValue;
      15: if sValue='[null]' then rec.lang:='' else rec.lang:=sValue;
      16: if sValue='[null]' then rec.position:=-1 else rec.position:=StrToInt(sValue);
      17: if sValue='[null]' then rec.file_subtitle:='' else rec.file_subtitle:=sValue;
      18: if sValue='[null]' then rec.start0:=0 else rec.start0:=StrToInt(sValue);
      19: if sValue='[null]' then rec.transpose:=0 else rec.transpose:=StrToInt(sValue);
      20: if sValue='[null]' then rec.predkosc:=0 else rec.predkosc:=StrToInt(sValue);
      21: if sValue='[null]' then rec.tonacja:=0 else rec.tonacja:=StrToInt(sValue);
      22: if sValue='[null]' then rec.wsp_czasu_yt:=0 else rec.wsp_czasu_yt:=StrToInt(sValue);
      23: if sValue='[null]' then rec.w1:=0 else rec.w1:=StrToInt(sValue);
      24: if sValue='[null]' then rec.w2:=0 else rec.w2:=StrToInt(sValue);
      25: if sValue='[null]' then rec.w3:=0 else rec.w3:=StrToInt(sValue);
      26: if sValue='[null]' then rec.w4:=0 else rec.w4:=StrToInt(sValue);
    end;
    if PosRec=26 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             if rec.link='"' then rec.link:='';
             dm.add_rec.ParamByName('id').AsInteger:=rec.id;
             dm.add_rec.ParamByName('nazwa').AsString:=rec.nazwa;
             if rec.link='' then dm.add_rec.ParamByName('link').Clear else dm.add_rec.ParamByName('link').AsString:=rec.link;
             if rec.plik='' then dm.add_rec.ParamByName('plik').Clear else dm.add_rec.ParamByName('plik').AsString:=rec.plik;
             if rec.rozdzial=-1 then dm.add_rec.ParamByName('rozdzial').Clear
                                else dm.add_rec.ParamByName('rozdzial').AsInteger:=rec.rozdzial;
             if rec.wzmocnienie=-1 then dm.add_rec.ParamByName('wzmocnienie').Clear
                                   else dm.add_rec.ParamByName('wzmocnienie').AsBoolean:=rec.wzmocnienie=1;
             if rec.glosnosc=-1 then dm.add_rec.ParamByName('glosnosc').Clear
                                else dm.add_rec.ParamByName('glosnosc').AsInteger:=rec.glosnosc;
             dm.add_rec.ParamByName('status').AsInteger:=rec.status;
             dm.add_rec.ParamByName('osd').AsInteger:=rec.osd;
             dm.add_rec.ParamByName('audio').AsInteger:=rec.audio;
             dm.add_rec.ParamByName('resample').AsInteger:=rec.resample;
             if rec.audioeq='' then dm.add_rec.ParamByName('audioeq').Clear
                               else dm.add_rec.ParamByName('audioeq').AsString:=rec.audioeq;
             if rec.file_audio='' then dm.add_rec.ParamByName('file_audio').Clear
                                  else dm.add_rec.ParamByName('file_audio').AsString:=rec.file_audio;
             if rec.lang='' then dm.add_rec.ParamByName('lang').Clear
                            else dm.add_rec.ParamByName('lang').AsString:=rec.lang;
             if rec.position=-1 then dm.add_rec.ParamByName('position').Clear
                                else dm.add_rec.ParamByName('position').AsInteger:=rec.position;
             if rec.file_subtitle='' then dm.add_rec.ParamByName('file_subtitle').Clear
                                     else dm.add_rec.ParamByName('file_subtitle').AsString:=rec.file_subtitle;
             dm.add_rec.ParamByName('start0').AsInteger:=rec.start0;
             dm.add_rec.ParamByName('transpose').AsInteger:=rec.transpose;
             dm.add_rec.ParamByName('predkosc').AsInteger:=rec.predkosc;
             dm.add_rec.ParamByName('tonacja').AsInteger:=rec.tonacja;
             dm.add_rec.ParamByName('wsp_czasu_yt').AsInteger:=rec.wsp_czasu_yt;
             dm.add_rec.ParamByName('wektor_yt_1').AsInteger:=rec.w1;
             dm.add_rec.ParamByName('wektor_yt_2').AsInteger:=rec.w2;
             dm.add_rec.ParamByName('wektor_yt_3').AsInteger:=rec.w3;
             dm.add_rec.ParamByName('wektor_yt_4').AsInteger:=rec.w4;
             dm.add_rec.Execute;
           end;
        1: begin
             {odczyt listy filmów by później wybrać niektóre z nich do doczytania}
             lista_wybor.Add(rec.nazwa);
             klucze_wybor.Add(IntToStr(rec.id));
           end;
        2: begin
             {zapis do bazy tylko wybranych pozycji}
             i:=ecode.StringToItemIndex(klucze_wybor,IntToStr(rec.id));
             if i>-1 then
             begin
               dm.add_rec.ParamByName('id').Clear;
               dm.add_rec.ParamByName('nazwa').AsString:=rec.nazwa;
               if rec.link='' then dm.add_rec.ParamByName('link').Clear else dm.add_rec.ParamByName('link').AsString:=rec.link;
               if rec.plik='' then dm.add_rec.ParamByName('plik').Clear else dm.add_rec.ParamByName('plik').AsString:=rec.plik;
               if db_rozid.AsInteger=0 then dm.add_rec.ParamByName('rozdzial').Clear
                                       else dm.add_rec.ParamByName('rozdzial').AsInteger:=db_rozid.AsInteger;
               //if rec.rozdzial='[null]' then dm.add_rec.ParamByName('rozdzial').Clear
               //                         else dm.add_rec.ParamByName('rozdzial').AsInteger:=rec.rozdzial;
               if rec.wzmocnienie=-1 then dm.add_rec.ParamByName('wzmocnienie').Clear
                                     else dm.add_rec.ParamByName('wzmocnienie').AsBoolean:=rec.wzmocnienie=1;
               if rec.glosnosc=-1 then dm.add_rec.ParamByName('glosnosc').Clear
                                  else dm.add_rec.ParamByName('glosnosc').AsInteger:=rec.glosnosc;
               dm.add_rec.ParamByName('status').AsInteger:=rec.status;
               dm.add_rec.ParamByName('osd').AsInteger:=rec.osd;
               dm.add_rec.ParamByName('audio').AsInteger:=rec.audio;
               dm.add_rec.ParamByName('resample').AsInteger:=rec.resample;
               if rec.audioeq='' then dm.add_rec.ParamByName('audioeq').Clear
                                 else dm.add_rec.ParamByName('audioeq').AsString:=rec.audioeq;
               if rec.file_audio='' then dm.add_rec.ParamByName('file_audio').Clear
                                    else dm.add_rec.ParamByName('file_audio').AsString:=rec.file_audio;
               if rec.lang='' then dm.add_rec.ParamByName('lang').Clear
                              else dm.add_rec.ParamByName('lang').AsString:=rec.lang;
               if rec.position=-1 then dm.add_rec.ParamByName('position').Clear
                                  else dm.add_rec.ParamByName('position').AsInteger:=rec.position;
               if rec.file_subtitle='' then dm.add_rec.ParamByName('file_subtitle').Clear
                                       else dm.add_rec.ParamByName('file_subtitle').AsString:=rec.file_subtitle;
               dm.add_rec.ParamByName('start0').AsInteger:=rec.start0;
               dm.add_rec.ParamByName('transpose').AsInteger:=rec.transpose;
               dm.add_rec.ParamByName('predkosc').AsInteger:=rec.predkosc;
               dm.add_rec.ParamByName('tonacja').AsInteger:=rec.tonacja;
               dm.add_rec.ParamByName('wsp_czasu_yt').AsInteger:=rec.wsp_czasu_yt;
               dm.add_rec.ParamByName('wektor_yt_1').AsInteger:=rec.w1;
               dm.add_rec.ParamByName('wektor_yt_2').AsInteger:=rec.w2;
               dm.add_rec.ParamByName('wektor_yt_3').AsInteger:=rec.w3;
               dm.add_rec.ParamByName('wektor_yt_4').AsInteger:=rec.w4;
               dm.add_rec.Execute;
               id:=get_last_id;
               lista_wybor.Delete(i);
               lista_wybor.Insert(i,IntToStr(id));
             end;
           end;
      end; {case}
    end; {if PosRec=x}
  end else
  if rec.typ='C' then {CZASY}
  begin
    if TCsvParser(Sender).Tag=1 then
    begin
      Stopped:=true;
      exit;
    end;
    case PosRec of
       1: rec.typ:=sValue;
       2: rec.id:=StrToInt(sValue);
       3: rec.film:=StrToInt(sValue);
       4: rec.nazwa:=sValue;
       5: rec.czas_od:=StrToInt(sValue);
       6: rec.czas_do:=StrToInt(sValue);
       7: rec.czas2:=StrToInt(sValue);
       8: if sValue='[null]' then rec.status:=0 else rec.status:=StrToInt(sValue);
       9: if sValue='[null]' then rec.file_audio:='' else rec.file_audio:=sValue;
      10: if sValue='[null]' then rec.autor:='' else rec.autor:=sValue;
      11: if sValue='1' then rec.mute:=true else rec.mute:=false;
    end;
    if PosRec=11 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             dm.add_rec2.ParamByName('id').AsInteger:=rec.id;
             dm.add_rec2.ParamByName('film').AsInteger:=rec.film;
             dm.add_rec2.ParamByName('nazwa').AsString:=rec.nazwa;
             dm.add_rec2.ParamByName('czas_od').AsInteger:=rec.czas_od;
             if rec.czas_do=0 then dm.add_rec2.ParamByName('czas_do').Clear
             else dm.add_rec2.ParamByName('czas_do').AsInteger:=rec.czas_do;
             if rec.czas2=0 then dm.add_rec2.ParamByName('czas2').Clear
             else dm.add_rec2.ParamByName('czas2').AsInteger:=rec.czas2;
             dm.add_rec2.ParamByName('status').AsInteger:=rec.status;
             if rec.file_audio='' then dm.add_rec2.ParamByName('file_audio').Clear
                                  else dm.add_rec2.ParamByName('file_audio').AsString:=rec.file_audio;
             if rec.autor='' then dm.add_rec2.ParamByName('autor').Clear
                             else dm.add_rec2.ParamByName('autor').AsString:=rec.autor;
             if rec.mute then dm.add_rec2.ParamByName('mute').AsInteger:=1
                         else dm.add_rec2.ParamByName('mute').Clear;
             dm.add_rec2.Execute;
           end;
        2: begin
             {zapis do bazy tylko wybranych pozycji}
             i:=ecode.StringToItemIndex(klucze_wybor,IntToStr(rec.film));
             if i>-1 then
             begin
               id:=StrToInt(lista_wybor[i]);
               dm.add_rec2.ParamByName('id').Clear;
               dm.add_rec2.ParamByName('film').AsInteger:=id;
               dm.add_rec2.ParamByName('nazwa').AsString:=rec.nazwa;
               dm.add_rec2.ParamByName('czas_od').AsInteger:=rec.czas_od;
               if rec.czas_do=0 then dm.add_rec2.ParamByName('czas_do').Clear
               else dm.add_rec2.ParamByName('czas_do').AsInteger:=rec.czas_do;
               if rec.czas2=0 then dm.add_rec2.ParamByName('czas2').Clear
               else dm.add_rec2.ParamByName('czas2').AsInteger:=rec.czas2;
               dm.add_rec2.ParamByName('status').AsInteger:=rec.status;
               if rec.file_audio='' then dm.add_rec2.ParamByName('file_audio').Clear
                                    else dm.add_rec2.ParamByName('file_audio').AsString:=rec.file_audio;
               if rec.autor='' then dm.add_rec2.ParamByName('autor').Clear
                               else dm.add_rec2.ParamByName('autor').AsString:=rec.autor;
               if rec.mute then dm.add_rec2.ParamByName('mute').AsInteger:=1
                           else dm.add_rec2.ParamByName('mute').Clear;
               dm.add_rec2.Execute;
             end;
           end;
      end; {case}
    end; {if PosRec=x}
  end else
  if rec.typ='I' then {INDEKSY}
  begin
    case PosRec of
      1: rec.typ:=sValue;
      2: rec.id:=StrToInt(sValue);
      3: rec.s1:=sValue;
      4: rec.s2:=sValue;
      5: rec.s3:=sValue;
      6: rec.s4:=sValue;
      7: rec.s5:=sValue;
    end;
    if PosRec=7 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             mem_lamp[rec.id].active:=rec.s1='1';
             mem_lamp[rec.id].rozdzial:=StrToInt(rec.s2);
             mem_lamp[rec.id].indeks:=StrToInt(rec.s3);
             mem_lamp[rec.id].indeks_czasu:=StrToInt(rec.s4);
             mem_lamp[rec.id].time:=StrToFloat(rec.s5);
             tab_lamp_odczyt(true);
        end;
      end; {case}
    end; {if PosRec=x}
  end;
end;

procedure TForm1.czasyBeforeOpen(DataSet: TDataSet);
begin
  czasy.ClearDefs;
  if CheckBox1.Checked then czasy.AddDef('-- var1','and (status & 1) = 0');
  if CheckBox3.Checked then czasy.AddDef('-- var2','and active=1');
end;

procedure TForm1.czasyCalcFields(DataSet: TDataSet);
var
  stat: integer;
  b,i: boolean;
  s: string;
begin
  stat:=czasystatus.AsInteger;
  b:=GetBit(stat,0);
  i:=GetBit(stat,1);
  s:='';
  if i then s:=s+'I';
  if b then s:=s+'B';
  czasyc_flagi.AsString:=s;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
var
  s,s1: string;
  start0,playstart0: boolean;
begin
  if filmy.IsEmpty then exit;
  stop_force:=true;
  _MPLAYER_FORCESTART0:=0;
  if mplayer.Running then mplayer.Stop;
  indeks_czas:=-1;
  s:=filmy.FieldByName('plik').AsString;
  if (s='') or (not FileExists(s)) then s:=filmy.FieldByName('link').AsString;
  Edit1.Text:=s;
  ReadVariableFromDatabase(db_roz,filmy);
  start0:=filmy.FieldByName('start0').AsInteger=1;
  playstart0:=GetBit(filmy.FieldByName('status').AsInteger,4);
  if not playstart0 then playstart0:=db_roz.FieldByName('nomemtime').AsInteger=1;
  _ustaw_cookies;
  if not playstart0 then
  begin
    if _DEF_FULLSCREEN_MEMORY then
    begin
      if cctimer_opt>0 then
      begin
        (* kontynuuję od ostatniej pozycji czasowej *)
        if start0 then
        begin
          _MPLAYER_FORCESTART0:=filmyposition.AsInteger;
        end else begin
          s1:=FormatDateTime('hh:nn:ss.z',IntegerToTime(cctimer_opt));
          if mplayer.Engine=meMPV then
          begin
            if const_mplayer_param='' then const_mplayer_param:='--start='+s1
            else const_mplayer_param:=const_mplayer_param+' --start='+s1;
          end else begin
            if const_mplayer_param='' then const_mplayer_param:='-ss '+s1
            else const_mplayer_param:=const_mplayer_param+' -ss '+s1;
          end;
        end;
      end;
    end else
    if miPlayer.Checked and (filmyposition.AsInteger>0) then
    begin
      (* kontynuuję od ostatniej pozycji czasowej *)
      if start0 then
      begin
        _MPLAYER_FORCESTART0:=filmyposition.AsInteger;
      end else begin
        s1:=FormatDateTime('hh:nn:ss.z',IntegerToTime(filmyposition.AsInteger));
        if mplayer.Engine=meMPV then
        begin
          if const_mplayer_param='' then const_mplayer_param:='--start='+s1
          else const_mplayer_param:=const_mplayer_param+' --start='+s1;
        end else begin
          if const_mplayer_param='' then const_mplayer_param:='-ss '+s1
          else const_mplayer_param:=const_mplayer_param+' -ss '+s1;
        end;
      end;
    end;
  end;
  Play.Click;
end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  b,b2: boolean;
begin
  DBGrid1.Canvas.Font.Bold:=false;
  b:=filmyc_plik_exist.AsBoolean;
  if b then
  begin
    b2:=ExtractFileExt(filmyplik.AsString)='.ogg';
    if b2 then DBGrid1.Canvas.Font.Color:=clGreen else DBGrid1.Canvas.Font.Color:=clBlue;
  end else DBGrid1.Canvas.Font.Color:=TColor($333333);
  if indeks_play=filmyid.AsInteger then
  begin
    DBGrid1.Canvas.Font.Bold:=true;
    if b then
      DBGrid1.Canvas.Font.Color:=TColor($0E0044)
    else
      DBGrid1.Canvas.Font.Color:=clBlack;
  end;
  DBGrid1.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  //if _SET_VIEW_SCREEN then FPodglad.DBGrid1.Refresh;
end;

procedure TForm1.DBGrid2CellClick(Column: TColumn);
begin
  if _SET_VIEW_SCREEN then FPodglad.DBGrid2.Update;
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
var
  s,s1: string;
  start0: boolean;
begin
  if czasy.IsEmpty then exit;
  pstatus_ignore:=true;
  if _SET_GREEN_SCREEN then FScreen.MemReset;
  {player działa}
  if mplayer.Running and (indeks_play=filmy.FieldByName('id').AsInteger) then
  begin
    if vv_obrazy then SeekPlay(mplayer_obraz_normalize(czasy.FieldByName('czas_od').AsInteger))
    else SeekPlay(czasy.FieldByName('czas_od').AsInteger);
    exit;
  end;
  {player nie działa - uruchamiam i lece od danego momentu}
  stop_force:=true;
  _MPLAYER_FORCESTART0:=0;
  if mplayer.Running then mplayer.Stop;
  s:=filmy.FieldByName('plik').AsString;
  if (s='') or (not FileExists(s)) then s:=filmy.FieldByName('link').AsString;
  Edit1.Text:=s;
  ReadVariableFromDatabase(db_roz,filmy);
  start0:=filmystart0.AsInteger=1;
  if vv_obrazy then s1:=FormatDateTime('hh:nn:ss.z',IntegerToTime(mplayer_obraz_normalize(czasy.FieldByName('czas_od').AsInteger)))
  else s1:=FormatDateTime('hh:nn:ss.z',IntegerToTime(czasy.FieldByName('czas_od').AsInteger));
  force_position:=false;
  _ustaw_cookies;
  if start0 then
  begin
    _MPLAYER_FORCESTART0:=czasy.FieldByName('czas_od').AsInteger;
  end else begin
    if mplayer.Engine=meMPV then
    begin
      if const_mplayer_param='' then const_mplayer_param:='--start='+s1
      else const_mplayer_param:=const_mplayer_param+' --start='+s1;
    end else begin
      if const_mplayer_param='' then const_mplayer_param:='-ss '+s1
      else const_mplayer_param:=const_mplayer_param+' -ss '+s1;
    end;
  end;
  if indeks_czas>-1 then indeks_czas:=czasy.FieldByName('id').AsInteger;
  if czasymute.IsNull then vv_mute:=false else vv_mute:=czasymute.AsInteger=1;
  vv_old_mute:=vv_mute;
  Play.Click;
  timer_obrazy.Enabled:=vv_obrazy;
end;

procedure TForm1.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  a: integer;
  b,c: boolean;
begin
  a:=czasystatus.AsInteger;
  b:=ecode.GetBit(a,0);
  c:=ecode.GetBit(a,1);
  DBGrid2.Canvas.Font.Bold:=false;

  if b then DBGrid2.Canvas.Font.Color:=clRed else
  //if c then DBGrid2.Canvas.Font.Color:=clGray else
  DBGrid2.Canvas.Font.Color:=TColor($333333);

  if indeks_czas=czasy.FieldByName('id').AsInteger then
  begin
    DBGrid2.Canvas.Font.Bold:=true;
    if b then DBGrid2.Canvas.Font.Color:=clGray
         else DBGrid2.Canvas.Font.Color:=clBlack;
  end;
  DBGrid2.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  //if _SET_VIEW_SCREEN then FPodglad.DBGrid2.Update;
end;

procedure TForm1.DBGrid3PrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
var
  b: boolean;
  tlo,video,plik: TColor;
begin
  tlo:=clBlack;
  video:=clWhite;
  plik:=clYellow;
  DBGrid3.Canvas.Font.Bold:=false;
  b:=filmyc_plik_exist.AsBoolean;
  if b then DBGrid3.Canvas.Font.Color:=plik else DBGrid3.Canvas.Font.Color:=video;
  if (not filmyposition.IsNull) and (filmyposition.AsInteger>0) then DBGrid3.Canvas.Font.Bold:=true;
  if gdSelected in AState then DBGrid3.Canvas.Brush.Color:=clBlue else
  DBGrid3.Canvas.Brush.Color:=tlo;
end;

procedure TForm1.DBLookupComboBox1CloseUp(Sender: TObject);
begin
  DBLookupComboBox1.DataSource:=ds_roz;
  DBLookupComboBox1.DataField:='id';
end;

procedure TForm1.DBLookupComboBox1DropDown(Sender: TObject);
begin
  DBLookupComboBox1.DataSource:=nil;
end;

procedure TForm1.DBLookupComboBox1Select(Sender: TObject);
var
  id: integer;
begin
  id:=DBLookupComboBox1.KeyValue;
  db_roz.Locate('id',id,[]);
  //filmy.First;
  filmy_reopen;
end;

procedure TForm1.db_rozAfterScroll(DataSet: TDataSet);
begin
  MenuItem70.Checked:=db_rozautosort.AsInteger=1;
  MenuItem98.Checked:=MenuItem70.Checked;
  MenuItem113.Checked:=db_rozautosortdesc.AsInteger=1;
end;

procedure TForm1.db_roznazwaGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText:=Sender.AsString;
end;

procedure TForm1.ds_filmyDataChange(Sender: TObject; Field: TField);
begin
  Menuitem63.Enabled:=filmyc_plik_exist.AsBoolean;
end;

procedure TForm1.filmyBeforeOpen(DataSet: TDataSet);
var
  s,s1: string;
  a,i: integer;
begin
  s:=IntToStr(filmy.Tag);
  if s[1]>'1' then a:=1 else
  if s[2]>'1' then a:=2 else
  if s[3]>'1' then a:=3 else a:=1;
  filmy.ClearDefs;
  s1:=trim(Edit2.Text);
  if s1<>'' then filmy.AddDef('-- where_add','and nazwa like :filtr');
  if a=1 then
  begin
    if s[a]='3' then
    begin
      filmy.AddDef('-- sort','order by id desc');
    end else begin
      filmy.AddDef('-- sort','order by id');
    end;
  end else
  if a=2 then
  begin
    if s[a]='3' then
    begin
      filmy.AddDef('-- sort','order by nazwa desc, data_uploaded desc, id desc');
    end else begin
      filmy.AddDef('-- sort','order by nazwa,data_uploaded,id');
    end;
  end else
  if a=3 then
  begin
    if s[a]='3' then
    begin
      filmy.AddDef('-- sort','order by data_uploaded desc, nazwa desc, id desc');
    end else begin
      filmy.AddDef('-- sort','order by data_uploaded,nazwa,id');
    end;
  end;
end;

procedure TForm1.filmyBeforeOpenII(Sender: TObject);
var
  s: string;
begin
  if MenuItem25.Checked then filmy.ParamByName('all').AsInteger:=0
                        else filmy.ParamByName('all').AsInteger:=1;
  s:=trim(Edit2.Text);
  if s<>'' then filmy.ParamByName('filtr').AsString:='%'+s+'%';
end;

procedure TForm1.filmyCalcFields(DataSet: TDataSet);
var
  b: boolean;
  s: string;
begin
  s:=filmyplik.AsString;
  if (s='') or (not FileExists(s)) then b:=false else b:=true;
  filmyc_plik_exist.AsBoolean:=b;
end;

procedure TForm1.film_playBeforeOpen(DataSet: TDataSet);
var
  s,s1: string;
  a,i: integer;
begin
  s:=IntToStr(filmy.Tag);
  if s[1]>'1' then a:=1 else
  if s[2]>'1' then a:=2 else
  if s[3]>'1' then a:=3 else a:=1;
  film_play.ClearDefs;
  s1:=trim(Edit2.Text);
  if s1<>'' then film_play.AddDef('-- where_add','and nazwa like :filtr');
  if a=1 then
  begin
    if s[a]='3' then
    begin
      film_play.AddDef('-- sort','order by id desc');
    end else begin
      film_play.AddDef('-- sort','order by id');
    end;
  end else
  if a=2 then
  begin
    if s[a]='3' then
    begin
      film_play.AddDef('-- sort','order by nazwa desc, data_uploaded desc, id desc');
    end else begin
      film_play.AddDef('-- sort','order by nazwa,data_uploaded,id');
    end;
  end else
  if a=3 then
  begin
    if s[a]='3' then
    begin
      film_play.AddDef('-- sort','order by data_uploaded desc, nazwa desc, id desc');
    end else begin
      film_play.AddDef('-- sort','order by data_uploaded,nazwa,id');
    end;
  end;
end;

procedure TForm1.film_playBeforeOpenII(Sender: TObject);
var
  s: string;
begin
  film_play.ParamByName('id').AsInteger:=auto_play_id;
  if MenuItem25.Checked then film_play.ParamByName('all').AsInteger:=0
                        else film_play.ParamByName('all').AsInteger:=1;
  s:=trim(Edit2.Text);
  if s<>'' then film_play.ParamByName('filtr').AsString:='%'+s+'%';
end;

procedure TForm1.fmenuBefore(aItemIndex: integer);
begin
  cctimer_opt:=0;
end;

procedure TForm1.fmenuExecute(aItemIndex: integer; aResult: integer);
begin
  (* pierwszy zestaw *)
  if aItemIndex=0 then
  begin
    case aResult of
      0: cctimer_opt:=0;
      1: cctimer_opt:=filmyposition.AsInteger;
    end;
    DBGrid1DblClick(self);
  end else
  (* drugi zestaw *)
  if aItemIndex=1 then
  begin
    case aResult of
      0: begin
           (* Opuść tryb pełnoekranowy *)
           _DEF_FULLSCREEN_MEMORY:=false;
           UpdateFilmToRoz;
           go_fullscreen(true);
         end;
      1: menu_rozdzialy;
      2: begin
           (* Usuń zapis czasu *)
           filmy.Edit;
           filmyposition.Clear;
           filmy.Post;
         end;
      3: sciagnij_film;
      4: DeleteFilm(true,false,true);
      5: DeleteFilm(true,true,true);
      6: ComputerOff;
      7: begin
           MenuItem100.Checked:=true;
           MenuItem101.Checked:=false;
           fmenu.Items.Delete(1);
           fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,$Halt End Film,Halt End All Film,Cancel Shutdown!');
         end;
      8: begin
           MenuItem100.Checked:=false;
           MenuItem101.Checked:=true;
           fmenu.Items.Delete(1);
           fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,Halt End Film,$Halt End All Film,Cancel Shutdown!');
         end;
      9: begin
           MenuItem100.Checked:=false;
           MenuItem101.Checked:=false;
           fmenu.Items.Delete(1);
           fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,Halt End Film,Halt End All Film,Cancel Shutdown!');
         end;
    end;
  end else
  (* trzeci zestaw *)
  if aItemIndex=2 then
  begin
    writeln(aResult);
    case aResult of
       0: cctimer_opt:=0;
       1: cctimer_opt:=0;
       2: cctimer_opt:=0;
       3: cctimer_opt:=0;
       4: cctimer_opt:=0;
       5: cctimer_opt:=0;
       6: cctimer_opt:=0;
       7: cctimer_opt:=0;
       8: cctimer_opt:=0;
       9: cctimer_opt:=0;
      10: cctimer_opt:=1;
    end;
    if cctimer_opt=1 then ComputerOff else
    begin
      (* wyłączam shutdown's *)
      MenuItem100.Checked:=false;
      MenuItem101.Checked:=false;
      fmenu.Items.Delete(1);
      fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,Halt End Film,Halt End All Film,Cancel Shutdown!');
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if npilot.Active then npilot.Disconnect;
  shared.Stop;
  go_fullscreen(true);
  application.ProcessMessages;
  if UOSPlayer.Busy or UOSpodklad.Busy or UOSszum.Busy then
  begin
    if UOSPlayer.Busy then UOSPlayer.Stop(true);
    if UOSpodklad.Busy then UOSpodklad.Stop(true);
    if UOSszum.Busy then UOSszum.Stop(true);
    Application.ProcessMessages;
    sleep(500);
  end;
  if mplayer.Playing or mplayer.Paused then
  begin
    Stop.Click;
    sleep(500);
  end;
  db_close;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  b15: boolean;
  res: TResourceStream;
  k: TKeyEvent;
begin
  //writeln('Force key: ',Key);
  //EXIT;
  b15:=miRecord.Checked;
  {obsługa skrótów klawiszowych}
  if b15 then
  begin
    case Key of
      VK_S: if (not miRecord.Checked) and (not miPresentation.Checked) and mplayer.Running then zrob_zdjecie(true);
      VK_E: if (not miPresentation.Checked) and mplayer.Running then MenuItem11.Click; //'E'
      VK_I: czasy_id_info;
      VK_RETURN: if mplayer.Running then DBGrid2DblClick(Sender); //'ENTER
      107: if mplayer.Running then dodaj_pozycje_na_koniec_listy(ssShift in Shift); //'+'
      188: if mplayer.Running then czasy_edycja_188; //'<'
      190: if mplayer.Running then czasy_edycja_190; //'>'
      191: if mplayer.Running then czasy_edycja_191; //'/'
      146: if mplayer.Running then czasy_edycja_146; //'\' (między SHIFT a Z)
    end;
  end;

  {obsługa reszty skrótów}
  case Key of
    VK_SPACE: if mplayer.Running then Play.Click;
    VK_LEFT: if mplayer.Running and (not miPresentation.Checked) then mplayer.Position:=mplayer.Position-4;
    VK_RIGHT: if mplayer.Running and (not miPresentation.Checked) then mplayer.Position:=mplayer.Position+4;
    VK_UP: komenda_up;
    VK_DOWN: komenda_down;
    VK_F: {if not miPresentation.Checked then} go_fullscreen;
    VK_D: if mplayer.Running then MenuItem117.Click;
    VK_O: if not miPresentation.Checked then go_przelaczpokazywanieczasu;
    VK_M: if mplayer.Running then PlayMute;
    VK_ESCAPE: if not Panel1.Visible then
               begin
                 if _DEF_FULLSCREEN_MEMORY then
                 begin
                   UpdateFilmToRoz;
                   _DEF_FULLSCREEN_MEMORY:=false;
                   DBGrid3.Visible:=false;
                 end;
                 go_fullscreen;
                 Key:=0;
               end;
    VK_DELETE: if Menuitem45.Checked then
               begin
                 if DBGrid1.Focused then
                 begin
                   if not filmy.IsEmpty then filmy.Delete;
                 end else
                 if DBGrid2.Focused then usun_pozycje_czasu(false);
               end;
    VK_R: if (not miPresentation.Checked) and mplayer.Running then test_force:=true;
    VK_RETURN: if mplayer.Running and (not b15) then go_czas2; //'ENTER'
    else if MenuItem17.Checked then writeln('Klawisz: ',Key);
  end;

  {obsługa pilota}
  if miPlayer.Checked or miPresentation.Checked or miRecord.Checked then
  begin

    if miPresentation.Checked then
    begin
      if (Key=45) and (not bcenzura) then
      begin
        mixer.RecMute;
        try
          cenzura:=TMemoryStream.Create;
          res:=TResourceStream.Create(hInstance,'CENZURA',RT_RCDATA);
          cenzura.LoadFromStream(res);
        finally
          res.Free;
        end;
        UOSPlayer.Volume:=0.04;
        UOSPlayer.Start(cenzura);
        bcenzura:=true;
      end;
      if Key=46 then
      begin
        try
          cenzura:=TMemoryStream.Create;
          res:=TResourceStream.Create(hInstance,'PRZERYWNIK2',RT_RCDATA);
          cenzura.LoadFromStream(res);
        finally
          res.Free;
        end;
        UOSPlayer.Volume:=1;
        UOSPlayer.Start(cenzura);
      end;
      if MenuItem76.Checked then
      begin
        if Key=49 then mplayer.Pause else
        if Key=50 then mplayer.Replay;
      end;
    end;
    Presentation.Execute(Key);
  end;
  Key:=0;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {obsługa pilota}
  if miPlayer.Checked or miPresentation.Checked or miRecord.Checked then
  begin
    if miPresentation.Checked then
    begin
      if Key=45 then if bcenzura then
      begin
        UOSPlayer.Stop;
        mixer.RecUnmute;
        bcenzura:=false;
      end;
    end;
  end;
end;

procedure TForm1.Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[1].active:=false;
    mem_lamp[1].zmiana:=true;
    Memory_1.ImageIndex:=27;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[1].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[1].indeks:=indeks_play;
    mem_lamp[1].indeks_czasu:=indeks_czas;
    mem_lamp[1].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[1].active:=true;
    mem_lamp[1].zmiana:=true;
    Memory_1.ImageIndex:=28;
  end;
  if _SET_VIEW_SCREEN then FPodglad.Memory_1.ImageIndex:=Memory_1.ImageIndex;
  if _DEF_PANEL then FPanel.Memory_1.ImageIndex:=Memory_1.ImageIndex;
end;

procedure TForm1.Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[2].active:=false;
    mem_lamp[2].zmiana:=true;
    Memory_2.ImageIndex:=29;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[2].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[2].indeks:=indeks_play;
    mem_lamp[2].indeks_czasu:=indeks_czas;
    mem_lamp[2].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[2].active:=true;
    mem_lamp[2].zmiana:=true;
    Memory_2.ImageIndex:=30;
  end;
  if _SET_VIEW_SCREEN then FPodglad.Memory_2.ImageIndex:=Memory_2.ImageIndex;
  if _DEF_PANEL then FPanel.Memory_2.ImageIndex:=Memory_2.ImageIndex;
end;

procedure TForm1.Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[3].active:=false;
    mem_lamp[3].zmiana:=true;
    Memory_3.ImageIndex:=31;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[3].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[3].indeks:=indeks_play;
    mem_lamp[3].indeks_czasu:=indeks_czas;
    mem_lamp[3].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[3].active:=true;
    mem_lamp[3].zmiana:=true;
    Memory_3.ImageIndex:=32;
  end;
  if _SET_VIEW_SCREEN then FPodglad.Memory_3.ImageIndex:=Memory_3.ImageIndex;
  if _DEF_PANEL then FPanel.Memory_3.ImageIndex:=Memory_3.ImageIndex;
end;

procedure TForm1.Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[4].active:=false;
    mem_lamp[4].zmiana:=true;
    Memory_4.ImageIndex:=33;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[4].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[4].indeks:=indeks_play;
    mem_lamp[4].indeks_czasu:=indeks_czas;
    mem_lamp[4].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[4].active:=true;
    mem_lamp[4].zmiana:=true;
    Memory_4.ImageIndex:=34;
  end;
  if _SET_VIEW_SCREEN then FPodglad.Memory_4.ImageIndex:=Memory_4.ImageIndex;
  if _DEF_PANEL then FPanel.Memory_4.ImageIndex:=Memory_4.ImageIndex;
end;

procedure TForm1.MenuItem100Click(Sender: TObject);
begin
  MenuItem100.Checked:=not MenuItem100.Checked;
  if MenuItem100.Checked then
  begin
    MenuItem101.Checked:=false;
    fmenu.Items.Delete(1);
    fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,$Halt End Film,Halt End All Film,Cancel Shutdown!');
  end else begin
    fmenu.Items.Delete(1);
    fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,Halt End Film,Halt End All Film,Cancel Shutdown!');
  end;
end;

procedure TForm1.MenuItem101Click(Sender: TObject);
begin
  MenuItem101.Checked:=not MenuItem101.Checked;
  if MenuItem101.Checked then
  begin
    MenuItem100.Checked:=false;
    fmenu.Items.Delete(1);
    fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,Halt End Film,$Halt End All Film,Cancel Shutdown!');
  end else begin
    fmenu.Items.Delete(1);
    fmenu.Items.Insert(1,'Wyjdź,Wybierz rozdział,Usuń zapis czasu,Ściągnij film,$Usuń film,$Usuń film i plik,$Wyłącz komputer,Halt End Film,Halt End All Film,Cancel Shutdown!');
  end;
end;

procedure TForm1.MenuItem102Click(Sender: TObject);
begin
  MenuItem102.Checked:=not MenuItem102.Checked;
  _DEF_VIEW_SCREEN:=MenuItem102.Checked;
  dm.SetConfig('default-view-screen',_DEF_VIEW_SCREEN);
end;

procedure TForm1.MenuItem103Click(Sender: TObject);
begin
  zapisz_fragment_filmu;
end;

procedure TForm1.MenuItem104Click(Sender: TObject);
begin
  MenuItem93.Click;
end;

procedure TForm1.MenuItem105Click(Sender: TObject);
begin
  play.Click;
end;

procedure TForm1.MenuItem107Click(Sender: TObject);
begin
  stop.Click;
end;

procedure TForm1.mplayerStop(Sender: TObject);
var
  pom1,pom2,pom3: integer;
  s: string;
  a1,a2,a3,a4: boolean;
begin
  pplay(0,true);
  zapisz(0);
  DBGrid3.Visible:=_DEF_FULLSCREEN_MEMORY;
  force_deinterlace:=false;
  uELED18.Active:=false;
  Label11.Visible:=uELED18.Active;
  uELED20.Active:=false;
  Label12.Visible:=uELED20.Active;
  Label16.Visible:=false;
  pp_cache.Visible:=false;
  cctimer_opt:=0;
  szumpause;
  Edit1.Text:='';
  pom1:=indeks_rozd;
  pom2:=indeks_play;
  Play.ImageIndex:=0;
  const_mplayer_param:='';
  mplayer.StartParam:='';
  ClearVariable;
  uELED5.Active:=false;
  DBGrid1.Refresh;
  DBGrid2.Refresh;
  if _SET_VIEW_SCREEN then
  begin
    FPodglad.DBGrid1.Refresh;
    FPodglad.DBGrid2.Refresh;
  end;
  Play.ImageIndex:=0;
  Label3.Caption:='-:--';
  Label4.Caption:='-:--';
  pp.Position:=0;
  pp_cache.Position:=0;
  reset_oo;
  update_pp_oo;
  if _DEF_PANEL then FPanel.Play.ImageIndex:=Play.ImageIndex;
  if CLIPBOARD_PLAY OR EXTFILE_PLAY then
  begin
    CLIPBOARD_PLAY:=false;
    EXTFILE_PLAY:=false;
    exit;
  end;
  if (not stop_force) and miPlayer.Checked then
  begin
    if MenuItem100.Checked then
    begin
      if _DEF_FULLSCREEN_MEMORY then fmenu.Execute(2) else ComputerOff;
      exit;
    end;
    ReadRoz.ParamByName('id').AsInteger:=pom1;
    ReadRoz.Open;
    a1:=ReadRozautosort.AsInteger=1;
    a2:=ReadRozautosortdesc.AsInteger=1;
    a3:=ReadRoznovideo.AsInteger=1;
    a4:=ReadRoznormalize_audio.AsInteger=1;
    ReadRoz.Close;
    auto_play_id:=pom1;
    auto_play_sort:=a1;
    auto_play_sort_desc:=a2;
    film_play.Open;
    film_play.Locate('id',pom2,[]);
    film_play.Next;
    pom3:=film_play.FieldByName('id').AsInteger;
    if (pom2<>pom3) and (pom3<>0) then
    begin
      if pom1=db_rozid.AsInteger then
      begin
        filmy.First;
        filmy.Locate('id',pom3,[]);
      end;
      s:=film_play.FieldByName('plik').AsString;
      if (s='') or (not FileExists(s)) then s:=film_play.FieldByName('link').AsString;
      Edit1.Text:=s;
      ReadVariableFromDatabase(nil,film_play);
      indeks_czas:=-1;
      indeks_rozd:=pom1;
      if not vv_novideo then vv_novideo:=a3;
      if not vv_normalize then vv_normalize:=a4;
      Play.Click;
    end else begin
      if MenuItem101.Checked then
      begin
        if _DEF_FULLSCREEN_MEMORY then fmenu.Execute(2) else ComputerOff;
        exit;
      end;
      if (not miPresentation.Checked) and (not _DEF_FULLSCREEN_MEMORY) then go_fullscreen(true);
    end;
    film_play.Close;
  end else if (not miPresentation.Checked) and (not _DEF_FULLSCREEN_MEMORY) then go_fullscreen(true);
  stop_force:=false;
end;

procedure TForm1.npilotConnect(aSocket: TLSocket);
begin
  uELED3.Color:=clRed;
  npilot.SendString('tryb=pilot');
end;

procedure TForm1.npilotReceiveString(aMsg: string; aSocket: TLSocket;
  aBinSize: integer; var aReadBin: boolean);
var
  s1,s2: string;
begin
  //writeln('MSG = ',aMsg);
  s1:=GetLineToStr(aMsg,1,'=');
  if s1='pilot' then
  begin
    s2:=trim(GetLineToStr(aMsg,2,'='));
    if pos('key_',s2)=1 then pilot_wykonaj(s2) else
    if s2='active' then uELED3.Color:=clBlue else
    if s2='noactive' then uELED3.Color:=clRed;
  end else
  if s1='tryb' then
  begin
    s2:=trim(GetLineToStr(aMsg,2,'='));
    if s2='pilot' then npilot.SendString('pilot=active');
  end;
end;

procedure TForm1.npilotStatus(aActive, aCrypt: boolean);
begin
  uELED3.Active:=aActive;
end;

procedure TForm1.ooMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if vv_obrazy then exit;
  if mplayer.Running and (Label5.Caption<>'-:--') then
  begin
    pstatus_ignore:=true;
    if czas_nastepny=-1 then max:=MiliSecToInteger(round(mplayer.Duration*1000))-czas_aktualny
    else max:=czas_nastepny-czas_aktualny;
    a:=round(max*X/oo.Width)+czas_aktualny;
    czas:=IntegerToTime(a)*SecsPerDay;
    mplayer.Position:=czas;
  end;
end;

procedure TForm1.ooMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var
  max: integer;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if vv_obrazy then exit;
  if mplayer.Running and (Label5.Caption<>'-:--') then
  begin
    if czas_nastepny=-1 then max:=MiliSecToInteger(round(mplayer.Duration*1000))-czas_aktualny
    else max:=czas_nastepny-czas_aktualny;
    a:=round(max*X/oo.Width)+czas_aktualny;
    aa:=IntegerToTime(a-czas_aktualny);
    bPos:=a-czas_aktualny<3600000;
    if bPos then podpowiedz2.Caption:=FormatDateTime('nn:ss',przelicz_czas(aa)) else podpowiedz2.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(aa));
    podpowiedz2.Left:=X+oo.Left-round(podpowiedz2.Width/2);
    podpowiedz2.Visible:=true;
    oo_mouse.Enabled:=false;
    oo_mouse.Enabled:=true;
  end;
end;

procedure TForm1.oo_mouseStartTimer(Sender: TObject);
begin
  podpowiedz2.Visible:=true;
end;

procedure TForm1.oo_mouseTimer(Sender: TObject);
begin
  oo_mouse.Enabled:=false;
  podpowiedz2.Visible:=false;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  dodaj_pozycje_na_koniec_listy;
end;

procedure TForm1.MenuItem112Click(Sender: TObject);
begin
  BExit.Click;
end;

procedure TForm1.MenuItem113Click(Sender: TObject);
begin
  MenuItem113.Checked:=not MenuItem113.Checked;
  db_roz.Edit;
  if MenuItem113.Checked then db_rozautosortdesc.AsInteger:=1 else db_rozautosortdesc.AsInteger:=0;
  db_roz.Post;
  filmy_reopen;
end;

procedure TForm1.MenuItem114Click(Sender: TObject);
var
  s,ext: string;
  b: boolean;
  q,c: integer;
begin
  s:=filmyplik.AsString;
  b:=s<>'';
  if b then b:=FileExists(s);
  ext:=ExtractFileExt(s);
  if ext='.ogg' then
  begin
    mess.ShowInformation('Plik źródłowy jest już plikiem OGG. Przerywam.');
    exit;
  end;
  if b then
  begin
    FConfOGG:=TFConfOGG.Create(self);
    try
      FConfOGG.in_file:=s;
      FConfOGG.init(1);
      FConfOGG.ShowModal;
      b:=FConfOGG.out_ok;
      if b then
      begin
        q:=FConfOGG.out_quality;
        c:=FConfOGG.out_channels;
      end;
    finally
      FConfOGG.Free;
    end;
  end else mess.ShowWarning('Plik źródłowy nie istnieje, przerywam.');
  if b then vcc.RenderOgg(filmyid.AsInteger,s,c,q);
end;

procedure TForm1.MenuItem116Click(Sender: TObject);
begin
  (*
  ffmpeg -i Waking\ from\ the\ Dream\ \[sKhZlMs6oME\].mkv -vn -ab 192k -f ogg Sample.ogg
  *)
end;

procedure TForm1.MenuItem117Click(Sender: TObject);
begin
  MenuItem117.Checked:=not MenuItem117.Checked;
  if mplayer.Running then mplayer.Deinterlace:=MenuItem117.Checked;
end;

procedure TForm1.MenuItem118Click(Sender: TObject);
var
  t: TBookmark;
  ss: TStrings;
  b,b2: boolean;
  s: string;
  dlugosc,dlugosc_yt,a: integer;
  wektory: boolean;
  w1,w2: array[1..2] of integer;
begin
  if not mplayer.Running then
  begin
    mess.ShowInformation('Odtwarzanie musi byś w trakcie!');
    exit;
  end;
  if czasy.IsEmpty then exit;
  w1[1]:=filmywektor_yt_1.AsInteger;
  w1[2]:=filmywektor_yt_2.AsInteger;
  w2[1]:=filmywektor_yt_3.AsInteger;
  w2[2]:=filmywektor_yt_4.AsInteger;
  wektory:=(w1[1]>0) and (w1[2]>0) and (w2[1]>0) and (w2[2]>0);
  dlugosc:=TimeToInteger(mplayer.Duration/SecsPerDay);
  dlugosc_yt:=filmywsp_czasu_yt.AsInteger;
  b:=mess.ShowConfirmationYesNo('Czy do planu dołączyć ignorowane obszary filmu?');
  b2:=true;
  ss:=TStringList.Create;
  try
    czasy.DisableControls;
    t:=czasy.GetBookmark;
    czasy.First;
    while not czasy.EOF do
    begin
      if GetBit(czasystatus.AsInteger,0) and (not b) then
      begin
        czasy.Next;
        continue;
      end;
      s:=czasynazwa.AsString;
      if wektory then a:=get_wektor_yt(czasyczas_od.AsInteger,w1[1],w1[2],w2[1],w2[2],dlugosc,dlugosc_yt) else
      if dlugosc_yt=0 then a:=czasyczas_od.AsInteger else a:=round(czasyczas_od.AsInteger*dlugosc_yt/dlugosc);
      if b2 then ss.Add(FormatDateTime('h:nn:ss',IntegerToTime(a))+' - '+FirstMinusToGeneratePlane(s))
            else ss.Add(FirstMinusToGeneratePlane(s));
      czasy.Next;
    end;
    Clipboard.AsText:=ss.Text;
  finally
    czasy.GotoBookmark(t);
    czasy.EnableControls;
    ss.Free;
  end;
end;

procedure TForm1.MenuItem119Click(Sender: TObject);
begin
  Timer2.Enabled:=not Timer2.Enabled;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
var
  id: integer;
begin
  if czasy.RecordCount=0 then exit;
  id:=czasy.FieldByName('id').AsInteger;
  FCzas:=TFCzas.Create(self);
  try
    FCzas.s_nazwa:=czasy.FieldByName('nazwa').AsString;
    FCzas.s_autor:=czasy.FieldByName('autor').AsString;
    FCzas.s_audio:=czasy.FieldByName('file_audio').AsString;
    FCzas.i_od:=czasy.FieldByName('czas_od').AsInteger;
    FCzas.io_link_id_czasu:=czasywstawka_filmowa_czas_id.AsInteger;
    if czasy.FieldByName('czas_do').IsNull then FCzas.i_do:=0
    else FCzas.i_do:=czasy.FieldByName('czas_do').AsInteger;
    if czasymute.IsNull then FCzas.b_mute:=false else FCzas.b_mute:=czasymute.AsInteger=1;
    FCzas.in_tryb:=2;
    FCzas.ShowModal;
    if FCzas.out_ok then
    begin
      czasy.Edit;
      czasy.FieldByName('nazwa').AsString:=FCzas.s_nazwa;
      if FCzas.s_autor='' then czasy.FieldByName('autor').Clear
                          else czasy.FieldByName('autor').AsString:=FCzas.s_autor;
      if FCzas.s_audio='' then czasy.FieldByName('file_audio').Clear
                          else czasy.FieldByName('file_audio').AsString:=FCzas.s_audio;
      if FCzas.b_mute then czasymute.AsInteger:=1 else czasymute.Clear;
      if FCzas.io_link_id_czasu=0 then czasywstawka_filmowa_czas_id.Clear else czasywstawka_filmowa_czas_id.AsInteger:=FCzas.io_link_id_czasu;
      czasy.Post;
    end;
  finally
    FCzas.Free;
  end;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  if czasy.RecordCount=0 then exit;
  usun_pozycje_czasu(not Menuitem45.Checked);
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
  if filmynotatki.IsNull then exit;
  AutoGenerateYT2Czasy(filmynotatki.AsString);
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var
  ss: TStrings;
begin
  if mess.ShowConfirmationYesNo('Czy pobrać dane ze zdalnego serwera?') then
  begin
    ss:=TStringList.Create;
    try
      dm.www_odczyt(ss);
      ss.SaveToFile(MyConfDir('archiwum_www.csv'));
    finally
      ss.Free;
    end;
    csv.Filename:=MyConfDir('archiwum_www.csv');
    csv.Tag:=1;
    csv.Execute;
    exit;
  end;
  if OpenDialogCsv.Execute then
  begin
    csv.Filename:=OpenDialogCsv.FileName;
    csv.Tag:=1;
    csv.Execute;
  end;
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
  MenuItem17.Checked:=not MenuItem17.Checked;
end;

procedure TForm1.MenuItem18Click(Sender: TObject);
begin
  dm.schemasync.SaveSchema;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  dodaj_film;
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
  MenuItem25.Checked:=not MenuItem25.Checked;
  filmy.Close;
  filmy.Open;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  MenuItem26.Checked:=not MenuItem26.Checked;
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
var
  s: string;
  id: integer;
begin
  s:=InputBox('Nowy rozdział','Podaj nazwę:','');
  if s<>'' then
  begin
    dm.roz_add.ParamByName('nazwa').AsString:=s;
    dm.roz_add.ExecSQL;
    id:=get_last_id;
    db_roz.Refresh;
    db_roz.Locate('id',id,[]);
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
var
  vstatus: integer;
  roz1,roz2: integer;
  file1,file2: string;
begin
  if filmy.RecordCount=0 then exit;
  FLista:=TFLista.Create(self);
  try
    FLista.s_tytul:=filmy.FieldByName('nazwa').AsString;
    FLista.s_link:=filmy.FieldByName('link').AsString;
    file1:=filmy.FieldByName('plik').AsString;
    FLista.s_file:=file1;
    FLista.s_audio:=filmyfile_audio.AsString;
    FLista.s_lang:=filmylang.AsString;
    FLista.s_subtitle:=filmyfile_subtitle.AsString;
    FLista.s_notatki:=filmynotatki.AsString;
    if filmy.FieldByName('rozdzial').IsNull then roz1:=0
    else roz1:=filmy.FieldByName('rozdzial').AsInteger;
    FLista.i_roz:=roz1;
    if filmywzmocnienie.IsNull then FLista.in_out_wzmocnienie:=-1 else
    if filmywzmocnienie.AsBoolean then FLista.in_out_wzmocnienie:=1 else FLista.in_out_wzmocnienie:=0;
    if filmyglosnosc.IsNull then FLista.in_out_glosnosc:=-1 else FLista.in_out_glosnosc:=filmyglosnosc.AsInteger;
    vstatus:=filmystatus.AsInteger;
    FLista.in_out_obrazy:=GetBit(vstatus,0);
    FLista.in_transmisja:=GetBit(vstatus,1);
    FLista.in_szum:=GetBit(vstatus,2);
    FLista.in_normalize:=GetBit(vstatus,3);
    FLista.in_play_start0:=GetBit(vstatus,4);
    FLista.in_play_novideo:=GetBit(vstatus,5);
    FLista.in_normalize_not:=GetBit(vstatus,6);
    FLista.in_out_osd:=filmyosd.AsInteger;
    FLista.in_out_audio:=filmyaudio.AsInteger;
    FLista.in_out_resample:=filmyresample.AsInteger;
    FLista.in_out_start0:=filmystart0.AsInteger=1;
    FLista.io_transpose:=filmytranspose.AsInteger;
    FLista.io_predkosc:=filmypredkosc.AsInteger;
    FLista.io_tonacja:=filmytonacja.AsInteger;
    FLista.io_wsp_czasu_yt:=filmywsp_czasu_yt.AsInteger;
    FLista.io_w1_yt:=filmywektor_yt_1.AsInteger;
    FLista.io_w2_yt:=filmywektor_yt_2.AsInteger;
    FLista.io_w3_yt:=filmywektor_yt_3.AsInteger;
    FLista.io_w4_yt:=filmywektor_yt_4.AsInteger;
    FLista.in_tryb:=2;
    FLista.ShowModal;
    if FLista.out_ok then
    begin
      filmy.Edit;
      filmy.FieldByName('nazwa').AsString:=FLista.s_tytul;
      if FLista.s_link='' then filmy.FieldByName('link').Clear else filmy.FieldByName('link').AsString:=FLista.s_link;
      if FLista.s_audio='' then filmyfile_audio.Clear else filmyfile_audio.AsString:=FLista.s_audio;
      if FLista.s_lang='' then filmylang.Clear else filmylang.AsString:=FLista.s_lang;
      if FLista.s_subtitle='' then filmyfile_subtitle.Clear else filmyfile_subtitle.AsString:=FLista.s_subtitle;
      roz2:=FLista.i_roz;
      if roz2=0 then filmy.FieldByName('rozdzial').Clear
      else filmy.FieldByName('rozdzial').AsInteger:=roz2;
      file2:=FLista.s_file;
      if file1<>'' then file2:=filename2roz2filename(roz1,roz2,file1,file2);
      if file2='' then filmy.FieldByName('plik').Clear else filmy.FieldByName('plik').AsString:=file2;
      if trim(FLista.s_notatki)='' then filmynotatki.Clear else filmynotatki.AsString:=FLista.s_notatki;
      if FLista.in_out_wzmocnienie=-1 then filmywzmocnienie.Clear else filmywzmocnienie.AsBoolean:=FLista.in_out_wzmocnienie=1;
      if FLista.in_out_glosnosc=-1 then filmyglosnosc.Clear else filmyglosnosc.AsInteger:=FLista.in_out_glosnosc;
      SetBit(vstatus,0,FLista.in_out_obrazy);
      SetBit(vstatus,1,FLista.in_transmisja);
      SetBit(vstatus,2,FLista.in_szum);
      SetBit(vstatus,3,FLista.in_normalize);
      SetBit(vstatus,4,FLista.in_play_start0);
      SetBit(vstatus,5,FLista.in_play_novideo);
      SetBit(vstatus,6,FLista.in_normalize_not);
      filmystatus.AsInteger:=vstatus;
      filmyosd.AsInteger:=FLista.in_out_osd;
      filmyaudio.AsInteger:=FLista.in_out_audio;
      filmyresample.AsInteger:=FLista.in_out_resample;
      if FLista.in_out_start0 then filmystart0.AsInteger:=1 else filmystart0.AsInteger:=0;
      filmytranspose.AsInteger:=FLista.io_transpose;
      filmypredkosc.AsInteger:=FLista.io_predkosc;
      filmytonacja.AsInteger:=FLista.io_tonacja;
      filmywsp_czasu_yt.AsInteger:=FLista.io_wsp_czasu_yt;
      filmywektor_yt_1.AsInteger:=FLista.io_w1_yt;
      filmywektor_yt_2.AsInteger:=FLista.io_w2_yt;
      filmywektor_yt_3.AsInteger:=FLista.io_w3_yt;
      filmywektor_yt_4.AsInteger:=FLista.io_w4_yt;
      filmy.Post;
      filmy.Refresh;
    end;
  finally
    FLista.Free;
  end;
end;

procedure TForm1.MenuItem30Click(Sender: TObject);
var
  id: integer;
begin
  if db_roz.FieldByName('id').AsInteger=0 then exit;
  id:=db_roz.FieldByName('id').AsInteger;
  FRozdzial:=TFRozdzial.Create(self);
  try
    FRozdzial.io_nazwa:=db_roznazwa.AsString;
    FRozdzial.io_dir:=db_rozdirectory.AsString;
    FRozdzial.io_nomem:=db_roznomemtime.AsInteger=1;
    FRozdzial.io_noarchive:=db_roznoarchive.AsInteger=1;
    FRozdzial.io_novideo:=db_roznovideo.AsInteger=1;
    FRozdzial.io_normalize_audio:=db_roznormalize_audio.AsInteger=1;
    FRozdzial.io_format:=db_rozformatfile.AsInteger;
    FRozdzial.io_chroniony:=db_rozchroniony.AsInteger=1;
    FRozdzial.ShowModal;
    if FRozdzial.io_zmiany then
    begin
      db_roz.Edit;
      db_roz.FieldByName('nazwa').AsString:=FRozdzial.io_nazwa;
      if FRozdzial.io_dir='' then db_rozdirectory.Clear else db_rozdirectory.AsString:=FRozdzial.io_dir;
      if FRozdzial.io_nomem then db_roznomemtime.AsInteger:=1 else db_roznomemtime.AsInteger:=0;
      if FRozdzial.io_noarchive then db_roznoarchive.AsInteger:=1 else db_roznoarchive.AsInteger:=0;
      if FRozdzial.io_novideo then db_roznovideo.AsInteger:=1 else db_roznovideo.AsInteger:=0;
      if FRozdzial.io_normalize_audio then db_roznormalize_audio.AsInteger:=1 else db_roznormalize_audio.AsInteger:=0;
      db_rozformatfile.AsInteger:=FRozdzial.io_format;
      if FRozdzial.io_chroniony then db_rozchroniony.AsInteger:=1 else db_rozchroniony.AsInteger:=0;
      db_roz.Post;
    end;
  finally
    FRozdzial.Free;
  end;
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
var
  id: integer;
  b: boolean;
  link,plik: string;
  vobrazy: boolean;
begin
  if db_roz.FieldByName('id').AsInteger=0 then exit;
  if mess.ShowConfirmationYesNo('Czy usunąć wskazany rozdział?') then
  begin
    id:=db_roz.FieldByName('id').AsInteger;
    dm.trans.StartTransaction;
    if mess.ShowConfirmationYesNo('Czy usunąć jednocześnie z bazy danych wszystkie filmy należące do usuwanego rozdziału?') then
    begin
      b:=mess.ShowConfirmationYesNo('Czy istniejące pliki skojarzone z filmami także usunąć?^^Zwróć uwagę, że zostaną tylko usunięte pliki, których film ma wypełniony link do Youtube, więc pozycje bez tego linku nie zostaną usunięte.');
      filmy_roz.Open;
      while not filmy_roz.EOF do
      begin
        if b then
        begin
          if filmy_roz.FieldByName('link').IsNull then link:='' else  link:=filmy_roz.FieldByName('link').AsString;
          plik:=filmy_roz.FieldByName('plik').AsString;
          vobrazy:=GetBit(filmy_roz.FieldByName('status').AsInteger,0);
          if (vobrazy or (link<>'')) and (plik<>'') and FileExists(plik) then DeleteFile(plik);
        end;
        filmy_roz.Next;
      end;
      filmy_roz.Close;
      db_roz.Delete;
    end else begin
      dm.roz_del1.ParamByName('id').AsInteger:=id;
      dm.roz_del1.Execute;
      db_roz.Delete;
    end;
    dm.trans.Commit;
  end;
end;

procedure TForm1.MenuItem32Click(Sender: TObject);
var
  cc,dd: string;
  aa,vv: TStrings;
  a,v: integer;
begin
  if filmyc_plik_exist.AsBoolean then exit;
  if FileExists(_DEF_COOKIES_FILE_YT) then cc:=_DEF_COOKIES_FILE_YT else cc:='';
  aa:=TStringList.Create;
  vv:=TStringList.Create;
  if not filmyrozdzial.IsNull then dd:=trim(db_rozdirectory.AsString);
  if dd='' then dd:=dm.GetConfig('default-directory-save-files','');
  try
    youtube.AutoSelect:=_DEF_YT_AUTOSELECT;
    youtube.MaxVideoQuality:=_DEF_YT_AS_QUALITY;
    youtube.PathToCookieFile:=cc;
    youtube.DownloadInfo(filmylink.AsString,aa,vv);
    FSelectYT:=TFSelectYT.Create(self);
    try
      FSelectYT.CheckListBox1.Items.Assign(aa);
      FSelectYT.CheckListBox2.Items.Assign(vv);
      FSelectYT.ShowModal;
      if FSelectYT.io_ok then
      begin
        a:=FSelectYT.io_audio;
        v:=FSelectYT.io_video;
      end else exit;
    finally
      FSelectYT.Free;
    end;
  finally
    aa.Free;
    vv.Free;
  end;
  youtube.AddLink(filmylink.AsString,dd,a,v,filmyid.AsInteger);
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
var
  cc,dd: string;
  t: TBookmark;
begin
  if filmy.IsEmpty then exit;
  if not filmyrozdzial.IsNull then dd:=trim(db_rozdirectory.AsString);
  if dd='' then
  begin
    ytdir.InitialDir:=dm.GetConfig('default-directory-save-files','');
    if not ytdir.Execute then exit;
    dd:=ytdir.FileName;
  end;
  if FileExists(_DEF_COOKIES_FILE_YT) then cc:=_DEF_COOKIES_FILE_YT else cc:='';
  youtube.AutoSelect:=_DEF_YT_AUTOSELECT;
  youtube.MaxVideoQuality:=_DEF_YT_AS_QUALITY;
  youtube.PathToCookieFile:=cc;
  filmy.DisableControls;
  t:=filmy.GetBookmark;
  filmy.First;
  while not filmy.EOF do
  begin
    if filmyc_plik_exist.AsBoolean then
    begin
      filmy.Next;
      continue;
    end;
    youtube.AddLink(filmylink.AsString,dd,0,0,filmyid.AsInteger);
    filmy.Next;
  end;
  filmy.GotoBookmark(t);
  filmy.EnableControls;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
  FConfig:=TFConfig.Create(self);
  FConfig.ShowModal;
  //pilot:=dm.pilot_wczytaj;
  pilot_wczytaj;
end;

procedure TForm1.MenuItem35Click(Sender: TObject);
begin
  zapisz_fragment_filmu(true);
end;

var
  tasma_wektor: integer = 0;

procedure TForm1.MenuItem36Click(Sender: TObject);
begin
  FZapisTasmy:=TFZapisTasmy.Create(self);
  try
    FZapisTasmy.wektor.Value:=tasma_wektor;
    FZapisTasmy.ShowModal;
    tasma_wektor:=FZapisTasmy.wektor.Value;
  finally
    FZapisTasmy.Free;
  end;
end;

procedure TForm1.MenuItem37Click(Sender: TObject);
var
  t: TBookmark;
  ss: TStrings;
  b,b2: boolean;
begin
  if czasy.IsEmpty then exit;
  b:=mess.ShowConfirmationYesNo('Czy do planu dołączyć ignorowane obszary filmu?');
  b2:=mess.ShowConfirmationYesNo('Czy dołączyć etykiety czasowe do planu?');
  ss:=TStringList.Create;
  try
    czasy.DisableControls;
    t:=czasy.GetBookmark;
    czasy.First;
    while not czasy.EOF do
    begin
      if GetBit(czasystatus.AsInteger,0) and (not b) then
      begin
        czasy.Next;
        continue;
      end;
      if b2 then ss.Add('[czas] - '+FirstMinusToGeneratePlane(czasynazwa.AsString))
            else ss.Add(czasynazwa.AsString);
      czasy.Next;
    end;
    Clipboard.AsText:=ss.Text;
  finally
    czasy.GotoBookmark(t);
    czasy.EnableControls;
    ss.Free;
  end;
end;

procedure TForm1.MenuItem38Click(Sender: TObject);
var
  a: integer;
  b: boolean;
begin
  a:=czasystatus.AsInteger;
  b:=ecode.GetBit(a,0);
  if b then SetBit(a,0,false) else SetBit(a,0,true);
  czasy.Edit;
  czasystatus.AsInteger:=a;
  czasy.Post;
end;

procedure TForm1.MenuItem39Click(Sender: TObject);
begin
  MenuItem39.Checked:=not MenuItem39.Checked;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  DeleteFilm;
end;

procedure TForm1.MenuItem40Click(Sender: TObject);
begin
  if Menuitem40.Tag=0 then
  begin
    Menuitem40.Tag:=filmyid.AsInteger;
    Menuitem40.Caption:='Pamięć 1 ('+filmynazwa.AsString+')';
  end else begin
    Menuitem40.Tag:=0;
    Menuitem40.Caption:='Pamięć 1';
  end;
  auto_memory[1]:=Menuitem40.Tag;
  Menuitem40.Checked:=Menuitem40.Tag>0;
end;

procedure TForm1.MenuItem41Click(Sender: TObject);
begin
  if Menuitem41.Tag=0 then
  begin
    Menuitem41.Tag:=filmyid.AsInteger;
    Menuitem41.Caption:='Pamięć 2 ('+filmynazwa.AsString+')';
  end else begin
    Menuitem41.Tag:=0;
    Menuitem41.Caption:='Pamięć 2';
  end;
  auto_memory[2]:=Menuitem41.Tag;
  Menuitem41.Checked:=Menuitem41.Tag>0;
end;

procedure TForm1.MenuItem42Click(Sender: TObject);
begin
  if Menuitem42.Tag=0 then
  begin
    Menuitem42.Tag:=filmyid.AsInteger;
    Menuitem42.Caption:='Pamięć 3 ('+filmynazwa.AsString+')';
  end else begin
    Menuitem42.Tag:=0;
    Menuitem42.Caption:='Pamięć 3';
  end;
  auto_memory[3]:=Menuitem42.Tag;
  Menuitem42.Checked:=Menuitem42.Tag>0;
end;

procedure TForm1.MenuItem43Click(Sender: TObject);
begin
  if Menuitem43.Tag=0 then
  begin
    Menuitem43.Tag:=filmyid.AsInteger;
    Menuitem43.Caption:='Pamięć 4 ('+filmynazwa.AsString+')';
  end else begin
    Menuitem43.Tag:=0;
    Menuitem43.Caption:='Pamięć 4';
  end;
  auto_memory[4]:=Menuitem43.Tag;
  Menuitem43.Checked:=Menuitem43.Tag>0;
end;

procedure TForm1.MenuItem44Click(Sender: TObject);
var
  a: integer;
  b: boolean;
begin
  a:=czasystatus.AsInteger;
  b:=ecode.GetBit(a,1);
  if b then SetBit(a,1,false) else SetBit(a,1,true);
  czasy.Edit;
  czasystatus.AsInteger:=a;
  czasy.Post;
end;

procedure TForm1.MenuItem45Click(Sender: TObject);
begin
  Menuitem45.Checked:=not Menuitem45.Checked;
end;

procedure TForm1.MenuItem46Click(Sender: TObject);
begin
  if SelDirPic.Execute then if SaveDialogFilm.Execute then PictureToVideo(SelDirPic.FileName,SaveDialogFilm.FileName,'*.jpg');
end;

procedure TForm1.MenuItem47Click(Sender: TObject);
begin
  if SelDirPic.Execute then if SaveDialogFilm.Execute then PictureToVideo(SelDirPic.FileName,SaveDialogFilm.FileName,'*.png');
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var
  plik: string;
  ss: TStrings;
begin
  if mess.ShowConfirmationYesNo('Czy pobrać dane ze zdalnego serwera?') then
  begin
    ss:=TStringList.Create;
    try
      plik:=MyConfDir('archiwum_www.csv');
      dm.www_odczyt(ss);
      ss.SaveToFile(plik);
    finally
      ss.Free;
    end;
  end else plik:=MyConfDir('archiwum.csv');
  if not mess.ShowConfirmationYesNo('Aktualne pozycje zostaną usunięte, kontynuować?') then exit;
  csv.Tag:=0;
  csv.Filename:=plik;
  csv.Execute;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
const
  NULE = ';[null];[null];[null];[null];[null];[null];[null];[null]';
var
  f: textfile;
  link,plik,nazwa,s,s1,s2,p1,p2: string;
  ss: TStrings;
  i: integer;
  domyslna_polityka_archiwizacji: boolean;
begin
  if filmy.RecordCount=0 then exit;
  domyslna_polityka_archiwizacji:=mess.ShowWarningYesNo('Domyślna polityka archiwizacji','Domyślnie będą archiwizowane rekordy z pominięciem sflagowanych no-archive.^Czy mam zastosować tą domyślną politykę archiwizacji?^^Zauważ, że jeśli wybierzesz NIE - zostaną zarchiwizowane wszystkie rekordy, także te oznaczone flagą no-archive!^^Czy zastosować domyślną politykę?');
  if domyslna_polityka_archiwizacji then
  begin
    dm.roz_id.Tag:=1;
    dm.filmy_id.Tag:=1;
    dm.czasy_id.Tag:=1;
  end else begin
    dm.roz_id.Tag:=2;
    dm.filmy_id.Tag:=2;
    dm.czasy_id.Tag:=2;
  end;
  assignfile(f,MyConfDir('archiwum.csv'));
  rewrite(f);
  dm.roz_id.Open;
  dm.roz_id.First;
  while not dm.roz_id.EOF do
  begin
    s:='R;'+dm.roz_id.FieldByName('id').AsString+';"'+dm.roz_id.FieldByName('nazwa').AsString+'"';
    if dm.roz_id.FieldByName('autosort').IsNull then s1:='0' else s1:=dm.roz_id.FieldByName('autosort').AsString;
    s:=s+';'+s1;
    if dm.roz_id.FieldByName('film_id').IsNull then s1:='[null]' else s1:=dm.roz_id.FieldByName('film_id').AsString;
    s:=s+';'+s1;
    s:=s+';'+dm.roz_id.FieldByName('nomemtime').AsString;
    s:=s+';'+dm.roz_id.FieldByName('noarchive').AsString;
    s:=s+';'+dm.roz_id.FieldByName('novideo').AsString;
    s:=s+';'+dm.roz_id.FieldByName('normalize_audio').AsString;
    s:=s+';"'+dm.roz_id.FieldByName('directory').AsString+'"';
    s:=s+';'+dm.roz_id.FieldByName('autosortdesc').AsString;
    s:=s+';'+dm.roz_id.FieldByName('formatfile').AsString;
    s:=s+';[null];[null];[null];[null];[null];[null];[null];[null];[null];[null];[null]';
    writeln(f,s+NULE);
    dm.roz_id.Next;
  end;
  dm.roz_id.Close;
  dm.filmy_id.Open;
  dm.filmy_id.First;
  while not dm.filmy_id.EOF do
  begin
    if dm.filmy_id.FieldByName('rozdzial').IsNull then p1:='[null]' else p1:=dm.filmy_id.FieldByName('rozdzial').AsString;
    if dm.filmy_id.FieldByName('wzmocnienie').IsNull then s1:='[null]' else if dm.filmy_id.FieldByName('wzmocnienie').AsBoolean then s1:='1' else s1:='0';
    if dm.filmy_id.FieldByName('glosnosc').IsNull then s2:='[null]' else s2:=dm.filmy_id.FieldByName('glosnosc').AsString;
    if dm.filmy_id.FieldByName('plik').IsNull then plik:='[null]' else plik:='"'+dm.filmy_id.FieldByName('plik').AsString+'"';
    if dm.filmy_id.FieldByName('nazwa').IsNull then nazwa:='[null]' else nazwa:='"'+dm.filmy_id.FieldByName('nazwa').AsString+'"';
    if dm.filmy_id.FieldByName('link').IsNull then link:='[null]' else link:='"'+dm.filmy_id.FieldByName('link').AsString+'"';
    s:='F;'+dm.filmy_id.FieldByName('id').AsString+';'+link+';'+plik+';'+p1+';'+nazwa+';'+s1+';'+s2+';'+dm.filmy_id.FieldByName('status').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('osd').AsString+';'+dm.filmy_id.FieldByName('audio').AsString+';'+dm.filmy_id.FieldByName('resample').AsString;
    if dm.filmy_id.FieldByName('audioeq').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('audioeq').AsString+'"';
    if dm.filmy_id.FieldByName('file_audio').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('file_audio').AsString+'"';
    if dm.filmy_id.FieldByName('lang').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('lang').AsString+'"';
    if dm.filmy_id.FieldByName('position').IsNull then s:=s+';[null]' else s:=s+';'+dm.filmy_id.FieldByName('position').AsString;
    if dm.filmy_id.FieldByName('file_subtitle').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('file_subtitle').AsString+'"';
    s:=s+';'+dm.filmy_id.FieldByName('start0').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('transpose').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('predkosc').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('tonacja').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('wsp_czasu_yt').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('wektor_yt_1').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('wektor_yt_2').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('wektor_yt_3').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('wektor_yt_4').AsString;
    writeln(f,s+NULE);
    dm.filmy_id.Next;
  end;
  dm.filmy_id.Close;
  dm.czasy_id.Open;
  while not dm.czasy_id.EOF do
  begin
    if dm.czasy_id.FieldByName('czas_do').IsNull then p1:='0' else p1:=dm.czasy_id.FieldByName('czas_do').AsString;
    if dm.czasy_id.FieldByName('czas2').IsNull then p2:='0' else p2:=dm.czasy_id.FieldByName('czas2').AsString;
    s:='C;'+dm.czasy_id.FieldByName('id').AsString+';'+dm.czasy_id.FieldByName('film').AsString+';"'+dm.czasy_id.FieldByName('nazwa').AsString+'";'+dm.czasy_id.FieldByName('czas_od').AsString+';'+p1+';'+p2+';'+dm.czasy_id.FieldByName('status').AsString;
    if dm.czasy_id.FieldByName('file_audio').IsNull then s:=s+';[null]' else s:=s+';"'+dm.czasy_id.FieldByName('file_audio').AsString+'"';
    if dm.czasy_id.FieldByName('autor').IsNull then s:=s+';[null]' else s:=s+';"'+dm.czasy_id.FieldByName('autor').AsString+'"';
    if dm.czasy_id.FieldByName('mute').IsNull then s:=s+';0' else s:=s+';'+dm.czasy_id.FieldByName('mute').AsString;
    s:=s+';[null];[null];[null];[null];[null];[null]';
    writeln(f,s+NULE);
    dm.czasy_id.Next;
  end;
  dm.czasy_id.Close;
  (* indeksy czasu *)
  for i:=1 to 4 do
  begin
    if mem_lamp[i].active then s1:='1' else s1:='0';
    s:='I;'+IntToStr(i)+';'+s1+';'+IntToStr(mem_lamp[i].rozdzial)+';'+IntToStr(mem_lamp[i].indeks)+';'+IntToStr(mem_lamp[i].indeks_czasu)+';'+FloatToStr(mem_lamp[i].time)+';[null];[null];[null];[null];[null];[null];[null];[null]';
    writeln(f,s+NULE);
  end;
  closefile(f);
  if mess.ShowConfirmationYesNo('Czy wysłać dane także na serwer?') then
  begin
    ss:=TStringList.Create;
    try
      ss.LoadFromFile(MyConfDir('archiwum.csv'));
      if not dm.www_zapis(ss) then mess.ShowError('Dane nie zostały wysłane z powodu błędu.');
    finally
      ss.Free;
    end;
  end;
end;

procedure TForm1.MenuItem62Click(Sender: TObject);
var
  s: string;
begin
  FAEQ:=TFAEQ.Create(self);
  try
    FAEQ.in_out_filtr:=vv_audioeq;
    FAEQ.in_tonacja:=vv_tonacja;
    FAEQ.in_predkosc:=vv_predkosc;
    FAEQ.ShowModal;
    if FAEQ.out_zapisz then
    begin
      s:=FAEQ.in_out_filtr;
      //writeln(s);
      filmy.Edit;
      if s='' then filmyaudioeq.Clear else filmyaudioeq.AsString:=s;
      filmy.Post;
      vv_audioeq:=s;
    end;
  finally
    FAEQ.Free;
  end;
end;

procedure TForm1.MenuItem63Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Zostanie tylko usunięty lokalny plik skojarzony z tym filmem.^Kontunuować?') then
  begin
    DeleteFile(filmyplik.AsString);
    filmy.Edit;
    filmyplik.Clear;
    filmy.Post;
  end;
end;

procedure TForm1.MenuItem65Click(Sender: TObject);
begin
  FPanMusic:=TFPanMusic.Create(self);
  FPanMusic.ShowModal;
end;

procedure TForm1.MenuItem67Click(Sender: TObject);
var
  s: string;
  czas: TTime;
  t: TYoutubeTimer;
begin
  if uELED10.Active then exit;
  s:=InputBox('Konfiguracja zegara','Podaj czas rozpoczęcia programu:','');
  if s<>'' then
  begin
    try
      czas:=StrToTime(s);
      t:=TYoutubeTimer.Create(czas);
    except
      mess.ShowError('Wystąpił błąd - zegar czasu nie został uruchomiony.');
    end;
  end;
end;

procedure TForm1.MenuItem68Click(Sender: TObject);
var
  s,s2: string;
  ss: TStrings;
  i: integer;
  vstatus: integer;
begin
  if not SelectDirectoryDialog1.Execute then exit;
  ss:=TStringList.Create;
  try
    DirectoryPack1.ExecuteFiles(SelectDirectoryDialog1.FileName,'*.avi;*.mkv;*.mp4;*.webm',ss);
    TStringList(ss).Sort;
    dm.trans.StartTransaction;
    for i:=0 to ss.Count-1 do
    begin
      s:=ss[i];
      filmy.Append;
      filmy.FieldByName('nazwa').AsString:=s;
      filmy.FieldByName('link').Clear;
      s2:=SelectDirectoryDialog1.FileName+_FF+s;
      s2:=StringReplace(s2,_FF+_FF,_FF,[rfReplaceAll]);
      filmy.FieldByName('plik').AsString:=s2;
      filmyfile_audio.Clear;
      if db_roz.FieldByName('id').AsInteger=0 then filmy.FieldByName('rozdzial').Clear
      else filmy.FieldByName('rozdzial').AsInteger:=db_roz.FieldByName('id').AsInteger;
      vstatus:=0;
      //SetBit(vstatus,0,FLista.in_out_obrazy);
      filmystatus.AsInteger:=vstatus;
      filmy.Post;
    end;
    dm.trans.Commit;
  finally
    ss.Free;
  end;
end;

procedure TForm1.MenuItem70Click(Sender: TObject);
begin
  MenuItem70.Checked:=not MenuItem70.Checked;
  MenuItem98.Checked:=MenuItem70.Checked;
  db_roz.Edit;
  if MenuItem70.Checked then db_rozautosort.AsInteger:=1 else db_rozautosort.AsInteger:=0;
  db_roz.Post;
  filmy_reopen;
end;

procedure TForm1.MenuItem71Click(Sender: TObject);
var
  a: TFImportDirectoryYoutube;
begin
  a:=TFImportDirectoryYoutube.Create(self);
  a.io_roz:=db_rozid.AsInteger;
  a.Show;
end;

procedure TForm1.MenuItem72Click(Sender: TObject);
begin
  //ffmpeg -i input.mp3 -ss 00:02:54.583 -t 300 -acodec copy output.mp3
  //ffmpeg -i input.mp3 -ss 00:02:54.583 --to 00:04:20.583 -acodec copy output.mp3
  mess.ShowInformation('Opcja przyszłościowa');
end;

procedure TForm1.MenuItem77Click(Sender: TObject);
var
  s: string;
begin
  s:=SetMCMT(Clipboard.AsText);
  if s='' then exit;
  if mplayer.Running then mplayer.Stop;
  CLIPBOARD_PLAY:=true;
  Edit1.Text:=s;
  vv_normalize:=true;
  Play.Click;
end;

procedure TForm1.MenuItem78Click(Sender: TObject);
begin
  MenuItem77.Click;
end;

procedure TForm1.MenuItem79Click(Sender: TObject);
begin
  MenuItem79.Checked:=not MenuItem79.Checked;
end;

procedure TForm1.MenuItem80Click(Sender: TObject);
begin
  zrob_zdjecie(true);
end;

procedure TForm1.MenuItem81Click(Sender: TObject);
var
  s,ext: string;
  b: boolean;
  q,c: integer;
begin
  s:=filmyplik.AsString;
  b:=s<>'';
  if b then b:=FileExists(s);
  ext:=ExtractFileExt(s);
  if ext='.ogg' then
  begin
    mess.ShowInformation('Plik źródłowy jest już plikiem OGG. Przerywam.');
    exit;
  end;
  if b then
  begin
    FConfOGG:=TFConfOGG.Create(self);
    try
      FConfOGG.in_file:=s;
      FConfOGG.init(1);
      FConfOGG.ShowModal;
      b:=FConfOGG.out_ok;
      if b then
      begin
        q:=FConfOGG.out_quality;
        c:=FConfOGG.out_channels;
      end;
    finally
      FConfOGG.Free;
    end;
  end else mess.ShowWarning('Plik źródłowy nie istnieje, przerywam.');
  if b then vcc.RenderOgg(s,c,q);
end;

procedure TForm1.MenuItem82Click(Sender: TObject);
var
  s,ext: string;
  b: boolean;
  c: integer;
begin
  s:=filmyplik.AsString;
  b:=s<>'';
  if b then b:=FileExists(s);
  ext:=ExtractFileExt(s);
  if ext='.wav' then
  begin
    mess.ShowInformation('Plik źródłowy jest już plikiem WAV. Przerywam.');
    exit;
  end;
  if b then
  begin
    FConfOGG:=TFConfOGG.Create(self);
    try
      FConfOGG.in_file:=s;
      FConfOGG.init(0);
      FConfOGG.ShowModal;
      b:=FConfOGG.out_ok;
      if b then c:=FConfOGG.out_channels;
    finally
      FConfOGG.Free;
    end;
  end else mess.ShowWarning('Plik źródłowy nie istnieje, przerywam.');
  if b then vcc.RenderWav(s,c);
end;

procedure TForm1.MenuItem83Click(Sender: TObject);
begin
  AutoGenerateYT2Czasy(Clipboard.AsText);
end;

procedure TForm1.MenuItem86Click(Sender: TObject);
begin
  MenuItem86.Checked:=not MenuItem86.Checked;
  _DEF_GREEN_SCREEN:=MenuItem86.Checked;
  dm.SetConfig('default-green-screen',_DEF_GREEN_SCREEN);
end;

procedure TForm1.MenuItem92Click(Sender: TObject);
begin
  MenuItem92.Visible:=false;
end;

procedure TForm1.MenuItem93Click(Sender: TObject);
var
  s: string;
begin
  s:=SetMCMT(Clipboard.AsText);
  if s='' then exit;
  if mplayer.Running then mplayer.Stop;
  CLIPBOARD_PLAY:=true;
  Edit1.Text:=s;
  Play.Click;
end;

procedure TForm1.miPlayerClick(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    1: miPlayer.Checked:=true;
    2: miRecord.Checked:=true;
    3: miPresentation.Checked:=true;
  end;
  if miPresentation.Checked then zmiana(tryb) else zmiana;
end;

procedure TForm1.mplayerBeforePlay(ASender: TObject; AFilename: string);
var
  s: string;
  a1,a2: boolean;
  online: boolean;
begin
  if _DEF_ENGINE_PLAYER=0 then mplayer.Engine:=meMplayer else mplayer.Engine:=meMPV;
  case _DEF_ACCEL_PLAYER of
     0: mplayer.AccelType:='';
     1: mplayer.AccelType:='libmpv';
     2: mplayer.AccelType:='gpu';
     3: mplayer.AccelType:='vdpau';
     4: mplayer.AccelType:='wlshm';
     5: mplayer.AccelType:='xv';
     6: mplayer.AccelType:='vaapi';
     7: mplayer.AccelType:='x11';
     8: mplayer.AccelType:='null';
     9: mplayer.AccelType:='image';
    10: mplayer.AccelType:='tct';
    11: mplayer.AccelType:='drm';
  end;
  s:=trim(mplayer.Filename);
  a1:=pos('http://',s)=1;
  a2:=pos('https://',s)=1;
  online:=a1 or a2;
  mplayer.VisibleCacheing:=online;
  Label16.Caption:='00:00';
  Label16.Visible:=online;
  pp_cache.Visible:=online;
  if online then
  begin
    uELED20.Active:=true;
    Label12.Visible:=uELED20.Active;
    if (_DEF_ONLINE_CACHE=0) then
    begin
      mplayer.Cache:=_DEF_CACHE;
      mplayer.CacheMin:=_DEF_CACHE_PREINIT;
    end else begin
      mplayer.Cache:=_DEF_ONLINE_CACHE;
      mplayer.CacheMin:=_DEF_ONLINE_CACHE_PREINIT;
    end;
  end else begin
    uELED20.Active:=false;
    Label12.Visible:=uELED20.Active;
    mplayer.Cache:=_DEF_CACHE;
    mplayer.CacheMin:=_DEF_CACHE_PREINIT;
  end;
  if mplayer.Engine=meMplayer then _mplayerBeforePlay(ASender,AFilename) else
  if mplayer.Engine=meMPV then _mpvBeforePlay(ASender,AFilename);
end;

procedure TForm1.mplayerBeforeStop(Sender: TObject);
var
  pom: integer;
  l: integer;
begin
  if EXTFILE_PLAY then exit;
  if CLIPBOARD_PLAY then
  begin
    l:=TimeToInteger(mplayer.GetPositionOnlyRead/SecsPerDay);
    SetMCMT(dm.zloz_adres_youtube(_MPLAYER_CLIPBOARD_MEMORY,l));
    exit;
  end;
  if miPlayer.Checked then
  begin
    if stop_force then l:=TimeToInteger(mplayer.GetPositionOnlyRead/SecsPerDay) else l:=0;
    if l>0 then
    begin
      if _DEF_FULLSCREEN_MEMORY then
      begin
        filmy.Edit;
        filmyposition.AsInteger:=l;
        filmy.Post;
      end else begin
        pom:=filmyid.AsInteger;
        dm.film.ParamByName('id').AsInteger:=indeks_play;
        dm.film.Open;
        dm.film.Edit;
        dm.film.FieldByName('position').AsInteger:=l;
        dm.film.Post;
        dm.film.Close;
        filmy.Refresh;
        filmy.Locate('id',pom,[]);
      end;
    end;
  end;
  _MPLAYER_LOCALTIME:=false;
  timer_obrazy.Enabled:=false;
  SetCursorOnPresentation(false);
  if auto_memory[1]=indeks_play then
  begin
    mem_lamp[1].rozdzial:=indeks_rozd;
    mem_lamp[1].indeks:=indeks_play;
    mem_lamp[1].indeks_czasu:=indeks_czas;
    mem_lamp[1].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[1].active:=true;
    mem_lamp[1].zmiana:=true;
    Memory_1.ImageIndex:=28;
    if _SET_VIEW_SCREEN then FPodglad.Memory_1.ImageIndex:=Memory_1.ImageIndex;
  end else
  if auto_memory[2]=indeks_play then
  begin
    mem_lamp[2].rozdzial:=indeks_rozd;
    mem_lamp[2].indeks:=indeks_play;
    mem_lamp[2].indeks_czasu:=indeks_czas;
    mem_lamp[2].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[2].active:=true;
    mem_lamp[2].zmiana:=true;
    Memory_2.ImageIndex:=30;
    if _SET_VIEW_SCREEN then FPodglad.Memory_2.ImageIndex:=Memory_2.ImageIndex;
  end else
  if auto_memory[3]=indeks_play then
  begin
    mem_lamp[3].rozdzial:=indeks_rozd;
    mem_lamp[3].indeks:=indeks_play;
    mem_lamp[3].indeks_czasu:=indeks_czas;
    mem_lamp[3].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[3].active:=true;
    mem_lamp[3].zmiana:=true;
    Memory_3.ImageIndex:=32;
    if _SET_VIEW_SCREEN then FPodglad.Memory_3.ImageIndex:=Memory_3.ImageIndex;
  end else
  if auto_memory[4]=indeks_play then
  begin
    mem_lamp[4].rozdzial:=indeks_rozd;
    mem_lamp[4].indeks:=indeks_play;
    mem_lamp[4].indeks_czasu:=indeks_czas;
    mem_lamp[4].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[4].active:=true;
    mem_lamp[4].zmiana:=true;
    Memory_4.ImageIndex:=34;
    if _SET_VIEW_SCREEN then FPodglad.Memory_4.ImageIndex:=Memory_4.ImageIndex;
  end;
end;

procedure TForm1.mplayerGrabImage(ASender: TObject; AFilename: String);
var
  res: TResourceStream;
begin
  try
    cenzura:=TMemoryStream.Create;
    res:=TResourceStream.Create(hInstance,'SHUTTER',RT_RCDATA);
    cenzura.LoadFromStream(res);
  finally
    res.Free;
  end;
  UOSPlayer.Volume:=1;
  UOSPlayer.Start(cenzura);
end;

procedure TForm1.mplayerPause(Sender: TObject);
begin
  zapisz(2);
  szumpause;
  Play.ImageIndex:=0;
  if _DEF_PANEL then FPanel.Play.ImageIndex:=Play.ImageIndex;
  //if vv_audio1<>'' then podklad_play(vv_audio1);
end;

procedure TForm1.mplayerPlay(Sender: TObject);
var
  s: string;
begin
  stop_force:=false;
  zapisz(1);
  DBGrid3.Visible:=false;
  Play.ImageIndex:=1;
  DBGrid1.Refresh;
  DBGrid2.Refresh;
  if _SET_VIEW_SCREEN then
  begin
    FPodglad.DBGrid1.Refresh;
    FPodglad.DBGrid2.Refresh;
  end;
  if mplayer.Playing then Play.ImageIndex:=1 else Play.ImageIndex:=0;
  test_play;
  szumplay;
  if miPlayer.Checked then if _DEF_FULLSCREEN_MEMORY then DBGrid3.Visible:=_DEF_FULLSCREEN_MEMORY and (not mplayer.Running);
  cctimer_opt:=0;
end;

procedure TForm1.mplayerPlaying(ASender: TObject; APosition, ADuration: single);
var
  vDurationInt: integer;
  a,b,n: integer;
  aa,bb: TTime;
  bPos,bMax: boolean;
begin
  //writeln(FormatFloat('0.0000',APosition),'/',FormatFloat('0.0000',ADuration));
  if vv_obrazy then mplayer.Pause;
  {kod dotyczy kontrolki "pp"}
  if ADuration=0 then exit;
  vDurationInt:=mplayer.SingleMpToInteger(ADuration);
  if vDurationInt<>vv_duration then UpdateFilmDuration(vDurationInt);
  if (_MPLAYER_FORCESTART0>0) and (APosition>0) and (not _MPLAYER_FORCESTART0_BOOL) then
  begin
    _MPLAYER_FORCESTART0_BOOL:=true;
    mplayer.Position:=mplayer.IntegerToSingleMp(_MPLAYER_FORCESTART0);
    _MPLAYER_FORCESTART0:=0;
    _MPLAYER_FORCESTART0_BOOL:=false;
    exit;
  end;
  aa:=ADuration/SecsPerDay;
  bb:=APosition/SecsPerDay;
  a:=TimeToInteger(aa);
  b:=TimeToInteger(bb);
  pp.Min:=0;
  pp.Max:=a;
  pp.Position:=b;
  bMax:=a<3600000;
  bPos:=b<3600000;
  if bPos then Label3.Caption:=FormatDateTime('nn:ss',przelicz_czas(bb)) else Label3.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(bb));
  if bMax then Label4.Caption:=FormatDateTime('nn:ss',przelicz_czas(aa)) else Label4.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(aa));
  if test_force or ((czas_nastepny>-1) and (czas_nastepny<b)) then test;
  {kod dotyczy kontrolki "oo"}
  if czas_aktualny>-1 then
  begin
    if czas_nastepny=-1 then n:=TimeToInteger(ADuration/SecsPerDay) else n:=czas_nastepny;
    if n-czas_aktualny<=0 then
    begin
      if oo.Position>0 then reset_oo;
      exit;
    end;
    bPos:=b-czas_aktualny<3600000;
    bMax:=n-czas_aktualny<3600000;
    oo.Min:=0; //czas_aktualny;
    oo.Max:=n-czas_aktualny;
    oo.Position:=b-czas_aktualny;
    try
      if bPos then Label5.Caption:=FormatDateTime('nn:ss',przelicz_czas(IntegerToTime(b-czas_aktualny))) else Label5.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(IntegerToTime(b-czas_aktualny)));
      if bMax then Label6.Caption:=FormatDateTime('nn:ss',przelicz_czas(IntegerToTime(n-czas_aktualny))) else Label6.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(IntegerToTime(n-czas_aktualny)));
    except
    end;
  end;
  update_pp_oo;
end;

procedure TForm1.mplayerReplay(Sender: TObject);
begin
  zapisz(3);
  Play.ImageIndex:=1;
  if _DEF_PANEL then FPanel.Play.ImageIndex:=Play.ImageIndex;
  test_force:=true;
  //podklad_pause(vv_audio1);
  szumplay;
end;

procedure TForm1.mplayerSetPosition(Sender: TObject);
begin
  test_force:=true;
  mplayerPlaying(self,mplayer.Position,mplayer.Duration);
  //writeln(TimeToInteger(mplayer.Position/SecsPerDay),'/',TimeToInteger(mplayer.Duration/SecsPerDay));
end;

procedure TForm1.Panel3Resize(Sender: TObject);
begin
  resize_update_grid;
end;

procedure TForm1.PlayCBClick(Sender: TObject);
var
  s: string;
begin
  s:=GetMCMT;
  if s='' then exit;
  if mplayer.Running then mplayer.Stop;
  CLIPBOARD_PLAY:=true;
  Edit1.Text:=s;
  Play.Click;
end;

procedure TForm1.PlayCBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  s: string;
begin
  if Button=mbRight then
  begin
    s:=GetMCMT(true);
    if s='' then exit;
    if mplayer.Running then mplayer.Stop;
    CLIPBOARD_PLAY:=true;
    Edit1.Text:=s;
    Play.Click;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  inidb: TIniFile;
  dbok: boolean;
  b: boolean;
  s: string;
  ss: TStringList;
begin
  shared.Start;
  inidb:=TIniFile.Create(MyConfDir('studio.conf'));
  CUSTOM_DB:=inidb.ReadBool('database','enabled',false);
  if CUSTOM_DB then
  begin
    dm.db.Protocol:=inidb.ReadString('database','protocol','');
    dm.db.HostName:=inidb.ReadString('database','host','');
    dm.db.Database:=inidb.ReadString('database','database','');
    dm.db.ControlsCodePage:=cCP_UTF8;
    dm.db.ClientCodepage:='utf8mb4';
    dm.db.User:=inidb.ReadString('database','user','');
    dm.db.Password:=inidb.ReadString('database','password','');
  end else begin
    inidb.Free;
    halt;
  end;
  inidb.Free;
  cmute:=false;
  upnp.Init;
  dbok:=db_open;
  parametr:='';
  force_deinterlace:=false;
  key_ignore:=TStringList.Create;
  key_ignore.Sorted:=true;
  tak_nie_k:=TStringList.Create;
  tak_nie_v:=TStringList.Create;
  def_pilot:=TStringList.Create;
  def_pilot_values:=TStringList.Create;
  def_pilot1:=TStringList.Create;
  def_pilot1_values:=TStringList.Create;
  def_pilot2:=TStringList.Create;
  def_pilot2_values:=TStringList.Create;
  def_pilot3:=TStringList.Create;
  def_pilot3_values:=TStringList.Create;
  {$IFDEF LINUX}
  mplayer.Engine:=meMPV;
  {$ELSE}
  mplayer.Engine:=meMplayer;
  {$ENDIF}
  b:=UOSEngine.LoadLibrary;
  if not b then
  begin
    ss:=TStringList.Create;
    try
      UOSEngine.DriversLoad:=[dlPortAudio];
      b:=UOSEngine.LoadLibrary;
      if b then UOSEngine.UnLoadLibrary else
      begin
        s:=trim(UOSEngine.GetErrorStr);
        if s<>'' then ss.Add(s);
      end;
      UOSEngine.DriversLoad:=[dlPortAudio,dlSndAudio];
      b:=UOSEngine.LoadLibrary;
      if b then UOSEngine.UnLoadLibrary else
      begin
        s:=trim(UOSEngine.GetErrorStr);
        if s<>'' then ss.Add(s);
      end;
      UOSEngine.DriversLoad:=[dlPortAudio,dlSndAudio,dlMpg123];
      b:=UOSEngine.LoadLibrary;
      if b then UOSEngine.UnLoadLibrary else
      begin
        s:=trim(UOSEngine.GetErrorStr);
        if s<>'' then ss.Add(s);
      end;
      s:=trim(ss.Text);
    finally
      ss.Free;
    end;
    if s<>'' then s:='^^Komunikat błędu:^'+s;
    mess.ShowError('UOS NOT LOADING!','Sterownik UOS nie został załadowany.'+s);
  end;
  mixer.Init;
  auto_memory[1]:=0;
  auto_memory[2]:=0;
  auto_memory[3]:=0;
  auto_memory[4]:=0;
  mem_lamp[1].active:=false;
  mem_lamp[2].active:=false;
  mem_lamp[3].active:=false;
  mem_lamp[4].active:=false;
  lista_wybor:=TStringList.Create;
  klucze_wybor:=TStringList.Create;
  trans_opis:=TStringList.Create;
  trans_film_czasy:=TStringList.Create;
  trans_indeksy:=TStringList.Create;
  canals:=TStringList.Create;
  if dbok then
  begin
    PropStorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
    PropStorage.Active:=true;
    if CUSTOM_DB then dm.schemacustom.init else dm.schemasync.init;
    pilot_wczytaj;
    _DEF_SHUTDOWN_MODE:=dm.GetConfig('default-shutdown-mode',0);
    _DEF_MULTIDESKTOP:=dm.GetConfig('default-multi-desktop','');
    _DEF_MULTIMEDIA_SAVE_DIR:=dm.GetConfig('default-directory-save-files','');
    _DEF_SCREENSHOT_SAVE_DIR:=dm.GetConfig('default-directory-save-files-ss','');
    _DEF_SCREENSHOT_FORMAT:=dm.GetConfig('default-screenshot-format',0);
    _DEF_COOKIES_FILE_YT:=dm.GetConfig('default-cookies-file-yt','');
    _DEF_GREEN_SCREEN:=dm.GetConfig('default-green-screen',false);
    _DEF_VIEW_SCREEN:=dm.GetConfig('default-view-screen',false);
    _DEF_ENGINE_PLAYER:=dm.GetConfig('default-engine-player',0);
    _DEF_CACHE:=dm.GetConfig('default-cache-player',0);
    _DEF_CACHE_PREINIT:=dm.GetConfig('default-cache-preinit-player',0);
    _DEF_ONLINE_CACHE:=dm.GetConfig('default-cache-online-player',0);
    _DEF_ONLINE_CACHE_PREINIT:=dm.GetConfig('default-cache-online-preinit-player',0);
    _DEF_ACCEL_PLAYER:=dm.GetConfig('default-accel-player',0);
    _DEF_AUDIO_DEVICE:=dm.GetConfig('default-audio-device','default');
    _DEF_AUDIO_DEVICE_MONITOR:=dm.GetConfig('default-audio-device-monitor','default');
    audio_device_refresh;
    _DEF_YT_AUTOSELECT:=dm.GetConfig('default-yt-autoselect',false);
    _DEF_YT_AS_QUALITY:=dm.GetConfig('default-yt-autoselect-quality',0);
    _DEF_YT_AS_QUALITY_PLAY:=dm.GetConfig('default-yt-autoselect-quality-play',0);
    Menuitem15.Visible:=_DEV_ON;
    MenuItem86.Checked:=_DEF_GREEN_SCREEN;
    MenuItem102.Checked:=_DEF_VIEW_SCREEN;
    KeyPytanie:='';
  end else _FORCE_CLOSE:=true;
  autorun.Enabled:=true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if _SET_GREEN_SCREEN then
  begin
    FScreen.Free;
    _SET_GREEN_SCREEN:=false;
  end;
  if _SET_VIEW_SCREEN then
  begin
    FPodglad.Free;
    _SET_VIEW_SCREEN:=false;
  end;
  UOSEngine.UnLoadLibrary;
  canals.Free;
  lista_wybor.Free;
  klucze_wybor.Free;
  trans_opis.Free;
  trans_film_czasy.Free;
  trans_indeksy.Free;
  key_ignore.Free;
  tak_nie_k.Free;
  tak_nie_v.Free;
  def_pilot.Free;
  def_pilot_values.Free;
  def_pilot1.Free;
  def_pilot1_values.Free;
  def_pilot2.Free;
  def_pilot2_values.Free;
  def_pilot3.Free;
  def_pilot3_values.Free;
  if _FORCE_SHUTDOWNMODE then cShutdown.execute;
end;

procedure TForm1.ppMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if vv_obrazy then exit;
  if mplayer.Running then
  begin
    pstatus_ignore:=true;
    max:=mplayer.Duration;
    czas:=round(max*X/pp.Width);
    mplayer.Position:=czas;
    pp.Position:=MiliSecToInteger(round(czas*1000));
    aa:=czas/SecsPerDay;
    a:=TimeToInteger(aa);
    bPos:=a<3600000;
    if bPos then Label3.Caption:=FormatDateTime('nn:ss',przelicz_czas(aa)) else Label3.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(aa));
    //test_force:=true;
  end;
end;

procedure TForm1.ppMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if vv_obrazy then exit;
  if mplayer.Running then
  begin
    max:=mplayer.Duration;
    czas:=round(max*X/pp.Width);
    aa:=czas/SecsPerDay;
    a:=TimeToInteger(aa);
    bPos:=a<3600000;
    if bPos then podpowiedz.Caption:=FormatDateTime('nn:ss',przelicz_czas(aa)) else podpowiedz.Caption:=FormatDateTime('h:nn:ss',przelicz_czas(aa));
    podpowiedz.Left:=X+pp.Left-round(podpowiedz.Width/2);
    podpowiedz.Visible:=true;
    pp_mouse.Enabled:=false;
    pp_mouse.Enabled:=true;
  end;
end;

procedure TForm1.pp_mouseStartTimer(Sender: TObject);
begin
  podpowiedz.Visible:=true;
end;

procedure TForm1.pp_mouseTimer(Sender: TObject);
begin
  pp_mouse.Enabled:=false;
  podpowiedz.Visible:=false;
end;

procedure TForm1.PresentationClick(aButton: integer; var aTestDblClick: boolean);
begin
  if miPlayer.Checked then
  begin
    {tryb zmiany rozdziałów}
    if cRozdzialy.Visible then
    begin
      case aButton of
          1: menu_rozdzialy(false);
          2: db_roz.Prior;
          3: db_roz.Next;
        4,5: menu_rozdzialy(false);
      end;
    end else
    {specjalny tryb odtwarzania filmów}
    if fmenu.IsManual then
    begin
      case aButton of
          1: fmenu.Click;
          2: fmenu.Prior;
          3: fmenu.Next;
        4,5: fmenu.Cancel;
      end;
    end else
    if mplayer.Running then
    begin
      case aButton of
        4,5: begin stop_force:=true; mplayer.Stop; end;
      end;
    end else begin
      case aButton of
          1: if fmenu.Active then fmenu.Click else if filmyposition.IsNull or (filmyposition.AsInteger=0) or (not _DEF_FULLSCREEN_MEMORY) then DBGrid1DblClick(self) else fmenu.Execute(0);
          2: filmy.Prior;
          3: filmy.Next;
        4,5: begin
               if _DEF_FULLSCREEN_MEMORY then //Uwaga: Sprawdzam historycznie przed zmianą!
               begin
                 if fmenu.Active then fmenu.Click else fmenu.Execute(1,fmManual);
               end else begin
                 _DEF_FULLSCREEN_MEMORY:=true;
                 UpdateFilmToRoz(true);
                 go_fullscreen;
               end;
             end;
      end;
    end;
  end;
end;

procedure TForm1.PropStorageRestoringProperties(Sender: TObject);
begin
  filmy.Tag:=PropStorage.ReadInteger('global_sort_tag',211);
  tab_lamp_odczyt;
end;

procedure TForm1.PropStorageSavingProperties(Sender: TObject);
begin
  PropStorage.ReadInteger('global_sort_tag',filmy.Tag);
  tab_lamp_zapisz;
end;

procedure TForm1.restart_csvTimer(Sender: TObject);
var
  b: boolean;
  i: integer;
begin
  restart_csv.Enabled:=false;
  if lista_wybor.Count>0 then
  begin
    FLista_wyboru:=TFLista_wyboru.Create(self);
    try
      FLista_wyboru.CheckListBox1.Items.Assign(lista_wybor);
      FLista_wyboru.klucze_wyboru.Assign(klucze_wybor);
      FLista_wyboru.ShowModal;
      if FLista_wyboru.out_ok then
      begin
        lista_wybor.Clear;
        klucze_wybor.Clear;
        for i:=0 to FLista_wyboru.CheckListBox1.Items.Count-1 do
        begin
          if FLista_wyboru.CheckListBox1.Checked[i] then
          begin
            lista_wybor.Add(FLista_wyboru.CheckListBox1.Items[i]);
            klucze_wybor.Add(FLista_wyboru.klucze_wyboru[i]);
          end;
          b:=klucze_wybor.Count>0;
        end;
      end else b:=false;
    finally
      FLista_wyboru.Free;
    end;
    if b then
    begin
      csv.Tag:=csv.Tag+1;
      csv.Execute;
    end;
  end;
end;

procedure TForm1.RewindClick(Sender: TObject);
begin
  mplayer.Position:=0;
  pp.Position:=0;
  pp_cache.Position:=0;
  Label16.Caption:='00:00';
  Label3.Caption:=FormatDateTime('nn:ss',0);
  test_force:=true;
  update_pp_oo;
end;

procedure TForm1.BExitClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.rfilmyTimer(Sender: TObject);
var
  id: integer;
begin
  rfilmy.Enabled:=false;
  id:=filmyid.AsInteger;
  try
    filmy.DisableControls;
    filmy.Refresh;
    filmy.Locate('id',id,[]);
  finally
    filmy.EnableControls;
  end;
end;

procedure TForm1.sharedMessage(Sender: TObject; AMessage: string);
begin
  if AMessage='{PILOT1}' then
  begin
    application.BringToFront;
    if npilot.Active then npilot.SendString('pilot=active');
    Presentation.ExecuteEx(1);
  end else
  if AMessage='{PILOT2}' then Presentation.ExecuteEx(2) else
  if AMessage='{PILOT3}' then Presentation.ExecuteEx(3) else
  if AMessage='{PILOT4}' then pilot_wykonaj('sygnal_front') else
  if AMessage='{PILOT5}' then pilot_wykonaj('sygnal_front');
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  pop_roz.PopUp;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
var
  s: string;
  www: boolean;
  //IIDL: PItemIDList;
begin
  if mplayer.Running then
  begin
    s:=trim(vv_link);
    if s='' then s:=trim(vv_plik);
  end else begin
    s:=trim(filmylink.AsString);
    if s='' then s:=trim(filmyplik.AsString);
  end;
  if s='' then exit;
  www:=(pos('http://',s)=1) or (pos('https://',s)=1);
  if www then OpenUrl(s) else OpenDocument(s);
  {if www then OpenUrl(s) else
  begin
    //OpenDocument(ExtractFilePath(s));
    IIDL:=ILCreateFromPath(PChar(s));
    if IIDL<>nil then
    try
      SHOpenFolderAndSelectItems(IIDL,0,nil,0);
    finally
      ILFree(IIDL);
    end;
  end;}
end;

procedure TForm1.StopClick(Sender: TObject);
begin
  stop_force:=true;
  if mplayer.Playing or mplayer.Paused then mplayer.Stop;
end;

procedure TForm1.tAutorStartTimer(Sender: TObject);
begin
  sleep(1000);
  film_autor:='';
  Presentation.SendKey(ord('N'));
end;

procedure TForm1.tAutorStopTimer(Sender: TObject);
begin
  Presentation.SendKey(ord('M'));
end;

procedure TForm1.tAutorTimer(Sender: TObject);
begin
  tAutor.Enabled:=false;
end;

procedure TForm1.tbkStopTimer(Sender: TObject);
begin
  _BLOCK_MUSIC_KEYS:=false;
end;

procedure TForm1.tbkTimer(Sender: TObject);
begin
  tbk.Enabled:=false;
end;

procedure TForm1.tcpProcessMessage;
begin
  Application.ProcessMessages;
end;

procedure TForm1.test_czasBeforeOpen(DataSet: TDataSet);
begin
  test_czas.ParamByName('id').AsInteger:=indeks_play;
end;

procedure TForm1.tObsOffTimerTimer(Sender: TObject);
begin
  dec(local_obs_off_timer);
  Label13.Caption:=IntToStr(local_obs_off_timer);
  if local_obs_off_timer=0 then
  begin
    tObsOffTimer.Enabled:=false;
    if komenda_nr_2<>'' then wykonaj_komende(komenda_nr_2);
  end;
end;

procedure TForm1.Timer2StartTimer(Sender: TObject);
begin
  uELED19.Active:=true;
  MenuItem119.Checked:=true;
  www1:=trim(clipbrd.Clipboard.AsText);
  www2:=www1;
end;

procedure TForm1.Timer2StopTimer(Sender: TObject);
begin
  uELED19.Active:=false;
  MenuItem119.Checked:=false;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  www1:=trim(clipbrd.Clipboard.AsText);
  if www1='' then exit;
  if www1<>www2 then
  begin
    www2:=www1;
    if pos('http',www2)=1 then
    begin
      Timer2.Enabled:=false;
      dodaj_film(www2);
      Timer2.Enabled:=true;
    end;
  end;
end;

procedure TForm1.timer_info_tasmyTimer(Sender: TObject);
begin
  timer_info_tasmy.Enabled:=false;
end;

procedure TForm1.timer_obrazyTimer(Sender: TObject);
begin
  if mplayer.Duration>0 then
  begin
    timer_obrazy.Enabled:=false;
    mplayerPlaying(self,mplayer.Position,mplayer.Duration);
  end;
end;

var
  wewn_1: integer;

procedure TForm1.tPytanieStartTimer(Sender: TObject);
begin
  wewn_1:=0;
end;

procedure TForm1.tPytanieStopTimer(Sender: TObject);
begin
  wewn_1:=0;
  uELED12.Active:=false;
end;

procedure TForm1.tPytanieTimer(Sender: TObject);
begin
  inc(wewn_1);
  if wewn_1>200 then wewn_1:=0;
  if wewn_1=5 then uELED12.Active:=true else
  if wewn_1=10 then uELED12.Active:=false else
  if wewn_1=15 then uELED12.Active:=true else
  if wewn_1=20 then uELED12.Active:=false else
  if wewn_1=25 then uELED12.Active:=true else
  if wewn_1=30 then uELED12.Active:=false;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  if not _DEF_PANEL then
  begin
    FPanel:=TFPanel.Create(self);
    FPanel.Show;
  end else begin
    FPanel.Close;
  end;
end;

procedure TForm1.tzegarTimer(Sender: TObject);
var
  t: TDateTime;
  h,m,s,ms: word;
  f: textfile;
begin
  t:=now;
  DecodeTime(t,h,m,s,ms);
  if ((s=0) and ((_C_DATETIME[1]<>h) or (_C_DATETIME[2]<>m) or (_C_DATETIME[3]<>s))) or (_C_DATETIME[1]=-1) then
  begin
    _C_DATETIME[1]:=h;
    _C_DATETIME[2]:=m;
    _C_DATETIME[3]:=s;
    assignfile(f,'/home/tao/czas.txt');
    rewrite(f);
    writeln(f,FormatDateTime('hh:nn',t));
    closefile(f);
  end;
end;

procedure TForm1.uEKnob1Change(Sender: TObject);
begin
  mplayer.Volume:=round(uEKnob1.Position)-indeks_def_volume;
end;

procedure TForm1.uEKnob1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then uEKnob1.Position:=100;
end;

procedure TForm1.uELED1Click(Sender: TObject);
begin
  zmiana(1);
end;

procedure TForm1.uELED2Click(Sender: TObject);
begin
  zmiana(2);
end;

procedure TForm1.uELED3Click(Sender: TObject);
begin
  if not npilot.Active then npilot.Connect else if uELED4.Color=clRed then npilot.SendString('pilot=active');
end;

procedure TForm1.vccFileRendered(aId: integer; aSourceFileName,
  aDestinationFileName: string);
begin
  if aId>0 then
  begin
    (* podmieniam pliki i kasuję stary *)
    dm.film.ParamByName('id').AsInteger:=aId;
    dm.film.Open;
    dm.film.Edit;
    dm.film.FieldByName('plik').AsString:=aDestinationFileName;
    dm.film.Post;
    dm.film.Close;
    DeleteFile(aSourceFileName);
    Form1.rfilmy.Enabled:=true;
  end;
end;

procedure TForm1.vccThreadsCount(aCount: integer);
begin
  uELED4.Active:=aCount>0;
  Label9.Visible:=aCount>0;
  Label9.Caption:=IntToStr(aCount);
end;

procedure TForm1.youtubeDlFinish(aLink, aFileName, aDir: string; aTag: integer);
var
  id2,format,c: integer;
begin
  dm.film.ParamByName('id').AsInteger:=aTag;
  dm.film.Open;
  id2:=dm.film.FieldByName('rozdzial').AsInteger;
  dm.film.Edit;
  dm.film.FieldByName('plik').AsString:=aDir+_FF+aFileName;
  dm.film.Post;
  dm.film.Close;
  ReadRoz.ParamByName('id').AsInteger:=id2;
  ReadRoz.Open;
  format:=ReadRozformatfile.AsInteger;
  ReadRoz.Close;
  if id2>0 then if (format>0) and (format<13) then vcc.RenderOgg(aTag,aDir+_FF+aFileName,0,format-2) else
  if (format>12) and (format<25) then vcc.RenderOgg(aTag,aDir+_FF+aFileName,2,format-14) else
  if format>24 then vcc.RenderOgg(aTag,aDir+_FF+aFileName,1,format-26);
  Form1.rfilmy.Enabled:=true;
end;

procedure TForm1.youtubeDlPosition(aPosition: integer; aSpeed: int64;
  aTag: integer);
begin
  ProgressBar1.Position:=aPosition;
  Label10.Caption:=NormalizeB('0.00',aSpeed)+'/s';
end;

procedure TForm1.youtubeStart(Sender: TObject);
begin
  ProgressBar1.Position:=0;
  ProgressBar1.Visible:=true;
  Label10.Caption:='0.00 B/s';
  Label10.Visible:=true;
end;

procedure TForm1.youtubeStop(Sender: TObject);
begin
  ProgressBar1.Visible:=false;
  Label10.Visible:=false;
end;

procedure TForm1._AUDIOMENU(Sender: TObject);
begin
  case TMenuitem(Sender).Tag of
    0: Menuitem54.Checked:=true;
    1: Menuitem55.Checked:=true;
    2: Menuitem56.Checked:=true;
  end;
  if mplayer.Running then
  begin
    case TMenuitem(Sender).Tag of
      0: mplayer.SetChannels(0);
      1: mplayer.SetChannels(1);
      2: mplayer.SetChannels(2);
    end;
  end;
end;

procedure TForm1._OPEN_CLOSE(DataSet: TDataSet);
begin
  if DataSet.Active then UstawPodgladSortowania;
  czasy.Active:=DataSet.Active;
end;

procedure TForm1._OPEN_CLOSE_TEST(DataSet: TDataSet);
begin
  test_czas2.Active:=DataSet.Active;
  test_czas22.Active:=DataSet.Active;
end;

procedure TForm1._OSDMENU(Sender: TObject);
begin
  case TMenuitem(Sender).Tag of
    0: Menuitem49.Checked:=true;
    1: Menuitem50.Checked:=true;
    2: Menuitem51.Checked:=true;
    3: Menuitem52.Checked:=true;
  end;
  if mplayer.Running then
  begin
    //_MPLAYER_LOCALTIME:=TMenuitem(Sender).Tag>0;
    mplayer.SetOSDLevel(TMenuitem(Sender).Tag);
  end;
end;

procedure TForm1._PLAY_MEMORY(Sender: TObject);
begin
  play_memory(TSpeedButton(Sender).Tag);
end;

procedure TForm1._ROZ_OPEN_CLOSE(DataSet: TDataSet);
begin
  filmy.Active:=DataSet.Active;
end;

procedure TForm1._SAMPLERATEMENU(Sender: TObject);
begin
  case TMenuitem(Sender).Tag of
    0: Menuitem57.Checked:=true;
    1: Menuitem58.Checked:=true;
    2: Menuitem59.Checked:=true;
    3: Menuitem60.Checked:=true;
    4: Menuitem61.Checked:=true;
  end;
  if mplayer.Running then
  begin
    case TMenuitem(Sender).Tag of
      0: mplayer.SetAudioSamplerate(0);
      1: mplayer.SetAudioSamplerate(11525);
      2: mplayer.SetAudioSamplerate(22050);
      3: mplayer.SetAudioSamplerate(44100);
      4: mplayer.SetAudioSamplerate(48000);
    end;
  end;
end;

procedure TForm1.AutoGenerateYT2Czasy(aList: string);
var
  ss: TStringList;
  s,s1,s2,pom: string;
  i,a: integer;
  h,m,sec,mi: word;
begin
  if filmynotatki.IsNull then exit;
  ss:=TStringList.Create;
  try
    ss.AddText(aList);
    for i:=0 to ss.Count-0 do
    begin
      try
        s:=ss[i];
      except
        continue;
      end;
      if trim(s)='' then continue;
      s1:=GetLineToStr(s,1,' ');
      s2:=s;
      a:=pos(' ',s2);
      if a>0 then delete(s2,1,a);
      s2:=trim(s2);
      try
        h:=0;
        m:=0;
        sec:=0;
        mi:=0;
        pom:=GetLineToStr(s1,1,':');
        if pom<>'' then m:=StrToInt(pom); //minuty
        pom:=GetLineToStr(s1,2,':');
        if pom<>'' then sec:=StrToInt(pom); //sekundy
        pom:=GetLineToStr(s1,3,':');
        if pom<>'' then //przesuwam o poziom wyżej i dodaję sekundy
        begin
          h:=m;
          m:=sec;
          sec:=StrToInt(pom);
        end;
        a:=TimeToInteger(h,m,sec,mi);
        dodaj_czas(filmyid.AsInteger,a,s2);
      except
      end;
    end;
  finally
    ss.Free;
  end;
end;

procedure TForm1.pilot_wczytaj;
var
  a: integer;
  s: string;
begin
  def_pilot.Clear;
  def_pilot_values.Clear;
  def_pilot1.Clear;
  def_pilot1_values.Clear;
  def_pilot2.Clear;
  def_pilot2_values.Clear;
  def_pilot3.Clear;
  def_pilot3_values.Clear;
  dm.dbpilot.Open;
  while not dm.dbpilot.EOF do
  begin
    s:=dm.dbpilotvalue.AsString+';'+dm.dbpilotexec.AsString+';'+dm.dbpilotexec2.AsString+';'+dm.dbpilotdelay.AsString;
    a:=dm.dbpilotlevel.AsInteger;
    if a=0 then
    begin
      def_pilot.Add(dm.dbpilotcode.AsString);
      def_pilot_values.Add(s);
    end else
    if a=1 then
    begin
      def_pilot1.Add(dm.dbpilotcode.AsString);
      def_pilot1_values.Add(s);
    end else
    if a=2 then
    begin
      def_pilot2.Add(dm.dbpilotcode.AsString);
      def_pilot2_values.Add(s);
    end else
    if a=3 then
    begin
      def_pilot3.Add(dm.dbpilotcode.AsString);
      def_pilot3_values.Add(s);
    end;
    dm.dbpilot.Next;
  end;
  dm.dbpilot.Close;
  (* ALIASY *)
  dm.dbpilot2.Open;
  while not dm.dbpilot2.EOF do
  begin
    s:=dm.dbpilot2value.AsString+';'+dm.dbpilot2exec.AsString+';'+dm.dbpilot2exec2.AsString+';'+dm.dbpilot2delay.AsString;
    a:=dm.dbpilot2level.AsInteger;
    if a=0 then
    begin
      def_pilot.Add(dm.dbpilot2code.AsString);
      def_pilot_values.Add(s);
    end else
    if a=1 then
    begin
      def_pilot1.Add(dm.dbpilot2code.AsString);
      def_pilot1_values.Add(s);
    end else
    if a=2 then
    begin
      def_pilot2.Add(dm.dbpilot2code.AsString);
      def_pilot2_values.Add(s);
    end else
    if a=3 then
    begin
      def_pilot3.Add(dm.dbpilot2code.AsString);
      def_pilot3_values.Add(s);
    end;
    dm.dbpilot2.Next;
  end;
  dm.dbpilot2.Close;
end;

procedure TForm1.pilot_wykonaj(aCode: string);
var
  ss1,ss2: TStringList;
  s,v,v2: string;
  i,a,opoznienie: integer;
begin
  if ComboBox1.ItemIndex=0 then
  begin
    ss1:=def_pilot;
    ss2:=def_pilot_values;
  end else
  if ComboBox1.ItemIndex=1 then
  begin
    ss1:=def_pilot1;
    ss2:=def_pilot1_values;
  end else
  if ComboBox1.ItemIndex=2 then
  begin
    if tryb=1 then
    begin
      ss1:=def_pilot2;
      ss2:=def_pilot2_values;
    end else begin
      ss1:=def_pilot3;
      ss2:=def_pilot3_values;
    end;
  end;
  for i:=0 to ss1.Count-1 do
  begin
    if ss1[i]=aCode then
    begin
      s:=ss2[i];
      a:=StrToInt(GetLineToStr(s,1,';'));
      v:=GetLineToStr(s,2,';');
      v2:=GetLineToStr(s,3,';');
      try opoznienie:=StrToInt(GetLineToStr(s,4,';')) except opoznienie:=0 end;
      if a>0 then pilot_wykonaj(a,aCode,opoznienie);
      if v<>'' then wykonaj_komende(v);
      if v2<>'' then komenda_nr_2:=v2;
    end;
  end;
end;

procedure TForm1.pilot_wykonaj(aCode: integer; aButton: string;
  aOpoznienie: integer);
begin
  case aCode of
     1: zmiana(1);
     2: zmiana(2);
     3: if tryb=1 then zmiana(2) else zmiana(1);
     4: begin zmiana(1); pplay(0); end;
     5: begin zmiana(2); pplay(0); end;
     6: begin ppause(0); zmiana(1); end;
     7: begin ppause(0); zmiana(2); end;
     8: pplay(0);
     9: ppause(0);
    10: if mplayer.Running then playpause;
    11: if mplayer.Running then obraz_next;
    12: if mplayer.Running then obraz_prior;
    13: if mplayer.Running then if vv_obrazy then obraz_next else pplay(0);
    14: if mplayer.Running then if vv_obrazy then obraz_prior else pplay(0);
    15: if mplayer.Running then if vv_obrazy then obraz_next else ppause(0);
    16: if mplayer.Running then if vv_obrazy then obraz_prior else ppause(0);
    17: if mplayer.Running then if vv_obrazy then obraz_next else playpause;
    18: if mplayer.Running then if vv_obrazy then obraz_prior else playpause;
    19: if mplayer.Running then mplayer.Stop;
    20: begin
          shared.SendMessage('{PILOT4}');
        end;
    21: if mplayer.Running then zapisz_indeks_czasu(1);
    22: if mplayer.Running then zapisz_indeks_czasu(2);
    23: Presentation.ExecuteEx(1);
    24: Presentation.ExecuteEx(2);
    25: Presentation.ExecuteEx(3);
    26: Presentation.ExecuteEx(4);
    27: zglosnij10;
    28: scisz10;
    29: PlayMute;
    30: begin MenuItem10.Click; go_beep; end;
    31: begin zablokuj_aktualny_i_dodaj_pozycje_na_koniec_listy; go_beep; end;
    32: mplayer.Position:=mplayer.Position-4;
    33: mplayer.Position:=mplayer.Position+4;
    34: begin
          _MPLAYER_LOCALTIME:=not _MPLAYER_LOCALTIME;
          if _MPLAYER_LOCALTIME then mplayer.SetOSDLevel(3) else mplayer.SetOSDLevel(0);
        end;
    35: zaswiec_kamerke(0);
    36: zaswiec_kamerke(1);
    37: zaswiec_kamerke(2);
    38: begin
          application.BringToFront;
          if npilot.Active then npilot.SendString('pilot=active');
        end;
    39: begin
          local_delay_timer_opoznienie:=aOpoznienie;
          tObsOffTimer.Enabled:=true;
        end;
    40: begin
          shared.SendMessage('{PILOT4};CLEAR');
        end;
    41: begin
          czasy_edycja_188;
          go_beep;
        end;
  end;
end;

procedure TForm1.zaswiec_kamerke(aCam: integer);
begin
  if not _SET_LAMP_FORMS then exit;
  if aCam=1 then
  begin
    FLamp1.uELED1.Active:=true;
    FLamp2.uELED1.Active:=false;
  end else
  if aCam=2 then
  begin
    FLamp1.uELED1.Active:=false;
    FLamp2.uELED1.Active:=true;
  end else begin
    FLamp1.uELED1.Active:=false;
    FLamp2.uELED1.Active:=false;
  end;
end;

procedure TForm1.filmy_reopen;
begin
  filmy.Close;
  filmy.Open;
end;

procedure TForm1.zapisz(komenda: integer);
var
  a,b: integer;
  s: string;
begin
  if precord then
  begin
    a:=LiveTimer.GetIndexTime;
    if mplayer.Playing or mplayer.Paused then b:=TimeToInteger(mplayer.GetPositionOnlyRead/SecsPerDay) else b:=-1;
    case komenda of
      0: s:='STOP';
      1: s:='PLAY';
      2: s:='PAUSE';
      3: s:='REPLAY';
    end;
    dm.zapis_add.ParamByName('czas').AsInteger:=a;
    dm.zapis_add.ParamByName('indeks').AsInteger:=b;
    dm.zapis_add.ParamByName('komenda').AsInteger:=komenda;
    dm.zapis_add.ParamByName('opis').AsString:=s;
    dm.zapis_add.ExecSQL;
  end;
end;

procedure TForm1.play_alarm;
var
  res: TResourceStream;
begin
  if miPresentation.Checked then
  begin
    if MenuItem92.Visible then exit;
    try
      mem_alarm:=TMemoryStream.Create;
      res:=TResourceStream.Create(hInstance,'ALARM',RT_RCDATA);
      mem_alarm.LoadFromStream(res);
    finally
      res.Free;
    end;
    if UOSalarm.Busy then UOSalarm.Stop;
    UOSAlarm.Start(mem_alarm);
    MenuItem92.Visible:=true;
  end;
end;

procedure TForm1.TextToScreen(aString: string; aLength, aRows: integer;
  var aText: TStrings);
var
  i,a: integer;
  s,s1: string;
begin
  s:=trim(aString);
  aText.Clear;
  while length(s)>0 do
  begin
    s1:=copy(s,1,81);
    for i:=81 downto 1 do
    begin
      if s1[i]=' ' then
      begin
        a:=i;
        break;
      end;
    end;
    s1:=trim(copy(s,1,a));
    aText.Add(s1);
    delete(s,1,a-1);
    s:=trim(s);
  end;
  for i:=5 downto aText.Count do aText.Insert(0,'');
end;

procedure TForm1.ComputerOff;
begin
  (* Opuść tryb pełnoekranowy *)
  _DEF_FULLSCREEN_MEMORY:=false;
  UpdateFilmToRoz;
  go_fullscreen(true);
  application.ProcessMessages;
  (* wyślij komendę i zamknij program *)
  _FORCE_SHUTDOWNMODE:=true;
  close;
end;

procedure TForm1.szumload(aNo: integer);
var
  res: TResourceStream;
begin
  if miPresentation.Checked then
  begin
    try
      szum:=TMemoryStream.Create;
      res:=TResourceStream.Create(hInstance,'SZUM',RT_RCDATA);
      szum.LoadFromStream(res);
    finally
      res.Free;
    end;
    UOSszum.Volume:=0.2;
    UOSszum.Start(szum);
  end;
end;

procedure TForm1.szumplay;
begin
  if not miPresentation.Checked then exit;
  if not vv_szum then exit;
  if not UOSszum.Busy then
  begin
    szumload;
    exit;
  end;
  if UOSszum.Pausing then UOSszum.Replay;
end;

procedure TForm1.szumpause;
begin
  if not UOSszum.Busy then exit;
  if UOSszum.Pausing then exit;
  UOSszum.Pause;
end;

procedure TForm1.tab_lamp_zapisz(aNr: integer);
var
  a1,a2: integer;
  i: integer;
begin
  if aNr=0 then
  begin
    a1:=1;
    a2:=4;
  end else begin
    a1:=aNr;
    a2:=aNr;
  end;
  for i:=a1 to a2 do
  begin
    if mem_lamp[i].zmiana then
    begin
      PropStorage.WriteBoolean('lamp'+IntToStr(i)+'_active',mem_lamp[i].active);
      PropStorage.WriteInteger('lamp'+IntToStr(i)+'_rozdzial',mem_lamp[i].rozdzial);
      PropStorage.WriteInteger('lamp'+IntToStr(i)+'_indeks',mem_lamp[i].indeks);
      PropStorage.WriteInteger('lamp'+IntToStr(i)+'_czas',mem_lamp[i].indeks_czasu);
      PropStorage.WriteString('lamp'+IntToStr(i)+'_time',FloatToStr(mem_lamp[i].time));
    end;
  end;
end;

procedure TForm1.tab_lamp_odczyt(aOnlyRefreshLamp: boolean);
var
  i: integer;
begin
  if not aOnlyRefreshLamp then
  begin
    for i:=1 to 4 do
    begin
      mem_lamp[i].active:=PropStorage.ReadBoolean('lamp'+IntToStr(i)+'_active',false);
      mem_lamp[i].rozdzial:=PropStorage.ReadInteger('lamp'+IntToStr(i)+'_rozdzial',0);
      mem_lamp[i].indeks:=PropStorage.ReadInteger('lamp'+IntToStr(i)+'_indeks',0);
      mem_lamp[i].indeks_czasu:=PropStorage.ReadInteger('lamp'+IntToStr(i)+'_czas',0);
      mem_lamp[i].time:=StrToFloat(PropStorage.ReadString('lamp'+IntToStr(i)+'_time','0'));
      mem_lamp[i].zmiana:=false;
    end;
  end;
  if mem_lamp[1].active then Memory_1.ImageIndex:=28 else Memory_1.ImageIndex:=27;
  if mem_lamp[2].active then Memory_2.ImageIndex:=30 else Memory_2.ImageIndex:=29;
  if mem_lamp[3].active then Memory_3.ImageIndex:=32 else Memory_3.ImageIndex:=31;
  if mem_lamp[4].active then Memory_4.ImageIndex:=34 else Memory_4.ImageIndex:=33;
  if _SET_VIEW_SCREEN then
  begin
    FPodglad.Memory_1.ImageIndex:=Memory_1.ImageIndex;
    FPodglad.Memory_2.ImageIndex:=Memory_2.ImageIndex;
    FPodglad.Memory_3.ImageIndex:=Memory_3.ImageIndex;
    FPodglad.Memory_4.ImageIndex:=Memory_4.ImageIndex;
  end;
end;

procedure TForm1.dodaj_pozycje_na_koniec_listy(aSkopiujTemat: boolean);
var
  s: string;
  a: integer;
begin
  if aSkopiujTemat then
  begin
    czasy_notnull.Open;
    s:=czasynazwa.AsString;
    czasy_notnull.Close;
    if s='' then s:='..';
  end else s:='';
  a:=MiliSecToInteger(Round(mplayer.GetPositionOnlyRead*1000));
  if vv_obrazy then
  begin
    dec(a,10);
    if a<0 then a:=0;
  end;
  dodaj_czas(filmy.FieldByName('id').AsInteger,a,s);
end;

procedure TForm1.zablokuj_aktualny_i_dodaj_pozycje_na_koniec_listy(
  aSkopiujTemat: boolean);
var
  a: integer;
  b: boolean;
begin
  a:=czasystatus.AsInteger;
  b:=ecode.GetBit(a,0);
  SetBit(a,0,true);
  czasy.Last;
  czasy.Edit;
  czasystatus.AsInteger:=a;
  czasy.Post;
  dodaj_pozycje_na_koniec_listy(aSkopiujTemat);
end;

procedure TForm1.DeleteFilm(aDB: boolean; aFile: boolean; aBezPytan: boolean);
var
  b: boolean;
  id,i: integer;
  link,plik: string;
  vobrazy: boolean;
begin
  if filmy.RecordCount=0 then exit;

  id:=filmy.FieldByName('id').AsInteger;
  if filmylink.IsNull then link:='' else link:=filmylink.AsString;
  plik:=filmy.FieldByName('plik').AsString;
  vobrazy:=GetBit(filmystatus.AsInteger,0);

  if aDB then
  begin
    b:=Menuitem45.Checked or aBezPytan;
    if not b then b:=mess.ShowConfirmationYesNo('Czy usunąć pozycję z listy filmów?');
    if b then
    begin
      for i:=1 to 4 do if mem_lamp[i].active and (mem_lamp[i].indeks=id) then
      begin
        mem_lamp[i].active:=false;
        case i of
          1: Memory_1.ImageIndex:=27;
          2: Memory_2.ImageIndex:=29;
          3: Memory_3.ImageIndex:=31;
          4: Memory_4.ImageIndex:=33;
        end;
        if _SET_VIEW_SCREEN then
        begin
          case i of
            1: FPodglad.Memory_1.ImageIndex:=Memory_1.ImageIndex;
            2: FPodglad.Memory_2.ImageIndex:=Memory_2.ImageIndex;
            3: FPodglad.Memory_3.ImageIndex:=Memory_3.ImageIndex;
            4: FPodglad.Memory_4.ImageIndex:=Memory_4.ImageIndex;
          end;
        end;
      end;
      stop_force:=true;
      if id=indeks_play then mplayer.Stop;
      filmy.Delete;
    end;
  end;

  if aFile then
  begin
    if (vobrazy or (link<>'')) and (plik<>'') and FileExists(plik) then
    begin
      b:=aBezPytan;
      if not b then b:=mess.ShowConfirmationYesNo('Znaleziono plik na dysku do którego odnosiła się ta pozycja, czy chcesz także usunąć plik z dysku?');
      if b then DeleteFile(plik);
    end;
  end;
end;

procedure TForm1.sciagnij_film(aDownloadAll: boolean);
var
  t: TBookmark;
  dir: string;
  cc: string;
begin
  if filmy.IsEmpty then exit;
  dir:=dm.GetConfig('default-directory-save-files','');

  if aDownloadAll then
  begin
    filmy.DisableControls;
    t:=filmy.GetBookmark;
    filmy.First;
    while not filmy.EOF do
    begin
      if filmyc_plik_exist.AsBoolean then
      begin
        filmy.Next;
        continue;
      end;
      youtube.AddLink(filmylink.AsString,dir,0,0,filmyid.AsInteger);
      filmy.Next;
    end;
    filmy.GotoBookmark(t);
    filmy.EnableControls;
  end else begin
    if filmyc_plik_exist.AsBoolean then exit;
    youtube.AddLink(filmylink.AsString,dir,0,0,filmyid.AsInteger);
  end;
end;

procedure TForm1.scisz10;
var
  a: double;
begin
  a:=uEKnob1.Position-5;
  if a<0 then a:=0;
  uEKnob1.Position:=a;
end;

procedure TForm1.zglosnij10;
var
  a: double;
begin
  a:=uEKnob1.Position+5;
  if a>200 then a:=200;
  uEKnob1.Position:=a;
end;

procedure TForm1.menu_rozdzialy(aOn: boolean);
begin
  cRozdzialy.Visible:=aOn;
end;

procedure TForm1.dodaj_film(aLink: string);
var
  vstatus: integer;
  a,b: integer;
  bol: boolean;
  dt: TDate;
begin
  FLista:=TFLista.Create(self);
  try
    FLista.in_tryb:=1;
    FLista.i_roz:=db_roz.FieldByName('id').AsInteger;
    FLista.in_out_obrazy:=false;
    if aLink<>'' then FLista.www_link:=aLink;
    FLista.ShowModal;
    if FLista.out_ok then
    begin
      dm.trans.StartTransaction;
      filmy.Append;
      filmy.FieldByName('nazwa').AsString:=FLista.s_tytul;
      if FLista.s_link='' then filmy.FieldByName('link').Clear else
      begin
        filmy.FieldByName('link').AsString:=FLista.s_link;
        bol:=youtube.GetDateForYoutube(FLista.s_link,dt);
        if bol then filmydata_uploaded.AsDateTime:=dt;
      end;
      if FLista.s_file='' then filmy.FieldByName('plik').Clear else filmy.FieldByName('plik').AsString:=FLista.s_file;
      if FLista.s_audio='' then filmyfile_audio.Clear else filmyfile_audio.AsString:=FLista.s_audio;
      filmy.FieldByName('rozdzial').AsInteger:=FLista.i_roz;
      vstatus:=0;
      SetBit(vstatus,0,FLista.in_out_obrazy);
      filmystatus.AsInteger:=vstatus;
      filmy.Post;
      dm.trans.Commit;
    end;
  finally
    FLista.Free;
  end;
end;

procedure TForm1.update_mute(aMute: boolean);
begin
  mplayer.SetMute(aMute);
end;

procedure TForm1._mplayerBeforePlay(Sender: TObject; AFileName: string);
var
  ipom,vol,vosd,vaudio,vresample: integer;
  osd,audio,samplerate,audioeq,lang,s1,audionormalize,novideo: string;
begin
  SetCursorOnPresentation(miPresentation.Checked and mplayer.Running);
  {VIDEO}
  if vv_novideo then novideo:='--no-video' else novideo:='';
  {AUDIOEQ AND AUDIONORMALIZE}
  if vv_audioeq='' then audioeq:='' else audioeq:='--af=superequalizer='+vv_audioeq;
  if vv_normalize then audionormalize:='--af-add=dynaudnorm=g=10:f=250:r=0.9:p=1' else audionormalize:='';
  {Screenshot}
  mplayer.ScreenshotDirectory:=_DEF_SCREENSHOT_SAVE_DIR;
  case _DEF_SCREENSHOT_FORMAT of
    0: mplayer.ScreenshotFormat:=ssJPG;
    1: mplayer.ScreenshotFormat:=ssPNG;
  end;
  uELED5.Active:=vv_obrazy;
  {OSD}
  if vv_osd=0 then
  begin
    if Menuitem49.Checked then vosd:=1 else
    if Menuitem50.Checked then vosd:=2 else
    if Menuitem51.Checked then vosd:=3 else
    if Menuitem52.Checked then vosd:=4 else
    vosd:=1;
  end else vosd:=vv_osd;
  case vosd of
    1: osd:='-osdlevel 0 -subfont-osd-scale 6';
    2: osd:='-osdlevel 1 -subfont-osd-scale 6';
    3: osd:='-osdlevel 2 -subfont-osd-scale 6';
    4: osd:='-osdlevel 3 -subfont-osd-scale 6';
    else osd:='-osdlevel 0 -subfont-osd-scale 6';
  end;
  {AUDIO}
  if vv_mute then s1:='yes' else s1:='no';
  if vv_audio=0 then
  begin
    if Menuitem54.Checked then vaudio:=1 else if Menuitem55.Checked then vaudio:=2 else if Menuitem56.Checked then vaudio:=3 else vaudio:=0;
  end else vaudio:=vv_audio;
  case vaudio of
    1: audio:='-nosound';
    2: if s1='yes' then audio:='-nosound' else audio:='-channels 1';
    3: if s1='yes' then audio:='-nosound' else audio:='-channels 2';
    else if s1='yes' then audio:='-nosound' else audio:='';
  end;
  {LANG}
  if vv_lang='' then lang:='' else
  begin
    try
      ipom:=StrToInt(vv_lang);
      lang:='--no-sub-visibility --aid='+vv_lang;
    except
      lang:='--no-sub-visibility --alang='+vv_lang;
    end;
  end;
  {RESAMPLE}
  if vv_resample=0 then
  begin
    if Menuitem58.Checked then vresample:=1 else
    if Menuitem59.Checked then vresample:=2 else
    if Menuitem60.Checked then vresample:=3 else
    if Menuitem61.Checked then vresample:=4 else
    vresample:=0;
  end else vresample:=vv_resample;
  case vresample of
    1: samplerate:='--audio-samplerate=11025';
    2: samplerate:='--audio-samplerate=22050';
    3: samplerate:='--audio-samplerate=44100';
    4: samplerate:='--audio-samplerate=48000';
    else samplerate:='';
  end;
  {RESZTA}
  if vv_wzmocnienie then
  begin
    mplayer.BostVolume:=vv_wzmocnienie;
    if vv_glosnosc=0 then
    begin
      indeks_def_volume:=0;
      vol:=round(uEKnob1.Position);
    end else begin
      indeks_def_volume:=100-vv_glosnosc;
      vol:=round(uEKnob1.Position)-indeks_def_volume;
    end;
  end else begin
    indeks_def_volume:=0;
    mplayer.BostVolume:=Menuitem39.Checked;
    vol:=round(uEKnob1.Position);
  end;
  if const_mplayer_param='' then
    mplayer.StartParam:=audioeq+' '+audionormalize+' '+osd+' '+audio+' '+lang+' '+samplerate+' -volume '+IntToStr(vol)+' '+novideo
  else
    mplayer.StartParam:=audioeq+' '+audionormalize+' '+osd+' '+audio+' '+lang+' '+samplerate+' -volume '+IntToStr(vol)+' '+const_mplayer_param+' '+novideo;
  if _FULL_SCREEN then
  begin
    mplayer.ProcessPriority:=mpIdle;
  end else mplayer.ProcessPriority:=mpNormal;
end;

procedure TForm1._mpvBeforePlay(Sender: TObject; AFileName: string);
var
  ipom,vol,vosd,vaudio,vresample,vvquality: integer;
  device,osd,audio,samplerate,audioeq,lang,s1,audionormalize,novideo,transpose,quality,predkosc,tonacja: string;
  fdeinterlace: string;
begin
  SetCursorOnPresentation(miPresentation.Checked and mplayer.Running);
  {FORCE DEINTERLACE}
  if (not MenuItem117.Checked) and force_deinterlace then fdeinterlace:='-deinterlace=yes' else fdeinterlace:='';
  uELED18.Active:=mplayer.Deinterlace or force_deinterlace;
  Label11.Visible:=uELED18.Active;
  {VIDEO}
  if vv_novideo then novideo:='--no-video' else novideo:='';
  quality:='';
  if vv_plik='' then
  begin
    if _DEF_YT_AS_QUALITY_PLAY>0 then quality:=dm.youtube.GetInfoToLink(vv_link,0,_DEF_YT_AS_QUALITY_PLAY);
    if quality<>'' then quality:='--ytdl-format='+quality;
  end;
  {PREDKOŚĆ ODTWARZANIA}
  if vv_predkosc=0 then predkosc:='' else
  begin
    if vv_predkosc<0 then predkosc:='-speed=0.'+IntToStr(100+vv_predkosc) else
    predkosc:='-speed=1.'+IntToStr(vv_predkosc);
  end;
  {TONACJA ODTWARZANIA}
  if vv_tonacja=0 then tonacja:='' else
  begin
    if vv_tonacja<0 then tonacja:='-af-add=rubberband=pitch-scale=0.'+IntToStr(100+vv_tonacja) else
    tonacja:='-af-add=rubberband=pitch-scale=1.'+IntToStr(vv_tonacja);
  end;
  {TRANSPOSE}
  case vv_transpose of
    1: transpose:='-vf transpose=5';
    2: transpose:='-vf transpose=2';
    else transpose:='';
  end;
  {DEVICE AUDIO}
  if (_DEF_MULTIDESKTOP_LEFT>-1) and (_DEF_MULTIDESKTOP_LEFT<=Left) then
  begin
    if _DEF_AUDIO_DEVICE_MONITOR='default' then device:='' else device:='--audio-device='+_DEF_AUDIO_DEVICE_MONITOR;
  end else if _DEF_AUDIO_DEVICE='default' then device:='' else device:='--audio-device='+_DEF_AUDIO_DEVICE;
  {AUDIOEQ AND AUDIONORMALIZE}
  if vv_audioeq='' then audioeq:='' else audioeq:='--af-add=superequalizer='+vv_audioeq;
  if vv_normalize then audionormalize:='--af-add=dynaudnorm=g=10:f=250:r=0.9:p=1' else audionormalize:='';
  {Screenshot}
  mplayer.ScreenshotDirectory:=_DEF_SCREENSHOT_SAVE_DIR;
  case _DEF_SCREENSHOT_FORMAT of
    0: mplayer.ScreenshotFormat:=ssJPG;
    1: mplayer.ScreenshotFormat:=ssPNG;
  end;
  uELED5.Active:=vv_obrazy;
  {OSD}
  if vv_osd=0 then
  begin
    if Menuitem49.Checked then vosd:=1 else
    if Menuitem50.Checked then vosd:=2 else
    if Menuitem51.Checked then vosd:=3 else
    if Menuitem52.Checked then vosd:=4 else
    vosd:=1;
  end else vosd:=vv_osd;
  case vosd of
    1: osd:='--osd-level=0 --osd-scale=0.5 --osd-border-size=2 --osd-margin-x=10 --osd-margin-y=10';
    2: osd:='--osd-level=1 --osd-scale=0.5 --osd-border-size=2 --osd-margin-x=10 --osd-margin-y=10';
    3: osd:='--osd-level=2 --osd-scale=0.5 --osd-border-size=2 --osd-margin-x=10 --osd-margin-y=10';
    4: osd:='--osd-level=3 --osd-scale=0.5 --osd-border-size=2 --osd-margin-x=10 --osd-margin-y=10';
    else osd:='--osd-level=0 --osd-scale=0.5 --osd-border-size=2 --osd-margin-x=10 --osd-margin-y=10';
  end;
  {AUDIO}
  if vv_mute then s1:='yes' else s1:='no';
  if vv_audio=0 then
  begin
    if Menuitem54.Checked then vaudio:=1 else if Menuitem55.Checked then vaudio:=2 else if Menuitem56.Checked then vaudio:=3 else vaudio:=0;
  end else vaudio:=vv_audio;
  case vaudio of
    1: audio:='--mute=yes';
    2: audio:='--mute='+s1+' --audio-channels=mono';
    3: audio:='--mute='+s1+' --audio-channels=stereo';
    else audio:='--mute='+s1;
  end;
  {LANG}
  if vv_lang='' then lang:='' else
  begin
    try
      ipom:=StrToInt(vv_lang);
      lang:='--no-sub-visibility --aid='+vv_lang;
    except
      lang:='--no-sub-visibility --alang='+vv_lang;
    end;
  end;
  {RESAMPLE}
  if vv_resample=0 then
  begin
    if Menuitem58.Checked then vresample:=1 else
    if Menuitem59.Checked then vresample:=2 else
    if Menuitem60.Checked then vresample:=3 else
    if Menuitem61.Checked then vresample:=4 else
    vresample:=0;
  end else vresample:=vv_resample;
  case vresample of
    1: samplerate:='--audio-samplerate=11025';
    2: samplerate:='--audio-samplerate=22050';
    3: samplerate:='--audio-samplerate=44100';
    4: samplerate:='--audio-samplerate=48000';
    else samplerate:='';
  end;
  {RESZTA}
  if vv_wzmocnienie then
  begin
    //mplayer.BostVolume:=vv_wzmocnienie;
    if vv_glosnosc=0 then
    begin
      indeks_def_volume:=0;
      vol:=round(uEKnob1.Position);
    end else begin
      indeks_def_volume:=100-vv_glosnosc;
      vol:=round(uEKnob1.Position)-indeks_def_volume;
    end;
  end else begin
    indeks_def_volume:=0;
    mplayer.BostVolume:=Menuitem39.Checked;
    vol:=round(uEKnob1.Position);
  end;
  if const_mplayer_param='' then
    mplayer.StartParam:=quality+' '+device+' '+audioeq+' '+audionormalize+' '+osd+' '+audio+' '+lang+' '+samplerate+' -volume '+IntToStr(vol)+' '+novideo+' '+transpose+' '+predkosc+' '+tonacja+' '+fdeinterlace
  else
    mplayer.StartParam:=quality+' '+device+' '+audioeq+' '+audionormalize+' '+osd+' '+audio+' '+lang+' '+samplerate+' -volume '+IntToStr(vol)+' '+const_mplayer_param+' '+novideo+' '+transpose+' '+predkosc+' '+tonacja+' '+fdeinterlace;
  if _FULL_SCREEN then
  begin
    mplayer.ProcessPriority:=mpIdle;
  end else mplayer.ProcessPriority:=mpNormal;
end;

procedure TForm1._ustaw_cookies;
begin
  if _DEF_COOKIES_FILE_YT<>'' then if FileExists(_DEF_COOKIES_FILE_YT) then
  begin
    if mplayer.Engine=meMplayer then const_mplayer_param:='-cookies -cookies-file '+_DEF_COOKIES_FILE_YT else
    if mplayer.Engine=meMPV then const_mplayer_param:='--cookies --cookies-file='+_DEF_COOKIES_FILE_YT+' --ytdl-raw-options=cookies='+_DEF_COOKIES_FILE_YT;
  end;
end;

procedure TForm1.ppause(aNr: integer);
var
  s: string;
begin
  case aNr of
    0: _STUDIO_PLAY_BLOCKED_0:=true;
    1: _STUDIO_PLAY_BLOCKED_1:=true;
    2: _STUDIO_PLAY_BLOCKED_2:=true;
    3: _STUDIO_PLAY_BLOCKED_3:=true;
    4: _STUDIO_PLAY_BLOCKED_4:=true;
  end;
  uELED13.Active:=_STUDIO_PLAY_BLOCKED_0;
  uELED14.Active:=_STUDIO_PLAY_BLOCKED_1;
  uELED15.Active:=_STUDIO_PLAY_BLOCKED_2;
  uELED16.Active:=_STUDIO_PLAY_BLOCKED_3;
  uELED17.Active:=_STUDIO_PLAY_BLOCKED_4;
  if mplayer.Playing then mplayer.Pause;
  if _STUDIO_PLAY_BLOCKED_0 then s:='1' else s:='0';
  if _STUDIO_PLAY_BLOCKED_1 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_2 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_3 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_4 then s:=s+'1' else s:=s+'0';
end;

procedure TForm1.pplay(aNr: integer; aForce: boolean);
var
  s: string;
begin
  case aNr of
    0: _STUDIO_PLAY_BLOCKED_0:=false;
    1: _STUDIO_PLAY_BLOCKED_1:=false;
    2: _STUDIO_PLAY_BLOCKED_2:=false;
    3: _STUDIO_PLAY_BLOCKED_3:=false;
    4: _STUDIO_PLAY_BLOCKED_4:=false;
  end;
  if aForce then
  begin
    _STUDIO_PLAY_BLOCKED_0:=false;
    _STUDIO_PLAY_BLOCKED_1:=false;
    _STUDIO_PLAY_BLOCKED_2:=false;
    _STUDIO_PLAY_BLOCKED_3:=false;
    _STUDIO_PLAY_BLOCKED_4:=false;
  end;
  uELED13.Active:=_STUDIO_PLAY_BLOCKED_0;
  uELED14.Active:=_STUDIO_PLAY_BLOCKED_1;
  uELED15.Active:=_STUDIO_PLAY_BLOCKED_2;
  uELED16.Active:=_STUDIO_PLAY_BLOCKED_3;
  uELED17.Active:=_STUDIO_PLAY_BLOCKED_4;
  if _STUDIO_PLAY_BLOCKED_0 then s:='1' else s:='0';
  if _STUDIO_PLAY_BLOCKED_1 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_2 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_3 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_4 then s:=s+'1' else s:=s+'0';
  if _STUDIO_PLAY_BLOCKED_0 or _STUDIO_PLAY_BLOCKED_1 or _STUDIO_PLAY_BLOCKED_2 or _STUDIO_PLAY_BLOCKED_3 or _STUDIO_PLAY_BLOCKED_4 then exit;
  if mplayer.Paused then mplayer.Replay;
end;

procedure TForm1.playpause(aPlayForce: boolean);
begin
  if _STUDIO_PLAY_BLOCKED_0 then pplay(0,aPlayForce) else ppause(0);
end;

function TForm1.GetCanal(aKey: string): integer;
var
  a,i: integer;
begin
  (* sprawdzam czy klucz już został wcześniej dodany *)
  a:=-1;
  for i:=0 to canals.Count-1 do if canals[i]=aKey then
  begin
    a:=i+1;
    break;
  end;
  (* jeśli klucz nie został dodany, dodaję go teraz *)
  if a=-1 then a:=canals.Add(aKey)+1;
  result:=a;
end;

procedure TForm1.wykonaj_komende(aCommand: string);
var
  p: TProcess;
  s: string;
  i: integer;
begin
  if aCommand='' then exit;
  (* kod odpowiedzialny za obsługe wykonywania komend *)
  p:=TProcess.Create(self);
  p.ShowWindow:=swoHIDE;
  try
    i:=1;
    while true do
    begin
      s:=GetLineToStr(aCommand,i,' ');
      if s='' then break;
      if i=1 then p.Executable:=s else p.Parameters.Add(s);
      inc(i);
    end;
    p.Execute;
  finally
    p.Free;
  end;
end;

function TForm1.GetMCMT(aOdPoczatku: boolean): string;
begin
  if aOdPoczatku then _MPLAYER_CLIPBOARD_MEMORY:=dm.rozbij_adres_youtube(dm.GetConfig('mplayer-clipboard-memory',''))
  else _MPLAYER_CLIPBOARD_MEMORY:=dm.GetConfig('mplayer-clipboard-memory','');
  result:=_MPLAYER_CLIPBOARD_MEMORY;
end;

function TForm1.SetMCMT(aSciezka: string): string;
var
  l: single;
begin
  (*
  https://youtu.be/gdmRDThm1-8?t=2618  (43:38)
  https://www.youtube.com/watch?v=clbt12upuaA
  *)
  if aSciezka='' then
  begin
    if not mplayer.Running then
    begin
      result:='';
      exit;
    end;
    l:=mplayer.Position;
    { ... }
  end else _MPLAYER_CLIPBOARD_MEMORY:=aSciezka;
  dm.SetConfig('mplayer-clipboard-memory',_MPLAYER_CLIPBOARD_MEMORY);
  result:=_MPLAYER_CLIPBOARD_MEMORY;
end;

procedure TForm1.PlayMute;
begin
  cmute:=not cmute;
  mplayer.SetMute(cmute);
end;

procedure mpvAD(aStr: string; var aS1,aS2: string);
var
  s,s1,s2: string;
begin
  s:=trim(aStr);
  s1:=trim(GetLineToStr(s,2,''''));
  s2:=trim(GetLineToStr(s,3,''''));
  if s2[1]='(' then
  begin
    delete(s2,1,1);
    delete(s2,length(s2),1);
  end;
  aS1:=s1;
  aS2:=s2;
end;

procedure TForm1.audio_device_refresh;
var
  p: TProcess;
  ss: TStringList;
  s,s1,s2: string;
  i: integer;
  b,c: boolean;
begin
  if _DEF_AUDIO_DEVICE='default' then exit;
  b:=true;
  c:=true;
  p:=TProcess.Create(self);
  try
    p.Options:=[poWaitOnExit,poUsePipes,poNoConsole];
    p.ShowWindow:=swoHIDE;
    p.Executable:='sh';
    p.Parameters.Add('-c');
    p.Parameters.Add('mpv --audio-device=help | grep pulse');
    p.Execute;
    ss:=TStringList.Create;
    try
      if p.Output.NumBytesAvailable>0 then
      begin
        ss.LoadFromStream(p.Output);
        for i:=0 to ss.Count-1 do
        begin
          s:=ss[i];
          mpvAD(s,s1,s2);
          if s1=_DEF_AUDIO_DEVICE then
          begin
            b:=false;
            break;
          end;
        end;
        for i:=0 to ss.Count-1 do
        begin
          s:=ss[i];
          mpvAD(s,s1,s2);
          if s1=_DEF_AUDIO_DEVICE_MONITOR then
          begin
            c:=false;
            break;
          end;
        end;
      end;
    finally
      ss.Free;
    end;
  finally
    p.Terminate(0);
    p.Free;
  end;
  if b then _DEF_AUDIO_DEVICE:='default';
  if c then _DEF_AUDIO_DEVICE_MONITOR:='default';
end;

procedure TForm1.ReadVariableFromDatabase(aRozdzial, aFilm: TDataSet);
var
  q: TZQuery;
begin
  vv_mute:=false;
  vv_old_mute:=false;
  indeks_rozd:=aFilm.FieldByName('rozdzial').AsInteger;
  film_tytul:=aFilm.FieldByName('nazwa').AsString;
  indeks_play:=aFilm.FieldByName('id').AsInteger;
  vv_link:=aFilm.FieldByName('link').AsString;
  vv_plik:=aFilm.FieldByName('plik').AsString;
  if aFilm.FieldByName('wzmocnienie').IsNull then vv_wzmocnienie:=false else vv_wzmocnienie:=aFilm.FieldByName('wzmocnienie').AsBoolean;
  if aFilm.FieldByName('glosnosc').IsNull then vv_glosnosc:=0 else vv_glosnosc:=aFilm.FieldByName('glosnosc').AsInteger;
  vv_obrazy:=GetBit(aFilm.FieldByName('status').AsInteger,0);
  vv_transmisja:=GetBit(aFilm.FieldByName('status').AsInteger,1);
  vv_szum:=GetBit(aFilm.FieldByName('status').AsInteger,2);
  vv_novideo:=GetBit(aFilm.FieldByName('status').AsInteger,5);
  vv_osd:=aFilm.FieldByName('osd').AsInteger;
  vv_audio:=aFilm.FieldByName('audio').AsInteger;
  vv_lang:=aFilm.FieldByName('lang').AsString;
  vv_resample:=aFilm.FieldByName('resample').AsInteger;
  vv_audioeq:=aFilm.FieldByName('audioeq').AsString;
  vv_audio1:=aFilm.FieldByName('file_audio').AsString;
  vv_normalize:=GetBit(aFilm.FieldByName('status').AsInteger,3);
  vv_normalize_not:=GetBit(aFilm.FieldByName('status').AsInteger,6);
  vv_transpose:=aFilm.FieldByName('transpose').AsInteger;
  vv_predkosc:=aFilm.FieldByName('predkosc').AsInteger;
  vv_tonacja:=aFilm.FieldByName('tonacja').AsInteger;
  if aRozdzial<>nil then
  begin
    if not vv_novideo then vv_novideo:=aRozdzial.FieldByName('novideo').AsInteger=1;
    if (not vv_normalize) and (not vv_normalize_not) then vv_normalize:=aRozdzial.FieldByName('normalize_audio').AsInteger=1;
  end;
  q:=TZQuery.Create(self);
  q.Connection:=dm.db;
  q.SQL.Add('select duration from filmy where id=:id');
  q.ParamByName('id').AsInteger:=indeks_play;
  try
    q.Open;
    vv_duration:=q.FieldByName('duration').AsInteger;
    q.Close;
  finally
    q.Free;
  end;
end;

procedure TForm1.ClearVariable;
begin
  indeks_rozd:=-1;
  film_tytul:='';
  indeks_play:=-1;
  indeks_czas:=-1;
  czas_aktualny:=-1;
  czas_nastepny:=-1;
  vv_obrazy:=false;
  vv_transmisja:=false;
  vv_szum:=false;
  vv_osd:=0;
  vv_audio:=0;
  vv_lang:='';
  vv_resample:=0;
  vv_audioeq:='';
  vv_audio1:='';
  vv_audio2:='';
  vv_mute:=false;
  vv_old_mute:=false;
  vv_novideo:=false;
  vv_normalize:=false;
  vv_normalize_not:=false;
  vv_transpose:=0;
  vv_predkosc:=0;
  vv_tonacja:=0;
  vv_mute:=false;
  vv_old_mute:=false;
  vv_link:='';
  vv_plik:='';
  vv_duration:=0;
  vv_wzmocnienie:=false;
  vv_glosnosc:=0
end;

procedure TForm1.PlayFromParameter(aParam: string);
var
  s,pom,plik_do_usuniecia: string;
  typ,a,a2,licznik: integer; //0-nieznany 1-www 2-plik 3-EXTM3U
  b: boolean;
  ext: string;
  f: textfile;
begin
  typ:=0;
  plik_do_usuniecia:='';
  s:=trim(aParam);
  (* sprawdzam czy to jest www *)
  a:=pos('http://',s);
  a2:=pos('https://',s);
  if (a=1) or (a2=1) then typ:=1;
  (* sprawdzam czy plik istnieje na dysku *)
  if typ=0 then
  begin
    b:=FileExists(s);
    if b then typ:=2 else
    begin
      s:=MyDir(s);
      b:=FileExists(s);
      if b then typ:=2;
    end;
  end;
  (* jeśli to www to próbuję odpalić *)
  if typ=1 then
  begin
    if mplayer.Running then mplayer.Stop;
    EXTFILE_PLAY:=true;
    Edit1.Text:=s;
    play.Click;
  end else
  (* jeśli to plik - wykonuję dodatkowe działania i odpalam go *)
  if typ=2 then
  begin
    ext:=ExtractFileExt(s);
    if ext='' then
    begin
      (* plik bez rozszerzenia - sprawdzam co to za plik *)
      licznik:=0;
      assignfile(f,s);
      reset(f);
      while not eof(f) do
      begin
        inc(licznik);
        readln(f,pom);
        pom:=trim(pom);
        if licznik=1 then
        begin
          if pom='#EXTM3U' then
          begin
            typ:=3;
            plik_do_usuniecia:=s;
            continue;
          end else begin
            typ:=0;
            break;
          end;
        end;
        if (pom[1]='#') or (pom='') then continue;
        s:=pom;
        break;
      end;
      closefile(f);
      if typ=3 then DeleteFile(plik_do_usuniecia);
      if s<>'' then
      begin
        if mplayer.Running then mplayer.Stop;
        force_deinterlace:=typ=3;
        EXTFILE_PLAY:=true;
        Edit1.Text:=s;
        play.Click;
      end;
    end else begin
      if mplayer.Running then mplayer.Stop;
      EXTFILE_PLAY:=true;
      Edit1.Text:=s;
      play.Click;
    end;
  end;
end;

function TForm1.przelicz_czas(aCzas: TTime): TTime;
begin
  if vv_predkosc=0 then result:=aCzas else result:=(100-vv_predkosc)*aCzas/100;
end;

function TForm1.get_wektor_yt(czas, w11, w12, w21, w22, d1, d2: integer
  ): integer;
var
  a: integer;
  f1,f2,r: integer;
  w,wsp: double;
begin
  a:=d1-d2;
  f1:=w21-w11;
  f2:=w22-w12;
  wsp:=f1/f2;
  r:=round((czas)*wsp);
  if r<0 then r:=0;
  result:=r;
end;

function TForm1.roz2dir(id: integer): string;
var
  s: string;
begin
  dm.roz_dane.ParamByName('id').AsInteger:=id;
  dm.roz_dane.Open;
  s:=dm.roz_danedirectory.AsString;
  dm.roz_dane.Close;
  if s<>'' then if s[length(s)]<>_FF then s:=s+_FF;
  result:=s;
end;

function TForm1.filename2roz2filename(r1, r2: integer; f1, f2: string): string;
var
  err: integer;
  cdir1,cdir2: string;
  fn1,fn2,dir1,dir2: string;
  b,b2: boolean;
begin
  try
    err:=1; fn1:=ExtractFileName(f1);
    err:=2; fn2:=ExtractFileName(f2);
    err:=3; dir1:=ExtractFilePath(f1);
    err:=4; dir2:=ExtractFilePath(f2);
    {writeln('r1 = ',r1);
    writeln('r2 = ',r2);}
    err:=5; if r1=0 then cdir1:=_DEF_MULTIMEDIA_SAVE_DIR else cdir1:=roz2dir(r1);
    err:=6; if r2=0 then cdir2:=_DEF_MULTIMEDIA_SAVE_DIR else cdir2:=roz2dir(r2);

    {writeln('f1 = ',f1);
    writeln('f2 = ',f2);
    writeln('fn1 = ',fn1);
    writeln('fn2 = ',fn2);
    writeln('dir1 = ',dir1);
    writeln('dir2 = ',dir2);
    writeln('cdir1 = ',cdir1);
    writeln('cdir2 = ',cdir2);}

    err:=7;
    b:=(dir1=cdir1) and (dir2=cdir2) and (fn1=fn2) and FileExists(f1);
    //writeln('b = ',b);
    if b then
    begin
      (* wrzucamy plik do nowego katalogu *)
      err:=8;
      b2:=RenameFile(f1,cdir2+fn1);
      if b2 then f2:=cdir2+fn1;
    end;
  except
    on E: Exception do mess.ShowError('Wystąpił błąd na linijce kodu = '+IntToStr(err)+':^'+E.Message);
  end;
  result:=f2;
end;

procedure TForm1.zapisz_fragment_filmu(do_konca: boolean);
var
  a: TAsyncProcess;
  p1,p2,s1,s2,s3: string;
  a1,a2: TTime;
  ss: TStringList;
begin
  p1:=trim(filmyplik.AsString);
  if p1='' then exit;
  a1:=-1;
  a1:=IntegerToTime(czasyczas_od.AsInteger);
  a2:=-1;
  if czasyczas_do.IsNull then
  begin
    czasy_nast.ParamByName('czas_aktualny').AsInteger:=czasyczas_od.AsInteger;
    czasy_nast.Open;
    if not czasy_nast.FieldByName('czas_od').IsNull then a2:=IntegerToTime(czasy_nast.FieldByName('czas_od').AsInteger);
    czasy_nast.Close;
  end else a2:=IntegerToTime(czasyczas_do.AsInteger);
  if a1=-1 then exit;
  ExtractPFE(p1,s1,s2,s3);
  p2:=s2+'_('+czasynazwa.AsString+')_'+s3;
  if SelectDir.Execute then
  begin
    p2:=SelectDir.FileName+_FF+p2;
    a:=TAsyncProcess.Create(self);
    a.Options:=[poWaitOnExit,poUsePipes,poStderrToOutPut,poNoConsole];
    a.ShowWindow:=swoHIDE;
    try
      a.Executable:='ffmpeg';
      a.Parameters.Add('-ss');
      a.Parameters.Add(FormatDateTime('hh:nn:ss.zzz',a1));
      if (not do_konca) and (a2<>-1) and (a2>a1) then
      begin
        a.Parameters.Add('-t');
        a.Parameters.Add(FormatDateTime('hh:nn:ss.zzz',a2-a1));
      end;
      a.Parameters.Add('-i');
      a.Parameters.Add(p1);
      a.Parameters.Add('-acodec');
      a.Parameters.Add('copy');
      a.Parameters.Add('-vcodec');
      a.Parameters.Add('copy');
      a.Parameters.Add(p2);
      a.Execute;
    finally
      a.Terminate(0);
      a.Free;
      mess.ShowInformation('Plik został zapisany.');
    end;
  end;
end;

procedure TForm1.zapisz_indeks_czasu(aIndeks: integer);
var
  a: integer;
begin
  if not LiveTimer.Active then exit;
  a:=LiveTimer.GetIndexTime;
  dm.tasma_add.ParamByName('czas').AsInteger:=a;
  dm.tasma_add.ParamByName('nazwa_filmu').AsString:=FormatDateTime('hh:nn:ss',a);
  case aIndeks of
    1: dm.tasma_add.ParamByName('nazwa_czasu').AsString:='INDEX A';
    2: dm.tasma_add.ParamByName('nazwa_czasu').AsString:='INDEX B';
  end;
  dm.tasma_add.ExecSQL;
end;

procedure TForm1.czasy_id_info;
begin
  mess.ShowInformation('Identyfikator rekordu to: '+czasyid.AsString);
end;

procedure TForm1.UpdateFilmDuration(aDuration: integer);
var
  q: TZQuery;
begin
  vv_duration:=aDuration;
  q:=TZQuery.Create(self);
  q.Connection:=dm.db;
  q.SQL.Add('update filmy set duration=:duration where id=:id');
  try
    q.ParamByName('id').AsInteger:=indeks_play;
    q.ParamByName('duration').AsInteger:=aDuration;
    q.ExecSQL;
    //filmy_refresh;
    //film_play_refresh;
  finally
    q.Free;
  end;
end;

procedure TForm1.filmy_refresh;
var
  t: TBookmark;
begin
  filmy.DisableControls;
  t:=filmy.GetBookmark;
  filmy.Refresh;
  filmy.GotoBookmark(t);
  filmy.EnableControls;
end;

procedure TForm1.film_play_refresh;
var
  t: TBookmark;
begin
  if not film_play.Active then exit;
  film_play.DisableControls;
  t:=film_play.GetBookmark;
  film_play.Refresh;
  film_play.GotoBookmark(t);
  film_play.EnableControls;
end;

function TForm1.TimeToText(aTime: TTime): string;
var
  s: string;
begin
  s:=FormatDateTime('hh',aTime);
  if s='00' then s:=FormatDateTime('nn:ss',aTime) else s:=FormatDateTime('hh:nn:ss',aTime);
  result:=s;
end;

procedure TForm1.UstawPodgladSortowania;
var
  i,a: integer;
  s: string;
begin
  s:=IntToStr(filmy.Tag);
  for i:=1 to 3 do if s[i]>'1' then
  begin
    a:=i;
    break;
  end;
  for i:=0 to 2 do DBGrid1.Columns[i].Title.Font.Bold:=false;
  DBGrid1.Columns[0].Title.Caption:='Id.';
  DBGrid1.Columns[1].Title.Caption:='Nazwa';
  DBGrid1.Columns[2].Title.Caption:='Data';
  DBGrid1.Columns[a-1].Title.Font.Bold:=true;
  case a of
    1: if s[a]='3' then DBGrid1.Columns[0].Title.Caption:='Id. ↑' else DBGrid1.Columns[0].Title.Caption:='Id. ↓';
    2: if s[a]='3' then DBGrid1.Columns[1].Title.Caption:='Nazwa ↑' else DBGrid1.Columns[1].Title.Caption:='Nazwa ↓';
    3: if s[a]='3' then DBGrid1.Columns[2].Title.Caption:='Data ↑' else DBGrid1.Columns[2].Title.Caption:='Data ↓';
  end;
  MenuItem9.Enabled:=a=1;
  MenuItem20.Enabled:=a=1;
end;

procedure TForm1.RunParameter(aStr: string);
begin
  PlayFromParameter(aStr);
end;

function TForm1.GetPrivateIndexPlay: integer;
begin
  result:=indeks_play;
end;

function TForm1.GetPrivateIndexCzas: integer;
begin
  result:=indeks_czas;
end;

function TForm1.GetPrivateVvObrazy: boolean;
begin
  result:=vv_obrazy;
end;

procedure TForm1.SetPrivatePStatusIgnore(aNewStatus: boolean);
begin
  pstatus_ignore:=aNewStatus;
end;

function TForm1.GetPrivatePStatusIgnore: boolean;
begin
  result:=pstatus_ignore;
end;

function TForm1.GetPrivateCzasNastepny: integer;
begin
  result:=czas_nastepny;
end;

function TForm1.GetPrivateCzasAktualny: integer;
begin
  result:=czas_aktualny;
end;

procedure TForm1.UpdateFilmToRoz(aRestore: boolean);
begin
  if aRestore then
  begin
    if not db_rozfilm_id.IsNull then filmy.Locate('id',db_rozfilm_id.AsInteger,[]);
  end else
  if db_rozfilm_id.IsNull or (db_rozfilm_id.AsInteger<>filmyid.AsInteger) then
  begin
    db_roz.Edit;
    db_rozfilm_id.AsInteger:=filmyid.AsInteger;
    db_roz.Post;
  end;
end;

procedure TForm1.SeekPlay(aCzas: integer);
var
  t: TTime;
  Hour, Minute, Second, MilliSecond: word;
  a: single;
begin
  t:=IntegerToTime(aCzas);
  DecodeTime(t,Hour,Minute,Second,MilliSecond);
  a:=(Hour*60*60)+(Minute*60)+Second+(MilliSecond/1000);
  mplayer.Position:=a;
end;

function TForm1.db_open: boolean;
var
  b: boolean;
begin
  if CUSTOM_DB then
  begin
    try
      dm.schemacustom.StructFileName:=MyConfDir('studio2.dat');
      dm.db.Connect;
      if dm.db.Connected then
      begin
        if not _DEV_ON then if FileExists(dm.schemacustom.StructFileName) then dm.schemacustom.SyncSchema;
        db_roz.Open;
        result:=true;
      end else result:=false;
    except
      result:=false;
    end;
  end else result:=false;
end;

procedure TForm1.db_close;
begin
  if dm.db.Connected then
  begin
    db_roz.Close;
    dm.db.Disconnect;
  end;
end;

function TForm1.get_last_id: integer;
begin
  dm.last_id.Open;
  result:=dm.last_id.Fields[0].AsInteger;
  dm.last_id.Close;
end;

procedure TForm1.usun_pozycje_czasu(wymog_potwierdzenia: boolean);
begin
  if wymog_potwierdzenia then if not mess.ShowConfirmationYesNo('Czy faktycznie chcesz usunąć ten wpis?') then exit;
  czasy.Delete;
  test_force:=true;
end;

procedure TForm1.komenda_up;
begin
  if DBGrid1.Focused then filmy.Prior else
  if DBGrid2.Focused then czasy.Prior;
end;

procedure TForm1.komenda_down;
begin
  if DBGrid1.Focused then filmy.Next else
  if DBGrid2.Focused then czasy.Next;
end;

procedure TForm1.go_czas2;
begin
  if (mplayer.Playing or mplayer.Paused) and (indeks_play=filmy.FieldByName('id').AsInteger) then
    if not czasyczas2.IsNull then SeekPlay(czasy.FieldByName('czas2').AsInteger);
end;

procedure TForm1.resize_update_grid;
begin
  //DBGrid1.Columns[1].Width:=Panel3.Width-14;
  //DBGrid2.Columns[2].Width:=DBGrid1.Columns[1].Width-22;
  DBGrid3.Columns[1].Width:=Screen.Width;
end;

procedure TForm1.test_play;
var
  b: boolean;
begin
  b:=pstatus_ignore;
  test;
  pstatus_ignore:=b;
end;

procedure TForm1.test(APositionForce: single);
var
  vposition: single;
  a,teraz,teraz1,teraz2: integer;
  czas_od,czas_do,czas_do_2: integer;
  nazwa,s1,s2,autor,v_audio: string;
  stat: integer;
  pstatus,istatus: boolean;
begin
  test_force:=false;
  czas_aktualny:=-1;
  czas_nastepny:=-1;  //INDEKS KONCA CZASU!
  czas_nastepny2:=-1; //SKOK DO NAST CZASU!
  vv_old_mute:=vv_mute;
  vv_mute:=false;
  if not mplayer.Running then exit;
  if APositionForce>0.0000001 then vposition:=APositionForce else vposition:=mplayer.GetPositionOnlyRead;

  test_czas.Open;
  try
    if test_czas.IsEmpty then exit;
    teraz:=MiliSecToInteger(round(vposition*1000));
    teraz1:=teraz-1000;
    teraz2:=teraz+1000;
    while not test_czas.EOF do
    begin
      s1:=film_tytul;
      s2:=test_czas.FieldByName('nazwa').AsString;
      film_autor:=test_czas.FieldByName('autor').AsString;
      nazwa:=film_tytul+' - '+s2;
      film_tytul1:=film_tytul;
      film_tytul2:=s2;
      czas_od:=test_czas.FieldByName('czas_od').AsInteger;
      v_audio:=test_czas.FieldByName('file_audio').AsString;
      if test_czas.FieldByName('czas_do').IsNull then
      begin
        if test_czas2.IsEmpty then czas_do:=-1
        else begin
          czas_do:=test_czas2.FieldByName('czas_od').AsInteger;
        end;
        if test_czas22.IsEmpty then czas_do_2:=-1
        else begin
          czas_do_2:=test_czas22.FieldByName('czas_od').AsInteger;
        end;
      end else begin
        czas_do:=test_czas.FieldByName('czas_do').AsInteger;
        czas_do_2:=czas_do;
      end;
      if (teraz2>czas_od) and ((czas_do=-1) or (teraz<czas_do)) then
      begin
        {CZAS AKTUALNY JEST TERAZ!}
        if (czas_od<=teraz2) and ((czas_do=-1) or (czas_do>teraz)) then
        begin
          stat:=test_czas.FieldByName('status').AsInteger;
          if test_czas.FieldByName('mute').IsNull then vv_mute:=false else vv_mute:=test_czas.FieldByName('mute').AsInteger=1;
          if pstatus_ignore then pstatus:=false else
          begin
            pstatus:=GetBit(stat,0);
            if (not pstatus) and (ComboBox1.ItemIndex<>1) then pstatus:=test_czas.FieldByName('active').AsInteger=0;
          end;
          istatus:=GetBit(stat,1);
          czas_aktualny:=czas_od;
          czas_aktualny_nazwa:=nazwa;
          czas_aktualny_indeks:=test_czas.FieldByName('id').AsInteger;
          if ComboBox1.ItemIndex=1 then
          begin
            if czas_do>teraz then begin czas_nastepny:=czas_do; czas_nastepny2:=czas_do; end;
          end else begin
            if czas_do_2>teraz then begin czas_nastepny:=czas_do; czas_nastepny2:=czas_do_2; end;
          end;
          vv_audio2:=v_audio;
        end;
        if czas_nastepny>-1 then break;
      end;
      if czas_od>teraz then czas_nastepny:=czas_od;
      if czas_nastepny>-1 then break;
      test_czas.Next;
    end;
  finally
    test_czas.Close;
  end;
  pstatus_ignore:=false;
  {UAKTUALNIAMY!}
  if vv_old_mute<>vv_mute then update_mute(vv_mute);
  if czas_aktualny>-1 then
  begin
    if pstatus then
    begin
      if (czas_nastepny=-1) or ((ComboBox1.ItemIndex<>1) and (czas_do_2=-1)) then mplayer.Stop else SeekPlay(czas_nastepny2);
      exit;
    end;
    indeks_czas:=czas_aktualny_indeks;
    DBGrid2.Refresh;
    if _SET_VIEW_SCREEN then FPodglad.DBGrid2.Refresh;
    a:=StringToItemIndex(trans_indeksy,IntToStr(indeks_czas));
  end else begin
    indeks_czas:=-1;
    DBGrid2.Refresh;
    if _SET_VIEW_SCREEN then FPodglad.DBGrid2.Refresh;
    reset_oo;
  end;
end;

end.

