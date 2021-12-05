unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Menus, XMLPropStorage, DBGrids, ZDataset, MPlayerCtrl, CsvParser,
  ExtMessage, UOSEngine, UOSPlayer, NetSocket, LiveTimer, Presentation,
  ConsMixer, DirectoryPack, FullscreenMenu, ExtShutdown, DBGridPlus, Polfan,
  upnp, YoutubeDownloader, ExtSharedMemory, ExtSharedCommunication, Types, db,
  process, Grids, ComCtrls, DBCtrls, ueled, uEKnob, uETilePanel,
  TplProgressBarUnit, lNet, rxclock, DCPrijndael;

type

  { TForm1 }

  TForm1 = class(TForm)
    BExit: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    czasyautor: TMemoField;
    czasymute: TLargeintField;
    czasy_notnullautor: TMemoField;
    dbGridPytania: TDBGridPlus;
    DBMemo1: TDBMemo;
    aes: TDCP_rijndael;
    db_roznoarchive: TLargeintField;
    db_roznomemtime: TLargeintField;
    dsPytania: TDataSource;
    shared: TExtSharedCommunication;
    filmyfile_subtitle: TMemoField;
    czasy_notnull: TZQuery;
    czasyfilm1: TLargeintField;
    czasyid1: TLargeintField;
    czasynazwa1: TMemoField;
    czasy_notnullczas2: TLargeintField;
    czasy_notnullczas_do: TLargeintField;
    czasy_notnullczas_od: TLargeintField;
    DBGrid3: TDBGrid;
    DBText1: TDBText;
    db_rozautosort: TLargeintField;
    db_rozfilm_id: TLargeintField;
    DirectoryPack1: TDirectoryPack;
    cShutdown: TExtShutdown;
    filmylang: TMemoField;
    filmyposition: TLargeintField;
    filmystart0: TLargeintField;
    fmenu: TFullscreenMenu;
    ImageList2: TImageList;
    Label10: TLabel;
    Label9: TLabel;
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
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItem98: TMenuItem;
    MenuItem99: TMenuItem;
    mixer: TConsMixer;
    czasyczas2: TLargeintField;
    czasyczas_do: TLargeintField;
    czasyczas_od: TLargeintField;
    czasyc_flagi: TStringField;
    czasyfile_audio: TMemoField;
    czasyfilm: TLargeintField;
    czasyid: TLargeintField;
    czasynazwa: TMemoField;
    czasystatus: TLargeintField;
    cRozdzialy: TPanel;
    OpenDialog1: TOpenDialog;
    Panel12: TPanel;
    PlayCB: TSpeedButton;
    polfan: TPolfan;
    pop_roz: TPopupMenu;
    pop_pytania: TPopupMenu;
    pytaniaczas_dt: TTimeField;
    pytaniaklucz: TMemoField;
    pytanianick: TMemoField;
    pytaniapytanie_calc: TMemoField;
    pytaniaczas: TLargeintField;
    pytaniaid: TLargeintField;
    pytaniapytanie: TMemoField;
    RxClock1: TRxClock;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SoundLevel: TEdit;
    Label8: TLabel;
    MenuItem63: TMenuItem;
    MenuItem65: TMenuItem;
    pp1: TplProgressBar;
    Presentation: TPresentation;
    filmyaudio: TLargeintField;
    filmyaudioeq: TMemoField;
    filmyfile_audio: TMemoField;
    filmyglosnosc: TLargeintField;
    filmyosd: TLargeintField;
    filmyresample: TLargeintField;
    filmystatus: TLargeintField;
    filmywzmocnienie: TBooleanField;
    film_play: TZQuery;
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
    N5: TMenuItem;
    N4: TMenuItem;
    SaveDialogFilm: TSaveDialog;
    SelDirPic: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Timer1: TTimer;
    tAutor: TTimer;
    tFilm: TTimer;
    tcp_timer: TTimer;
    tbk: TTimer;
    tCurOff: TTimer;
    t_tcp_exit: TTimer;
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
    MenuItem35: TMenuItem;
    tcp: TNetSocket;
    rfilmy: TIdleTimer;
    filmyc_plik_exist: TBooleanField;
    filmyid: TLargeintField;
    filmylink: TMemoField;
    filmynazwa: TMemoField;
    filmyplik: TMemoField;
    filmyrozdzial: TLargeintField;
    filmysort: TLargeintField;
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
    uELED2: TuELED;
    uELED3: TuELED;
    uELED4: TuELED;
    uELED5: TuELED;
    uELED6: TuELED;
    uELED7: TuELED;
    uELED8: TuELED;
    uELED9: TuELED;
    UOSalarm: TUOSPlayer;
    UOSpodklad: TUOSPlayer;
    UOSszum: TUOSPlayer;
    upnp: TUpnp;
    youtube: TYoutubeDownloader;
    ytdir: TSelectDirectoryDialog;
    MenuItem25: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    DBLookupComboBox1: TDBLookupComboBox;
    db_roz: TZQuery;
    db_rozid: TLargeintField;
    db_roznazwa: TMemoField;
    db_rozsort: TLargeintField;
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
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TuETilePanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ds_test_czas: TDataSource;
    Label2: TLabel;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
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
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
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
    filmy: TZQuery;
    czasy: TZQuery;
    pytania: TZQuery;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure csvAfterRead(Sender: TObject);
    procedure csvBeforeRead(Sender: TObject);
    procedure csvRead(Sender: TObject; NumberRec, PosRec: integer; sName,
      sValue: string; var Stopped: boolean);
    procedure czasyCalcFields(DataSet: TDataSet);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
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
    procedure ds_rozDataChange(Sender: TObject; Field: TField);
    procedure filmyBeforeOpen(DataSet: TDataSet);
    procedure filmyCalcFields(DataSet: TDataSet);
    procedure film_playBeforeOpen(DataSet: TDataSet);
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
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
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
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem70Click(Sender: TObject);
    procedure MenuItem71Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem75Click(Sender: TObject);
    procedure MenuItem76Click(Sender: TObject);
    procedure MenuItem77Click(Sender: TObject);
    procedure MenuItem79Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem80Click(Sender: TObject);
    procedure MenuItem81Click(Sender: TObject);
    procedure MenuItem82Click(Sender: TObject);
    procedure MenuItem84Click(Sender: TObject);
    procedure MenuItem85Click(Sender: TObject);
    procedure MenuItem86Click(Sender: TObject);
    procedure MenuItem88Click(Sender: TObject);
    procedure MenuItem89Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem90Click(Sender: TObject);
    procedure MenuItem91Click(Sender: TObject);
    procedure MenuItem92Click(Sender: TObject);
    procedure MenuItem93Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure miPlayerClick(Sender: TObject);
    procedure mplayerBeforePlay(ASender: TObject; AFilename: string);
    procedure mplayerBeforeStop(Sender: TObject);
    procedure mplayerGrabImage(ASender: TObject; AFilename: String);
    procedure mplayerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mplayerPause(Sender: TObject);
    procedure mplayerPlay(Sender: TObject);
    procedure mplayerPlaying(ASender: TObject; APosition, ADuration: single);
    procedure mplayerReplay(Sender: TObject);
    procedure mplayerSetPosition(Sender: TObject);
    procedure mplayerStop(Sender: TObject);
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
    procedure polfanReadDocument(Sender: TObject; AName: string;
      AMode: TPolfanRoomMode; AMessage: string; ADocument: TStrings;
      ARefresh: boolean);
    procedure pp1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pp_mouseStartTimer(Sender: TObject);
    procedure pp_mouseTimer(Sender: TObject);
    procedure PresentationClick(aButton: integer; var aTestDblClick: boolean);
    procedure PresentationClickLong(aButton: integer; aDblClick: boolean);
    procedure PropStorageRestoringProperties(Sender: TObject);
    procedure PropStorageSavingProperties(Sender: TObject);
    procedure pytaniaCalcFields(DataSet: TDataSet);
    procedure restart_csvTimer(Sender: TObject);
    procedure RewindClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure rfilmyTimer(Sender: TObject);
    procedure sharedMessage(Sender: TObject; AMessage: string);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure tAutorStartTimer(Sender: TObject);
    procedure tAutorStopTimer(Sender: TObject);
    procedure tAutorTimer(Sender: TObject);
    procedure tbkStopTimer(Sender: TObject);
    procedure tbkTimer(Sender: TObject);
    procedure tcpConnect(aSocket: TLSocket);
    procedure tcpCryptBinary(const indata; var outdata; var size: longword);
    procedure tcpCryptString(var aText: string);
    procedure tcpDecryptBinary(const indata; var outdata; var size: longword);
    procedure tcpDecryptString(var aText: string);
    procedure tcpProcessMessage;
    procedure tcpReceiveString(aMsg: string; aSocket: TLSocket;
      aBinSize: integer; var aReadBin: boolean);
    procedure tcpStatus(aActive, aCrypt: boolean);
    procedure tCurOffTimer(Sender: TObject);
    procedure test_czasBeforeOpen(DataSet: TDataSet);
    procedure tFilmTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure timer_info_tasmyTimer(Sender: TObject);
    procedure timer_obrazyTimer(Sender: TObject);
    procedure tPytanieStartTimer(Sender: TObject);
    procedure tPytanieStopTimer(Sender: TObject);
    procedure tPytanieTimer(Sender: TObject);
    procedure tzegarTimer(Sender: TObject);
    procedure t_tcp_exitTimer(Sender: TObject);
    procedure uEKnob1Change(Sender: TObject);
    procedure uEKnob1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure uELED1Click(Sender: TObject);
    procedure uELED2Click(Sender: TObject);
    procedure uELED3Change(Sender: TObject);
    procedure uELED8Change(Sender: TObject);
    procedure uELED9Click(Sender: TObject);
    procedure UOSpodkladBeforeStart(Sender: TObject);
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
    trans_serwer: boolean;
    trans_film_tytul: string;
    trans_film_czasy: TStrings;
    trans_indeksy: TStrings;
    key_ignore: TStringList;
    KeyPytanie: string;
    tak_nie_k,tak_nie_v: TStringList;
    procedure zapisz(komenda: integer);
    procedure play_alarm;
    procedure TextToScreen(aString: string; aLength,aRows: integer; var aText: TStrings);
    procedure ComputerOff;
    function PragmaForeignKeys: boolean;
    procedure PragmaForeignKeys(aOn: boolean);
    procedure UpdateFilmToRoz(aRestore: boolean = false);
    procedure SeekPlay(aCzas: integer);
    procedure db_open;
    procedure db_close;
    function get_last_id: integer;
    procedure przyciski(v_playing: boolean);
    procedure update_dioda_tasma(aKlik: boolean = false);
    procedure wygeneruj_plik2(nazwa1: string = ''; nazwa2: string = ''; aS1: string =''; aS2: string = '');
    procedure wygeneruj_plik_autora(nazwa1: string = '');
    procedure usun_pozycje_czasu(wymog_potwierdzenia: boolean);
    procedure komenda_up;
    procedure komenda_down;
    procedure go_czas2;
    function go_up(force_id: integer = 0): boolean;
    function go_first(force_id: integer = 0): boolean;
    function go_down(force_id: integer = 0): boolean;
    function go_last(force_id: integer = 0): boolean;
    procedure resize_update_grid;
    procedure test_play;
    procedure test(APositionForce: single = 0.0);
    procedure czasy_edycja_188;
    procedure czasy_edycja_190;
    procedure czasy_edycja_191;
    procedure czasy_edycja_146;
    procedure reset_oo;
    procedure play_memory(nr: integer);
    procedure zmiana(aTryb: integer = 0);
    procedure przygotuj_do_transmisji;
    procedure DaneCzasoweDoTransmisji(var aTimeAct,aFilmLength,aFilmPos,aStat: integer; var aPosSingle: single);
    function RunCommandTransmission(aCommand: string; aRurka: integer = -1): string;
    procedure SendRamkaPP;
    procedure SendRamkaMonitor;
    procedure SendRamkaMonitor(aSocket: TLSocket; aIdRurki: integer = -1);
    procedure zapisz_na_tasmie(aFilm: string; aCzas: string = '');
    procedure PictureToVideo(aDir,aFilename,aExt: string);
    function mplayer_obraz_normalize(aPosition: integer): integer;
    procedure dodaj_czas(aIdFilmu,aCzas: integer; aComment: string = '');
    procedure zrob_zdjecie(aForce: boolean = false);
    procedure zrob_zdjecie_do_paint;
    procedure obraz_next;
    procedure obraz_prior;
    procedure go_fullscreen(aOff: boolean = false);
    procedure go_przelaczpokazywanieczasu;
    procedure go_beep;
    procedure SetCursorOnPresentation(aHideCursor: boolean);
    procedure musicload(aNo: integer = -1);
    procedure musicplay;
    procedure musicpause;
    procedure szumload(aNo: integer = -1);
    procedure szumplay;
    procedure szumpause;
    procedure tab_lamp_zapisz;
    procedure tab_lamp_odczyt(aOnlyRefreshLamp: boolean = false);
    procedure dodaj_pozycje_na_koniec_listy(aSkopiujTemat: boolean = false);
    procedure DeleteFilm(aDB: boolean = true; aFile: boolean = true; aBezPytan: boolean = false);
    procedure sciagnij_film(aDownloadAll: boolean = false);
    procedure scisz10;
    procedure zglosnij10;
    procedure menu_rozdzialy(aOn: boolean = true);
    procedure dodaj_film(aNaPoczatku: boolean = false);
    procedure zapisz_temat(aForceStr: string = '');
    procedure update_mute(aMute: boolean = false);
    procedure _mplayerBeforePlay(Sender: TObject; AFileName: string);
    procedure _mpvBeforePlay(Sender: TObject; AFileName: string);
    procedure _ustaw_cookies;
    procedure pytanie_add(aKey,aNick,aPytanie,aCzas: string);
    procedure pytanie(aKey: string = ''; aNick: string = ''; aPytanie: string = '');
    procedure tak_nie_przelicz;
    procedure ppause(aNr: integer);
    procedure pplay(aNr: integer; aForce: boolean = false);
    procedure playpause(aPlayForce: boolean = false);
    function GetCanal(aKey: string): integer;
    procedure wykonaj_komende(aCommand: string);
    function GetMCMT(aOdPoczatku: boolean = false): string;
    function SetMCMT(aSciezka: string = ''): string;
  protected
    //procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  ecode, serwis, keystd, lista, czas, lista_wyboru, config,
  lcltype, LCLIntf, Clipbrd,
  transmisja, zapis_tasmy, audioeq, panmusic, rozdzial,
  yt_selectfiles, ImportDirectoryYoutube, screen_unit, ankiety, cytaty;

type
  TMemoryLamp = record
    active: boolean;
    rozdzial,indeks,indeks_czasu: integer;
    time: single;
  end;
  TYoutubeElement = record
    link: string;
    film: integer;
    dir: string;
    audio,video: integer;
  end;
  PYoutubeElement = ^TYoutubeElement;

var
  pilot: TArchitektPilot;
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
    osd,audio,resample,start0: integer;
    nazwa,autor,link,plik: string;
    wzmocnienie,glosnosc,position: integer;
    audioeq,file_audio,lang,file_subtitle: string;
    s1,s2,s3,s4,s5: string;
    mute: boolean;
    nomemtime,noarchive: integer;
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
  czas_aktualny_nazwa: string;
  czas_aktualny_indeks: integer = -1;
  bcenzura: boolean = false;
  auto_memory: array [1..4] of integer;
  vv_wzmocnienie: boolean = false;
  vv_glosnosc: integer = 0;
  vv_obrazy: boolean = false;
  vv_transmisja: boolean = false;
  vv_szum: boolean = false;
  vv_normalize: boolean = false;
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
    wygeneruj_plik2(film_tytul);
  end;
end;

procedure TForm1.PlayRecClick(Sender: TObject);
begin
  if precord and miPresentation.Checked then exit;
  precord:=not precord;
  if precord then
  begin
    PlayRec.ImageIndex:=40;
    update_dioda_tasma;
  end else begin
    PlayRec.ImageIndex:=39;
    update_dioda_tasma;
  end;
  if precord then
  begin
    tasma_s1:='';
    tasma_s2:='';
    dm.tasma_clear.Execute;
    if pytania.Active then pytania.Refresh;
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

procedure PolfanMessageToUserText(aMessage: string; var aUser,aText: string);
var
  a: integer;
begin
  a:=pos(':',aMessage);
  aUser:=trim(copy(aMessage,1,a-1));
  aText:=trim(copy(aMessage,a+1,maxint));
end;

procedure TForm1.polfanReadDocument(Sender: TObject; AName: string;
  AMode: TPolfanRoomMode; AMessage: string; ADocument: TStrings;
  ARefresh: boolean);
var
  s,user,message: string;
  b: boolean;
begin
  if (Aname='StudioJahu') and (Amode=rmRoom) then
  begin
    s:=trim(DelHtml(AMessage));
    if length(s)=0 then exit;
    if s[1]='*' then exit;
    PolfanMessageToUserText(s,user,message);
    b:=pos('??',message)>0;
    if b then
    begin
      while pos('??',message)>0 do message:=StringReplace(message,'??','?',[rfReplaceAll]);
      pytanie_add('{polfan:'+user+'}',user,message,'');
      polfan.SendText('{"numbers":[410],"strings":["<'+SColorToHtmlColor(clRed)+'>** Pytanie od użytkownika '+user+' przyjęte.", "'+polfan.Room+'"]}')
    end;
  end;
end;

procedure TForm1.pp1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  a: integer;
begin
  pp1.Position:=round(pp1.Max*X/pp1.Width);
  Timer1.Enabled:=true;
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
    filmy.First;
    filmy.Locate('id',i,[]);
    czasy.First;
    czasy.Locate('id',i2,[]);
    {uruchomienie filmu}
    dm.film.ParamByName('id').AsInteger:=i;
    dm.film.Open;
    nazwa:=dm.film.FieldByName('nazwa').AsString;
    link:=dm.film.FieldByName('link').AsString;
    plik:=dm.film.FieldByName('plik').AsString;
    if dm.film.FieldByName('wzmocnienie').IsNull then vv_wzmocnienie:=false else vv_wzmocnienie:=dm.film.FieldByName('wzmocnienie').AsBoolean;
    if dm.film.FieldByName('glosnosc').IsNull then vv_glosnosc:=0 else vv_glosnosc:=dm.film.FieldByName('glosnosc').AsInteger;
    vv_link:=dm.film.FieldByName('link').AsString;
    vv_plik:=dm.film.FieldByName('plik').AsString;
    vv_obrazy:=GetBit(dm.film.FieldByName('status').AsInteger,0);
    vv_transmisja:=GetBit(dm.film.FieldByName('status').AsInteger,1);
    vv_osd:=dm.film.FieldByName('osd').AsInteger;
    vv_audio:=dm.film.FieldByName('audio').AsInteger;
    vv_resample:=dm.film.FieldByName('resample').AsInteger;
    vv_audioeq:=dm.film.FieldByName('audioeq').AsString;
    vv_audio1:=dm.film.FieldByName('file_audio').AsString;
    vv_szum:=GetBit(dm.film.FieldByName('status').AsInteger,2);
    vv_normalize:=GetBit(dm.film.FieldByName('status').AsInteger,3);
    vv_novideo:=GetBit(filmystatus.AsInteger,5);
    vStart0:=dm.film.FieldByName('start0').AsInteger=1;
    vv_lang:=dm.film.FieldByName('lang').AsString;
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
  end else begin
    tryb:=aTryb;
    uELED1.Active:=tryb=1;
    uELED2.Active:=tryb=2;
  end;
  if _DEF_GREEN_SCREEN then if _SET_GREEN_SCREEN then fscreen.film(uELED2.Active);
  //if (a=1) and (tryb=2) then Presentation.SendKey(ord('Q'));
  //if (a=2) and (tryb=1) then Presentation.SendKey(ord('X'));
  if (a=1) and (tryb=2) then wykonaj_komende('obs-cli --password 123ikpd sceneitem show "KAMERA + VIDEO" Video');
  if (a=2) and (tryb=1) then wykonaj_komende('obs-cli --password 123ikpd sceneitem hide "KAMERA + VIDEO" Video');
end;

procedure TForm1.przygotuj_do_transmisji;
var
  stat: integer;
  istatus: boolean;
begin
  trans_film_tytul:=filmynazwa.AsString;
  trans_film_czasy.Clear;
  trans_indeksy.Clear;
  if czasy.RecordCount>0 then
  begin
    test_czas.ParamByName('id').AsInteger:=filmyid.AsInteger;
    test_czas.Open;
    while not test_czas.EOF do
    begin
      stat:=test_czas.FieldByName('status').AsInteger;
      istatus:=GetBit(stat,1);
      if istatus then
      begin
        test_czas.Next;
        continue;
      end;
      trans_indeksy.Add(test_czas.FieldByName('id').AsString);
      trans_film_czasy.Add(test_czas.FieldByName('nazwa').AsString);
      test_czas.Next;
    end;
    test_czas.Close;
  end;
end;

procedure TForm1.DaneCzasoweDoTransmisji(var aTimeAct, aFilmLength, aFilmPos,
  aStat: integer; var aPosSingle: single);
begin
  if mplayer.Running then
  begin
    if mplayer.Playing then aStat:=1 else aStat:=2;
  end else aStat:=0;
  if aStat>0 then
  begin
    repeat
      Application.ProcessMessages;
      aFilmLength:=TimeToInteger(mplayer.Duration/SecsPerDay);
    until aFilmLength>0;
    aTimeAct:=TimeToInteger(time);
    aPosSingle:=mplayer.Position;
    aFilmPos:=TimeToInteger(aPosSingle/SecsPerDay);
  end else begin
    aFilmLength:=0;
    aTimeAct:=0;
    aFilmPos:=0;
    aPosSingle:=0;
  end;
end;

function TForm1.RunCommandTransmission(aCommand: string; aRurka: integer
  ): string;
var
  s,s1: string;
  a: integer;
  czas_aktualny,film_duration,film_pos,film_stat: integer;
  posit: single;
begin
  if aCommand='{READ_ALL}' then
  begin
    DaneCzasoweDoTransmisji(czas_aktualny,film_duration,film_pos,film_stat,posit);
    s1:=FormatFloat('0.000000',posit);
    if indeks_play>-1 then
    begin
      if indeks_czas>-1 then a:=StringToItemIndex(trans_indeksy,IntToStr(indeks_czas));
      s:='{READ_ALL}$'+IntToStr(aRurka)+'$'+IntToStr(a)+'$'+trans_tytul+'$'+trans_opis.Text+'$'+IntToStr(film_stat)+'$'+ExtractFilename(mplayer.Filename)+'$'+IntToStr(czas_aktualny)+'$'+IntToStr(film_duration)+'$'+IntToStr(film_pos)+'$'+trans_film_tytul+'$'+StringReplace(trans_film_czasy.Text,#10,'|',[rfReplaceAll])+'$'+s1;
    end else
      s:='{READ_ALL}$'+IntToStr(aRurka)+'$'+IntToStr(indeks_czas)+'$'+trans_tytul+'$'+trans_opis.Text+'$0';
    s:=StringReplace(s,#10,'',[rfReplaceAll]);
    s:=StringReplace(s,#13,'',[rfReplaceAll]);
  end else
  if aCommand='{RAMKA_PP}' then
  begin
    DaneCzasoweDoTransmisji(czas_aktualny,film_duration,film_pos,film_stat,posit);
    s1:=FormatFloat('0.000000',posit);
    s:='{RAMKA_PP}$'+IntToStr(aRurka)+'$'+IntToStr(film_stat)+'$'+ExtractFilename(mplayer.Filename)+'$'+IntToStr(czas_aktualny)+'$'+IntToStr(film_duration)+'$'+IntToStr(film_pos)+'$'+s1;
  end;
  result:=s;
end;

procedure TForm1.SendRamkaPP;
var
  s: string;
begin
  s:=RunCommandTransmission('{RAMKA_PP}');
  if s='' then exit;
  tcp.SendString(s);
end;

procedure TForm1.SendRamkaMonitor;
var
  s: string;
begin
  s:='{CAMERAS}$'+IntToStr(_MONITOR_CAM);
  tcp.SendString(s);
end;

procedure TForm1.SendRamkaMonitor(aSocket: TLSocket; aIdRurki: integer);
var
  s: string;
begin
  s:='{CAMERAS}$'+IntToStr(aIdRurki)+'$'+IntToStr(_MONITOR_CAM);
  tcp.SendString(s,aSocket);
end;

procedure TForm1.zapisz_na_tasmie(aFilm: string; aCzas: string);
var
  a: integer;
  s1,s2: string;
begin
  if precord then
  begin
    a:=LiveTimer.GetIndexTime;
    s1:=aFilm;
    s2:=aCzas;
    if (s1=tasma_s1) and (s2=tasma_s2) then exit;
    tasma_s1:=s1;
    tasma_s2:=s2;
    dm.tasma_add.ParamByName('czas').AsInteger:=a;
    dm.tasma_add.ParamByName('nazwa_filmu').AsString:=s1;
    dm.tasma_add.ParamByName('nazwa_czasu').AsString:=s2;
    dm.tasma_add.ExecSQL;
    update_dioda_tasma(true);
    timer_info_tasmy.Enabled:=true;
  end;
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
  //trans.StartTransaction;
  filmy.Append;
  filmy.FieldByName('nazwa').AsString:='Film z obrazów';
  filmy.FieldByName('link').Clear;
  filmy.FieldByName('plik').AsString:=aFilename;
  filmy.FieldByName('rozdzial').AsInteger:=db_rozid.AsInteger;
  vstatus:=0;
  SetBit(vstatus,0,true);
  filmystatus.AsInteger:=vstatus;
  filmy.Post;
  dm.dbini.Execute;
  //trans.Commit;
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
begin
  dm.trans.StartTransaction;
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  if aComment='' then czasy.FieldByName('nazwa').AsString:='..' else
    czasy.FieldByName('nazwa').AsString:=aComment;
  czasy.FieldByName('czas_od').AsInteger:=aCzas;
  czasy.Post;
  dm.trans.Commit;
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

procedure TForm1.musicload(aNo: integer);
var
  l: integer;
  p: string;
  s: TStringList;
begin
  if aNo>-1 then l:=aNo else l:=music_no;
  p:=MyConfDir('music.conf');
  if FileExists(p) then
  begin
    Label8.Caption:=IntToStr(l+1);
    s:=TStringList.Create;
    try
      s.LoadFromFile(p);
      if s.Count>l then
      begin
        music_no:=l;
        if miPresentation.Checked then
        begin
          if UOSPodklad.FileName<>s[music_no] then
          begin
            if UOSPodklad.Busy then
            begin
              UOSpodklad.Stop;
              while UOSPodklad.Busy do application.ProcessMessages;
            end;
            UOSPodklad.FileName:=s[music_no];
          end;
          if uELED9.Active and ((not mplayer.Playing) or (mplayer.Paused)) then if not UOSPodklad.Busy then UOSPodklad.Start else UOSpodklad.Replay;
        end;
      end else uELED9.Active:=false;
    finally
      s.Free;
    end;
  end else uELED9.Active:=false;
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
         dm.dbini.Execute;
         dm.trans.Commit;
         db_roz.Refresh;
         lista_wybor.Clear;
         klucze_wybor.Clear;
       end;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
var
  b: boolean;
  temat: string;
begin
  b:=CheckBox1.Checked;
  tak_nie_k.Clear;
  tak_nie_v.Clear;
  if b then
  begin
    (* ustawiam temat ankiety *)
    FAnkiety:=TFAnkiety.Create(self);
    FAnkiety.io_tryb:=2; //1 - edycja, 2 - lista wyboru
    try
      FAnkiety.ShowModal;
      temat:=FAnkiety.io_tekst;
    finally
      FAnkiety.Free;
    end;
    if temat='[ANULUJ]' then
    begin
      CheckBox1.Checked:=false;
      exit;
    end else if temat='' then temat:='Ankieta/Głosowanie:';
    (* resetuję rejestry i uruchamiam głosowanie *)
    fscreen.tak_nie(0,0,temat);
    tcp.SendString('{INF2}$-1$1$'+temat);
  end else begin
    (* resetuję rejestry i wyłączam głosowanie *)
    fscreen.tak_nie;
    tcp.SendString('{INF2}$-1$0');
  end;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
var
  b: boolean;
  s1,s2,s3: string;
begin
  b:=CheckBox2.Checked;
  if b then
  begin
    (* ustawiam temat ankiety *)
    FCytaty:=TFCytaty.Create(self);
    FCytaty.io_tryb:=2; //1 - edycja, 2 - lista wyboru
    try
      FCytaty.ShowModal;
      s1:=FCytaty.io_tytul;
      s2:=FCytaty.io_cytat;
      s3:=FCytaty.io_zrodlo;
    finally
      FCytaty.Free;
    end;
    if s1='' then
    begin
      CheckBox2.Checked:=false;
      exit;
    end;
    (* resetuję rejestry i uruchamiam głosowanie *)
    fscreen.cytat(s1,s2,s3);
  end else begin
    (* resetuję rejestry i wyłączam głosowanie *)
    fscreen.cytat;
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: miPlayer.Checked:=true;
    1: miRecord.Checked:=true;
    2: miPresentation.Checked:=true;
  end;
  uELED6.Active:=false;
  uELED7.Active:=false;
  uELED8.Active:=false;
  case ComboBox1.ItemIndex of
    0: uELED6.Active:=true;
    1: uELED7.Active:=true;
    2: uELED8.Active:=true;
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
  if _DEF_POLFAN then
  begin
    if miPresentation.Checked then
    begin
      if not polfan.Active then polfan.Connect;
    end else begin
      if polfan.Active then polfan.Disconnect;
    end;
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
      3: rec.sort:=StrToInt(sValue);
      4: rec.nazwa:=sValue;
      5: if sValue='' then rec.asort:=0 else rec.asort:=StrToInt(sValue);
      6: if (sValue='') or (sValue='[null]') then rec.film:=-1 else rec.film:=StrToInt(sValue);
      7: rec.nomemtime:=StrToInt(sValue);
      8: rec.noarchive:=StrToInt(sValue);
    end;
    if PosRec=8 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             dm.add_rec0.ParamByName('id').AsInteger:=rec.id;
             dm.add_rec0.ParamByName('sort').AsInteger:=rec.sort;
             dm.add_rec0.ParamByName('nazwa').AsString:=rec.nazwa;
             dm.add_rec0.ParamByName('autosort').AsInteger:=rec.asort;
             if rec.film=-1 then dm.add_rec0.ParamByName('film').Clear else dm.add_rec0.ParamByName('film').AsInteger:=rec.film;
             dm.add_rec0.ParamByName('nomemtime').AsInteger:=rec.nomemtime;
             dm.add_rec0.ParamByName('noarchive').AsInteger:=rec.noarchive;
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
       3: rec.sort:=StrToInt(sValue);
       4: if sValue='[null]' then rec.link:='' else rec.link:=sValue;
       5: if sValue='[null]' then rec.plik:='' else rec.plik:=sValue;
       6: if sValue='[null]' then rec.rozdzial:=-1 else rec.rozdzial:=StrToInt(sValue);
       7: rec.nazwa:=sValue;
       8: if sValue='[null]' then rec.wzmocnienie:=-1 else rec.wzmocnienie:=StrToInt(sValue);
       9: if sValue='[null]' then rec.glosnosc:=-1 else rec.glosnosc:=StrToInt(sValue);
      10: if sValue='[null]' then rec.status:=0 else rec.status:=StrToInt(sValue);
      11: if sValue='[null]' then rec.osd:=0 else rec.osd:=StrToInt(sValue);
      12: if sValue='[null]' then rec.audio:=0 else rec.audio:=StrToInt(sValue);
      13: if sValue='[null]' then rec.resample:=0 else rec.resample:=StrToInt(sValue);
      14: if sValue='[null]' then rec.audioeq:='' else rec.audioeq:=sValue;
      15: if sValue='[null]' then rec.file_audio:='' else rec.file_audio:=sValue;
      16: if sValue='[null]' then rec.lang:='' else rec.lang:=sValue;
      17: if sValue='[null]' then rec.position:=-1 else rec.position:=StrToInt(sValue);
      18: if sValue='[null]' then rec.file_subtitle:='' else rec.file_subtitle:=sValue;
      19: if sValue='[null]' then rec.start0:=0 else rec.start0:=StrToInt(sValue);
    end;
    if PosRec=19 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             if rec.link='"' then rec.link:='';
             dm.add_rec.ParamByName('id').AsInteger:=rec.id;
             dm.add_rec.ParamByName('sort').AsInteger:=rec.sort;
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
               dm.add_rec.ParamByName('sort').Clear;
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
  indeks_rozd:=filmyrozdzial.AsInteger;
  film_tytul:=filmy.FieldByName('nazwa').AsString;
  indeks_play:=filmy.FieldByName('id').AsInteger;
  indeks_czas:=-1;
  vv_link:=filmylink.AsString;
  vv_plik:=filmyplik.AsString;
  vv_wzmocnienie:=filmywzmocnienie.AsBoolean;
  vv_glosnosc:=filmyglosnosc.AsInteger;
  vv_obrazy:=GetBit(filmystatus.AsInteger,0);
  vv_transmisja:=GetBit(filmystatus.AsInteger,1);
  vv_szum:=GetBit(filmystatus.AsInteger,2);
  vv_novideo:=GetBit(filmystatus.AsInteger,5);
  vv_osd:=filmyosd.AsInteger;
  vv_audio:=filmyaudio.AsInteger;
  vv_lang:=filmylang.AsString;
  vv_resample:=filmyresample.AsInteger;
  vv_audioeq:=filmyaudioeq.AsString;
  vv_audio1:=filmyfile_audio.AsString;
  vv_mute:=false;
  vv_old_mute:=false;
  vv_normalize:=GetBit(filmystatus.AsInteger,3);
  start0:=filmystart0.AsInteger=1;
  playstart0:=GetBit(filmystatus.AsInteger,4);
  if not playstart0 then playstart0:=db_roznomemtime.AsInteger=1;
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
  if czasy.RecordCount=0 then zapisz_na_tasmie(film_tytul);
end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  b: boolean;
begin
  DBGrid1.Canvas.Font.Bold:=false;
  b:=filmyc_plik_exist.AsBoolean;
  if b then DBGrid1.Canvas.Font.Color:=clBlue else DBGrid1.Canvas.Font.Color:=TColor($333333);
  if indeks_play=filmyid.AsInteger then
  begin
    DBGrid1.Canvas.Font.Bold:=true;
    if b then
      DBGrid1.Canvas.Font.Color:=TColor($0E0044)
    else
      DBGrid1.Canvas.Font.Color:=clBlack;
  end;
  DBGrid1.DefaultDrawColumnCell(Rect,DataCol,Column,State);
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
  film_tytul:=filmy.FieldByName('nazwa').AsString;//+' - '+czasy.FieldByName('nazwa').AsString;
  vv_obrazy:=GetBit(filmystatus.AsInteger,0);
  vv_transmisja:=GetBit(filmystatus.AsInteger,1);
  vv_szum:=GetBit(filmystatus.AsInteger,2);
  vv_normalize:=GetBit(filmystatus.AsInteger,3);
  vv_novideo:=GetBit(filmystatus.AsInteger,5);
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
  indeks_rozd:=filmyrozdzial.AsInteger;
  indeks_play:=filmy.FieldByName('id').AsInteger;
  if indeks_czas>-1 then indeks_czas:=czasy.FieldByName('id').AsInteger;
  vv_link:=filmylink.AsString;
  vv_plik:=filmyplik.AsString;
  vv_wzmocnienie:=filmywzmocnienie.AsBoolean;
  vv_glosnosc:=filmyglosnosc.AsInteger;
  vv_osd:=filmyosd.AsInteger;
  vv_audio:=filmyaudio.AsInteger;
  vv_lang:=filmylang.AsString;
  vv_resample:=filmyresample.AsInteger;
  vv_audioeq:=filmyaudioeq.AsString;
  vv_audio1:=filmyfile_audio.AsString;
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
  filmy.First;
end;

procedure TForm1.db_rozAfterScroll(DataSet: TDataSet);
begin
  MenuItem70.Checked:=db_rozautosort.AsInteger=1;
  MenuItem98.Checked:=MenuItem70.Checked;
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

procedure TForm1.ds_rozDataChange(Sender: TObject; Field: TField);
begin
  if db_rozautosort.AsInteger=1 then filmy.SortedFields:='nazwa' else filmy.SortedFields:='';
end;

procedure TForm1.filmyBeforeOpen(DataSet: TDataSet);
begin
  if MenuItem25.Checked then filmy.ParamByName('all').AsInteger:=0
                        else filmy.ParamByName('all').AsInteger:=1;
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
begin
  if MenuItem25.Checked then film_play.ParamByName('all').AsInteger:=0
                        else film_play.ParamByName('all').AsInteger:=1;
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
  shared.Stop;
  go_fullscreen(true);
  application.ProcessMessages;
  if UOSPlayer.Busy or UOSpodklad.Busy or trans_serwer then
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
  wygeneruj_plik2;
  db_close;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  b15: boolean;
  res: TResourceStream;
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
    VK_O: if not miPresentation.Checked then go_przelaczpokazywanieczasu;
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

  {obsługa plików muzycznych}
  if (not _BLOCK_MUSIC_KEYS) and miPresentation.Checked then case Key of
    VK_1: musicload(0);
    VK_2: musicload(1);
    VK_3: musicload(2);
    VK_4: musicload(3);
    VK_5: musicload(4);
    VK_6: musicload(5);
    VK_7: musicload(6);
    VK_8: musicload(7);
    VK_9: musicload(8);
    VK_0: musicload(9);
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
    Memory_1.ImageIndex:=28;
  end;
end;

procedure TForm1.Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[2].active:=false;
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
    Memory_2.ImageIndex:=30;
  end;
end;

procedure TForm1.Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[3].active:=false;
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
    Memory_3.ImageIndex:=32;
  end;
end;

procedure TForm1.Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[4].active:=false;
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
    Memory_4.ImageIndex:=34;
  end;
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

procedure TForm1.mplayerStop(Sender: TObject);
var
  pom1,pom2,pom3: integer;
  s: string;
begin
  pplay(0,true);
  zapisz(0);
  DBGrid3.Visible:=_DEF_FULLSCREEN_MEMORY;
  cctimer_opt:=0;
  wygeneruj_plik2;
  if uELED9.Active then musicplay;
  szumpause;
  Edit1.Text:='';
  pom1:=indeks_rozd;
  pom2:=indeks_play;
  Play.ImageIndex:=0;
  const_mplayer_param:='';
  mplayer.StartParam:='';
  indeks_rozd:=-1;
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
  uELED5.Active:=false;
  DBGrid1.Refresh;
  DBGrid2.Refresh;
  przyciski(false);
  Play.ImageIndex:=0;
  Label3.Caption:='-:--';
  Label4.Caption:='-:--';
  pp.Position:=0;
  reset_oo;
  if trans_serwer then SendRamkaPP;
  if CLIPBOARD_PLAY then
  begin
    CLIPBOARD_PLAY:=false;
    exit;
  end;
  if (not stop_force) and miPlayer.Checked then
  begin
    if MenuItem100.Checked then
    begin
      if _DEF_FULLSCREEN_MEMORY then fmenu.Execute(2) else ComputerOff;
      exit;
    end;
    film_play.ParamByName('id').AsInteger:=pom1;
    film_play.Open;
    film_play.Locate('id',pom2,[]);
    film_play.Next;
    pom3:=film_play.FieldByName('id').AsInteger;
    if (pom2<>pom3) and (pom3<>0) then
    begin
      s:=film_play.FieldByName('plik').AsString;
      if (s='') or (not FileExists(s)) then s:=film_play.FieldByName('link').AsString;
      Edit1.Text:=s;
      indeks_rozd:=pom1;
      film_tytul:=film_play.FieldByName('nazwa').AsString;
      indeks_play:=film_play.FieldByName('id').AsInteger;
      indeks_czas:=-1;
      vv_wzmocnienie:=film_play.FieldByName('wzmocnienie').AsBoolean;
      vv_glosnosc:=film_play.FieldByName('glosnosc').AsInteger;
      vv_obrazy:=GetBit(film_play.FieldByName('status').AsInteger,0);
      vv_transmisja:=GetBit(film_play.FieldByName('status').AsInteger,1);
      vv_szum:=GetBit(film_play.FieldByName('status').AsInteger,2);
      vv_novideo:=GetBit(filmystatus.AsInteger,5);
      vv_osd:=film_play.FieldByName('osd').AsInteger;
      vv_audio:=film_play.FieldByName('audio').AsInteger;
      vv_resample:=film_play.FieldByName('resample').AsInteger;
      vv_audioeq:=film_play.FieldByName('audioeq').AsString;
      vv_audio1:=film_play.FieldByName('file_audio').AsString;
      vv_mute:=false;
      vv_old_mute:=false;
      Play.Click;
      if czasy.RecordCount=0 then zapisz_na_tasmie(film_tytul);
    end else begin
      if MenuItem101.Checked then
      begin
        if _DEF_FULLSCREEN_MEMORY then fmenu.Execute(2) else ComputerOff;
        exit;
      end;
      if not _DEF_FULLSCREEN_MEMORY then go_fullscreen(true);
    end;
    film_play.Close;
  end else if not _DEF_FULLSCREEN_MEMORY then go_fullscreen(true);
  stop_force:=false;
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
    aa:=IntegerToTime(a);
    bPos:=a<3600000;
    if bPos then podpowiedz2.Caption:=FormatDateTime('nn:ss',aa) else podpowiedz2.Caption:=FormatDateTime('h:nn:ss',aa);
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
    if czasy.FieldByName('czas_do').IsNull then FCzas.i_do:=0
    else FCzas.i_do:=czasy.FieldByName('czas_do').AsInteger;
    if czasymute.IsNull then FCzas.b_mute:=false else FCzas.b_mute:=czasymute.AsInteger=1;
    FCzas.in_tryb:=2;
    FCzas.ShowModal;
    if FCzas.out_ok then
    begin
      dm.trans.StartTransaction;
      czasy.Edit;
      czasy.FieldByName('nazwa').AsString:=FCzas.s_nazwa;
      if FCzas.s_autor='' then czasy.FieldByName('autor').Clear
                          else czasy.FieldByName('autor').AsString:=FCzas.s_autor;
      if FCzas.s_audio='' then czasy.FieldByName('file_audio').Clear
                          else czasy.FieldByName('file_audio').AsString:=FCzas.s_audio;
      if FCzas.b_mute then czasymute.AsInteger:=1 else czasymute.Clear;
      czasy.Post;
      dm.trans.Commit;
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

procedure TForm1.MenuItem13Click(Sender: TObject);
var
  a_id,a_od,a_do: integer;
  p_id,p_od,p_do: integer;
  id,pom1,pom2: integer;
  cod: integer;
begin
  a_id:=czasy.FieldByName('id').AsInteger;
  a_od:=czasy.FieldByName('czas_od').AsInteger;
  if czasy.FieldByName('czas_do').IsNull then a_do:=-1 else a_do:=czasy.FieldByName('czas_do').AsInteger;
  czasy_przed.ParamByName('id_aktualne').AsInteger:=a_id;
  czasy_przed.Open;
  if czasy_przed.IsEmpty then
  begin
    p_od:=0;
    p_do:=0;
  end else begin
    p_id:=czasy_przed.FieldByName('id').AsInteger;
    p_od:=czasy_przed.FieldByName('czas_od').AsInteger;
    if czasy_przed.FieldByName('czas_do').IsNull then p_do:=-1 else p_do:=czasy_przed.FieldByName('czas_do').AsInteger;
  end;
  czasy_przed.Close;

  if p_do=-1 then cod:=p_od else cod:=p_do;

  dm.trans.StartTransaction;
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  czasy.FieldByName('nazwa').AsString:='..';
  czasy.FieldByName('czas_od').AsInteger:=cod;
  czasy.FieldByName('czas_do').Clear;
  czasy.Post;
  czasy.Last;
  id:=czasy.FieldByName('id').AsInteger;
  dm.czasy_up_id.ParamByName('id').AsInteger:=id;
  dm.czasy_up_id.ParamByName('new_id').AsInteger:=0;
  dm.czasy_up_id.ExecSQL;

  czasy_od_id.ParamByName('id_aktualne').AsInteger:=a_id;
  czasy_od_id.Open;
  pom1:=id;
  while not czasy_od_id.EOF do
  begin
    pom2:=czasy_od_id.Fields[0].AsInteger;
    dm.czasy_up_id.ParamByName('id').AsInteger:=pom2;
    dm.czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
    dm.czasy_up_id.ExecSQL;
    czasy_od_id.Next;
    pom1:=pom2;
  end;
  dm.czasy_up_id.ParamByName('id').AsInteger:=0;
  dm.czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
  dm.czasy_up_id.ExecSQL;
  czasy_od_id.Close;
  dm.trans.Commit;
  czasy.Refresh;
  czasy.Locate('id',pom1,[]);
  test;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
var
  a_id,a_od,a_do: integer;
  p_id,p_od,p_do: integer;
  id,pom1,pom2: integer;
  cod: integer;
  ostatni: boolean;
begin
  a_id:=czasy.FieldByName('id').AsInteger;
  a_od:=czasy.FieldByName('czas_od').AsInteger;
  if czasy.FieldByName('czas_do').IsNull then a_do:=-1 else a_do:=czasy.FieldByName('czas_do').AsInteger;
  czasy_po.ParamByName('id_aktualne').AsInteger:=a_id;
  czasy_po.Open;
  if czasy_po.IsEmpty then ostatni:=true else
  begin
    p_id:=czasy_po.FieldByName('id').AsInteger;
    p_od:=czasy_po.FieldByName('czas_od').AsInteger;
    if czasy_po.FieldByName('czas_do').IsNull then p_do:=-1 else p_do:=czasy_po.FieldByName('czas_do').AsInteger;
    ostatni:=false;
  end;
  czasy_po.Close;

  if a_do=-1 then cod:=a_od else cod:=a_do;

  dm.trans.StartTransaction;
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  czasy.FieldByName('nazwa').AsString:='..';
  czasy.FieldByName('czas_od').AsInteger:=cod;
  czasy.FieldByName('czas_do').Clear;
  czasy.Post;
  czasy.Last;
  if ostatni then
  begin
    dm.trans.Commit;
    exit;
  end;
  id:=czasy.FieldByName('id').AsInteger;
  dm.czasy_up_id.ParamByName('id').AsInteger:=id;
  dm.czasy_up_id.ParamByName('new_id').AsInteger:=0;
  dm.czasy_up_id.ExecSQL;

  czasy_od_id.ParamByName('id_aktualne').AsInteger:=p_id;
  czasy_od_id.Open;
  pom1:=id;
  while not czasy_od_id.EOF do
  begin
    pom2:=czasy_od_id.Fields[0].AsInteger;
    dm.czasy_up_id.ParamByName('id').AsInteger:=pom2;
    dm.czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
    dm.czasy_up_id.ExecSQL;
    czasy_od_id.Next;
    pom1:=pom2;
  end;
  dm.czasy_up_id.ParamByName('id').AsInteger:=0;
  dm.czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
  dm.czasy_up_id.ExecSQL;
  czasy_od_id.Close;
  dm.trans.Commit;
  czasy.Refresh;
  czasy.Locate('id',pom1,[]);
  test;
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

procedure TForm1.MenuItem19Click(Sender: TObject);
var
  id_roz,id_filmu,id_czasu: integer;
  id,new_id: integer;
begin
  if not mess.ShowConfirmationYesNo('Baza danych zostanie zrestrukturyzowana, identyfikatory zostaną przepisane i nadane na nowo, po tej operacji baza zostanie spakowana, by zwolnić zajmowane miejsce na dysku.^^Czy kontynuować?') then exit;
  if filmy.IsEmpty then exit;
  id_roz:=db_roz.FieldByName('id').AsInteger;
  id_filmu:=filmy.FieldByName('id').AsInteger;
  if czasy.IsEmpty then id_czasu:=-1 else id_czasu:=czasy.FieldByName('id').AsInteger;
  dm.trans.StartTransaction;
  {rozdziały}
  dm.roz2.Open;
  new_id:=1;
  while not dm.roz2.EOF do
  begin
    id:=dm.roz2.FieldByName('id').AsInteger;
    if id<>new_id then
    begin
      if id=id_roz then id_roz:=new_id;
      dm.rename_id0.ParamByName('id').AsInteger:=id;
      dm.rename_id0.ParamByName('new_id').AsInteger:=new_id;
      dm.rename_id0.Execute;
    end;
    inc(new_id);
    dm.roz2.Next;
  end;
  dm.roz2.Close;
  {filmy}
  dm.filmy2.Open;
  new_id:=1;
  while not dm.filmy2.EOF do
  begin
    id:=dm.filmy2.FieldByName('id').AsInteger;
    if id<>new_id then
    begin
      if id=id_filmu then id_filmu:=new_id;
      dm.rename_id.ParamByName('id').AsInteger:=id;
      dm.rename_id.ParamByName('new_id').AsInteger:=new_id;
      dm.rename_id.Execute;
    end;
    inc(new_id);
    dm.filmy2.Next;
  end;
  dm.filmy2.Close;
  {filmy - sort}
  dm.filmy3.Open;
  new_id:=1;
  while not dm.filmy3.EOF do
  begin
    id:=dm.filmy3.FieldByName('sort').AsInteger;
    if id<>new_id then
    begin
      if id=id_filmu then id_filmu:=new_id;
      dm.rename_id1.ParamByName('sort').AsInteger:=id;
      dm.rename_id1.ParamByName('new_sort').AsInteger:=new_id;
      dm.rename_id1.Execute;
    end;
    inc(new_id);
    dm.filmy3.Next;
  end;
  dm.filmy3.Close;
  {czasy}
  dm.czasy2.Open;
  new_id:=1;
  while not dm.czasy2.EOF do
  begin
    id:=dm.czasy2.FieldByName('id').AsInteger;
    if id<>new_id then
    begin
      if id=id_czasu then id_czasu:=new_id;
      dm.rename_id2.ParamByName('id').AsInteger:=id;
      dm.rename_id2.ParamByName('new_id').AsInteger:=new_id;
      dm.rename_id2.Execute;
    end;
    inc(new_id);
    dm.czasy2.Next;
  end;
  dm.czasy2.Close;
  dm.trans.Commit;
  dm.pakowanie_db.Execute;
  //filmy.Close;
  db_roz.Close;
  dm.db.Disconnect;
  dm.db.Connect;
  //filmy.Open;
  db_roz.Open;
  db_roz.Locate('id',id_roz,[]);
  filmy.Locate('id',id_filmu,[]);
  if id_czasu>-1 then czasy.Locate('id',id_czasu,[]);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  dodaj_film;
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var
  id_roz,id_filmu,id_czasu: integer;
begin
  if mess.ShowConfirmationYesNo('Baza danych zostanie spakowana, tj. usunięte zostaną rekordy wcześniej usunięte, które zajmują już tylko pamięć dyskową.^^Czy kontynuować?') then
  begin
    id_roz:=db_roz.FieldByName('id').AsInteger;
    if filmy.IsEmpty then id_filmu:=-1 else id_filmu:=filmy.FieldByName('id').AsInteger;
    if czasy.IsEmpty then id_czasu:=-1 else id_czasu:=czasy.FieldByName('id').AsInteger;
    dm.pakowanie_db.Execute;
    //filmy.Close;
    db_roz.Close;
    dm.db.Disconnect;
    dm.db.Connect;

    //filmy.Open;
    //if id_filmu>-1 then filmy.Locate('id',id_filmu,[]);
    //if id_czasu>-1 then czasy.Locate('id',id_czasu,[]);

    db_roz.Open;
    db_roz.Locate('id',id_roz,[]);
    filmy.Locate('id',id_filmu,[]);
    if id_czasu>-1 then czasy.Locate('id',id_czasu,[]);
  end;
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
begin
  if filmy.RecordCount=0 then exit;
  FLista:=TFLista.Create(self);
  try
    FLista.s_tytul:=filmy.FieldByName('nazwa').AsString;
    FLista.s_link:=filmy.FieldByName('link').AsString;
    FLista.s_file:=filmy.FieldByName('plik').AsString;
    FLista.s_audio:=filmyfile_audio.AsString;
    FLista.s_lang:=filmylang.AsString;
    FLista.s_subtitle:=filmyfile_subtitle.AsString;
    if filmy.FieldByName('rozdzial').IsNull then FLista.i_roz:=0
    else FLista.i_roz:=filmy.FieldByName('rozdzial').AsInteger;
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
    FLista.in_out_osd:=filmyosd.AsInteger;
    FLista.in_out_audio:=filmyaudio.AsInteger;
    FLista.in_out_resample:=filmyresample.AsInteger;
    FLista.in_out_start0:=filmystart0.AsInteger=1;
    FLista.in_tryb:=2;
    FLista.ShowModal;
    if FLista.out_ok then
    begin
      dm.trans.StartTransaction;
      filmy.Edit;
      filmy.FieldByName('nazwa').AsString:=FLista.s_tytul;
      if FLista.s_link='' then filmy.FieldByName('link').Clear else filmy.FieldByName('link').AsString:=FLista.s_link;
      if FLista.s_file='' then filmy.FieldByName('plik').Clear else filmy.FieldByName('plik').AsString:=FLista.s_file;
      if FLista.s_audio='' then filmyfile_audio.Clear else filmyfile_audio.AsString:=FLista.s_audio;
      if FLista.s_lang='' then filmylang.Clear else filmylang.AsString:=FLista.s_lang;
      if FLista.s_subtitle='' then filmyfile_subtitle.Clear else filmyfile_subtitle.AsString:=FLista.s_subtitle;
      if FLista.i_roz=0 then filmy.FieldByName('rozdzial').Clear
      else filmy.FieldByName('rozdzial').AsInteger:=FLista.i_roz;
      if FLista.in_out_wzmocnienie=-1 then filmywzmocnienie.Clear else filmywzmocnienie.AsBoolean:=FLista.in_out_wzmocnienie=1;
      if FLista.in_out_glosnosc=-1 then filmyglosnosc.Clear else filmyglosnosc.AsInteger:=FLista.in_out_glosnosc;
      SetBit(vstatus,0,FLista.in_out_obrazy);
      SetBit(vstatus,1,FLista.in_transmisja);
      SetBit(vstatus,2,FLista.in_szum);
      SetBit(vstatus,3,FLista.in_normalize);
      SetBit(vstatus,4,FLista.in_play_start0);
      SetBit(vstatus,5,FLista.in_play_novideo);
      filmystatus.AsInteger:=vstatus;
      filmyosd.AsInteger:=FLista.in_out_osd;
      filmyaudio.AsInteger:=FLista.in_out_audio;
      filmyresample.AsInteger:=FLista.in_out_resample;
      if FLista.in_out_start0 then filmystart0.AsInteger:=1 else filmystart0.AsInteger:=0;
      filmy.Post;
      dm.trans.Commit;
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
    FRozdzial.io_nazwa:=db_roz.FieldByName('nazwa').AsString;
    FRozdzial.io_nomem:=db_roznomemtime.AsInteger=1;
    FRozdzial.io_noarchive:=db_roznoarchive.AsInteger=1;
    FRozdzial.ShowModal;
    if FRozdzial.io_zmiany then
    begin
      db_roz.Edit;
      db_roz.FieldByName('nazwa').AsString:=FRozdzial.io_nazwa;
      if FRozdzial.io_nomem then db_roznomemtime.AsInteger:=1 else db_roznomemtime.AsInteger:=0;
      if FRozdzial.io_noarchive then db_roznoarchive.AsInteger:=1 else db_roznoarchive.AsInteger:=0;
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
      dm.roz_del2.ParamByName('id').AsInteger:=id;
      dm.roz_del2.Execute;
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
  cc: string;
  aa,vv: TStrings;
  a,v: integer;
begin
  if filmyc_plik_exist.AsBoolean then exit;
  if FileExists(_DEF_COOKIES_FILE_YT) then cc:=_DEF_COOKIES_FILE_YT else cc:='';
  aa:=TStringList.Create;
  vv:=TStringList.Create;
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
  youtube.AddLink(filmylink.AsString,dm.GetConfig('default-directory-save-files',''),a,v,filmyid.AsInteger);
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
var
  cc: string;
  t: TBookmark;
begin
  if filmy.IsEmpty then exit;
  ytdir.InitialDir:=dm.GetConfig('default-directory-save-files','');
  if not ytdir.Execute then exit;
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
    youtube.AddLink(filmylink.AsString,ytdir.FileName,0,0,filmyid.AsInteger);
    filmy.Next;
  end;
  filmy.GotoBookmark(t);
  filmy.EnableControls;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
  FConfig:=TFConfig.Create(self);
  FConfig.ShowModal;
  pilot:=dm.pilot_wczytaj;
end;

procedure TForm1.MenuItem35Click(Sender: TObject);
var
  tryb: integer;
begin
  FTransmisja:=TFTransmisja.Create(self);
  try
    FTransmisja.ShowModal;
    if FTransmisja.out_ok then
    begin
      trans_tytul:=FTransmisja.Edit1.Text;
      trans_opis.Assign(FTransmisja.Memo1.Lines);
      trans_serwer:=FTransmisja.CheckBox1.Checked;
      trans_code:=FTransmisja.FCode.Text;
    end;
  finally
    FTransmisja.Free;
  end;
  if trans_serwer then
  begin
    if tcp.Active then
    begin
      tcp.Disconnect;
      sleep(250);
    end;
    tcp.MaxBuffer:=CONST_MAX_BUFOR;
    tcp.Host:='serwer';
    tcp.Port:=4681;
    tcp.Mode:=smClient;
    if not tcp.Connect then
    begin
      tcp.Port:=4682;
      tcp.Mode:=smClient;
      tcp.Connect;
    end;
  end;
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
    s:='R;'+dm.roz_id.FieldByName('id').AsString+';'+dm.roz_id.FieldByName('sort').AsString+';"'+dm.roz_id.FieldByName('nazwa').AsString+'"';
    if dm.roz_id.FieldByName('autosort').IsNull then s1:='0' else s1:=dm.roz_id.FieldByName('autosort').AsString;
    s:=s+';'+s1;
    if dm.roz_id.FieldByName('film_id').IsNull then s1:='[null]' else s1:=dm.roz_id.FieldByName('film_id').AsString;
    s:=s+';'+s1;
    s:=s+';'+dm.roz_id.FieldByName('nomemtime').AsString;
    s:=s+';'+dm.roz_id.FieldByName('noarchive').AsString;
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

    s:='F;'+dm.filmy_id.FieldByName('id').AsString+';'+dm.filmy_id.FieldByName('sort').AsString+';'+link+';'+plik+';'+p1+';'+nazwa+';'+s1+';'+s2+';'+dm.filmy_id.FieldByName('status').AsString;
    s:=s+';'+dm.filmy_id.FieldByName('osd').AsString+';'+dm.filmy_id.FieldByName('audio').AsString+';'+dm.filmy_id.FieldByName('resample').AsString;
    if dm.filmy_id.FieldByName('audioeq').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('audioeq').AsString+'"';
    if dm.filmy_id.FieldByName('file_audio').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('file_audio').AsString+'"';
    if dm.filmy_id.FieldByName('lang').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('lang').AsString+'"';
    if dm.filmy_id.FieldByName('position').IsNull then s:=s+';[null]' else s:=s+';'+dm.filmy_id.FieldByName('position').AsString;
    if dm.filmy_id.FieldByName('file_subtitle').IsNull then s:=s+';[null]' else s:=s+';"'+dm.filmy_id.FieldByName('file_subtitle').AsString+'"';
    s:=s+';'+dm.filmy_id.FieldByName('start0').AsString;
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
      dm.dbini.Execute;
    end;
    dm.trans.Commit;
  finally
    ss.Free;
  end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  go_up;
end;

procedure TForm1.MenuItem70Click(Sender: TObject);
begin
  MenuItem70.Checked:=not MenuItem70.Checked;
  MenuItem98.Checked:=MenuItem70.Checked;
  db_roz.Edit;
  if MenuItem70.Checked then db_rozautosort.AsInteger:=1 else db_rozautosort.AsInteger:=0;
  db_roz.Post;
end;

procedure TForm1.MenuItem71Click(Sender: TObject);
begin
  FImportDirectoryYoutube:=TFImportDirectoryYoutube.Create(self);
  try
    FImportDirectoryYoutube.ShowModal;
  finally
    FImportDirectoryYoutube.Free;
  end;
end;

procedure TForm1.MenuItem72Click(Sender: TObject);
begin
  //ffmpeg -i input.mp3 -ss 00:02:54.583 -t 300 -acodec copy output.mp3
  //ffmpeg -i input.mp3 -ss 00:02:54.583 --to 00:04:20.583 -acodec copy output.mp3
  mess.ShowInformation('Opcja przyszłościowa');
end;

procedure TForm1.MenuItem75Click(Sender: TObject);
begin
  dodaj_film(true);
end;

procedure TForm1.MenuItem76Click(Sender: TObject);
begin
  zapisz_temat;
end;

procedure TForm1.MenuItem77Click(Sender: TObject);
var
  s: string;
begin
  s:=trim(czasynazwa.AsString);
  if s='' then exit;
  zapisz_temat(s);
  zapisz_na_tasmie('[TEMAT]',s);
end;

procedure TForm1.MenuItem79Click(Sender: TObject);
begin
  MenuItem79.Checked:=not MenuItem79.Checked;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  go_down;
end;

procedure TForm1.MenuItem80Click(Sender: TObject);
begin
  zrob_zdjecie(true);
end;

procedure TForm1.MenuItem81Click(Sender: TObject);
begin
  if pytania.IsEmpty then exit;
  pytania.Delete;
  pytanie;
end;

procedure TForm1.MenuItem82Click(Sender: TObject);
begin
  key_ignore.Add(pytaniaklucz.AsString);
  dm.ikeyadd.ParamByName('klucz').AsString:=pytaniaklucz.AsString;
  dm.ikeyadd.ExecSQL;
  pytania.DisableControls;
  pytania.Close;
  pytania.Open;
  pytania.EnableControls;
end;

procedure TForm1.MenuItem84Click(Sender: TObject);
begin
  if pytania.IsEmpty then exit;
  pytanie(pytaniaklucz.AsString,pytanianick.AsString,pytaniapytanie.AsString);
end;

procedure TForm1.MenuItem85Click(Sender: TObject);
begin
  pytanie;
  SpeedButton3.Font.Style:=[];
end;

procedure TForm1.MenuItem86Click(Sender: TObject);
begin
  MenuItem86.Checked:=not MenuItem86.Checked;
  _DEF_GREEN_SCREEN:=MenuItem86.Checked;
  dm.SetConfig('default-green-screen',_DEF_GREEN_SCREEN);
end;

procedure TForm1.MenuItem88Click(Sender: TObject);
var
  s: TStringList;
  i: integer;
begin
  s:=TStringList.Create;
  try
    if OpenDialog1.Execute then
    begin
      s.LoadFromFile(OpenDialog1.FileName);
      for i:=0 to s.Count-1 do
      begin
        if (i mod 2) = 0 then
        begin
          pytania.Append;
          pytaniaczas.AsInteger:=TimeToInteger;
          pytanianick.AsString:=s[i];
        end else begin
          pytaniapytanie.AsString:=s[i];
          pytania.Post;
        end;
      end;
      if pytania.State in [dsEdit,dsInsert] then pytania.Cancel;
    end;
  finally
    s.Free;
  end;
end;

procedure TForm1.MenuItem89Click(Sender: TObject);
begin
  FAnkiety:=TFAnkiety.Create(self);
  FAnkiety.io_tryb:=1; //1 - edycja, 2 - lista wyboru
  try
    FAnkiety.ShowModal;
  finally
    FAnkiety.Free;
  end;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  go_first;
end;

procedure TForm1.MenuItem90Click(Sender: TObject);
begin
  FCytaty:=TFCytaty.Create(self);
  FCytaty.io_tryb:=1; //1 - edycja, 2 - lista wyboru
  FCytaty.Show;
end;

procedure TForm1.MenuItem91Click(Sender: TObject);
begin
  MenuItem91.Checked:=not MenuItem91.Checked;
  _DEF_POLFAN:=MenuItem91.Checked;
  dm.SetConfig('default-polfan',_DEF_POLFAN);
  if miPresentation.Checked then
  begin
    if not _DEF_POLFAN then if polfan.Active then polfan.Disconnect;
    if _DEF_POLFAN then if not polfan.Active then polfan.Connect;
  end;
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

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  go_last;
end;

procedure TForm1.miPlayerClick(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    1: miPlayer.Checked:=true;
    2: miRecord.Checked:=true;
    3: miPresentation.Checked:=true;
  end;
  uELED6.Active:=false;
  uELED7.Active:=false;
  uELED8.Active:=false;
  case TMenuItem(Sender).Tag of
    1: uELED6.Active:=true;
    2: uELED7.Active:=true;
    3: uELED8.Active:=true;
  end;
  if miPresentation.Checked then zmiana(tryb) else zmiana;
end;

procedure TForm1.mplayerBeforePlay(ASender: TObject; AFilename: string);
begin
  if _DEF_ENGINE_PLAYER=0 then mplayer.Engine:=meMplayer else mplayer.Engine:=meMPV;
  if mplayer.Engine=meMplayer then _mplayerBeforePlay(ASender,AFilename) else
  if mplayer.Engine=meMPV then _mpvBeforePlay(ASender,AFilename);
end;

procedure TForm1.mplayerBeforeStop(Sender: TObject);
var
  pom: integer;
  l: integer;
begin
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
    Memory_1.ImageIndex:=28;
  end else
  if auto_memory[2]=indeks_play then
  begin
    mem_lamp[2].rozdzial:=indeks_rozd;
    mem_lamp[2].indeks:=indeks_play;
    mem_lamp[2].indeks_czasu:=indeks_czas;
    mem_lamp[2].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[2].active:=true;
    Memory_2.ImageIndex:=30;
  end else
  if auto_memory[3]=indeks_play then
  begin
    mem_lamp[3].rozdzial:=indeks_rozd;
    mem_lamp[3].indeks:=indeks_play;
    mem_lamp[3].indeks_czasu:=indeks_czas;
    mem_lamp[3].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[3].active:=true;
    Memory_3.ImageIndex:=32;
  end else
  if auto_memory[4]=indeks_play then
  begin
    mem_lamp[4].rozdzial:=indeks_rozd;
    mem_lamp[4].indeks:=indeks_play;
    mem_lamp[4].indeks_czasu:=indeks_czas;
    mem_lamp[4].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[4].active:=true;
    Memory_4.ImageIndex:=34;
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

procedure TForm1.mplayerMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if _DEF_FULLSCREEN_CURSOR_OFF and (Screen.Cursor=crNone) then
  begin
    Screen.Cursor:=crDefault;
    tCurOff.Enabled:=true;
  end;
end;

procedure TForm1.mplayerPause(Sender: TObject);
begin
  zapisz(2);
  if uELED9.Active then musicplay;
  szumpause;
  Play.ImageIndex:=0;
  if trans_serwer then SendRamkaPP;
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
  przyciski(true);
  if mplayer.Playing then Play.ImageIndex:=1 else Play.ImageIndex:=0;
  test_play;
  if trans_serwer then
  begin
    przygotuj_do_transmisji;
    s:=RunCommandTransmission('{READ_ALL}');
    if s='' then exit;
    tcp.SendString(s);
  end;
  if uELED9.Active then musicpause;
  szumplay;
  if miPlayer.Checked then if _DEF_FULLSCREEN_MEMORY then DBGrid3.Visible:=_DEF_FULLSCREEN_MEMORY and (not mplayer.Running);
  cctimer_opt:=0;
end;

procedure TForm1.mplayerPlaying(ASender: TObject; APosition, ADuration: single);
var
  a,b,n: integer;
  aa,bb: TTime;
  bPos,bMax: boolean;
begin
  if _DEF_FULLSCREEN_CURSOR_OFF and (Screen.Cursor=crDefault) and (not tCurOff.Enabled) then tCurOff.Enabled:=true;
  //writeln(FormatFloat('0.0000',APosition),'/',FormatFloat('0.0000',ADuration));
  if vv_obrazy then mplayer.Pause;
  {kod dotyczy kontrolki "pp"}
  if ADuration=0 then exit;
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
  if bPos then Label3.Caption:=FormatDateTime('nn:ss',bb) else Label3.Caption:=FormatDateTime('h:nn:ss',bb);
  if bMax then Label4.Caption:=FormatDateTime('nn:ss',aa) else Label4.Caption:=FormatDateTime('h:nn:ss',aa);
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
    bPos:=czas_aktualny<3600000;
    bMax:=n<3600000;
    oo.Min:=0; //czas_aktualny;
    oo.Max:=n-czas_aktualny;
    oo.Position:=b-czas_aktualny;
    if bPos then Label5.Caption:=FormatDateTime('nn:ss',IntegerToTime(czas_aktualny)) else Label5.Caption:=FormatDateTime('h:nn:ss',IntegerToTime(czas_aktualny));
    if bMax then Label6.Caption:=FormatDateTime('nn:ss',IntegerToTime(n)) else Label6.Caption:=FormatDateTime('h:nn:ss',IntegerToTime(n));
  end;
end;

procedure TForm1.mplayerReplay(Sender: TObject);
begin
  zapisz(3);
  Play.ImageIndex:=1;
  if trans_serwer then SendRamkaPP;
  test_force:=true;
  //podklad_pause(vv_audio1);
  if uELED9.Active then musicpause;
  szumplay;
end;

procedure TForm1.mplayerSetPosition(Sender: TObject);
begin
  test_force:=true;
  if trans_serwer then SendRamkaPP;
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
begin
  shared.Start;
  upnp.Init;
  key_ignore:=TStringList.Create;
  key_ignore.Sorted:=true;
  tak_nie_k:=TStringList.Create;
  tak_nie_v:=TStringList.Create;
  {$IFDEF LINUX}
  mplayer.Engine:=meMPV;
  {$ELSE}
  mplayer.Engine:=meMplayer;
  {$ENDIF}
  UOSEngine.LoadLibrary;
  mixer.Init;
  pilot:=dm.pilot_wczytaj;
  auto_memory[1]:=0;
  auto_memory[2]:=0;
  auto_memory[3]:=0;
  auto_memory[4]:=0;
  mem_lamp[1].active:=false;
  mem_lamp[2].active:=false;
  mem_lamp[3].active:=false;
  mem_lamp[4].active:=false;
  uELED6.Active:=miPlayer.Checked;
  uELED7.Active:=miRecord.Checked;
  uELED8.Active:=miPresentation.Checked;
  lista_wybor:=TStringList.Create;
  klucze_wybor:=TStringList.Create;
  trans_opis:=TStringList.Create;
  trans_film_czasy:=TStringList.Create;
  trans_indeksy:=TStringList.Create;
  canals:=TStringList.Create;
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  dm.schemasync.init;
  db_open;
  przyciski(mplayer.Playing);
  _DEF_MULTIMEDIA_SAVE_DIR:=dm.GetConfig('default-directory-save-files','');
  _DEF_SCREENSHOT_SAVE_DIR:=dm.GetConfig('default-directory-save-files-ss','');
  _DEF_SCREENSHOT_FORMAT:=dm.GetConfig('default-screenshot-format',0);
  _DEF_COOKIES_FILE_YT:=dm.GetConfig('default-cookies-file-yt','');
  _DEF_GREEN_SCREEN:=dm.GetConfig('default-green-screen',false);
  _DEF_POLFAN:=dm.GetConfig('default-polfan',false);
  _DEF_ENGINE_PLAYER:=dm.GetConfig('default-engine-player',0);
  _DEF_YT_AUTOSELECT:=dm.GetConfig('default-yt-autoselect',false);
  _DEF_YT_AS_QUALITY:=dm.GetConfig('default-yt-autoselect-quality',0);
  Menuitem15.Visible:=_DEV_ON;
  MenuItem86.Checked:=_DEF_GREEN_SCREEN;
  MenuItem91.Checked:=_DEF_POLFAN;
  KeyPytanie:='';
  dbgridpytania.AutoScaleColumns;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if tcp.Active then tcp.Disconnect;
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
    if bPos then Label3.Caption:=FormatDateTime('nn:ss',aa) else Label3.Caption:=FormatDateTime('h:nn:ss',aa);
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
    if bPos then podpowiedz.Caption:=FormatDateTime('nn:ss',aa) else podpowiedz.Caption:=FormatDateTime('h:nn:ss',aa);
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
var
  a: ^TArchitekt;
  b: ^TArchitektPrzycisk;
begin
  b:=nil;

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
          //1: if mplayer.Playing then mplayer.Pause else mplayer.Replay;
          1: aTestDblClick:=true;
          2: if _MPLAYER_LOCALTIME then mplayer.Position:=mplayer.Position-10 else scisz10;
          3: if _MPLAYER_LOCALTIME then mplayer.Position:=mplayer.Position+10 else zglosnij10;
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
    exit;
  end else

  if miRecord.Checked then
  begin
    {specjalny tryb przygotowywania sesji programu}
    case aButton of
        1: if mplayer.Playing then begin MenuItem10.Click; go_beep; end else mplayer.Replay;
        2: mplayer.Position:=mplayer.Position-4;
        3: mplayer.Position:=mplayer.Position+4;
      4,5: if mplayer.Playing then mplayer.Pause else mplayer.Replay;
    end;
    exit;
  end;
  (* MONITOR > *)
  case aButton of
    1: begin _MONITOR_CAM:=3; SendRamkaMonitor; end;
    2: begin _MONITOR_CAM:=1; SendRamkaMonitor; end;
    3: begin _MONITOR_CAM:=2; SendRamkaMonitor; end;
    else begin _MONITOR_CAM:=0; SendRamkaMonitor; end;
  end;
  (* MONITOR < *)
  if (tryb=1) and vv_obrazy then a:=@pilot.t3 else
  if (tryb=2) and vv_obrazy then a:=@pilot.t4 else
  if tryb=1 then a:=@pilot.t1 else a:=@pilot.t2;
  case aButton of
    1: b:=@a^.p1;
    2: b:=@a^.p2;
    3: b:=@a^.p3;
    4: b:=@a^.p4;
    5: if a^.suma45 then b:=@a^.p4 else b:=@a^.p5;
  end;
  case b^.funkcja_wewnetrzna of
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
    20: zapisz_temat;
    21: begin
          shared.SendMessage('{PILOT'+IntToStr(aButton)+'}');
        end;
  end;
  if b^.kod_wewnetrzny>0 then
  begin
    _BLOCK_MUSIC_KEYS:=true;
    tbk.Enabled:=true;
    Presentation.SendKey(b^.kod_wewnetrzny);
    //_BLOCK_MUSIC_KEYS:=false;
  end;
  if b^.komenda0<>'' then wykonaj_komende(b^.komenda0);
  aTestDblClick:=b^.operacja_zewnetrzna;
end;

procedure TForm1.PresentationClickLong(aButton: integer; aDblClick: boolean);
var
  a: ^TArchitekt;
begin
  (* kod do obsługi mplayera *)
  if miPlayer.Checked and mplayer.Running then
  begin
    case aButton of
      1: if aDblClick then
         begin
           _MPLAYER_LOCALTIME:=not _MPLAYER_LOCALTIME;
           if _MPLAYER_LOCALTIME then mplayer.SetOSDLevel(3) else mplayer.SetOSDLevel(0);
         end else if mplayer.Playing then mplayer.Pause else mplayer.Replay;
    end;
    exit;
  end;
  (* starszy kod *)
  _BLOCK_MUSIC_KEYS:=true;
  tbk.Enabled:=true;
  if (tryb=1) and vv_obrazy then a:=@pilot.t3 else
  if (tryb=2) and vv_obrazy then a:=@pilot.t4 else
  if tryb=1 then a:=@pilot.t1 else a:=@pilot.t2;
  if aDblClick then
  begin
    case aButton of
      1: if a^.p1.dwuklik>0 then Presentation.SendKey(a^.p1.dwuklik);
      2: if a^.p2.dwuklik>0 then Presentation.SendKey(a^.p2.dwuklik);
      3: begin
           if a^.p3.dwuklik>0 then Presentation.SendKey(a^.p3.dwuklik);
           if tryb=2 then zrob_zdjecie_do_paint;
         end;
      4: if a^.p4.dwuklik>0 then Presentation.SendKey(a^.p4.dwuklik);
      5: if a^.p5.dwuklik>0 then Presentation.SendKey(a^.p5.dwuklik);
    end;
    case aButton of
      1: if a^.p1.komenda2<>'' then wykonaj_komende(a^.p1.komenda2);
      2: if a^.p2.komenda2<>'' then wykonaj_komende(a^.p2.komenda2);
      3: if a^.p3.komenda2<>'' then wykonaj_komende(a^.p3.komenda2);
      4: if a^.p4.komenda2<>'' then wykonaj_komende(a^.p4.komenda2);
      5: if a^.p5.komenda2<>'' then wykonaj_komende(a^.p5.komenda2);
    end;
  end else begin
    case aButton of
      1: if a^.p1.klik>0 then Presentation.SendKey(a^.p1.klik);
      2: if a^.p2.klik>0 then Presentation.SendKey(a^.p2.klik);
      3: if a^.p3.klik>0 then Presentation.SendKey(a^.p3.klik);
      4: if a^.p4.klik>0 then Presentation.SendKey(a^.p4.klik);
      5: if a^.p5.klik>0 then Presentation.SendKey(a^.p5.klik);
    end;
    case aButton of
      1: if a^.p1.komenda1<>'' then wykonaj_komende(a^.p1.komenda1);
      2: if a^.p2.komenda1<>'' then wykonaj_komende(a^.p2.komenda1);
      3: if a^.p3.komenda1<>'' then wykonaj_komende(a^.p3.komenda1);
      4: if a^.p4.komenda1<>'' then wykonaj_komende(a^.p4.komenda1);
      5: if a^.p5.komenda1<>'' then wykonaj_komende(a^.p5.komenda1);
    end;
  end;
end;

procedure TForm1.PropStorageRestoringProperties(Sender: TObject);
begin
  tab_lamp_odczyt;
end;

procedure TForm1.PropStorageSavingProperties(Sender: TObject);
begin
  tab_lamp_zapisz;
end;

procedure TForm1.pytaniaCalcFields(DataSet: TDataSet);
begin
  pytaniaczas_dt.AsDateTime:=IntegerToTime(pytaniaczas.AsInteger);
  pytaniapytanie_calc.AsString:='Nick: '+pytanianick.AsString+#10#10+pytaniapytanie.AsString;
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
  Label3.Caption:=FormatDateTime('nn:ss',0);
  test_force:=true;
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
    Presentation.ExecuteEx(1);
  end else
  if AMessage='{PILOT2}' then Presentation.ExecuteEx(2) else
  if AMessage='{PILOT3}' then Presentation.ExecuteEx(3) else
  if AMessage='{PILOT4}' then application.BringToFront else
  if AMessage='{PILOT5}' then application.BringToFront;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  pp1.Position:=10000;
  Timer1.Enabled:=true;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  pp1.Position:=StrToInt(SoundLevel.Text);
  Timer1.Enabled:=true;
end;

procedure TForm1.SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then SoundLevel.Caption:=IntToStr(pp1.Position);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  if SpeedButton3.Font.Style=[] then
  begin
    if pytania.IsEmpty then exit;
    pytanie(pytaniaklucz.AsString,pytanianick.AsString,pytaniapytanie.AsString);
    SpeedButton3.Font.Style:=[fsBold];
    DBGridPytania.Enabled:=false;
  end else
  if SpeedButton3.Font.Style=[fsBold] then
  begin
    pytanie(pytaniaklucz.AsString);
    if not pytania.IsEmpty then
    begin
      pytania.Delete;
      SpeedButton3.Font.Style:=[];
    end;
    DBGridPytania.Enabled:=true;
  end;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  tPytanie.Enabled:=false;
  if not DBGridPytania.Enabled then exit;
  pytania.Active:=not pytania.Active;
  dbGridPytania.Visible:=pytania.Active;
  DBMemo1.Visible:=pytania.Active;
  SpeedButton3.Visible:=pytania.Active;
  if pytania.Active then Label2.Caption:='Pytania:' else Label2.Caption:='Lista filmów:';
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
  s:=vv_link;
  if trim(s)='' then s:=vv_plik;
  if trim(s)='' then exit;
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
  wygeneruj_plik2;
end;

procedure TForm1.tAutorStartTimer(Sender: TObject);
begin
  sleep(1000);
  wygeneruj_plik_autora(film_autor);
  film_autor:='';
  Presentation.SendKey(ord('N'));
end;

procedure TForm1.tAutorStopTimer(Sender: TObject);
begin
  Presentation.SendKey(ord('M'));
  wygeneruj_plik_autora;
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

procedure TForm1.tcpConnect(aSocket: TLSocket);
begin
  tcp.SendString('{GET_VECTOR}');
end;

procedure TForm1.tcpCryptBinary(const indata; var outdata; var size: longword);
var
  vec,klucz: string;
begin
  size:=CalcBuffer(size,16);
  dm.DaneDoSzyfrowania(vec,klucz);
  aes.Init(klucz[1],128,@vec[1]);
  aes.Encrypt(indata,outdata,size);
  aes.Burn;
end;

procedure TForm1.tcpCryptString(var aText: string);
begin
  aText:=EncryptString(aText,dm.GetHashCode(2));
end;

procedure TForm1.tcpDecryptBinary(const indata; var outdata; var size: longword
  );
var
  vec,klucz: string;
begin
  dm.DaneDoSzyfrowania(vec,klucz);
  aes.Init(klucz[1],128,@vec[1]);
  aes.Decrypt(indata,outdata,size);
  aes.Burn;
end;

procedure TForm1.tcpDecryptString(var aText: string);
begin
  aText:=DecryptString(aText,dm.GetHashCode(2));
end;

procedure TForm1.tcpProcessMessage;
begin
  Application.ProcessMessages;
end;

procedure TForm1.tcpReceiveString(aMsg: string; aSocket: TLSocket;
  aBinSize: integer; var aReadBin: boolean);
var
  s1,s2,s3,s4,s5: string;
  a1,a2: integer;
  b: boolean;
  id,a: integer;
  posi: single;
begin
  //writeln('Mój klucz: ',key);
  //writeln('(',length(aMsg),') Otrzymałem: "',aMsg,'"');
  s1:=GetLineToStr(aMsg,1,'$');
  if s1='{EXIT}' then t_tcp_exit.Enabled:=true else
  if s1='{USERS_COUNT}' then
  begin
    a:=StrToInt(GetLineToStr(aMsg,2,'$')); //liczba połączonych użytkowników
    Label9.Caption:=IntToStr(a-1);
  end else
  if s1='{READ_ALL}' then
  begin
    id:=StrToInt(GetLineToStr(aMsg,2,'$','-1')); //ID RURKI
    s1:=RunCommandTransmission('{READ_ALL}',id);
    if s1='' then exit;
    tcp.SendString(s1,aSocket);
  end else
  if s1='{READ_MON}' then
  begin
    id:=StrToInt(GetLineToStr(aMsg,2,'$','-1')); //ID RURKI
    SendRamkaMonitor(aSocket,id);
  end else
  if s1='{LOGIN}' then
  begin
    s2:=GetLineToStr(aMsg,2,'$'); //key
    if s2='' then
    begin
      (* użytkownik bez określonego klucza - nadaję nowy klucz *)
      s2:=tcp.GetGUID;
      tcp.RegisterKey(s2,aSocket);
      tcp.SendString('{KEY-NEW}$'+s2,aSocket);
    end else begin
      (* użytkownik z kluczem - sprawdzam czy taki klucz istnieje *)
      if tcp.KeyExist(s2) then tcp.SendString('{KEY-OK}',aSocket) else
      begin
        s2:=tcp.GetGUID;
        tcp.RegisterKey(s2,aSocket);
        tcp.SendString('{KEY-NEW}$'+s2,aSocket);
      end;
    end;
  end else
  if s1='{INFO}' then
  begin
    s2:=GetLineToStr(aMsg,2,'$'); //key
    s3:=GetLineToStr(aMsg,3,'$'); //opcja
    id:=StrToInt(GetLineToStr(aMsg,4,'$','-1')); //ID RURKI
    if (s3='ALL') then if s2=KeyPytanie then tcp.SendString('{INF1}$'+IntToStr(id)+'$1',aSocket) else tcp.SendString('{INF1}$'+IntToStr(id)+'$0',aSocket);
    if (s3='ALL') then if CheckBox1.Checked then tcp.SendString('{INF2}$'+IntToStr(id)+'$1',aSocket) else tcp.SendString('{INF2}$'+IntToStr(id)+'$0',aSocket);
  end else
  if s1='{STUDIO_ALARM}' then
  begin
    (* przyszedł alarm od użytkownika *)
    play_alarm;
  end else
  if s1='{STUDIO_PLAY_STOP}' then
  begin
    (* zewnętrzne sterowanie studiem *)
    s2:=GetLineToStr(aMsg,2,'$'); //key
    b:=key_ignore.Find(s2,a);
    if b then exit;
    try a1:=StrToInt(GetLineToStr(aMsg,3,'$','-1')) except a1:=-1 end; //kanał (1..4)
    if a1<0 then exit;
    s3:=GetLineToStr(aMsg,4,'$'); //kod uwierzytelniający (ustawiany za każdym razem)
    if (trans_code='') or (trans_code<>s3) then exit;
    try a2:=StrToInt(GetLineToStr(aMsg,5,'$','-1')) except a2:=-1 end; //komenda (-1:default:null|0:pause|1:play)
    id:=StrToInt(GetLineToStr(aMsg,6,'$','-1')); //ID RURKI
    if a2=0 then
    begin
      ppause(a1);
    end else
    if a2=1 then
    begin
      pplay(a1);
    end;
  end else
  if s1='{STUDIO}' then
  begin
    s2:=GetLineToStr(aMsg,2,'$'); //key
    b:=key_ignore.Find(s2,a);
    if b then exit;
    s3:=GetLineToStr(aMsg,3,'$'); //komenda
    s4:=GetLineToStr(aMsg,4,'$'); //code
    id:=StrToInt(GetLineToStr(aMsg,5,'$','-1')); //ID RURKI
    if s4=trans_code then
    begin
      if s3='GET_CANAL' then tcp.SendString('{STUDIO}$'+IntToStr(id)+'$'+s2+'$SET_CANAL$'+IntToStr(GetCanal(s2)),aSocket);
    end;
  end else
  if s1='{PYTANIE}' then
  begin
    s2:=GetLineToStr(aMsg,2,'$'); //key
    b:=key_ignore.Find(s2,a);
    if b then exit;
    s3:=GetLineToStr(aMsg,3,'$'); //nick
    s4:=GetLineToStr(aMsg,4,'$'); //pytanie
    s5:=GetLineToStr(aMsg,5,'$'); //czas (opcja)
    pytanie_add(s2,s3,s4,s5);
  end else
  if s1='{PYTANIE_CHAT}' then  //KeyPytanie
  begin
    s2:=GetLineToStr(aMsg,2,'$'); //key
    b:=key_ignore.Find(s2,a);
    if b then exit;
    if s2=KeyPytanie then
    begin
      s3:=GetLineToStr(aMsg,3,'$'); //nick
      s4:=GetLineToStr(aMsg,4,'$'); //wiadomość
      pytania.Edit;
      pytaniapytanie.AsString:=pytaniapytanie.AsString+#13+'PYT: '+s4;
      pytania.Post;
      pytania.Refresh;
    end;
  end else
  if s1='{INTERAKCJA}' then
  begin
    //mon.SendString('{INTERAKCJA}$'+key+'${TAK_NIE}$1');
    s2:=GetLineToStr(aMsg,2,'$'); //key
    s3:=GetLineToStr(aMsg,3,'$'); //operacja
    s4:=GetLineToStr(aMsg,4,'$'); //wartość
    if s3='{TAK_NIE}' then
    begin
      if not CheckBox1.Checked then exit;
      a:=ecode.StringToItemIndex(tak_nie_k,s2);
      if a=-1 then
      begin
        tak_nie_k.Add(s2);
        tak_nie_v.Add(s4);
      end else begin
        tak_nie_k.Delete(a);
        tak_nie_v.Delete(a);
        tak_nie_k.Insert(a,s2);
        tak_nie_v.Insert(a,s4);
      end;
      tak_nie_przelicz;
    end;
  end else
  if s1='{GET_VECTOR}' then
  begin
    (* ustawienie nowego kodu VECTOR lub utrzymanie starego *)
    tcp.SendString('{VECTOR_OK}',aSocket);
  end else
  if s1='{VECTOR_OK}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector;
    tcp.SendString('{I-AM-SERVER}',aSocket);
  end else
  if s1='{VECTOR_IS_NEW}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector(GetLineToStr(aMsg,2,'$'));
    tcp.SendString('{I-AM-SERVER}',aSocket);
  end;
end;

procedure TForm1.tcpStatus(aActive, aCrypt: boolean);
begin
  uELED3.Active:=aActive;
end;

procedure TForm1.tCurOffTimer(Sender: TObject);
begin
  tCurOff.Enabled:=false;
  if _DEF_FULLSCREEN_CURSOR_OFF and (Screen.Cursor=crDefault) then Screen.Cursor:=crNone;
end;

procedure TForm1.test_czasBeforeOpen(DataSet: TDataSet);
begin
  test_czas.ParamByName('id').AsInteger:=indeks_play;
end;

procedure TForm1.tFilmTimer(Sender: TObject);
begin
  tFilm.Enabled:=false;
  wygeneruj_plik2;
  Presentation.SendKey(77);
  Presentation.SendKey(77);
  uELED11.Active:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  bstop: boolean;
  vv: integer;
begin
  bstop:=false;
  vv:=round(UOSpodklad.Volume*10000);
  if vv>10000 then vv:=10000;
  if vv<pp1.Position then
  begin
    vv:=vv+5;
    if vv>=pp1.Position then
    begin
      vv:=pp1.Position;
      bstop:=true;
    end;
    UOSpodklad.Volume:=vv/10000;
    if bstop then Timer1.Enabled:=false;
  end else begin
    vv:=vv-5;
    if vv<=pp1.Position then
    begin
      vv:=pp1.Position;
      bstop:=true;
    end;
    UOSpodklad.Volume:=vv/10000;
    if bstop then Timer1.Enabled:=false;
  end;
end;

procedure TForm1.timer_info_tasmyTimer(Sender: TObject);
begin
  timer_info_tasmy.Enabled:=false;
  update_dioda_tasma;
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

procedure TForm1.t_tcp_exitTimer(Sender: TObject);
begin
  t_tcp_exit.Enabled:=false;
  tcp.Disconnect;
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

procedure TForm1.uELED3Change(Sender: TObject);
begin
  Label9.Visible:=uELED3.Active;
end;

procedure TForm1.uELED8Change(Sender: TObject);
begin
  SetCursorOnPresentation(uELED8.Active and mplayer.Running);
end;

procedure TForm1.uELED9Click(Sender: TObject);
begin
  uELED9.Active:=not uELED9.Active;
  if not uELED9.Active then musicpause else
  if not mplayer.Playing then musicplay;
end;

procedure TForm1.UOSpodkladBeforeStart(Sender: TObject);
begin
  UOSPodklad.Volume:=pp1.Position/10000;
end;

procedure TForm1.youtubeDlFinish(aLink, aFileName, aDir: string; aTag: integer);
begin
  dm.film.ParamByName('id').AsInteger:=aTag;
  dm.film.Open;
  dm.film.Edit;
  dm.film.FieldByName('plik').AsString:=aDir+_FF+aFileName;
  dm.film.Post;
  dm.film.Close;
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
  czasy.Active:=DataSet.Active;
end;

procedure TForm1._OPEN_CLOSE_TEST(DataSet: TDataSet);
begin
  test_czas2.Active:=DataSet.Active;
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

procedure TForm1.musicplay;
begin
  if not miPresentation.Checked then exit;
  if not UOSPodklad.Busy then
  begin
    musicload;
    exit;
  end;
  if UOSPodklad.Pausing then UOSPodklad.Replay;
end;

procedure TForm1.musicpause;
begin
  if not UOSPodklad.Busy then exit;
  if UOSPodklad.Pausing then exit;
  UOSPodklad.Pause;
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

procedure TForm1.tab_lamp_zapisz;
var
  i: integer;
begin
  for i:=1 to 4 do
  begin
    PropStorage.WriteBoolean('lamp'+IntToStr(i)+'_active',mem_lamp[i].active);
    PropStorage.WriteInteger('lamp'+IntToStr(i)+'_rozdzial',mem_lamp[i].rozdzial);
    PropStorage.WriteInteger('lamp'+IntToStr(i)+'_indeks',mem_lamp[i].indeks);
    PropStorage.WriteInteger('lamp'+IntToStr(i)+'_czas',mem_lamp[i].indeks_czasu);
    PropStorage.WriteString('lamp'+IntToStr(i)+'_time',FloatToStr(mem_lamp[i].time));
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
    end;
  end;
  if mem_lamp[1].active then Memory_1.ImageIndex:=28 else Memory_1.ImageIndex:=27;
  if mem_lamp[2].active then Memory_2.ImageIndex:=30 else Memory_2.ImageIndex:=29;
  if mem_lamp[3].active then Memory_3.ImageIndex:=32 else Memory_3.ImageIndex:=31;
  if mem_lamp[4].active then Memory_4.ImageIndex:=34 else Memory_4.ImageIndex:=33;
end;

procedure TForm1.dodaj_pozycje_na_koniec_listy(aSkopiujTemat: boolean);
var
  s: string;
  a,b: integer;
begin
  if aSkopiujTemat then
  begin
    czasy_notnull.Open;
    s:=czasynazwa1.AsString;
    czasy_notnull.Close;
    if s='' then s:='..';
  end else s:='';
  b:=MiliSecToInteger(Round(mplayer.GetPositionOnlyRead*1000));
  if vv_obrazy then
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
  if b<a then dodaj_czas(filmy.FieldByName('id').AsInteger,a,s)
         else dodaj_czas(filmy.FieldByName('id').AsInteger,b,s);
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
      end;
      if id=indeks_play then mplayer.Stop;
      dm.trans.StartTransaction;
      filmy.Delete;
      dm.trans.Commit;
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

procedure TForm1.dodaj_film(aNaPoczatku: boolean);
var
  vstatus: integer;
  a,b: integer;
begin
  FLista:=TFLista.Create(self);
  try
    FLista.in_tryb:=1;
    FLista.i_roz:=db_roz.FieldByName('id').AsInteger;
    FLista.in_out_obrazy:=false;
    FLista.ShowModal;
    if FLista.out_ok then
    begin
      dm.trans.StartTransaction;
      if aNaPoczatku then
      begin
        filmy.DisableControls;
        filmy.First;
        a:=filmyid.AsInteger;
      end;
      filmy.Append;
      filmy.FieldByName('nazwa').AsString:=FLista.s_tytul;
      if FLista.s_link='' then filmy.FieldByName('link').Clear else filmy.FieldByName('link').AsString:=FLista.s_link;
      if FLista.s_file='' then filmy.FieldByName('plik').Clear else filmy.FieldByName('plik').AsString:=FLista.s_file;
      if FLista.s_audio='' then filmyfile_audio.Clear else filmyfile_audio.AsString:=FLista.s_audio;
      if FLista.i_roz=0 then filmy.FieldByName('rozdzial').Clear
      else filmy.FieldByName('rozdzial').AsInteger:=FLista.i_roz;
      vstatus:=0;
      SetBit(vstatus,0,FLista.in_out_obrazy);
      filmystatus.AsInteger:=vstatus;
      filmy.Post;
      dm.dbini.Execute;
      if aNaPoczatku then
      begin
        filmy.Last;
        b:=filmyid.AsInteger;
        dm.filmyidnext.ParamByName('id').AsInteger:=a;
        dm.filmyidnext.ParamByName('id2').AsInteger:=b+1;
        dm.filmyidnext.Execute;
        filmy.Refresh;
        filmy.First;
      end;
      dm.trans.Commit;
    end;
  finally
    FLista.Free;
    if aNaPoczatku then filmy.EnableControls;
  end;
end;

procedure TForm1.zapisz_temat(aForceStr: string);
var
  f: textfile;
  s: string;
  ss: TStringList;
  i: integer;
begin
  if aForceStr='' then s:=Clipboard.AsText else s:=aForceStr;
  while pos('  ',s)>0 do s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
  ss:=TStringList.Create;
  try
    tekst_46(s,ss);
    assignfile(f,'/home/tao/temat.txt');
    rewrite(f);
    writeln(f,ss.Text);
    closefile(f);
  finally
    ss.Free;
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
  SetCursorOnPresentation(uELED8.Active and mplayer.Running);
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
  ipom,vol,vosd,vaudio,vresample: integer;
  osd,audio,samplerate,audioeq,lang,s1,audionormalize,novideo: string;
begin
  SetCursorOnPresentation(uELED8.Active and mplayer.Running);
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
    mplayer.StartParam:=audioeq+' '+audionormalize+' '+osd+' '+audio+' '+lang+' '+samplerate+' -volume '+IntToStr(vol)+' '+novideo
  else
    mplayer.StartParam:=audioeq+' '+audionormalize+' '+osd+' '+audio+' '+lang+' '+samplerate+' -volume '+IntToStr(vol)+' '+const_mplayer_param+' '+novideo;
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

procedure TForm1.pytanie_add(aKey, aNick, aPytanie, aCzas: string);
var
  a,b: integer;
  s: string;
begin
  b:=TimeToInteger; //aCzas ignoruję w tej chwili!
  dm.pyt_get.ParamByName('pytanie').AsString:=aPytanie;
  dm.pyt_get.Open;
  a:=dm.pyt_getile.AsInteger;
  dm.pyt_get.Close;
  if a=0 then
  begin
    s:=trim(aPytanie);
    s:=StringReplace(s,#13,' ',[rfReplaceAll]);
    s:=StringReplace(s,#10,' ',[rfReplaceAll]);
    while pos('  ',s)>0 do s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
    dm.pyt_add.ParamByName('czas').AsInteger:=b;
    dm.pyt_add.ParamByName('klucz').AsString:=aKey;
    dm.pyt_add.ParamByName('nick').AsString:=aNick;
    dm.pyt_add.ParamByName('pytanie').AsString:=s;
    dm.pyt_add.ExecSQL;
    if pytania.Active then pytania.Refresh;
    tPytanie.Enabled:=not pytania.Active;
  end;
end;

procedure TForm1.pytanie(aKey: string; aNick: string; aPytanie: string);
var
  s: string;
  ss: TStrings;
  soket: TLSocket;
  b: boolean;
begin
  if (aNick<>'') or (aPytanie<>'') then
  begin
    if aNick='' then s:=aPytanie else s:=aNick+': '+aPytanie;
    while pos('  ',s)>0 do s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
  end;
  if _DEF_GREEN_SCREEN then
  begin
    s:=trim(s);
    b:=length(s)>0;
    if _SET_GREEN_SCREEN then fscreen.pytanie(s);
  end else begin
    ss:=TStringList.Create;
    try
      TextToScreen(s,80,6,ss);
      b:=length(trim(ss.Text))>0;
      ss.SaveToFile('/home/tao/pytanie.txt');
    finally
      ss.Free;
    end;
  end;
  (* wysłanie informacji *)
  if b then
  begin
    soket:=tcp.KeyToSocket(aKey);
    tcp.SendString('{INF1}$-1$'+aKey+'$1')
  end else begin
    soket:=tcp.KeyToSocket(KeyPytanie);
    tcp.SendString('{INF1}$-1$'+aKey+'$0')
  end;
  KeyPytanie:=aKey;
end;

procedure TForm1.tak_nie_przelicz;
var
  i: integer;
  tak,nie: integer;
begin
  tak:=0;
  nie:=0;
  for i:=0 to tak_nie_v.Count-1 do if tak_nie_v[i]='1' then inc(tak) else inc(nie);
  if CheckBox1.Checked then
  begin
    (* wyświetlenie danych na ekranie *)
    fscreen.tak_nie(tak,nie);
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
  tcp.SendString('{STUDIO_PLAY_STOP}$-1$'+s);
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
  tcp.SendString('{STUDIO_PLAY_STOP}$-1$'+s);
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

function TForm1.PragmaForeignKeys: boolean;
var
  q1: TZQuery;
  a: integer;
begin
  q1:=TZQuery.Create(self);
  q1.Connection:=dm.db;
  try
    q1.SQL.Clear;
    q1.SQL.Add('PRAGMA foreign_keys');
    q1.Open;
    a:=q1.Fields[0].AsInteger;
    q1.Close;
  finally
    q1.Free;
  end;
  result:=a=1;
end;

procedure TForm1.PragmaForeignKeys(aOn: boolean);
var
  q1: TZQuery;
begin
  q1:=TZQuery.Create(self);
  q1.Connection:=dm.db;
  try
    q1.SQL.Clear;
    if aOn then q1.SQL.Add('PRAGMA foreign_keys = ON')
           else q1.SQL.Add('PRAGMA foreign_keys = OFF');
    q1.ExecSQL;
  finally
    q1.Free;
  end;
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

procedure TForm1.db_open;
var
  b: boolean;
begin
  dm.schemasync.StructFileName:=MyConfDir('studio.dat');
  if sciezka_db='' then dm.db.Database:=MyConfDir('db.sqlite') else dm.db.Database:=sciezka_db;
  b:=not FileExists(dm.db.Database);
  dm.db.Connect;
  if not _DEV_ON then if FileExists(dm.schemasync.StructFileName) then dm.schemasync.SyncSchema;
  if b then dm.cr.Execute;
  PragmaForeignKeys(true);
  db_roz.Open;
end;

procedure TForm1.db_close;
begin
  db_roz.Close;
  dm.db.Disconnect;
end;

function TForm1.get_last_id: integer;
begin
  dm.last_id.Open;
  result:=dm.last_id.Fields[0].AsInteger;
  dm.last_id.Close;
end;

procedure TForm1.przyciski(v_playing: boolean);
begin
  exit;
  Play.Enabled:=not v_playing;
  Stop.Enabled:=v_playing;
end;

procedure TForm1.update_dioda_tasma(aKlik: boolean);
begin
  if aKlik then uELED4.Color:=clYellow else uELED4.Color:=$006F7575;
  uELED4.Active:=precord;
end;

procedure TForm1.wygeneruj_plik2(nazwa1: string; nazwa2: string; aS1: string;
  aS2: string);
var
  f: textfile;
begin
  if not miPresentation.Checked then exit;
  if aS1<>'' then zapisz_na_tasmie(aS1,aS2);
  if _DEF_GREEN_SCREEN then
  begin
    if _SET_GREEN_SCREEN then
    begin
      if vv_transmisja then fscreen.film('>>> Transmisja na żywo <<<','',uELED2.Active) else fscreen.film(nazwa1,nazwa2,uELED2.Active);
    end;
  end;
end;

procedure TForm1.wygeneruj_plik_autora(nazwa1: string);
var
  f: textfile;
begin
  exit;
  if not miPresentation.Checked then exit;
  assignfile(f,'/home/tao/autor.txt');
  rewrite(f);
  writeln(f,' '+nazwa1+' ');
  closefile(f);
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

function TForm1.go_up(force_id: integer): boolean;
var
  id,id2: integer;
  s1,s2: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  if force_id=0 then filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    s1:=filmy.FieldByName('sort').AsInteger;
    filmy.Prior;
    id2:=filmy.FieldByName('id').AsInteger;
    s2:=filmy.FieldByName('sort').AsInteger;
    if id=id2 then exit;
    if force_id=0 then dm.trans.StartTransaction;
    dm.update_sort.ParamByName('id').AsInteger:=id;
    dm.update_sort.ParamByName('sort').AsInteger:=s2;
    dm.update_sort.Execute;
    dm.update_sort.ParamByName('id').AsInteger:=id2;
    dm.update_sort.ParamByName('sort').AsInteger:=s1;
    dm.update_sort.Execute;
    if force_id=0 then dm.trans.Commit;
    filmy.Refresh;
    filmy.Locate('id',id,[]);
    result:=true;
  finally
    if force_id=0 then filmy.EnableControls;
  end;
end;

function TForm1.go_first(force_id: integer): boolean;
var
  id: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    dm.trans.StartTransaction;
    repeat until not go_up(id);
    dm.trans.Commit;
  finally
    filmy.EnableControls;
  end;
end;

function TForm1.go_down(force_id: integer): boolean;
var
  id,id2: integer;
  s1,s2: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  if force_id=0 then filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    s1:=filmy.FieldByName('sort').AsInteger;
    filmy.Next;
    id2:=filmy.FieldByName('id').AsInteger;
    s2:=filmy.FieldByName('sort').AsInteger;
    if id=id2 then exit;
    if force_id=0 then dm.trans.StartTransaction;
    dm.update_sort.ParamByName('id').AsInteger:=id;
    dm.update_sort.ParamByName('sort').AsInteger:=s2;
    dm.update_sort.Execute;
    dm.update_sort.ParamByName('id').AsInteger:=id2;
    dm.update_sort.ParamByName('sort').AsInteger:=s1;
    dm.update_sort.Execute;
    if force_id=0 then dm.trans.Commit;
    filmy.Refresh;
    filmy.Locate('id',id,[]);
    result:=true;
  finally
    if force_id=0 then filmy.EnableControls;
  end;
end;

function TForm1.go_last(force_id: integer): boolean;
var
  id: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    dm.trans.StartTransaction;
    repeat until not go_down(id);
    dm.trans.Commit;
  finally
    filmy.EnableControls;
  end;
end;

procedure TForm1.resize_update_grid;
begin
  DBGrid1.Columns[1].Width:=Panel3.Width-14;
  DBGrid2.Columns[2].Width:=DBGrid1.Columns[1].Width-22;
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
  czas_od,czas_do: integer;
  nazwa,s1,s2,autor,v_audio: string;
  stat: integer;
  pstatus,istatus: boolean;
begin
  test_force:=false;
  czas_aktualny:=-1;
  czas_nastepny:=-1;
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
        else czas_do:=test_czas2.FieldByName('czas_od').AsInteger;
      end else czas_do:=test_czas.FieldByName('czas_do').AsInteger;
      if (teraz2>czas_od) and ((czas_do=-1) or (teraz<czas_do)) then
      begin
        {CZAS AKTUALNY JEST TERAZ!}
        if (czas_od<=teraz2) and ((czas_do=-1) or (czas_do>teraz)) then
        begin
          stat:=test_czas.FieldByName('status').AsInteger;
          if test_czas.FieldByName('mute').IsNull then vv_mute:=false else vv_mute:=test_czas.FieldByName('mute').AsInteger=1;
          if pstatus_ignore then pstatus:=false else pstatus:=GetBit(stat,0);
          istatus:=GetBit(stat,1);
          czas_aktualny:=czas_od;
          czas_aktualny_nazwa:=nazwa;
          czas_aktualny_indeks:=test_czas.FieldByName('id').AsInteger;
          if czas_do>teraz then czas_nastepny:=czas_do;
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
      if czas_nastepny=-1 then mplayer.Stop else SeekPlay(czas_nastepny);
      exit;
    end;
    if not istatus then zapisz_na_tasmie(s1,s2);
    indeks_czas:=czas_aktualny_indeks;
    DBGrid2.Refresh;
    if not istatus then
    begin
      wygeneruj_plik2(film_tytul1,film_tytul2);
    end;
    a:=StringToItemIndex(trans_indeksy,IntToStr(indeks_czas));
    if trans_serwer and (not istatus) then tcp.SendString('{INDEX_CZASU}$-1$'+IntToStr(a));
  end else begin
    zapisz_na_tasmie(s1);
    indeks_czas:=-1;
    DBGrid2.Refresh;
    reset_oo;
    wygeneruj_plik2(film_tytul);
    if trans_serwer then tcp.SendString('{INDEX_CZASU}$-1$-1');
  end;
end;

end.

