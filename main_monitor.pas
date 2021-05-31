unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, Menus, DBCtrls, NetSocket, ExtMessage,
  ZTransaction, DBGridPlus, DSMaster, DBSchemaSyncSqlite, UOSEngine, UOSPlayer,
  ExtEventLog, ZMasterVersionDB, HtmlView, lNet, ueled, uETilePanel,
  DCPrijndael, DCPsha512, ZConnection, ZDataset, ZSqlProcessor, Types, DB,
  HTMLUn2, HtmlGlobals, DBGrids, eventlog, Grids;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    Bevel1: TBevel;
    aes: TDCP_rijndael;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    daneurl: TMemoField;
    DBGridPlus1: TDBGridPlus;
    dsignores: TDataSource;
    dbClearHistoryUser: TZQuery;
    DBGridPlus2: TDBGridPlus;
    dsusers2: TDataSource;
    dbPrzeczytane: TZQuery;
    dsprive1: TDataSource;
    debug: TExtEventLog;
    edit_pp: TZQuery;
    edit_plik2: TZQuery;
    del_plik: TZQuery;
    IsIgnore: TZQuery;
    ignoresid: TLargeintField;
    ignoresklucz: TMemoField;
    ignoresnick: TMemoField;
    IsIgnoreile: TLargeintField;
    IsUserstatus: TLargeintField;
    is_plikid: TLargeintField;
    KeyToUserid: TLargeintField;
    KeyToUsernazwa: TMemoField;
    Label2: TLabel;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem20: TMenuItem;
    mCisza: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem9: TMenuItem;
    ODialog: TOpenDialog;
    OImage: TOpenDialog;
    pmKontakty: TPopupMenu;
    pmKontakty2: TPopupMenu;
    prive1: TZQuery;
    prive1adresat: TMemoField;
    prive1formatowanie: TMemoField;
    prive1id: TLargeintField;
    prive1insertdt: TMemoField;
    prive1nadawca: TMemoField;
    prive1nick: TMemoField;
    prive1przeczytane: TLargeintField;
    prive1tresc: TMemoField;
    Programistyczne: TMenuItem;
    schema: TDBSchemaSyncSqlite;
    Label1: TLabel;
    master: TDSMaster;
    dsusers: TDataSource;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    pmJa: TPopupMenu;
    tFreeChat: TTimer;
    tHalt: TTimer;
    tAdmAllUser: TTimer;
    tBAN: TTimer;
    ping_pong: TTimer;
    tReqKeyOk: TTimer;
    uELED2: TuELED;
    uos: TUOSEngine;
    play1: TUOSPlayer;
    users: TZQuery;
    daneemail: TMemoField;
    daneid: TLargeintField;
    daneimie: TMemoField;
    daneklucz: TMemoField;
    danenazwa: TMemoField;
    danenazwisko: TMemoField;
    daneopis: TMemoField;
    DBText1: TDBText;
    DBText2: TDBText;
    dsdane: TDataSource;
    Image1: TImage;
    ImageList: TImageList;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem6: TMenuItem;
    mess: TExtMessage;
    mon: TNetSocket;
    pmTray: TPopupMenu;
    StatusBar1: TStatusBar;
    autorun: TTimer;
    texit: TTimer;
    tFreeStudio: TTimer;
    timer_start: TTimer;
    timer_stop: TTimer;
    propstorage: TXMLPropStorage;
    TrayIcon1: TTrayIcon;
    uELED1: TuELED;
    uETilePanel1: TuETilePanel;
    db: TZConnection;
    trans: TZTransaction;
    dane: TZQuery;
    users2: TZQuery;
    users2opis: TMemoField;
    users2url: TMemoField;
    usersemail: TMemoField;
    usersemail1: TMemoField;
    usersid: TLargeintField;
    usersid1: TLargeintField;
    usersile: TLargeintField;
    usersile1: TLargeintField;
    usersimie: TMemoField;
    usersimie1: TMemoField;
    usersklucz: TMemoField;
    usersklucz1: TMemoField;
    usersnazwa: TMemoField;
    usersnazwa1: TMemoField;
    usersnazwisko: TMemoField;
    usersnazwisko1: TMemoField;
    usersopis: TMemoField;
    usersstatus: TLargeintField;
    usersstatus1: TLargeintField;
    usersurl: TMemoField;
    user_exist: TZQuery;
    KeyToUser: TZQuery;
    user_existile: TLargeintField;
    dbClearHistory: TZQuery;
    IsUser: TZReadOnlyQuery;
    ignores: TZQuery;
    naprawa_db: TZSQLProcessor;
    schema2: TZMasterVersionDB;
    add_plik: TZQuery;
    is_plik: TZQuery;
    edit_plik: TZQuery;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBGridPlus1DblClick(Sender: TObject);
    procedure dsusers2DataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
    procedure mCiszaClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure monCryptBinary(const indata; var outdata; var size: longword);
    procedure monError(const aMsg: string; aSocket: TLSocket);
    procedure monReceiveBinary(const outdata; size: longword; aSocket: TLSocket
      );
    procedure monReceiveString(aMsg: string; aSocket: TLSocket;
      aBinSize: integer; var aReadBin: boolean);
    procedure monStatus(aActive, aCrypt: boolean);
    procedure ping_pongTimer(Sender: TObject);
    procedure schema2Create(Sender: TObject; TagNo: integer; var Stopped,
      NegationResult, ForceUpgrade: boolean);
    procedure schema2Upgrade(Sender: TObject; TagNo, VerDB: integer;
      var Stopped: boolean);
    procedure schemaAfterSync(Sender: TObject);
    procedure schemaLoadMemStruct(aValue: TStringList);
    procedure tAdmAllUserTimer(Sender: TObject);
    procedure tBANTimer(Sender: TObject);
    procedure tFreeChatTimer(Sender: TObject);
    procedure tHaltTimer(Sender: TObject);
    procedure tReqKeyOkTimer(Sender: TObject);
    procedure _GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure _SetText(Sender: TField; const aText: string);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure monConnect(aSocket: TLSocket);
    procedure monDecryptBinary(const indata; var outdata; var size: longword);
    procedure monDisconnect;
    procedure monProcessMessage;
    procedure monTimeVector(aTimeVector: integer);
    procedure propstorageRestoreProperties(Sender: TObject);
    procedure texitTimer(Sender: TObject);
    procedure tFreeStudioTimer(Sender: TObject);
    procedure timer_startTimer(Sender: TObject);
    procedure timer_stopTimer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    led_kolor: TColor;
    okna_do_zabicia: TList;
    sound1: TMemoryStream;
    list: TList;
    list_key: TStringList;
    signales: TStringList;
    studio_run, chat_run, plikownia_run: boolean;
    wektor_czasu: integer;
    key: string;
    C_AWATAR: integer;
    function TextCertificate(aFileName: string): integer;
    procedure AppOnDeactivate(Sender: TObject);
    procedure AppOnActivate(Sender: TObject);
    procedure LoadImgConf;
    procedure LoginWtorny;
    procedure go_beep(aIndex: integer = 0);
    procedure go_set_chat(aFont, aFont2: string; aSize, aSize2, aColor, aFormat, aMaxLineChat: integer);
    procedure go_set_vector_contacts_messages_counts(aValue: integer);
    procedure go_set_debug(aDebug: boolean);
    procedure RequestRegisterKey(aKey: string; aUsunStaryKlucz: boolean);
    procedure SetDebug(aDebug: boolean);
    procedure clear_prive(aValue: string);
    procedure PutKey(aKey: string);
    function GetKey(aToken: string = ''): string;
    procedure AddKontakt(aKey,aNazwa: string; aSzary: boolean);
    procedure UserKeyToNazwa(aKey: string; var aNazwa: string);
    procedure TestWersji(a1,a2,a3,a4: integer);
    procedure IconTrayMessage(aValue: integer);
    procedure zablokowanie_uslug;
    procedure odblokowanie_uslug;
    procedure SendMessage(aKomenda: string; aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure SendMessageBin(aKomenda: string; aValue: string = ''; aBlock: pointer = nil; aBlockSize: integer = 0);
    procedure SendMessageBinNoKey(aKomenda: string; aValue: string = ''; aBlock: pointer = nil; aBlockSize: integer = 0);
    procedure SendChatSpecjal(aOd,aDoKey: string; aKod: integer; aTresc: string);
    procedure restart;
    procedure StudioDestroy;
    procedure StudioDestroyTimer;
    procedure StudioGetData;
    function IfXIsFChat(aX1,aX2: pointer): boolean;
    procedure ChatDestroy;
    procedure ChatDestroyTimer(aPointer: pointer);
    procedure ZamknijWszystkieChaty;
    procedure PolaczenieAktywne;
    procedure WizytowkaToProfil(aFileName: string = '');
    procedure WizytowkaToKontakt(aFileName: string);
    procedure WizytowkaToLinkFile(aFileName: string);
    procedure NaprawaBazy;
    procedure SetRunningPlikownia(aValue: boolean);
    procedure SetUploadingPlikownia(aValue: boolean);
    procedure SetDownloadingPlikownia(aValue: boolean);
  public
    img1,img2: TStringList;
    stat_file_test: TStringList;
    procedure RunParameter(aPar: String);
    procedure StatFileTest;
  end;

var
  FMonitor: TFMonitor;

implementation

uses
  ecode, serwis, keystd, cverinfo, lcltype, lclintf, studio,
  MojProfil, Chat, KontoExport, UsunKonfiguracje, ustawienia,
  ignores, Plikownia;

var
  C_KONIEC: boolean = false;
  C_EXIT: boolean = false;

{$R *.lfm}

{ TFMonitor }

procedure TFMonitor.monDecryptBinary(const indata; var outdata;
  var size: longword);
var
  vec,klucz: string;
begin
  dm.DaneDoSzyfrowania(vec,klucz);
  aes.Init(klucz[1],128,@vec[1]);
  aes.Decrypt(indata,outdata,size);
  aes.Burn;
end;

procedure TFMonitor.monConnect(aSocket: TLSocket);
begin
  led_kolor:=clRed;
  if cDebug then debug.Debug('Code: [monOnConnect] - execute');
  CONST_RUN_BLOCK:=true;
  dm.DaneDoSzyfrowaniaClear;
  StatusBar1.Panels[0].Text:='Połączenie: OK';
  timer_start.Enabled:=true;
end;

procedure TFMonitor.Label4Click(Sender: TObject);
begin
  OpenUrl('http://studiojahu.duckdns.org/pytania-bezposrednio-do-studia.html');
end;

procedure TFMonitor.MenuItem1Click(Sender: TObject);
begin
  C_EXIT:=true;
  close;
end;

procedure TFMonitor.MenuItem6Click(Sender: TObject);
begin
  C_EXIT:=true;
  close;
end;

procedure TFMonitor.MenuItem8Click(Sender: TObject);
begin
  MenuItem7Click(Sender);
end;

procedure TFMonitor.autorunTimer(Sender: TObject);
var
  host: string;
begin
  autorun.Enabled:=false;
  led_kolor:=clRed;
  uEled1.Color:=clSilver;
  uEled1.Active:=true;
  application.ProcessMessages;
  if cDebug then debug.Debug('Timer: [autorun] - execute');

  host:='studiojahu.duckdns.org';
  if host='sun' then host:='127.0.0.1';
  if host='127.0.0.1' then host:='sun';

  if cDebug then debug.Debug('  connect begin');
  mon.MaxBuffer:=CONST_MAX_BUFOR;
  mon.Connect;
  if cDebug then debug.Debug('  connect end');
  if mon.Active then exit;

  autorun.Enabled:=not mon.Active;
  uEled1.Active:=mon.Active;
end;

procedure TFMonitor.BitBtn1Click(Sender: TObject);
var
  s: string;
begin
  s:=danenazwa.AsString;
  if (s='') or (s='[nazwy użytkownika brak]') then
  begin
    if mess.ShowConfirmationYesNo('Brak wypełnionego nicka. Uzupełnij najpierw sój profil, czy chcesz zrobić to teraz?') then MenuItem7Click(Sender);
    exit;
  end;
  if chat_run then
  begin
    FChat.Show;
    exit;
  end;
  FChat:=TFChat.Create(self,'Chat',-1,danenazwa.AsString,key,'','');
  //FChat.nick:=danenazwa.AsString;
  //FChat.key:=key;
  //FChat.nick2:='';
  //FChat.key2:='';
  FChat.OnSendMessage:=@SendMessage;
  FChat.OnSendMessageNoKey:=@SendMessageNoKey;
  FChat.OnExecuteDestroy:=@ChatDestroyTimer;
  FChat.OnTrayIconMessage:=@IconTrayMessage;
  FChat.OnAddKontakt:=@AddKontakt;
  FChat.OnKeyToNazwa:=@UserKeyToNazwa;
  FChat.OnGoBeep:=@go_beep;
  FChat.Show;
  chat_run:=true;
end;

procedure TFMonitor.BitBtn2Click(Sender: TObject);
var
  plik: string;
  typ: integer;
begin
  if ODialog.Execute then plik:=ODialog.FileName;
  if plik='' then exit;
  typ:=TextCertificate(plik);
  case typ of
    1: WizytowkaToProfil(plik);
    2: WizytowkaToKontakt(plik);
    3: WizytowkaToLinkFile(plik);
  end;
end;

procedure TFMonitor.BitBtn3Click(Sender: TObject);
begin
  mon.Disconnect;
end;

procedure TFMonitor.DBGridPlus1DblClick(Sender: TObject);
var
  token,k,s: string;
  i,a: integer;
  okno: TFChat;
  b: boolean;
begin
  s:=danenazwa.AsString;
  if (s='') or (s='[nazwy użytkownika brak]') then
  begin
    if mess.ShowConfirmationYesNo('Brak wypełnionego nicka. Uzupełnij najpierw sój profil, czy chcesz zrobić to teraz?') then MenuItem7Click(Sender);
    exit;
  end;
  b:=TDBGridPlus(Sender).Tag=1;
  IconTrayMessage(1);
  if not BitBtn2.Enabled then exit;
  (* otwarcie chatu prywatnego *)
  token:=dm.GetHashCode(4);
  if b then k:=DecryptString(usersklucz.AsString,token,true) else k:=DecryptString(usersklucz1.AsString,token,true);
  s:=k;
  setlength(s,5);
  a:=-1;
  for i:=0 to list_key.Count-1 do if list_key[i]=k then
  begin
    a:=i;
    break;
  end;
  if a=-1 then
  begin
    if b then okno:=TFChat.Create(self,'Chat_'+s,0,danenazwa.AsString,key,usersnazwa.AsString,k) else
              okno:=TFChat.Create(self,'Chat_'+s,0,danenazwa.AsString,key,usersnazwa1.AsString,k);
    a:=list.Add(okno);
    list_key.Insert(a,k);
    okno.IDENT:=a;
    okno.uELED1.Active:=true;
    okno.OnSendMessage:=@SendMessage;
    okno.OnSendMessageNoKey:=@SendMessageNoKey;
    okno.OnExecuteDestroy:=@ChatDestroyTimer;
    okno.OnTrayIconMessage:=@IconTrayMessage;
    okno.OnAddKontakt:=@AddKontakt;
    okno.OnGoBeep:=@go_beep;
    okno.OnClearPrive:=@clear_prive;
    if b then okno.Caption:='Okno rozmowy prywatnej ('+usersnazwa.AsString+')' else
              okno.Caption:='Okno rozmowy prywatnej ('+usersnazwa1.AsString+')';
    okno.Show;
  end else TFChat(list[a]).Show;
end;

procedure TFMonitor.dsusers2DataChange(Sender: TObject; Field: TField);
begin
  DBGridPlus2.Visible:=users2.RecordCount>0;
end;

procedure TFMonitor.FormShow(Sender: TObject);
begin
  {$IFDEF WINDOWS}propstorage.Restore;{$ENDIF}
end;

procedure TFMonitor.mCiszaClick(Sender: TObject);
begin
  if mCisza.ImageIndex=0 then mCisza.ImageIndex:=1 else mCisza.ImageIndex:=0;
end;

procedure TFMonitor.MenuItem10Click(Sender: TObject);
begin
  if users2.IsEmpty then exit;
  if not mess.ShowConfirmationYesNo('Użytkownik o nicku '+usersnazwa1.AsString+' zostanie usunięty z listy twoich kontaktów i ustawiony jako ignorowany.^Potwierdź tą operację.') then exit;
  trans.StartTransaction;
  (* dodanie użytkownika do ignorowanych *)
  ignores.Append;
  ignoresnick.AsString:=usersnazwa1.AsString;
  ignoresklucz.AsString:=usersklucz1.AsString;
  ignores.Post;
  (* wysłanie użytkownika do ignorowanych na serwerze *)
  //SendMessage('{IGNORE_CHAT_USER}',DecryptString(usersklucz1.AsString,dm.GetHashCode(4),true));
  (* usunięcie historii czata i kontaktu *)
  dbClearHistoryUser.ParamByName('user').AsString:=usersklucz1.AsString;
  dbClearHistoryUser.ExecSQL;
  users2.Delete;
  trans.Commit;
end;

procedure TFMonitor.MenuItem11Click(Sender: TObject);
begin
  schema.StructFileName:=MyDir('dbstruct.dat');
  schema.SaveSchema;
end;

procedure TFMonitor.MenuItem12Click(Sender: TObject);
var
  vMajorVersion,vMinorVersion,vRelease,vBuild: integer;
begin
  GetProgramVersion(vMajorVersion,vMinorVersion,vRelease,vBuild);
  mon.SendString('{SET_VERSION}$'+IntToStr(vMajorVersion)+'$'+IntToStr(vMinorVersion)+'$'+IntToStr(vRelease)+'$'+IntToStr(vBuild));
end;

procedure TFMonitor.MenuItem13Click(Sender: TObject);
var
  b: boolean;
begin
  FUsunKonfiguracje:=TFUsunKonfiguracje.Create(self);
  try
    FUsunKonfiguracje.ShowModal;
    b:=FUsunKonfiguracje.io_usun;
  finally
    FUsunKonfiguracje.Free;
  end;
  if b then
  begin
    propstorage.Active:=false;
    if DeleteFile(propstorage.FileName) then
    begin
      mess.ShowWarning('Plik konfiguracji usunięty, nastąpi teraz zamknięcie programu.^Uruchom go jeszcze raz i wszystko powinno działać już dobrze.');
      C_EXIT:=true;
      close;
    end;
  end;
end;

procedure TFMonitor.MenuItem15Click(Sender: TObject);
var
  s: string;
  s1,s2,s3,s4: string;
begin
  if db.Connected then s1:='aktywne' else s1:='nieaktywne';
  if dane.Active then s2:='aktywne' else s2:='nieaktywne';
  if users.Active then s3:='aktywne' else s3:='nieaktywne';
  if LIBUOS then s4:='aktywne' else s4:='nieaktywne';

  s:='UOS Sounds: '+s4+'^^Home: "'+GetUserDir+'"^^DB: '+s1+'^Kontrolka profilu: '+s2+'^Kontrolka uzytkowników: '+s3+'^^Error UOS:^'+uos.GetErrorStr;
  mess.ShowInformation('STATUS',s);
end;

procedure TFMonitor.MenuItem16Click(Sender: TObject);
begin
  if users.IsEmpty then exit;
  if not mess.ShowConfirmationYesNo('Użytkownik o nicku '+usersnazwa.AsString+' zostanie usunięty z listy twoich kontaktów.^Potwierdź tą operację.') then exit;
  trans.StartTransaction;
  dbClearHistoryUser.ParamByName('user').AsString:=usersklucz.AsString;
  dbClearHistoryUser.ExecSQL;
  users.Delete;
  trans.Commit;
end;

procedure TFMonitor.MenuItem17Click(Sender: TObject);
begin
  if users.IsEmpty then exit;
  FMojProfil:=TFMojProfil.Create(self);
  FMojProfil.io_id:=usersid.AsInteger;
  FMojProfil.ShowModal;
  users.Refresh;
end;

procedure TFMonitor.MenuItem20Click(Sender: TObject);
begin
  dbClearHistory.ExecSQL;
  users.Refresh;
  mess.ShowInformation('Historia wyczyszczona.');
end;

procedure TFMonitor.MenuItem22Click(Sender: TObject);
begin
  FIgnores:=TFIgnores.Create(self);
  FIgnores.ShowModal;
  ignores.Refresh;
end;

procedure TFMonitor.MenuItem23Click(Sender: TObject);
begin
  if users2.IsEmpty then exit;
  if not mess.ShowConfirmationYesNo('Użytkownik o nicku '+usersnazwa1.AsString+' zostanie usunięty z listy twoich kontaktów.^Potwierdź tą operację.') then exit;
  trans.StartTransaction;
  dbClearHistoryUser.ParamByName('user').AsString:=usersklucz1.AsString;
  dbClearHistoryUser.ExecSQL;
  users2.Delete;
  trans.Commit;
end;

procedure TFMonitor.MenuItem26Click(Sender: TObject);
var
  s: string;
begin
  s:=DecryptString(usersklucz.AsString,dm.GetHashCode(4),true)+'$GET_ALL_USERS';
  SendMessage('{ADM}',s);
end;

procedure TFMonitor.MenuItem27Click(Sender: TObject);
begin
  LoadImgConf;
end;

procedure TFMonitor.MenuItem28Click(Sender: TObject);
begin
  if ustawienia_run then
  begin
    FUstawienia.Show;
    exit;
  end;
  ustawienia_run:=true;
  FUstawienia:=TFUstawienia.Create(self);
  FUstawienia.OnGoBeep:=@go_beep;
  FUstawienia.OnSetChat:=@go_set_chat;
  FUstawienia.OnSetVectorContactsMessagesCounts:=@go_set_vector_contacts_messages_counts;
  FUstawienia.OnSetDebug:=@go_set_debug;
  FUstawienia.OnReloadEmotes:=@LoadImgConf;
  FUstawienia.Show;
end;

procedure TFMonitor.MenuItem2Click(Sender: TObject);
begin
  WizytowkaToProfil;
end;

procedure TFMonitor.MenuItem30Click(Sender: TObject);
begin
  NaprawaBazy;
end;

procedure TFMonitor.MenuItem31Click(Sender: TObject);
begin
  if users.IsEmpty then exit;
  SendChatSpecjal(danenazwa.AsString,DecryptString(usersklucz.AsString,dm.GetHashCode(4),true),1,'');
  mess.ShowInformation('Prośba o kontakt została wysłana.');
end;

procedure TFMonitor.MenuItem32Click(Sender: TObject);
begin
  C_KONIEC:=true;
  mon.Disconnect;
  master.Close;
  schema.SyncSchema;
  C_KONIEC:=false;
  master.Open;
  autorun.Enabled:=true;
end;

procedure TFMonitor.MenuItem33Click(Sender: TObject);
begin
  if plikownia_run then FPlikownia.Show else
  begin
    FPlikownia:=TFPlikownia.Create(self);
    FPlikownia.key:=key;
    FPlikownia.OnSetRunningForm:=@SetRunningPlikownia;
    FPlikownia.OnSetUploadingForm:=@SetUploadingPlikownia;
    FPlikownia.OnSetDownloadingForm:=@SetDownloadingPlikownia;
    FPlikownia.OnSendMessage:=@SendMessageBin;
    FPlikownia.OnSendMessageNoKey:=@SendMessageBinNoKey;
    FPlikownia.Show;
    plikownia_run:=true;
  end;
end;

procedure TFMonitor.MenuItem34Click(Sender: TObject);
begin
  if users.IsEmpty then exit;
  SendMessageNoKey('{BAN}',DecryptString(usersklucz.AsString,dm.GetHashCode(4),true));
end;

procedure TFMonitor.MenuItem36Click(Sender: TObject);
var
  b: boolean;
begin
  if studio_run then
  begin
    FStudio.Show;
    exit;
  end;
  (* odpala studio *)
  FStudio:=TFStudio.Create(self);
  FStudio.OnStudioGetData:=@StudioGetData;
  FStudio.OnSendMessage:=@SendMessage;
  FStudio.OnSendMessageNoKey:=@SendMessageNoKey;
  FStudio.OnExecuteDestroy:=@StudioDestroyTimer;
  FStudio.czas_atomowy.Correction:=wektor_czasu;
  FStudio.czas_atomowy.Start;
  FStudio.key:=key;
  FStudio.Show;
  studio_run:=true;
end;

procedure TFMonitor.MenuItem7Click(Sender: TObject);
begin
  FMojProfil:=TFMojProfil.Create(self);
  FMojProfil.io_id:=0;
  FMojProfil.ShowModal;
  dane.Refresh;
end;

procedure TFMonitor.MenuItem9Click(Sender: TObject);
begin
  if users2.IsEmpty then exit;
  users2.Edit;
  usersstatus1.AsInteger:=0;
  users2.Post;
  users2.Refresh;
  users.Refresh;
end;

procedure TFMonitor.monCryptBinary(const indata; var outdata; var size: longword
  );
var
  vec,klucz: string;
begin
  size:=CalcBuffer(size,16);
  dm.DaneDoSzyfrowania(vec,klucz);
  aes.Init(klucz[1],128,@vec[1]);
  aes.Encrypt(indata,outdata,size);
  aes.Burn;
end;

procedure TFMonitor.monError(const aMsg: string; aSocket: TLSocket);
begin
  if cDebug then debug.Debug('Code: [monOnError] - '+aMsg);
end;

procedure TFMonitor.monReceiveBinary(const outdata; size: longword;
  aSocket: TLSocket);
begin
  if C_AWATAR>0 then
  begin
    edit_plik.ParamByName('id').AsLargeInt:=C_AWATAR;
    edit_plik.ParamByName('awatar').SetBlobData(@outdata,size);
    edit_plik.ExecSQL;
    if plikownia_run then FPlikownia._refresh;
    C_AWATAR:=0;
    exit;
  end;
  if plikownia_run then FPlikownia.monReceiveBinary(outdata,size,aSocket);
end;

procedure TFMonitor.monReceiveString(aMsg: string; aSocket: TLSocket;
  aBinSize: integer; var aReadBin: boolean);
var
  b,bb: boolean;
  vNick,vOdKey,vDoKey,vOdKeyCrypt: string;
  a1,a2,a3,a4: integer;
  s1,s2,s3,s4,s5,s6,s7,s8,s9,s10: string;
  s: string;
  id,e,i: integer;
  b1: boolean;
begin
  //if cDebug then debug.Debug('ReceiveString: "'+aMsg+'"');
  //writeln('Mój klucz: ',key);
  //writeln('(',length(aMsg),') Otrzymałem: "',aMsg,'"');
  s:=GetLineToStr(aMsg,1,'$');
  if cDebug then debug.Debug('Code: [monReceiveString] - '+s);
  if s='{EXIT}' then timer_stop.Enabled:=true else
  if s='{BAN}' then tBAN.Enabled:=true else
  if s='{KEY-NEW}' then
  begin
    key:=GetLineToStr(aMsg,2,'$');
    try a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); except a1:=0; end;
    tReqKeyOk.Enabled:=a1=1;
    if studio_run then FStudio.key:=key;
    if chat_run then FChat.key:=key;
    PutKey(key);
    if studio_run then
    begin
      mon.SendString('{READ_ALL}');
      mon.SendString('{INFO}$'+key+'$ALL');
    end;
    CONST_GET_CHAT:=true;
    mon.SendString('{GET_CHAT}');
    odblokowanie_uslug;
  end else
  if s='{KEY-OK}' then
  begin
    if studio_run then
    begin
      mon.SendString('{READ_ALL}');
      mon.SendString('{INFO}$'+key+'$ALL');
    end;
    CONST_GET_CHAT:=true;
    mon.SendString('{GET_CHAT}');
    odblokowanie_uslug;
  end else
  if s='{KEY-IS-LOGIN}' then LoginWtorny else
  if s='{IS_LIVE}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','-1'));
    a2:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    if a2=0 then mon.SendString('{IS_LIVE}$'+IntToStr(a1)+'$1') else if a2=1 then LoginWtorny;
  end else
  if s='{GET_CHAT_END}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$'));
    CONST_GET_CHAT:=false;
    if a1>0 then
    begin
      users.Refresh;
      go_beep;
    end;
  end else
  if s='{VECTOR_OK}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector;
    mon.GetTimeVector;
    if studio_run then mon.SendString('{READ_MON}');
    PolaczenieAktywne;
  end else
  if s='{VECTOR_IS_NEW}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector(GetLineToStr(aMsg,2,'$'));
    mon.GetTimeVector;
    if studio_run then mon.SendString('{READ_MON}');
    PolaczenieAktywne;
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
  if s='{SET_VERSION_ERR}' then
  begin
    e:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    if e=0 then mess.ShowInformation('SET_VERSION','Zwrócono komunikat błędu = 0.') else
                mess.ShowError('SET_VERSION','Zwrócono komunikat błędu = '+IntToStr(e)+'.');
  end else
  if s='{NEW_VERSION}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    a2:=StrToInt(GetLineToStr(aMsg,3,'$','0'));
    a3:=StrToInt(GetLineToStr(aMsg,4,'$','0'));
    a4:=StrToInt(GetLineToStr(aMsg,5,'$','0'));
    TestWersji(a1,a2,a3,a4);
  end else
  if cZDALNYDOSTEP and (s='{ADM}') then
  begin
    s1:=GetLineToStr(aMsg,2,'$',''); //klucz nadawcy
    s2:=GetLineToStr(aMsg,3,'$',''); //klucz odbiorcy
    s3:=GetLineToStr(aMsg,4,'$',''); //operacja
    if s2<>key then exit;
    if s3='GET_ALL_USERS' then
    begin
      cZDOper:=1;
      cZDAdresat:=s1;
      tAdmAllUser.Enabled:=true;
    end;
  end else
  if Programistyczne.Visible and (s='{ADMO}') then
  begin
    writeln(aMsg);
  end else
  if s='{FILE_REQUESTING}' then
  begin
    s1:=GetLineToStr(aMsg,2,'$','');  //klucz nadawcy
    s2:=GetLineToStr(aMsg,3,'$','');  //klucz odbiorcy
    if s2<>key then exit;
    s3:=GetLineToStr(aMsg,4,'$','');  //nick
    s4:=GetLineToStr(aMsg,5,'$','');  //indeks
    s5:=GetLineToStr(aMsg,6,'$','');  //nazwa
    s6:=GetLineToStr(aMsg,7,'$','');  //wielkość pliku
    s7:=GetLineToStr(aMsg,8,'$','');  //czas utworzenia
    s8:=GetLineToStr(aMsg,9,'$','');  //czas modyfikacji
    s9:=GetLineToStr(aMsg,10,'$',''); //opis
    a1:=StrToInt(GetLineToStr(aMsg,11,'$','0')); //public
    a2:=StrToInt(GetLineToStr(aMsg,12,'$','0')); //lp nastepnego pliku - domyślnie 0
    (* sprawdzam czy plik był już wcześniej dodany *)
    is_plik.ParamByName('indeks').AsString:=s4;
    is_plik.Open;
    if is_plik.IsEmpty then id:=0 else if is_plikid.IsNull then id:=0 else id:=is_plikid.AsInteger;
    is_plik.Close;
    if id=0 then
    begin
      (* dodanie pliku *)
      add_plik.ParamByName('indeks').AsString:=s4;
      add_plik.ParamByName('nick').AsString:=s3;
      add_plik.ParamByName('klucz').AsString:=EncryptString(s1,dm.GetHashCode(4),64);
      add_plik.ParamByName('nazwa').AsString:=s5;
      add_plik.ParamByName('dlugosc').AsLargeInt:=StrToInt64(s6);
      add_plik.ParamByName('czas_wstawienia').AsString:=FormatDateTime('yyyy-mm-dd hh:nn:ss',StrToDateTime(s7));
      add_plik.ParamByName('czas_modyfikacji').AsString:=FormatDateTime('yyyy-mm-dd hh:nn:ss',StrToDateTime(s8));
      if s1=key then add_plik.ParamByName('status').AsInteger:=1 else add_plik.ParamByName('status').AsInteger:=0;
      if s9='' then add_plik.ParamByName('opis').Clear else add_plik.ParamByName('opis').AsString:=s9;
      add_plik.ParamByName('awatar').Clear;
      add_plik.ParamByName('public').AsInteger:=a1;
      add_plik.ExecSQL;
      if plikownia_run then FPlikownia.pliki.Refresh;
      if aBinSize>0 then
      begin
        C_AWATAR:=trans.GetLastId;
        aReadBin:=true;
      end;
    end else begin
      (* aktualizacja pliku *)
      edit_plik2.ParamByName('nazwa').AsString:=s5;
      edit_plik2.ParamByName('dlugosc').AsLargeInt:=StrToInt64(s6);
      edit_plik2.ParamByName('czas_wstawienia').AsString:=FormatDateTime('yyyy-mm-dd hh:nn:ss',StrToDateTime(s7));
      edit_plik2.ParamByName('czas_modyfikacji').AsString:=FormatDateTime('yyyy-mm-dd hh:nn:ss',StrToDateTime(s8));
      if s9='' then edit_plik2.ParamByName('opis').Clear else edit_plik2.ParamByName('opis').AsString:=s9;
      edit_plik2.ParamByName('public').AsInteger:=a1;
      edit_plik2.ParamByName('id').AsInteger:=id;
      edit_plik2.ExecSQL;
      if plikownia_run then FPlikownia.pliki.Refresh;
      if aBinSize>0 then
      begin
        C_AWATAR:=id;
        aReadBin:=true;
      end;
    end;
    if a2>0 then SendMessage('{GET_PUBLIC}','$'+IntToStr(a2));
  end else
  if s='{FILE_STATING_EXIST}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','0')); //id pliku
    s1:=GetLineToStr(aMsg,3,'$',''); //indeks
    a2:=StrToInt(GetLineToStr(aMsg,4,'$','-1')); //status: -1=błąd, 0=deleted, 1=exist_not_public, 2=exist_public
    case a2 of
      0: begin
           del_plik.ParamByName('id').AsInteger:=a1;
           del_plik.ExecSQL;
           if plikownia_run then FPlikownia.pliki.Refresh;
         end;
      1: begin
           edit_pp.ParamByName('id').AsInteger:=a1;
           edit_pp.ParamByName('public').AsInteger:=0;
           edit_pp.ExecSQL;
           if plikownia_run then FPlikownia.pliki.Refresh;
         end;
      2: begin
           edit_pp.ParamByName('id').AsInteger:=a1;
           edit_pp.ParamByName('public').AsInteger:=1;
           edit_pp.ExecSQL;
           if plikownia_run then FPlikownia.pliki.Refresh;
         end;
    end;
    StatFileTest;
  end else
  if s='{SIGNAL}' then
  begin
    s1:=GetLineToStr(aMsg,2,'$',''); //klucz nadawcy
    s2:=GetLineToStr(aMsg,3,'$',''); //klucz odbiorcy
    if s2<>key then exit;
    s3:=GetLineToStr(aMsg,4,'$',''); //kod operacji
    s4:=GetLineToStr(aMsg,5,'$',''); //kod statusu
    s5:=GetLineToStr(aMsg,6,'$',''); //tresc 1
    s6:=GetLineToStr(aMsg,6,'$',''); //tresc 2
    if s3='MESSAGE' then
    begin
      case StrToInt(s4) of
        2: mess.ShowInformation('Wiadomość systemowa',s5);
      end;
    end;
  end else
  if s='{USERS_COUNT}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    StatusBar1.Panels[1].Text:='Ilość końcówek: '+IntToStr(a1);
  end else begin
    bb:=false;
    if studio_run then bb:=FStudio.monReceiveString(aMsg,s,aSocket);
    if (not bb) and chat_run then bb:=FChat.monReceiveString(aMsg,s,aSocket);
    if not bb then for i:=0 to list.Count-1 do
    begin
      bb:=TFChat(list[i]).monReceiveString(aMsg,s,aSocket);
      if bb then break;
    end;
    if (not bb) and plikownia_run then bb:=FPlikownia.monReceiveString(aMsg,s,aSocket,aBinSize,aReadBin);
    if not bb then
    begin
      (* jeśli to wiadomość prywatna to zapisuję i powiadamiam *)
      vNick:=GetLineToStr(aMsg,3,'$','');
      vOdKey:=GetLineToStr(aMsg,2,'$','');
      vOdKeyCrypt:=EncryptString(vOdKey,dm.GetHashCode(4),64);
      IsIgnore.ParamByName('klucz').AsString:=vOdKeyCrypt;
      IsIgnore.Open;
      b:=IsIgnoreile.AsInteger=1;
      IsIgnore.Close;
      if b then exit;
      vDoKey:=GetLineToStr(aMsg,4,'$','');
      if (s='{CHAT}') and (vOdKey<>'') and (vDoKey<>'') then
      begin
        s5:=GetLineToStr(aMsg,8,'$','');
        if s5<>'' then SendMessage('{FILE_REQUEST}',s5);
        IsUser.ParamByName('klucz').AsString:=vOdKeyCrypt;
        IsUser.Open;
        if IsUser.IsEmpty then e:=2 else e:=IsUserstatus.AsInteger;
        IsUser.Close;
        if e=2 then AddKontakt(vOdKey,vNick,true);
        prive1.Open;
        prive1.Append;
        prive1insertdt.AsString:=GetLineToStr(aMsg,7,'$','');
        prive1nadawca.AsString:=vOdKeyCrypt;
        prive1nick.AsString:=vNick;
        prive1adresat.AsString:=EncryptString(vDoKey,dm.GetHashCode(4),64);
        prive1formatowanie.AsString:=GetLineToStr(aMsg,5,'$','');
        prive1tresc.AsString:=GetLineToStr(aMsg,6,'$','');
        prive1przeczytane.AsInteger:=0;
        prive1.Post;
        prive1.Close;
        if e=0 then users.Refresh else users2.Refresh;
        IconTrayMessage(2);
        if not CONST_GET_CHAT then go_beep;
      end;
    end;
  end;
end;

procedure TFMonitor.monStatus(aActive, aCrypt: boolean);
begin
  ping_pong.Enabled:=aActive;
end;

procedure TFMonitor.ping_pongTimer(Sender: TObject);
begin
  if mon.Active then SendMessageNoKey('{PING}');
end;

type
  TDataArray = array [0..65535] of char;
  PDataArray = ^TDataArray;

procedure TFMonitor.schema2Create(Sender: TObject; TagNo: integer; var Stopped,
  NegationResult, ForceUpgrade: boolean);
var
  q: TZQuery;
begin
  q:=TZQuery.Create(self);
  q.Connection:=db;
  try
    q.SQL.Add('insert into config (zmienna,value_int) values (:zmienna,:wartosc);');
    q.ParamByName('zmienna').AsString:='verdb';
    q.ParamByName('wartosc').AsInteger:=0;
    q.ExecSQL;
  finally
    q.Free;
  end;
  Stopped:=true;
  ForceUpgrade:=true;
end;

procedure TFMonitor.schema2Upgrade(Sender: TObject; TagNo, VerDB: integer;
  var Stopped: boolean);
var
  q: TZQuery;
  s,s2: string;
begin
  q:=TZQuery.Create(self);
  q.Connection:=db;
  try
    trans.StartTransaction;
    if VerDB=1 then
    begin
      (* PRZESZYFROWUJĘ WSZYSTKO NA NOWE KLUCZE *)
      (* wpis profilowy *)
      dane.Open;
      if not dane.IsEmpty then
      begin
        s:=GetKey(dm.GetHashCode(3,true));
        if s<>'' then PutKey(s);
      end;
      dane.Close;
      (* wpisy kontaktów *)
      q.SQL.Clear;
      q.SQL.Add('select id,klucz from users');
      q.SQL.Add('where id>0');
      q.Open;
      while not q.EOF do
      begin
        s:=DecryptString(q.FieldByName('klucz').AsString,dm.GetHashCode(4,true),true);
        q.Edit;
        q.FieldByName('klucz').AsString:=EncryptString(s,dm.GetHashCode(4),64);
        q.Post;
        q.Next;
      end;
      q.Close;
      (* wpisy kontaktów ignorowanych *)
      q.SQL.Clear;
      q.SQL.Add('select id,klucz from ignores');
      q.Open;
      while not q.EOF do
      begin
        s:=DecryptString(q.FieldByName('klucz').AsString,dm.GetHashCode(4,true),true);
        q.Edit;
        q.FieldByName('klucz').AsString:=EncryptString(s,dm.GetHashCode(4),64);
        q.Post;
        q.Next;
      end;
      q.Close;
      (* wpisy wiadomości *)
      //EncryptString(vDoKey,dm.GetHashCode(4),64);
      q.SQL.Clear;
      q.SQL.Add('select id,nadawca,adresat from prive');
      q.Open;
      while not q.EOF do
      begin
        s:=DecryptString(q.FieldByName('nadawca').AsString,dm.GetHashCode(4,true),true);
        s2:=DecryptString(q.FieldByName('adresat').AsString,dm.GetHashCode(4,true),true);
        q.Edit;
        q.FieldByName('nadawca').AsString:=EncryptString(s,dm.GetHashCode(4),64);
        q.FieldByName('adresat').AsString:=EncryptString(s2,dm.GetHashCode(4),64);
        q.Post;
        q.Next;
      end;
      q.Close;
    end else
    if VerDB=2 then
    begin
      q.SQL.Clear;
      q.SQL.Add('select id,klucz from pliki order by id');
      q.Open;
      while not q.EOF do
      begin
        if length(trim(q.FieldByName('klucz').AsString))=24 then
        begin
          q.Edit;
          q.FieldByName('klucz').AsString:=EncryptString(q.FieldByName('klucz').AsString,dm.GetHashCode(4),64);
          q.Post;
        end;
        q.Next;
      end;
      q.Close;
    end else
    if VerDB=3 then
    begin
      q.SQL.Clear;
      q.SQL.Add('update pliki set czas_modyfikacji=czas_wstawienia where czas_modyfikacji is null');
      q.ExecSQL;
    end;
    trans.Commit;
  finally
    q.Free;
  end;
end;

procedure TFMonitor.schemaAfterSync(Sender: TObject);
begin
  schema2.Execute;
end;

procedure TFMonitor.schemaLoadMemStruct(aValue: TStringList);
var
  res: TResourceStream;
begin
  try
    res:=TResourceStream.Create(hInstance,'DBSTRUCT',RT_RCDATA);
    aValue.LoadFromStream(res);
  finally
    res.Free;
  end;
end;

procedure TFMonitor.tAdmAllUserTimer(Sender: TObject);
var
  pom: TColor;
  q: TZQuery;
  s: string;
  id,i: integer;
  s1: string;
begin
  tAdmAllUser.Enabled:=false;
  pom:=uELED1.Color;
  if cZDOper=1 then
  begin
    uELED1.Color:=clBlue;
    application.ProcessMessages;
    for i:=1 to 20 do begin application.ProcessMessages; sleep(100); end;
    q:=TZQuery.Create(self);
    q.Connection:=db;
    q.SQL.Add('select id,klucz,nazwa,status from users order by id');
    try
      q.Open;
      while not q.EOF do
      begin
        id:=q.FieldByName('id').AsInteger;
        if id=0 then s1:=DecryptString(q.FieldByName('klucz').AsString,dm.GetHashCode(3),true) else
                     s1:=DecryptString(q.FieldByName('klucz').AsString,dm.GetHashCode(4),true);
        s:=cZDAdresat+'$1$'+q.FieldByName('id').AsString+'$'+s1+'$'+q.FieldByName('nazwa').AsString+'$'+q.FieldByName('status').AsString;
        SendMessage('{ADMO}',s);
        sleep(100);
        application.ProcessMessages;
        q.Next;
      end;
      s:=cZDAdresat+'$0';
      SendMessage('{ADMO}',s);
      q.Close;
    finally
      q.Free;
    end;
    cZDOper:=0;
    cZDAdresat:='';
  end;
  uELED1.Color:=pom;
end;

procedure TFMonitor.tBANTimer(Sender: TObject);
begin
  tBAN.Enabled:=false;
  C_EXIT:=true;
  close;
end;

procedure TFMonitor.tFreeChatTimer(Sender: TObject);
begin
  tFreeChat.Enabled:=false;
  if cDebug then debug.Debug('Timer: [tFreeChat] - execute');
  ChatDestroy;
end;

procedure TFMonitor.tHaltTimer(Sender: TObject);
begin
  tHalt.Enabled:=false;
  mess.ShowWarning('Próbujesz zalogować się powtórnie!^Serwer odmawia ponownego zalogowania.^^Wychodzę.');
  C_EXIT:=true;
  close;
end;

procedure TFMonitor.tReqKeyOkTimer(Sender: TObject);
begin
  tReqKeyOk.Enabled:=false;
  mess.ShowInformation('Twoje żądanie ustawienia tożsamości zostało zaakceptowane.^Od tej chwili pracujesz z nową tożsamością.');
end;

procedure TFMonitor._GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText:=Sender.AsString;
end;

procedure TFMonitor._SetText(Sender: TField; const aText: string);
begin
  Sender.AsString:=aText;
end;

procedure TFMonitor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  b: boolean;
begin
  if cDebug then debug.Debug('Code: [FMonitorOnClose] - execute');
  b:=CONST_RUN_BLOCK;
  if (not C_EXIT) and (not b) then b:=IniReadBool('Flags','CloseToTray',false);
  if b then
  begin
    CloseAction:=caNone;
    WindowState:=wsMinimized;
    hide;
    exit;
  end;
  C_KONIEC:=true;
  StudioDestroy;
  ZamknijWszystkieChaty;
  if plikownia_run then
  begin
    FPlikownia.Free;
    plikownia_run:=false;
  end;
  if mon.Active then
  begin
    mon.Disconnect;
    sleep(250);
  end;
end;

procedure TFMonitor.FormCreate(Sender: TObject);
var
  b: boolean;
  a,ie: integer;
  plik: string;
begin
  application.OnDeactivate:=@AppOnDeactivate;
  application.OnActivate:=@AppOnActivate;
  IniOpen(MyConfDir('monitor.ini'));
  okna_do_zabicia:=TList.Create;
  list:=TList.Create;
  list_key:=TStringList.Create;
  signales:=TStringList.Create;
  img1:=TStringList.Create;
  img2:=TStringList.Create;
  stat_file_test:=TStringList.Create;
  LoadImgConf;
  DBGridPlus1.AutoScaleVector:=IniReadInteger('Path','ContactsMessagesCounts',0);
  schema.init;
  {$IFDEF UNIX}
  if DirectoryExists('/usr/local/lib/komunikator-jahu') then schema.StructFileName:='/usr/local/lib/komunikator-jahu/dbstruct.dat' else
  if DirectoryExists('/usr/lib/komunikator-jahu') then schema.StructFileName:='/usr/lib/komunikator-jahu/dbstruct.dat' else
  if DirectoryExists('/usr/local/share/komunikator-jahu') then schema.StructFileName:='/usr/local/share/komunikator-jahu/dbstruct.dat' else
  if DirectoryExists('/usr/share/komunikator-jahu') then schema.StructFileName:='/usr/share/komunikator-jahu/dbstruct.dat';
  {$ELSE}
  schema.StructFileName:=MyDir('dbstruct.dat');
  {$ENDIF}
  studio_run:=false;
  chat_run:=false;
  plikownia_run:=false;
  b:=false;
  Caption:='Komunikator JAHU ('+dm.aVER+')';
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  SetDebug(IniReadBool('Debug','RegisterExecuteCode',false));
  LIBUOS:=uos.LoadLibrary;
  mCisza.Visible:=LIBUOS;
  //mCiszaClick(Sender);
  (* SYSTEM SETTINGS >> *)
  case IniReadInteger('System','BufferSettings',1) of
    0: a:=1024;
    1: a:=20480;
    2: a:=65424;
  end;
  CONST_UP_FILE_BUFOR:=a;
  CONST_DW_FILE_BUFOR:=a;
  C_AWATAR:=0;
  (* << SYSTEM SETTINGS *)
  plik:=MyConfDir('monitor.sqlite');
  b:=FileExists(plik);
  db.Database:=plik;
  try
    ie:=1; db.Connect;
    if (not b) or (dm.aVER<>PropStorage.ReadString('verdb','')) then
    begin
      ie:=2;
      schema.SyncSchema;
      PropStorage.WriteString('verdb',dm.aVER);
    end;
    //schema2.Execute; //do testów, normalnie ma być wyłączone!
    ie:=3; master.Open;
  except
    on E: Exception do mess.ShowError('Błąd związany z DB ('+IntToStr(ie)+'):^^'+E.Message);
  end;
  if not mon.Active then autorun.Enabled:=true;
  if (not IniReadBool('Flags','CloseToTray',b)) or (not IniReadBool('Flags','StartMinimize',false)) then
  begin
    WindowState:=wsNormal;
    show;
  end;
end;

procedure TFMonitor.FormDestroy(Sender: TObject);
begin
  if cDebug then debug.Debug('DESTROY: [OnDestroy] - execute');
  IniClose;
  if LIBUOS then uos.UnLoadLibrary;
  okna_do_zabicia.Free;
  list.Free;
  list_key.Free;
  signales.Free;
  img1.Free;
  img2.Free;
  stat_file_test.Free;
  master.Close;
  db.Disconnect;
end;

procedure TFMonitor.monDisconnect;
begin
  if cDebug then debug.Debug('Code: [monOnDisconnect] - execute');
  zablokowanie_uslug;
  BitBtn1.Enabled:=false;
  MenuItem36.Enabled:=false;
  BitBtn2.Enabled:=false;
  BitBtn3.Enabled:=false;
  uEled1.Active:=false;
  dm.DaneDoSzyfrowaniaClear;
  restart;
end;

procedure TFMonitor.monProcessMessage;
begin
  Application.ProcessMessages;
end;

procedure TFMonitor.monTimeVector(aTimeVector: integer);
begin
  CONST_RUN_BLOCK:=false;
  BitBtn1.Enabled:=mon.Port<>4680;
  MenuItem36.Enabled:=true;
  BitBtn2.Enabled:=true;
  BitBtn3.Enabled:=true;
  wektor_czasu:=aTimeVector;
  key:=GetKey;
  mon.SendString('{LOGIN}$'+key);
end;

procedure TFMonitor.propstorageRestoreProperties(Sender: TObject);
begin
  mon.Host:=propstorage.ReadString('custom-ip','studiojahu.duckdns.org');
  Programistyczne.Visible:=propstorage.ReadBoolean('DEV',false);
  MenuItem35.Visible:=Programistyczne.Visible;
  MenuItem34.Visible:=Programistyczne.Visible;
end;

procedure TFMonitor.texitTimer(Sender: TObject);
begin
  texit.Enabled:=false;
  if cDebug then debug.Debug('Timer: [texit] - execute');
  C_KONIEC:=false;
  autorun.Enabled:=not mon.Connect;
end;

procedure TFMonitor.tFreeStudioTimer(Sender: TObject);
begin
  tFreeStudio.Enabled:=false;
  if cDebug then debug.Debug('Timer: [tFreeStudio] - execute');
  StudioDestroy;
end;

procedure TFMonitor.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  if cDebug then debug.Debug('Timer: [timer_start] - execute');
  mon.SendString('{GET_VECTOR}');
end;

procedure TFMonitor.timer_stopTimer(Sender: TObject);
begin
  timer_stop.Enabled:=false;
  if cDebug then debug.Debug('Timer: [timer_stop] - execute');
  C_KONIEC:=true;
  mon.Disconnect;
  texit.Enabled:=true;
end;

procedure TFMonitor.TrayIcon1Click(Sender: TObject);
begin
  if WindowState=wsNormal then
  begin
    WindowState:=wsMinimized;
    hide;
  end else begin
    WindowState:=wsNormal;
    show;
  end;
end;

function TFMonitor.TextCertificate(aFileName: string): integer;
var
  f: textfile;
  s: string;
begin
  assignfile(f,aFileName);
  reset(f);
  readln(f,s);
  closefile(f);
  if s='-----BEGIN STUDIO JAHU CERTIFICAT-----' then result:=1 //Certyfikat konta/tożsamości
  else
  if s='-----BEGIN STUDIO JAHU CONTACT-----' then result:=2 //Dane kontaktu
  else
  if s='-----BEGIN STUDIO JAHU LINK-FILE-----' then result:=3 //Dane pliku do ściągnięcia
  else result:=0;
end;

procedure TFMonitor.AppOnDeactivate(Sender: TObject);
begin
  cNonActive:=true;
end;

procedure TFMonitor.AppOnActivate(Sender: TObject);
begin
  cNonActive:=false;
end;

procedure TFMonitor.LoadImgConf;
var
  plik: string;
  tmp: TStringList;
  i: integer;
begin
  plik:=MyConfDir('img'+_FF+'img.conf');
  img1.Clear;
  img2.Clear;
  if FileExists(plik) then
  begin
    tmp:=TStringList.Create;
    try
      tmp.LoadFromFile(plik);
      for i:=0 to tmp.Count-1 do
      begin
        img1.Add(GetLineToStr(tmp[i],1,#9));
        img2.Add(GetLineToStr(tmp[i],2,#9));
      end;
    finally
      tmp.Free;
    end;
  end;
end;

procedure TFMonitor.LoginWtorny;
begin
  tHalt.Enabled:=true;
end;

procedure TFMonitor.go_beep(aIndex: integer);
var
  res: TResourceStream;
begin
  if mCisza.ImageIndex=1 then exit;
  if cVOL=-1 then cVOL:=IniReadInteger('Audio','Volume',100);
  (*
  BLEEP-SOUND
  BLOOPER-SOUND
  CLICK-SOUND
  CONNECTION-SOUND
  DING-SOUND
  ERROR-SOUND
  ERROR2-SOUND
  BEEP-SOUND
  SMS-TONE
  TICKET-SOUND
  *)
  if not LIBUOS then exit;
  play1.Stop;
  try
    sound1:=TMemoryStream.Create;
    case IniReadInteger('Audio','DefaultBeep',0) of
      0: res:=TResourceStream.Create(hInstance,'BLEEP-SOUND',RT_RCDATA);
      1: res:=TResourceStream.Create(hInstance,'BLOOPER-SOUND',RT_RCDATA);
      2: res:=TResourceStream.Create(hInstance,'CLICK-SOUND',RT_RCDATA);
      3: res:=TResourceStream.Create(hInstance,'CONNECTION-SOUND',RT_RCDATA);
      4: res:=TResourceStream.Create(hInstance,'DING-SOUND',RT_RCDATA);
      5: res:=TResourceStream.Create(hInstance,'ERROR-SOUND',RT_RCDATA);
      6: res:=TResourceStream.Create(hInstance,'ERROR2-SOUND',RT_RCDATA);
      7: res:=TResourceStream.Create(hInstance,'BEEP-SOUND',RT_RCDATA);
      8: res:=TResourceStream.Create(hInstance,'SMS-TONE',RT_RCDATA);
      9: res:=TResourceStream.Create(hInstance,'TICKET-SOUND',RT_RCDATA);
    end;
    sound1.LoadFromStream(res);
  finally
    res.Free;
  end;
  play1.Volume:=cVOL/100;
  play1.Start(sound1);
end;

procedure TFMonitor.go_set_chat(aFont, aFont2: string; aSize, aSize2, aColor,
  aFormat, aMaxLineChat: integer);
var
  i: integer;
begin
  if chat_run then FChat.GoSetChat(aFont,aFont2,aSize,aSize2,aColor,aFormat,aMaxLineChat);
  for i:=0 to list.Count-1 do TFChat(list[i]).GoSetChat(aFont,aFont2,aSize,aSize2,aColor,aFormat,aMaxLineChat);
end;

procedure TFMonitor.go_set_vector_contacts_messages_counts(aValue: integer);
begin
  DBGridPlus1.AutoScaleVector:=aValue;
end;

procedure TFMonitor.go_set_debug(aDebug: boolean);
begin
  SetDebug(aDebug);
end;

procedure TFMonitor.RequestRegisterKey(aKey: string; aUsunStaryKlucz: boolean);
begin
  if aUsunStaryKlucz then SendMessage('{REQUEST_NEW_KEY}',aKey+'$1') else SendMessage('{REQUEST_NEW_KEY}',aKey+'$0');
end;

procedure TFMonitor.SetDebug(aDebug: boolean);
begin
  if aDebug then
  begin
    if not cDebug then
    begin
      (* uruchamiam debugowanie *)
      debug.Active:=true;
      debug.Debug('--- DEBUG_START ---');
    end;
  end else begin
    if cDebug then
    begin
      (* wyłączam debugowanie *)
      debug.Debug('--- DEBUG_STOP ---');
      debug.Active:=false;
    end;
  end;
  cDEBUG:=aDebug;
end;

procedure TFMonitor.clear_prive(aValue: string);
begin
  dbPrzeczytane.ParamByName('user').AsString:=aValue;
  dbPrzeczytane.ExecSQL;
  users.Refresh;
  users2.Refresh;
end;

procedure TFMonitor.PutKey(aKey: string);
begin
  if dane.IsEmpty then
  begin
    dane.Append;
    daneid.AsInteger:=0;
  end else dane.Edit;
  daneklucz.AsString:=EncryptString(aKey,dm.GetHashCode(3),128);
  dane.Post;
end;

function TFMonitor.GetKey(aToken: string): string;
var
  vKey: string;
  vToken: string;
begin
  if dane.IsEmpty then
  begin
    result:='';
    exit;
  end;
  vKey:=daneklucz.AsString;
  if vKey='' then
  begin
    result:='';
    exit;
  end;
  if aToken='' then vToken:=dm.GetHashCode(3) else vToken:=aToken;
  result:=DecryptString(vKey,vToken,true);
end;

procedure TFMonitor.AddKontakt(aKey, aNazwa: string; aSzary: boolean);
var
  s: string;
  b: boolean;
  t: TZQuery;
begin
  if aSzary then t:=users2 else t:=users;
  (* zakodowanie klucza *)
  s:=EncryptString(aKey,dm.GetHashCode(4),64);
  (* sprawdzenie czy taki klucz już istnieje *)
  user_exist.ParamByName('klucz').AsString:=s;
  user_exist.Open;
  b:=(user_existile.AsInteger=0);
  user_exist.Close;
  if b then
  begin
    (* dodanie kontaktu jeśli nie istnieje *)
    t.Append;
    t.FieldByName('klucz').AsString:=s;
    t.FieldByName('nazwa').AsString:=aNazwa;
    if aSzary then t.FieldByName('status').AsInteger:=1 else //KONTAKT SZARY
    t.FieldByName('status').AsInteger:=0; //KONTAKT NORMALNY
    t.Post;
  end;
  t.Refresh;
end;

//Jeśli nazwa nie zostanie ustawiona to nie zostanie zmieniona!
procedure TFMonitor.UserKeyToNazwa(aKey: string; var aNazwa: string);
var
  s: string;
begin
  KeyToUser.ParamByName('klucz').AsString:=EncryptString(aKey,dm.GetHashCode(4),64);
  KeyToUser.Open;
  s:=KeyToUsernazwa.AsString;
  KeyToUser.Close;
  if s<>'' then aNazwa:=s;
end;

procedure TFMonitor.TestWersji(a1, a2, a3, a4: integer);
var
  vMajorVersion,vMinorVersion,vRelease,vBuild: integer;
  b: boolean;
  s1,s2,s3,s4: string;
begin
  b:=false;
  GetProgramVersion(vMajorVersion,vMinorVersion,vRelease,vBuild);
  if a1>vMajorVersion then b:=true else
  if (a1=vMajorVersion) and (a2>vMinorVersion) then b:=true else
  if (a1=vMajorVersion) and (a2=vMinorVersion) and (a3>vRelease) then b:=true else
  if (a1=vMajorVersion) and (a2=vMinorVersion) and (a3=vRelease) and (a4>vBuild) then b:=true;
  if b then
  begin
    s1:=IntToStr(a1);
    s2:=IntToStr(a2);
    s3:=IntToStr(a3);
    s4:=IntToStr(a4);
    Label2.Caption:='Dostępna nowa wersja programu '+s1+'.'+s2+'.'+s3+'-'+s4;
    Label2.Visible:=true;
  end;
end;

procedure TFMonitor.IconTrayMessage(aValue: integer);
begin
  case aValue of
    0: TrayIcon1.Icon.LoadFromResourceName(Hinstance,'TRAY_NOCONNECT');
    1: TrayIcon1.Icon.LoadFromResourceName(Hinstance,'TRAY_NORMAL');
    2: TrayIcon1.Icon.LoadFromResourceName(Hinstance,'TRAY_MESSAGE');
  end;
end;

procedure TFMonitor.zablokowanie_uslug;
var
  i: integer;
begin
  IconTrayMessage(0);
  if chat_run then FChat.blokuj;
  for i:=0 to list.Count-1 do TFChat(list[i]).blokuj;
end;

procedure TFMonitor.odblokowanie_uslug;
var
  i: integer;
begin
  IconTrayMessage(1);
  uELED1.Color:=led_kolor;
  uEled1.Active:=true;
  if chat_run then FChat.odblokuj(-1);
  for i:=0 to list.Count-1 do TFChat(list[i]).odblokuj(i);
end;

procedure TFMonitor.SendMessage(aKomenda: string; aValue: string);
var
  s: string;
begin
  if aValue='' then s:=aKomenda+'$'+key else s:=aKomenda+'$'+key+'$'+aValue;
  //if cDebug then debug.Debug('SendString: "'+s+'"');
  mon.SendString(s);
end;

procedure TFMonitor.SendMessageNoKey(aKomenda: string; aValue: string);
var
  s: string;
begin
  if aValue='' then s:=aKomenda else s:=aKomenda+'$'+aValue;
  //if cDebug then debug.Debug('SendStringNoKey: "'+s+'"');
  mon.SendString(s);
end;

procedure TFMonitor.SendMessageBin(aKomenda: string; aValue: string;
  aBlock: pointer; aBlockSize: integer);
var
  s: string;
begin
  if aValue='' then s:=aKomenda+'$'+key else s:=aKomenda+'$'+key+'$'+aValue;
  mon.SendString(s,aBlock,aBlockSize);
end;

procedure TFMonitor.SendMessageBinNoKey(aKomenda: string; aValue: string;
  aBlock: pointer; aBlockSize: integer);
var
  s: string;
begin
  if aValue='' then s:=aKomenda else s:=aKomenda+'$'+aValue;
  mon.SendString(s,aBlock,aBlockSize);
end;

procedure TFMonitor.SendChatSpecjal(aOd, aDoKey: string; aKod: integer;
  aTresc: string);
var
  s: string;
begin
  s:=aOd+'$'+aDoKey+'${'+IntToStr(aKod)+'}$'+aTresc;
  SendMessage('{CHAT}',s);
end;

procedure TFMonitor.restart;
begin
  StatusBar1.Panels[0].Text:='Połączenie: Brak';
  StatusBar1.Panels[1].Text:='Ilość końcówek: 0';
  if C_KONIEC then exit;
  autorun.Enabled:=not mon.Active;
end;

procedure TFMonitor.StudioDestroy;
begin
  if not studio_run then exit;
  studio_run:=false;
  FStudio.Free;
end;

procedure TFMonitor.StudioDestroyTimer;
begin
  tFreeStudio.Enabled:=true;
end;

procedure TFMonitor.StudioGetData;
begin
  mon.SendString('{READ_MON}');
  mon.SendString('{READ_ALL}');
  mon.SendString('{INFO}$'+key+'$ALL');
end;

function TFMonitor.IfXIsFChat(aX1, aX2: pointer): boolean;
var
  a,b: TFChat;
begin
  a:=TFChat(aX1);
  b:=TFChat(aX2);
  if chat_run then
  begin
    result:=a=b;
  end else result:=false;
end;

procedure TFMonitor.ChatDestroy;
var
  i,a: integer;
  x,v: TFChat;
begin
  while okna_do_zabicia.Count>0 do
  begin
    x:=TFChat(okna_do_zabicia[0]);
    if IfXIsFChat(x,FChat) then
    begin
      chat_run:=false;
      FChat.Free;
    end else begin
      v:=nil;
      a:=-1;
      for i:=0 to list.Count-1 do if TFChat(list[i])=x then
      begin
        a:=i;
        v:=TFChat(list[i]);
      end;
      list.Delete(a);
      list_key.Delete(a);
      v.Free;
    end;
    okna_do_zabicia.Delete(0);
  end;
end;

procedure TFMonitor.ChatDestroyTimer(aPointer: pointer);
begin
  okna_do_zabicia.Add(aPointer);
  tFreeChat.Enabled:=true;
end;

procedure TFMonitor.ZamknijWszystkieChaty;
var
  i: integer;
begin
  tFreeChat.Enabled:=false;
  if chat_run then FChat.Free;
  chat_run:=false;
  for i:=0 to list.Count-1 do TFChat(list[i]).Free;
  list.Clear;
  list_key.Clear;
end;

procedure TFMonitor.PolaczenieAktywne;
var
  i: integer;
begin
  exit;
  if chat_run then FChat.uELED1.Active:=true;
  for i:=0 to list.Count-1 do TFChat(list[i]).uELED1.Active:=true;
end;

procedure TFMonitor.WizytowkaToProfil(aFileName: string);
var
  b: boolean;
begin
  b:=chat_run or (list.Count>0);
  if b then
  begin
    mess.ShowInformation('W celu eksportu/importu danych kont wszystkie chaty muszą być zamknięte!^Pozamykaj je i spróbuj jeszcze raz.');
    exit;
  end;
  FExport:=TFExport.Create(self);
  FExport.OnRequestRegisterKey:=@RequestRegisterKey;
  try
    FExport.io_filename:=aFileName;
    FExport.ShowModal;
    if FExport.io_refresh then dane.Refresh;
  finally
    FExport.Free;
  end;
end;

procedure TFMonitor.WizytowkaToKontakt(aFileName: string);
var
  ss: TStringList;
  s,s1: string;
  l,i,j,size: integer;
  tab1,tab2: array [0..65535] of byte;
  vec: string;
  a: ^TCertyfWizytowka;
begin
  ss:=TStringList.Create;
  try
    ss.LoadFromFile(aFileName);
    s:=ss[0];
    if s<>'-----BEGIN STUDIO JAHU CONTACT-----' then
    begin
      mess.ShowInformation('To nie jest prawidłowy plik wizytówki!');
      exit;
    end;
    s:=ss[ss.Count-1];
    if s<>'-----END STUDIO JAHU CONTACT-----' then
    begin
      mess.ShowInformation('To nie jest prawidłowy plik wizytówki!');
      exit;
    end;
    l:=0;
    for i:=1 to ss.Count-2 do
    begin
      s:=ss[i];
      for j:=1 to round(length(s)/2) do
      begin
        s1:=copy(s,j*2-1,2);
        tab1[l]:=HexToDec(s1);
        inc(l);
      end;
    end;
    size:=l;
  finally
    ss.Free;
  end;
  vec:=dm.GetHashCode(6);
  aes.InitStr(vec,TDCP_sha512);
  aes.Decrypt(&tab1[0],&tab2[0],size);
  aes.Burn;
  a:=@tab2[0];
  if a^.io<>'{WIZYTOWKA}' then
  begin
    mess.ShowInformation('Odczytanie danych wizytówki nieudane!^Przerywam!');
    exit;
  end;
  if a^.klucz=key then
  begin
    mess.ShowInformation('Chcesz dodać siebie do własnych kontaktów?^To nie wyjdzie :)');
    exit;
  end;
  (**)
  s:=EncryptString(a^.klucz,dm.GetHashCode(4),64);
  user_exist.ParamByName('klucz').AsString:=s;
  user_exist.Open;
  i:=user_existile.AsInteger;
  user_exist.Close;
  if i>0 then
  begin
    mess.ShowInformation('Ten kontakt masz już dodany!^Nie dodaję drugiego takiego samego.');
    exit;
  end;
  (* zapis danych do tabeli *)
  users2.Append;
  usersnazwa1.AsString:=a^.nazwa;
  users2opis.AsString:=a^.opis;
  usersimie1.AsString:=a^.imie;
  usersnazwisko1.AsString:=a^.nazwisko;
  usersemail1.AsString:=a^.email;
  usersklucz1.AsString:=s;
  usersstatus1.AsInteger:=1;
  users2.Post;
end;

procedure TFMonitor.WizytowkaToLinkFile(aFileName: string);
begin
  MenuItem33Click(self);
  FPlikownia.WizytowkaToLinkFile(aFileName);
end;

procedure TFMonitor.NaprawaBazy;
begin
  trans.StartTransaction;
  try
    naprawa_db.Execute;
    trans.Commit;
    users.Refresh;
    users2.Refresh;
    mess.ShowInformation('Skrypt wykonany pomyślnie.');
  except
    on E: Exception do
    begin
      mess.ShowError('Skrypt wykonany z błędem:^^'+E.Message);
      trans.Rollback;
    end;
  end;
end;

procedure TFMonitor.SetRunningPlikownia(aValue: boolean);
begin
  plikownia_run:=aValue;
end;

procedure TFMonitor.SetUploadingPlikownia(aValue: boolean);
begin
  uELED2.Color:=clRed;
  uELED2.Active:=aValue;
  if not aValue then if plikownia_run then if FPlikownia.IsHide then FPlikownia.Close;
end;

procedure TFMonitor.SetDownloadingPlikownia(aValue: boolean);
begin
  uELED2.Color:=clGreen;
  uELED2.Active:=aValue;
  if not aValue then if plikownia_run then if FPlikownia.IsHide then FPlikownia.Close;
end;

procedure TFMonitor.RunParameter(aPar: String);
var
  typ: integer;
  b: boolean;
begin
  (* WIADOMOŚCI Z PROCESÓW WTÓRNYCH *)
  typ:=TextCertificate(aPar);
  if typ=1 then
  begin
    b:=chat_run or (list.Count>0);
    if b then
    begin
      mess.ShowInformation('W celu importu danych kont wszystkie chaty muszą być zamknięte!^Pozamykaj je i kliknij w plik certyfikatu jeszcze raz.');
      exit;
    end;
    FExport:=TFExport.Create(self);
    FExport.OnRequestRegisterKey:=@RequestRegisterKey;
    FExport.io_filename:=aPar;
    try
      FExport.ShowModal;
      if FExport.io_refresh then dane.Refresh;
    finally
      FExport.Free;
    end;
  end else
  if typ=2 then WizytowkaToKontakt(aPar) else
  if typ=3 then WizytowkaToLinkFile(aPar);
end;

procedure TFMonitor.StatFileTest;
begin
  if stat_file_test.Count=0 then exit;
  SendMessageNoKey('{FILE_STAT_EXIST}',stat_file_test[0]);
  stat_file_test.Delete(0);
end;

end.

