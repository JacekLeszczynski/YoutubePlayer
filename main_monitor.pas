unit main_monitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, XMLPropStorage, Menus, DBCtrls, TplProgressBarUnit,
  NetSocket, LiveTimer, ExtMessage, ZTransaction, DBGridPlus, DSMaster,
  HtmlView, lNet, ueled, uETilePanel, DCPrijndael, ZConnection, ZSqlProcessor,
  ZDataset, Types, DB, HTMLUn2, HtmlGlobals;

type

  { TFMonitor }

  TFMonitor = class(TForm)
    Bevel1: TBevel;
    aes: TDCP_rijndael;
    Bevel2: TBevel;
    DBGridPlus1: TDBGridPlus;
    Label1: TLabel;
    master: TDSMaster;
    dsusers: TDataSource;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    pmJa: TPopupMenu;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
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
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
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
    procedure SpeedButton6Click(Sender: TObject);
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
    procedure MenuItem7Click(Sender: TObject);
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
  ecode, serwis, lcltype, Clipbrd, lclintf, studio, test,
  MojProfil, Chat;

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
  uELED1.Color:=clYellow;
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

procedure TFMonitor.MenuItem7Click(Sender: TObject);
var
  b: boolean;
begin
  if studio_run then exit;
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

procedure TFMonitor.MenuItem8Click(Sender: TObject);
begin
  (* edycja swoich danych *)
  FMojProfil:=TFMojProfil.Create(self);
  FMojProfil.ShowModal;
  if dane.State in [dsEdit,dsInsert] then dane.Cancel;
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

procedure TFMonitor.SpeedButton6Click(Sender: TObject);
begin
  if chat_run then
  begin
    FChat.Show;
    exit;
  end;
  FChat:=TFChat.Create(self);
  FChat.nick:=danenazwa.AsString;
  //FChat.OnStudioGetData:=@StudioGetData;
  FChat.OnSendMessage:=@SendMessage;
  FChat.OnSendMessageNoKey:=@SendMessageNoKey;
  FChat.OnExecuteDestroy:=@ChatDestroyTimer;
  FChat.OnTrayIconMessage:=@IconTrayMessage;
  FChat.Show;
  FChat.key:=key;
  chat_run:=true;
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
  MenuItem7.Visible:=false;
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
  s: string;
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
    uELED1.Color:=clRed;
  end else
  if s='{SERVER-EXIST}' then
  begin
    uELED1.Color:=clYellow;
  end else
  if studio_run then FStudio.monReceiveString(aMsg,s,aSocket,aID) else
  if chat_run then FChat.monReceiveString(aMsg,s,aSocket,aID);
end;

procedure TFMonitor.monTimeVector(aTimeVector: integer);
begin
  MenuItem7.Visible:=true;
  wektor_czasu:=aTimeVector;
  StatusBar1.Panels[1].Text:='Różnica czasu: '+IntToStr(wektor_czasu)+' ms';
  key:=propstorage.ReadString('key-ident','');
  mon.SendString('{LOGIN}$'+key);
end;

procedure TFMonitor.propstorageRestoreProperties(Sender: TObject);
begin
  mon.Host:=propstorage.ReadString('custom-ip','studiojahu.duckdns.org');
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

