unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, Menus, DBCtrls, NetSocket, ExtMessage,
  ZTransaction, DBGridPlus, DSMaster, DBSchemaSyncSqlite, UOSEngine, UOSPlayer,
  ExtEventLog, HtmlView, lNet, ueled, uETilePanel, DCPrijndael, ZConnection,
  ZDataset, Types, DB, HTMLUn2, HtmlGlobals, DBGrids,
  eventlog;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    Bevel1: TBevel;
    aes: TDCP_rijndael;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    DBGridPlus1: TDBGridPlus;
    dsignores: TDataSource;
    dbClearHistoryUser: TZQuery;
    DBGridPlus2: TDBGridPlus;
    dsusers2: TDataSource;
    dbPrzeczytane: TZQuery;
    dsprive1: TDataSource;
    debug: TExtEventLog;
    IsIgnore: TZQuery;
    ignoresid: TLargeintField;
    ignoresklucz: TMemoField;
    ignoresnick: TMemoField;
    IsIgnoreile: TLargeintField;
    IsUserstatus: TLargeintField;
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
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    mCisza: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem9: TMenuItem;
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
    usersstatus: TLargeintField;
    usersstatus1: TLargeintField;
    user_exist: TZQuery;
    KeyToUser: TZQuery;
    user_existile: TLargeintField;
    dbClearHistory: TZQuery;
    IsUser: TZReadOnlyQuery;
    ignores: TZQuery;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBGridPlus1DblClick(Sender: TObject);
    procedure dsusers2DataChange(Sender: TObject; Field: TField);
    procedure mCiszaClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure monError(const aMsg: string; aSocket: TLSocket);
    procedure schemaLoadMemStruct(aValue: TStringList);
    procedure tAdmAllUserTimer(Sender: TObject);
    procedure tFreeChatTimer(Sender: TObject);
    procedure tHaltTimer(Sender: TObject);
    procedure tReqKeyOkTimer(Sender: TObject);
    procedure uELED2Click(Sender: TObject);
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
    procedure monCryptBinary(const indata; var outdata; var size: longword);
    procedure monCryptString(var aText: string);
    procedure monDecryptBinary(const indata; var outdata; var size: longword);
    procedure monDecryptString(var aText: string);
    procedure monDisconnect;
    procedure monProcessMessage;
    procedure monReceiveString(aMsg: string; aSocket: TLSocket; aID: integer);
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
    studio_run, chat_run: boolean;
    wektor_czasu: integer;
    key: string;
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
    function GetKey: string;
    procedure AddKontakt(aKey,aNazwa: string; aSzary: boolean);
    procedure UserKeyToNazwa(aKey: string; var aNazwa: string);
    procedure TestWersji(a1,a2,a3,a4: integer);
    procedure IconTrayMessage(aValue: integer);
    procedure zablokowanie_uslug;
    procedure odblokowanie_uslug;
    procedure SendMessage(aKomenda: string; aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure restart;
    procedure StudioDestroy;
    procedure StudioDestroyTimer;
    procedure StudioGetData;
    function IfXIsFChat(aX1,aX2: pointer): boolean;
    procedure ChatDestroy;
    procedure ChatDestroyTimer(aPointer: pointer);
    procedure ZamknijWszystkieChaty;
    procedure PolaczenieAktywne;
  public
    img1,img2: TStringList;
    procedure RunParameter(aPar: String);
  end;

var
  FMonitor: TFMonitor;

implementation

uses
  ecode, serwis, cverinfo, lcltype, lclintf, studio,
  MojProfil, Chat, KontoExport, UsunKonfiguracje, ustawienia,
  ignores;

var
  C_KONIEC: boolean = false;
  C_EXIT: boolean = false;

{$R *.lfm}

{ TFMonitor }

procedure TFMonitor.monCryptString(var aText: string);
begin
  aText:=EncryptString(aText,dm.GetHashCode(2));
end;

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
  host,h1,h2,h3: string;
  p1,p2,p3: word;
  b1,b2,b3: boolean;
  s: string[3];
begin
  autorun.Enabled:=false;
  led_kolor:=clRed;
  uEled1.Color:=clSilver;
  uEled1.Active:=true;
  application.ProcessMessages;
  if cDebug then debug.Debug('Timer: [autorun] - execute');

  host:='studiojahu.duckdns.org';
  if host='sun' then host:='127.0.0.1';
  h1:=host;
  p1:=4680; sleep(50);
  b1:=mon.IsOpenPort(h1,p1,'{EXIT}');
  if host='127.0.0.1' then host:='sun';
  h2:=host;
  p2:=4681; sleep(50);
  b2:=mon.IsOpenPort(h2,p2,'{EXIT}');
  h3:=h2;
  p3:=4682; sleep(50);
  b3:=mon.IsOpenPort(h3,p3,'{EXIT}');
  if cDebug then
  begin
    s:='000';
    if b1 then s[1]:='1';
    if b2 then s[2]:='1';
    if b3 then s[3]:='1';
    debug.Debug('  test ports: '+s);
  end;

  uEled1.Active:=false;
  application.ProcessMessages;
  sleep(250);
  uEled1.Active:=true;
  application.ProcessMessages;

  if b1 then begin mon.Host:=h1; mon.Port:=p1; end else
  if b2 then begin mon.Host:=h2; mon.Port:=p2; end else
  if b3 then begin mon.Host:=h3; mon.Port:=p3; end;

  if cDebug then debug.Debug('  connect begin');
  mon.Connect;
  if cDebug then debug.Debug('  connect end');
  if mon.Active then exit;

  autorun.Enabled:=not mon.Active;
  uEled1.Active:=mon.Active;
end;

procedure TFMonitor.BitBtn1Click(Sender: TObject);
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

procedure TFMonitor.BitBtn2Click(Sender: TObject);
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

procedure TFMonitor.mCiszaClick(Sender: TObject);
begin
  if mCisza.ImageIndex=0 then mCisza.ImageIndex:=1 else mCisza.ImageIndex:=0;
end;

procedure TFMonitor.MenuItem10Click(Sender: TObject);
begin
  if users2.IsEmpty then exit;
  if not mess.ShowConfirmationYesNo('Użytkownik o nicku Ambroży zostanie usunięty z listy twoich kontaktów i ustawiony jako ignorowany.^Potwierdź tą operację.') then exit;
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
  trans.StartTransaction;
  dbClearHistoryUser.ParamByName('user').AsString:=usersklucz.AsString;
  dbClearHistoryUser.ExecSQL;
  users.Delete;
  trans.Commit;
end;

procedure TFMonitor.MenuItem17Click(Sender: TObject);
begin
  FMojProfil:=TFMojProfil.Create(self);
  FMojProfil.io_id:=usersid.AsInteger;
  FMojProfil.ShowModal;
  users.Refresh;
end;

procedure TFMonitor.MenuItem19Click(Sender: TObject);
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

procedure TFMonitor.MenuItem2Click(Sender: TObject);
var
  b: boolean;
  i: integer;
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
    FExport.ShowModal;
    if FExport.io_refresh then dane.Refresh;
  finally
    FExport.Free;
  end;
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

procedure TFMonitor.monError(const aMsg: string; aSocket: TLSocket);
begin
  if cDebug then debug.Debug('Code: [monOnError] - '+aMsg);
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

procedure TFMonitor.uELED2Click(Sender: TObject);
begin
  mess.ShowInformation(mon.GetAddressIp);
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
  if mon.Active then
  begin
    mon.Disconnect;
    sleep(250);
  end;
end;

procedure TFMonitor.FormCreate(Sender: TObject);
var
  b: boolean;
  ie: integer;
  plik: string;
begin
  application.OnDeactivate:=@AppOnDeactivate;
  application.OnActivate:=@AppOnActivate;
  IniOpen(MyConfDir('monitor.ini'));
  okna_do_zabicia:=TList.Create;
  list:=TList.Create;
  list_key:=TStringList.Create;
  img1:=TStringList.Create;
  img2:=TStringList.Create;
  LoadImgConf;
  DBGridPlus1.AutoScaleVector:=IniReadInteger('Path','ContactsMessagesCounts',0);
  schema.init;
  schema.StructFileName:=MyDir('dbstruct.dat');
  studio_run:=false;
  chat_run:=false;
  b:=false;
  Caption:='Komunikator JAHU ('+dm.aVER+')';
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  PropStorage.Restore;
  SetDebug(IniReadBool('Debug','RegisterExecuteCode',false));
  LIBUOS:=uos.LoadLibrary;
  mCisza.Visible:=LIBUOS;
  //mCiszaClick(Sender);
  plik:=MyConfDir('monitor.sqlite');
  b:=FileExists(plik);
  db.Database:=plik;
  try
    ie:=1; db.Connect;
    if (not b) or (dm.aVER<>PropStorage.ReadString('verdb','')) then
    begin
      ie:=2;
      if not Programistyczne.Visible then schema.SyncSchema else if mess.ShowConfirmationYesNo('Czy wykonać restrukturyzację?') then schema.SyncSchema;
      PropStorage.WriteString('verdb',dm.aVER);
    end;
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
  img1.Free;
  img2.Free;
  master.Close;
  db.Disconnect;
end;

procedure TFMonitor.monDecryptString(var aText: string);
begin
  aText:=DecryptString(aText,dm.GetHashCode(2));
end;

procedure TFMonitor.monDisconnect;
begin
  if cDebug then debug.Debug('Code: [monOnDisconnect] - execute');
  zablokowanie_uslug;
  BitBtn1.Enabled:=false;
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

procedure TFMonitor.monReceiveString(aMsg: string; aSocket: TLSocket;
  aID: integer);
var
  bb: boolean;
  vNick,vOdKey,vDoKey,vOdKeyCrypt: string;
  a1,a2,a3,a4: integer;
  s1,s2,s3,s4: string;
  s: string;
  e,i: integer;
  b: boolean;
begin
  //writeln('Mój klucz: ',key);
  //writeln('(',length(aMsg),') Otrzymałem: "',aMsg,'"');
  s:=GetLineToStr(aMsg,1,'$');
  if cDebug then debug.Debug('Code: [monReceiveString] - '+s);
  if s='{EXIT}' then timer_stop.Enabled:=true else
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
  if s='{USERS_COUNT}' then
  begin
    a1:=StrToInt(GetLineToStr(aMsg,2,'$','0'));
    StatusBar1.Panels[1].Text:='Ilość końcówek: '+IntToStr(a1);
  end else begin
    if studio_run then FStudio.monReceiveString(aMsg,s,aSocket,aID);
    bb:=false;
    if chat_run then bb:=FChat.monReceiveString(aMsg,s,aSocket,aID);
    if not bb then for i:=0 to list.Count-1 do
    begin
      bb:=TFChat(list[i]).monReceiveString(aMsg,s,aSocket,aID);
      if bb then break;
    end;
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

procedure TFMonitor.monTimeVector(aTimeVector: integer);
begin
  CONST_RUN_BLOCK:=false;
  BitBtn1.Enabled:=true;
  BitBtn2.Enabled:=mon.Port<>4680;
  BitBtn3.Enabled:=true;
  wektor_czasu:=aTimeVector;
  key:=GetKey;
  mon.SendString('{LOGIN}$'+key);
end;

procedure TFMonitor.propstorageRestoreProperties(Sender: TObject);
begin
  mon.Host:=propstorage.ReadString('custom-ip','studiojahu.duckdns.org');
  Programistyczne.Visible:=propstorage.ReadBoolean('DEV',false);
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

function TFMonitor.GetKey: string;
var
  vKey,token: string;
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
  token:=dm.GetHashCode(3);
  result:=DecryptString(vKey,token,true);
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
begin
  //writeln('wysyłam: '+aKomenda+'$'+key+'$'+aValue);
  if aValue='' then mon.SendString(aKomenda+'$'+key) else mon.SendString(aKomenda+'$'+key+'$'+aValue);
end;

procedure TFMonitor.SendMessageNoKey(aKomenda: string; aValue: string);
begin
  //writeln('Wysyłam: ',aKomenda+'$'+aValue);
  if aValue='' then mon.SendString(aKomenda) else mon.SendString(aKomenda+'$'+aValue);
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

procedure TFMonitor.RunParameter(aPar: String);
begin
  (* WIADOMOŚCI Z PROCESÓW WTÓRNYCH *)

end;

end.

