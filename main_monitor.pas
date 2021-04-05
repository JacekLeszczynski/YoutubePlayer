unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, Menus, DBCtrls, TplProgressBarUnit,
  NetSocket, LiveTimer, ExtMessage, ZTransaction, DBGridPlus, DSMaster,
  DBSchemaSyncSqlite, HtmlView, lNet, ueled, uETilePanel, DCPrijndael,
  ZConnection, ZSqlProcessor, ZDataset, Types, DB, HTMLUn2, HtmlGlobals;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    Bevel1: TBevel;
    aes: TDCP_rijndael;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGridPlus1: TDBGridPlus;
    Label2: TLabel;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
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
    MenuItem4: TMenuItem;
    MenuItem6: TMenuItem;
    mCloseToTray: TMenuItem;
    mStartInTray: TMenuItem;
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
    dbcr: TZSQLProcessor;
    dane: TZQuery;
    usersemail: TMemoField;
    usersid: TLargeintField;
    usersimie: TMemoField;
    usersklucz: TMemoField;
    usersnazwa: TMemoField;
    usersnazwisko: TMemoField;
    usersopis: TMemoField;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure tFreeChatTimer(Sender: TObject);
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
    studio_run, chat_run: boolean;
    wektor_czasu: integer;
    key: string;
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
    procedure ChatDestroyTimer;
  public

  end;

var
  FMonitor: TFMonitor;

implementation

uses
  ecode, serwis, cverinfo, lcltype, Clipbrd, lclintf, studio, test,
  MojProfil, Chat, KontoExport;

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
  if mon.Host='127.0.0.1' then mon.Host:='sun';
  mon.Port:=4681;
  autorun.Enabled:=not mon.Connect;
end;

procedure TFMonitor.BitBtn1Click(Sender: TObject);
var
  b: boolean;
begin
  if studio_run then FStudio.Show;
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
  FChat:=TFChat.Create(self);
  FChat.nick:=danenazwa.AsString;
  FChat.OnSendMessage:=@SendMessage;
  FChat.OnSendMessageNoKey:=@SendMessageNoKey;
  FChat.OnExecuteDestroy:=@ChatDestroyTimer;
  FChat.OnTrayIconMessage:=@IconTrayMessage;
  FChat.Show;
  FChat.key:=key;
  chat_run:=true;
end;

procedure TFMonitor.MenuItem11Click(Sender: TObject);
begin
  schema.StructFileName:=MyDir('dbstrukt.monitor');
  schema.SaveSchema;
end;

procedure TFMonitor.MenuItem12Click(Sender: TObject);
var
  vMajorVersion,vMinorVersion,vRelease,vBuild: integer;
begin
  GetProgramVersion(vMajorVersion,vMinorVersion,vRelease,vBuild);
  mon.SendString('{SET_VERSION}$'+IntToStr(vMajorVersion)+'$'+IntToStr(vMinorVersion)+'$'+IntToStr(vRelease)+'$'+IntToStr(vBuild));
end;

procedure TFMonitor.MenuItem2Click(Sender: TObject);
begin
  FExport:=TFExport.Create(self);
  FExport.ShowModal;
end;

procedure TFMonitor.MenuItem7Click(Sender: TObject);
begin
  FMojProfil:=TFMojProfil.Create(self);
  FMojProfil.ShowModal;
  if dane.State in [dsEdit,dsInsert] then dane.Cancel;
end;

procedure TFMonitor.tFreeChatTimer(Sender: TObject);
begin
  tFreeChat.Enabled:=false;
  ChatDestroy;
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
  if not C_EXIT then if mCloseToTray.Checked then
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
  plik: string;
  b: boolean;
begin
  schema.init;
  studio_run:=false;
  chat_run:=false;
  b:=false;
  Caption:='Komunikator JAHU ('+dm.aVER+')';
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  PropStorage.Restore;
  plik:=MyConfDir('monitor.sqlite');
  b:=not FileExists(plik);
  db.Database:=plik;
  db.Connect;
  if b then dbcr.Execute;
  master.Open;
  if not mon.Active then autorun.Enabled:=true;
  if not mStartInTray.Checked then
  begin
    WindowState:=wsNormal;
    show;
  end;
end;

procedure TFMonitor.FormDestroy(Sender: TObject);
begin
  StudioDestroy;
  ChatDestroy;
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
  a1,a2,a3,a4: integer;
  s1,s2,s3,s4: string;
  s: string;
  e: integer;
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
    propstorage.WriteString('key-ident',key);
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
  end else
  if s='{VECTOR_IS_NEW}' then
  begin
    dm.DaneDoSzyfrowaniaSetNewVector(GetLineToStr(aMsg,2,'$'));
    mon.GetTimeVector;
    if studio_run then mon.SendString('{READ_MON}');
  end else
  if s='{SERVER-NON-EXIST}' then
  begin
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
  if studio_run then FStudio.monReceiveString(aMsg,s,aSocket,aID) else
  if chat_run then FChat.monReceiveString(aMsg,s,aSocket,aID);
end;

procedure TFMonitor.monTimeVector(aTimeVector: integer);
begin
  BitBtn1.Enabled:=true;
  BitBtn2.Enabled:=true;
  wektor_czasu:=aTimeVector;
  StatusBar1.Panels[1].Text:='Różnica czasu: '+IntToStr(wektor_czasu)+' ms';
  key:=propstorage.ReadString('key-ident','');
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

procedure TFMonitor.TestWersji(a1, a2, a3, a4: integer);
var
  vMajorVersion,vMinorVersion,vRelease,vBuild: integer;
  b: boolean;
  s1,s2,s3,s4: string;
begin
  b:=false;
  GetProgramVersion(vMajorVersion,vMinorVersion,vRelease,vBuild);
  if a1>vMajorVersion then b:=true else
  if a2>vMinorVersion then b:=true else
  if a3>vRelease then b:=true else
  if a4>vBuild then b:=true;
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
begin
  if chat_run then FChat.odblokuj;
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
  StatusBar1.Panels[1].Text:='Różnica czasu: ---';
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
begin
  if not chat_run then exit;
  chat_run:=false;
  FChat.Free;
end;

procedure TFMonitor.ChatDestroyTimer;
begin
  tFreeChat.Enabled:=true;
end;

end.

