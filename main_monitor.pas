unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, Menus, DBCtrls,
  NetSocket, ExtMessage, ZTransaction, DBGridPlus, DSMaster,
  DBSchemaSyncSqlite, UOSEngine, UOSPlayer, HtmlView, lNet, ueled,
  uETilePanel, DCPrijndael, ZConnection, ZDataset, Types, DB,
  HTMLUn2, HtmlGlobals;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    Bevel1: TBevel;
    aes: TDCP_rijndael;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dsprive: TDataSource;
    DBGridPlus1: TDBGridPlus;
    dsprive1: TDataSource;
    KeyToUsernazwa: TMemoField;
    Label2: TLabel;
    MemoField1: TMemoField;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    pmKontakty: TPopupMenu;
    prive1: TZQuery;
    priveadresat: TMemoField;
    priveformatowanie: TMemoField;
    priveid: TLargeintField;
    priveile: TMemoField;
    priveinsertdt: TMemoField;
    privenadawca: TMemoField;
    privenadawca1: TMemoField;
    priveprzeczytane: TLargeintField;
    privetresc: TMemoField;
    Programistyczne: TMenuItem;
    schema: TDBSchemaSyncSqlite;
    Label1: TLabel;
    master: TDSMaster;
    dsusers: TDataSource;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    pmJa: TPopupMenu;
    tFreeChat: TTimer;
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
    user_exist: TZQuery;
    usersemail: TMemoField;
    usersid: TLargeintField;
    usersimie: TMemoField;
    usersklucz: TMemoField;
    usersnazwa: TMemoField;
    usersnazwisko: TMemoField;
    usersopis: TMemoField;
    usersstatus: TLargeintField;
    usersstatus_str: TStringField;
    KeyToUser: TZQuery;
    user_existile: TLargeintField;
    prive: TZQuery;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGridPlus1DblClick(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure tFreeChatTimer(Sender: TObject);
    procedure usersCalcFields(DataSet: TDataSet);
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
    okna_do_zabicia: TStringList;
    sound1: TMemoryStream;
    list: TList;
    list_key: TStringList;
    studio_run, chat_run: boolean;
    wektor_czasu: integer;
    key: string;
    procedure go_beep(aIndex: integer = 0);
    procedure go_set_chat(aFont, aFont2: string; aSize, aSize2, aColor: integer);
    procedure PutKey(aKey: string);
    function GetKey: string;
    procedure AddKontakt(aKey,aNazwa: string);
    procedure UserKeyToNazwa(aKey: string; var aNazwa: string);
    procedure TestWersji(a1,a2,a3,a4: integer);
    procedure IconTrayMessage(aValue: boolean = true);
    procedure zablokowanie_uslug;
    procedure odblokowanie_uslug;
    procedure SendMessage(aKomenda: string; aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure restart;
    procedure StudioDestroy;
    procedure StudioDestroyTimer;
    procedure StudioGetData;
    procedure ChatDestroy;
    procedure ChatDestroyTimer(aIDENT: integer);
    procedure ZamknijWszystkieChaty;
    procedure PolaczenieAktywne;
  public
  end;

var
  FMonitor: TFMonitor;

implementation

uses
  ecode, serwis, cverinfo, lcltype, lclintf, studio,
  MojProfil, Chat, KontoExport, UsunKonfiguracje, ustawienia;

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
  dm.DaneDoSzyfrowaniaClear;
  uELED1.Color:=clRed;
  uEled1.Active:=true;
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
begin
  if mon.Host='sun' then mon.Host:='127.0.0.1';
  mon.Port:=4680;
  autorun.Enabled:=not mon.Connect;
  if not autorun.Enabled then exit;
  if mon.Host='127.0.0.1' then mon.Host:='sun';
  mon.Port:=4681;
  autorun.Enabled:=not mon.Connect;
  if not autorun.Enabled then exit;
  mon.Port:=4682;
  autorun.Enabled:=not mon.Connect;
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

procedure TFMonitor.DBGridPlus1DblClick(Sender: TObject);
var
  token,k,s: string;
  i,a: integer;
begin
  if not BitBtn2.Enabled then exit;
  (* otwarcie chatu prywatnego *)
  token:=dm.GetHashCode(4);
  k:=DecryptString(usersklucz.AsString,token,true);
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
    a:=list.Add(TFChat.Create(self,'Chat_'+s,0,danenazwa.AsString,key,usersnazwa.AsString,k));
    list_key.Insert(a,k);
    TFChat(list[a]).IDENT:=a;
    //TFChat(list[a]).nick:=danenazwa.AsString;
    //TFChat(list[a]).key:=key;
    //TFChat(list[a]).nick2:=usersnazwa.AsString;
    //TFChat(list[a]).key2:=k;
    TFChat(list[a]).uELED1.Active:=true;
    TFChat(list[a]).OnSendMessage:=@SendMessage;
    TFChat(list[a]).OnSendMessageNoKey:=@SendMessageNoKey;
    TFChat(list[a]).OnExecuteDestroy:=@ChatDestroyTimer;
    TFChat(list[a]).OnTrayIconMessage:=@IconTrayMessage;
    TFChat(list[a]).OnAddKontakt:=@AddKontakt;
    TFChat(list[a]).OnGoBeep:=@go_beep;
    TFChat(list[a]).Caption:='Okno rozmowy prywatnej ('+usersnazwa.AsString+')';
    TFChat(list[a]).Show;
  end else TFChat(list[a]).Show;
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
  if IniReadInteger('Audio','SystemSound',0)=1 then s4:='aktywne' else s4:='nieaktywne';
  s:='UOS Sounds: '+s4+'^^Sync: "'+schema.StructFileName+'"^^DB: '+s1+'^Kontrolka profilu: '+s2+'^Kontrolka uzytkowników: '+s3+'^^Error UOS:^'+uos.GetErrorStr;
  //s:=MyConfDir;
  mess.ShowInformation('STATUS',s);
end;

procedure TFMonitor.MenuItem16Click(Sender: TObject);
begin
  if users.IsEmpty then exit;
  users.Delete;
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
  FUstawienia.Show;
end;

procedure TFMonitor.MenuItem2Click(Sender: TObject);
begin
  FExport:=TFExport.Create(self);
  FExport.ShowModal;
end;

procedure TFMonitor.MenuItem7Click(Sender: TObject);
begin
  FMojProfil:=TFMojProfil.Create(self);
  FMojProfil.io_id:=0;
  FMojProfil.ShowModal;
  dane.Refresh;
end;

procedure TFMonitor.tFreeChatTimer(Sender: TObject);
begin
  tFreeChat.Enabled:=false;
  ChatDestroy;
end;

procedure TFMonitor.usersCalcFields(DataSet: TDataSet);
begin
  case usersstatus.AsInteger of
    0: usersstatus_str.AsString:='NEW';  //czeka na akceptację
    1: usersstatus_str.AsString:='OK';   //zaakceptowany
    2: usersstatus_str.AsString:='REJC'; //odrzucony
  end;
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
begin
  if not C_EXIT then if IniReadBool('Flags','CloseToTray',false) then
  begin
    CloseAction:=caNone;
    WindowState:=wsMinimized;
    hide;
    exit;
  end;
  StudioDestroy;
  C_KONIEC:=true;
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
  IniOpen(MyConfDir('monitor.ini'));
  okna_do_zabicia:=TStringList.Create;
  list:=TList.Create;
  list_key:=TStringList.Create;
  schema.init;
  schema.StructFileName:=MyDir('dbstruct.dat');
  studio_run:=false;
  chat_run:=false;
  b:=false;
  Caption:='Komunikator JAHU ('+dm.aVER+')';
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  PropStorage.Restore;
  if IniReadInteger('Audio','SystemSound',0)=1 then LIBUOS:=uos.LoadLibrary;
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
  if LIBUOS then uos.UnLoadLibrary;
  StudioDestroy;
  ChatDestroy;
  ZamknijWszystkieChaty;
  okna_do_zabicia.Free;
  list.Free;
  list_key.Free;
  master.Close;
  db.Disconnect;
end;

procedure TFMonitor.monDecryptString(var aText: string);
begin
  aText:=DecryptString(aText,dm.GetHashCode(2));
end;

procedure TFMonitor.monDisconnect;
begin
  zablokowanie_uslug;
  BitBtn1.Enabled:=false;
  BitBtn2.Enabled:=false;
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
  vOdKey,vDoKey: string;
  a1,a2,a3,a4: integer;
  s1,s2,s3,s4: string;
  s: string;
  e,i: integer;
begin
  //writeln('Mój klucz: ',key);
  //writeln('(',length(aMsg),') Otrzymałem: "',aMsg,'"');
  s:=GetLineToStr(aMsg,1,'$');
  if s='{EXIT}' then timer_stop.Enabled:=true else
  if s='{KEY-NEW}' then
  begin
    key:=GetLineToStr(aMsg,2,'$');
    if studio_run then FStudio.key:=key;
    if chat_run then FChat.key:=key;
    PutKey(key);
    if studio_run then
    begin
      mon.SendString('{READ_ALL}');
      mon.SendString('{INFO}$'+key+'$ALL');
    end;
    odblokowanie_uslug;
  end else
  if s='{KEY-OK}' then
  begin
    if studio_run then
    begin
      mon.SendString('{READ_ALL}');
      mon.SendString('{INFO}$'+key+'$ALL');
    end;
    odblokowanie_uslug;
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
    uELED1.Color:=clYellow;
  end else
  if s='{SERVER-EXIST}' then
  begin
    uELED1.Color:=clRed;
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
      vOdKey:=GetLineToStr(aMsg,2,'$','');
      vDoKey:=GetLineToStr(aMsg,4,'$','');
      if (s='{CHAT}') and (vOdKey<>'') and (vDoKey<>'') then
      begin
        prive1.Open;
        prive1.Append;
        priveinsertdt.AsString:=GetLineToStr(aMsg,7,'$','');
        privenadawca1.AsString:=vOdKey;
        priveadresat.AsString:=vDoKey;
        priveformatowanie.AsString:=GetLineToStr(aMsg,5,'$','');
        privetresc.AsString:=GetLineToStr(aMsg,6,'$','');
        priveprzeczytane.AsInteger:=0;
        prive1.Post;
        prive1.Close;
        prive.Refresh;
        go_beep;
      end;
    end;
  end;
end;

procedure TFMonitor.monTimeVector(aTimeVector: integer);
begin
  BitBtn1.Enabled:=true;
  BitBtn2.Enabled:=true;
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
  C_KONIEC:=false;
  autorun.Enabled:=not mon.Connect;
end;

procedure TFMonitor.tFreeStudioTimer(Sender: TObject);
begin
  tFreeStudio.Enabled:=false;
  StudioDestroy;
end;

procedure TFMonitor.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  mon.SendString('{GET_VECTOR}');
end;

procedure TFMonitor.timer_stopTimer(Sender: TObject);
begin
  timer_stop.Enabled:=false;
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

procedure TFMonitor.go_beep(aIndex: integer);
var
  res: TResourceStream;
begin
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
  play1.Volume:=1;
  play1.Start(sound1);
end;

procedure TFMonitor.go_set_chat(aFont, aFont2: string; aSize, aSize2,
  aColor: integer);
var
  i: integer;
begin
  if chat_run then FChat.GoSetChat(aFont,aFont2,aSize,aSize2,aColor);
  for i:=0 to list.Count-1 do TFChat(list[i]).GoSetChat(aFont,aFont2,aSize,aSize2,aColor);
end;

procedure TFMonitor.PutKey(aKey: string);
var
  s,token: string;
begin
  token:=dm.GetHashCode(3);
  s:=EncryptString(aKey,token,128);
  if dane.IsEmpty then
  begin
    dane.Append;
    daneid.AsInteger:=0;
  end else dane.Edit;
  daneklucz.AsString:=s;
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

procedure TFMonitor.AddKontakt(aKey, aNazwa: string);
var
  s,token: string;
  b: boolean;
begin
  (* zakodowanie klucza *)
  token:=dm.GetHashCode(4);
  s:=EncryptString(aKey,token,64);
  (* sprawdzenie czy taki klucz już istnieje *)
  user_exist.ParamByName('klucz').AsString:=s;
  user_exist.Open;
  b:=(user_existile.AsInteger=0);
  user_exist.Close;
  if b then
  begin
    (* dodanie kontaktu jeśli nie istnieje *)
    users.Append;
    usersklucz.AsString:=s;
    usersnazwa.AsString:=aNazwa;
    usersstatus.AsInteger:=0; //NOWY KONTAKT
    users.Post;
  end;
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

procedure TFMonitor.IconTrayMessage(aValue: boolean);
begin
  if aValue then TrayIcon1.Icon.LoadFromResourceName(Hinstance,'TRAY_MESSAGE')
  else TrayIcon1.Icon.LoadFromResourceName(Hinstance,'TRAY_NORMAL');
end;

procedure TFMonitor.zablokowanie_uslug;
begin
  if chat_run then FChat.blokuj;
end;

procedure TFMonitor.odblokowanie_uslug;
var
  i: integer;
begin
  if chat_run then FChat.odblokuj;
  for i:=0 to list.Count-1 do TFChat(list[i]).odblokuj;
end;

procedure TFMonitor.SendMessage(aKomenda: string; aValue: string);
begin
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
  autorun.Enabled:=not mon.Connect;
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

procedure TFMonitor.ChatDestroy;
var
  i,a: integer;
  x: TFChat;
begin
  while okna_do_zabicia.Count>0 do
  begin
    a:=StrToInt(okna_do_zabicia[0]);
    if a=-1 then
    begin
      if not chat_run then exit;
      chat_run:=false;
      FChat.Free;
    end else begin
      x:=TFChat(list[a]);
      list.Delete(a);
      list_key.Delete(a);
      x.Free;
    end;
    okna_do_zabicia.Delete(0);
  end;
end;

procedure TFMonitor.ChatDestroyTimer(aIDENT: integer);
begin
  okna_do_zabicia.Add(IntToStr(aIDENT));
  tFreeChat.Enabled:=true;
end;

procedure TFMonitor.ZamknijWszystkieChaty;
var
  i: integer;
begin
  for i:=0 to list.Count-1 do TFChat(list[i]).Free;
  list.Clear;
  list_key.Free;
end;

procedure TFMonitor.PolaczenieAktywne;
var
  i: integer;
begin
  exit;
  if chat_run then FChat.uELED1.Active:=true;
  for i:=0 to list.Count-1 do TFChat(list[i]).uELED1.Active:=true;
end;

end.

