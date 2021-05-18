unit Plikownia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  XMLPropStorage, ExtCtrls, DBGridPlus, DSMaster, ExtMessage, ZQueryPlus,
  LiveTimer, lNet, ZDataset, uETilePanel, Grids, DBGrids, ComCtrls, LCLType,
  Menus;

type

  { TFPlikownia }

  TFPlikowniaOnVoidEvent = procedure of object;
  TFPlikowniaOnBoolEvent = procedure(aValue: boolean) of object;
  TFPlikowniaOnSendMessageEvent = procedure(aKomenda: string; aValue: string; aBlock: pointer; aBlockSize: integer) of object;
  TFPlikownia = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    cFormatFileSize: TComboBox;
    CheckBox1: TCheckBox;
    cHideMyFiles: TComboBox;
    DBGridPlus1: TDBGridPlus;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    atom: TLiveTimer;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    mess: TExtMessage;
    master: TDSMaster;
    dspliki: TDataSource;
    odialog: TOpenDialog;
    plik2: TZQuery;
    plikczas_wstawienia: TMemoField;
    plikczas_wstawienia1: TMemoField;
    plikczas_zycia: TMemoField;
    plikczas_zycia1: TMemoField;
    plikdlugosc: TLargeintField;
    plikdlugosc1: TLargeintField;
    plikiczas_wstawienia: TMemoField;
    plikiczas_zycia: TMemoField;
    plikid: TLargeintField;
    plikid1: TLargeintField;
    plikidlugosc: TLargeintField;
    plikiid: TLargeintField;
    plikiindeks: TMemoField;
    plikiklucz: TMemoField;
    plikinazwa: TMemoField;
    plikindeks: TMemoField;
    plikindeks1: TMemoField;
    plikinick: TMemoField;
    plikisciezka: TMemoField;
    plikistatus: TLargeintField;
    plikklucz: TMemoField;
    plikklucz1: TMemoField;
    pliknazwa: TMemoField;
    pliknazwa1: TMemoField;
    pliknick: TMemoField;
    pliknick1: TMemoField;
    pliksciezka: TMemoField;
    pliksciezka1: TMemoField;
    plikstatus: TLargeintField;
    plikstatus1: TLargeintField;
    PopupMenu1: TPopupMenu;
    postep: TProgressBar;
    propstorage: TXMLPropStorage;
    sdialog: TSaveDialog;
    tSend: TTimer;
    tDownload: TTimer;
    uETilePanel1: TuETilePanel;
    uETilePanel2: TuETilePanel;
    uETilePanel3: TuETilePanel;
    uETilePanel4: TuETilePanel;
    up_indeks: TZQuery;
    del_id: TZQuery;
    plik: TZQuery;
    pliki: TZQueryPlus;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure cFormatFileSizeChange(Sender: TObject);
    procedure cHideMyFilesChange(Sender: TObject);
    procedure DBGridPlus1PrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dsplikiDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure plik2AfterClose(DataSet: TDataSet);
    procedure plik2AfterOpen(DataSet: TDataSet);
    procedure plikAfterClose(DataSet: TDataSet);
    procedure plikAfterOpen(DataSet: TDataSet);
    procedure plikiBeforeOpen(DataSet: TDataSet);
    procedure plikidlugoscGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure tDownloadTimer(Sender: TObject);
    procedure tSendTimer(Sender: TObject);
  private
    cERR,cIDX,ccIDX,cIDX2: integer;
    cLENGTH: int64;
    cFILENAME,cCRCHEX: string;
    ff: TFileStream;
    FOnSendMessage: TFPlikowniaOnSendMessageEvent;
    FOnSendMessageNoKey: TFPlikowniaOnSendMessageEvent;
    FOnSetDownloadingForm: TFPlikowniaOnBoolEvent;
    FOnSetRunningForm: TFPlikowniaOnBoolEvent;
    FOnSetUploadingForm: TFPlikowniaOnBoolEvent;
    procedure reopen;
    procedure SendMessage(aKomenda: string; aValue: string = ''; aBlock: pointer = nil; aBlockSize: integer = 0);
    procedure SendMessageNoKey(aKomenda: string; aValue: string = ''; aBlock: pchar = nil; aBlockSize: integer = 0);
    procedure SendRamka;
    procedure Send(aOd,aDoKey: string);
  public
    key: string;
    IsHide: boolean;
    bajty: integer;
    function monReceiveString(aMsg,aKomenda: string; aSocket: TLSocket; aBinSize: integer; var aReadBin: boolean): boolean;
    procedure monReceiveBinary(const outdata; size: longword; aSocket: TLSocket);
    procedure SetClose;
  published
    property OnSetRunningForm: TFPlikowniaOnBoolEvent read FOnSetRunningForm write FOnSetRunningForm;
    property OnSetUploadingForm: TFPlikowniaOnBoolEvent read FOnSetUploadingForm write FOnSetUploadingForm;
    property OnSetDownloadingForm: TFPlikowniaOnBoolEvent read FOnSetDownloadingForm write FOnSetDownloadingForm;
    property OnSendMessage: TFPlikowniaOnSendMessageEvent read FOnSendMessage write FOnSendMessage;
    property OnSendMessageNoKey: TFPlikowniaOnSendMessageEvent read FOnSendMessageNoKey write FOnSendMessageNoKey;
  end;

var
  FPlikownia: TFPlikownia;

implementation

uses
  main_monitor, serwis, ecode, crc, ListaKontaktow;

{$R *.lfm}

var
  w_cancel: boolean = false;

{ TFPlikownia }

procedure TFPlikownia.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if plik.Active or plik2.Active then CloseAction:=caHide else
  begin
    CloseAction:=caFree;
    if assigned(FOnSetRunningForm) then FOnSetRunningForm(false);
  end;
end;

procedure TFPlikownia.FormCreate(Sender: TObject);
begin
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  master.Open;
end;

procedure TFPlikownia.FormDestroy(Sender: TObject);
begin
  master.Close;
end;

procedure TFPlikownia.FormHide(Sender: TObject);
begin
  IsHide:=true;
end;

procedure TFPlikownia.FormShow(Sender: TObject);
begin
  {$IFDEF WINDOWS}propstorage.Restore;{$ENDIF}
  IsHide:=false;
end;

procedure TFPlikownia.MenuItem1Click(Sender: TObject);
begin
  (* udostępnij plik wybranemu z listy kontakcie *)
  FListaKontaktow:=TFListaKontaktow.Create(self);
  try
    FListaKontaktow.ShowModal;
    if FListaKontaktow.io_ok then
    begin
      (* wysłanie wiadomości chatowej delikatnie zmienionej *)
      Send(FMonitor.danenazwa.AsString,FListaKontaktow.io_klucz);
    end;
  finally
    FListaKontaktow.Free;
  end;
end;

procedure TFPlikownia.MenuItem2Click(Sender: TObject);
var
  x: string;
begin
  x:=InputBox('Podaj nazwę indeksu do odzyskania','Indeks','');
  if x='' then exit;
  SendMessage('{FILE_REQUEST}',x);
end;

procedure TFPlikownia.plik2AfterClose(DataSet: TDataSet);
begin
  if not CheckBox1.Checked then ff.Free;
  if assigned(FOnSetDownloadingForm) then FOnSetDownloadingForm(false);
  postep.Visible:=false;
  Label3.Visible:=false;
  BitBtn3.Visible:=false;
  atom.Stop;
  pliki.Refresh;
end;

procedure TFPlikownia.plik2AfterOpen(DataSet: TDataSet);
begin
  bajty:=0;
  atom.Start;
  atom.Tag:=atom.GetIndexTime;
  pliki.Refresh;
  if assigned(FOnSetDownloadingForm) then FOnSetDownloadingForm(true);
  Label3.Caption:='Postęp pobierania pliku:';
  postep.Visible:=true;
  Label3.Visible:=true;
  postep.Max:=100;
  postep.Position:=0;
  BitBtn3.Visible:=true;
end;

procedure TFPlikownia.plikAfterClose(DataSet: TDataSet);
begin
  ff.Free;
  if assigned(FOnSetUploadingForm) then FOnSetUploadingForm(false);
  postep.Visible:=false;
  Label3.Visible:=false;
  BitBtn3.Visible:=false;
  atom.Stop;
  pliki.Refresh;
end;

procedure TFPlikownia.plikAfterOpen(DataSet: TDataSet);
begin
  bajty:=0;
  atom.Start;
  atom.Tag:=atom.GetIndexTime;
  pliki.Refresh;
  if assigned(FOnSetUploadingForm) then FOnSetUploadingForm(true);
  Label3.Caption:='Postęp wysyłania pliku:';
  postep.Visible:=true;
  Label3.Visible:=true;
  postep.Max:=100;
  postep.Position:=0;
  BitBtn3.Visible:=true;
end;

procedure TFPlikownia.plikiBeforeOpen(DataSet: TDataSet);
begin
  pliki.ClearDefs;
  case cHideMyFiles.ItemIndex of
    1: pliki.AddDef('--where','where status=1');
    2: pliki.AddDef('--where','where status<>1');
  end;
end;

procedure TFPlikownia.plikidlugoscGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  case cFormatFileSize.ItemIndex of
    0: aText:=NormalizeB('### ### ### ### ### ##0.00',Sender.AsLargeInt);
    1: aText:=FormatFloat('### ### ### ### ### ##0',Sender.AsLargeInt)+' B';
    2: aText:=FormatFloat('### ### ### ### ### ##0.00',Sender.AsLargeInt/1024)+' KB';
    3: aText:=FormatFloat('### ### ### ### ### ##0.00',Sender.AsLargeInt/1024/1024)+' MB';
    4: aText:=FormatFloat('### ### ### ### ### ##0.00',Sender.AsLargeInt/1024/1024/1024)+' GB';
  end;
end;

procedure TFPlikownia.tDownloadTimer(Sender: TObject);
begin
  tDownload.Enabled:=false;
  inc(cERR);
  if cERR>3 then
  begin
    plik2.Close;
    exit;
  end;
  SendMessage('{FILE_DOWNLOAD}',plikid1.AsString+'$'+plikindeks1.AsString+'$'+IntToStr(cIDX)+'$');
  tDownload.Enabled:=true;
end;

procedure TFPlikownia.tSendTimer(Sender: TObject);
begin
  inc(cERR);
  if cERR>3 then
  begin
    tSend.Enabled:=false;
    plik.Close;
    exit;
  end;
  SendRamka;
end;

procedure TFPlikownia.reopen;
begin
  pliki.DisableControls;
  pliki.Close;
  pliki.Open;
  pliki.EnableControls;
end;

procedure TFPlikownia.SendMessage(aKomenda: string; aValue: string;
  aBlock: pointer; aBlockSize: integer);
begin
  if assigned(FOnSendMessage) then FOnSendMessage(aKomenda,aValue,aBlock,aBlockSize);
end;

procedure TFPlikownia.SendMessageNoKey(aKomenda: string; aValue: string;
  aBlock: pchar; aBlockSize: integer);
begin
  if assigned(FOnSendMessageNoKey) then FOnSendMessageNoKey(aKomenda,aValue,aBlock,aBlockSize);
end;

type
  TByteArray = array [0..65535] of byte;

procedure TFPlikownia.SendRamka;
var
  cc: string;
  czas,mx,n: integer;
  t: TByteArray;
begin
  tSend.Enabled:=false;
  if w_cancel then
  begin
    SendMessage('{FILE_END}',plikid.AsString+'$'+plikindeks.AsString+'$');
    plik.Close;
    exit;
  end;
  mx:=plikdlugosc.AsLargeInt div CONST_UP_FILE_BUFOR;
  if mx mod CONST_UP_FILE_BUFOR > 0 then inc(mx);
  postep.Position:=round(100*cIDX/mx);
  if cIDX>mx then
  begin
    SendMessage('{FILE_END}',plikid.AsString+'$'+plikindeks.AsString+'$');
    plik.Close;
    exit;
  end;

  if ccIDX<>cIDX then
  begin
    ff.Seek(cIDX*CONST_UP_FILE_BUFOR,soBeginning);
    ccIDX:=cIDX;
  end;
  n:=ff.Read(&t[0],CONST_UP_FILE_BUFOR);
  inc(ccIDX);
  cc:=CrcBlockToHex(pbyte(@t[0]),n);
  SendMessage('{FILE_UPLOAD}',plikid.AsString+'$'+plikindeks.AsString+'$'+cc+'$'+IntToStr(cIDX)+'$'+IntToStr(n)+'$#',@t,n);
  bajty+=n;
  czas:=atom.GetIndexTime;
  if czas>atom.Tag+1000 then
  begin
    Label3.Caption:='Postęp wysyłania pliku ('+NormalizeB('0.00',bajty)+'/s):';
    bajty:=0;
    atom.Tag:=czas;
  end;

  tSend.Enabled:=true;
end;

procedure TFPlikownia.Send(aOd, aDoKey: string);
var
  s: string;
  s1: string;
begin
  s:=aOd+'$'+aDoKey+'$'+'110'+IntToStr(clRed)+'$'+'Informacja: Udostępniłem dla Ciebie zasób plikowy, zajrzyj do plikowni.$'+plikiindeks.AsString+'$';
  SendMessage('{CHAT}',s);
end;

function TFPlikownia.monReceiveString(aMsg, aKomenda: string;
  aSocket: TLSocket; aBinSize: integer; var aReadBin: boolean): boolean;
var
  s1,s2,s3: string;
  a1,a2,a3: integer;
  i64: int64;
begin
  result:=false;
  if aKomenda='{FILE_UPLOADING}' then
  begin
    result:=true;
    if not plik.Active then exit;
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    if plikid.AsInteger<>a1 then exit;
    s2:=GetLineToStr(aMsg,4,'$',''); //status ('OK'|'ERROR')
    if s2='ERROR' then inc(cERR);
    if cERR>3 then
    begin
      tSend.Enabled:=false;
      plik.Close;
      exit;
    end;
    cIDX:=StrToInt(GetLineToStr(aMsg,5,'$','0')); //idx
    SendRamka;
  end else
  if aKomenda='{FILE_NEW_ACCEPTED}' then
  begin
    result:=true;
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    if a1<1 then exit;
    s2:=GetLineToStr(aMsg,4,'$',''); //indeks
    up_indeks.ParamByName('id').AsInteger:=a1;
    up_indeks.ParamByName('indeks').AsString:=s2;
    up_indeks.ExecSQL;
    pliki.Refresh;
    (* zainicjowanie przesyłania pliku *)
    ff:=TFileStream.Create(cFILENAME,fmOpenRead or fmShareDenyWrite);
    cERR:=0;
    cIDX:=0;
    plik.ParamByName('id').AsInteger:=a1;
    plik.Open;
    SendRamka;
  end else
  if aKomenda='{FILE_DELETE_TRUE}' then
  begin
    result:=true;
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    if a1<1 then exit;
    del_id.ParamByName('id').AsInteger:=a1;
    del_id.ExecSQL;
    pliki.Refresh;
  end else
  if aKomenda='{FILE_DELETE_FALSE}' then
  begin
    result:=true;
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    if a1<1 then exit;
    //del_id.ParamByName('id').AsInteger:=a1;
    //del_id.ExecSQL;
    //pliki.Refresh;
  end else
  if aKomenda='{FILE_STATING}' then
  begin
    result:=true;
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    s2:=GetLineToStr(aMsg,4,'$',''); //indeks
    i64:=StrToInt64(GetLineToStr(aMsg,5,'$','-1')); //wielkość pliku
    plik2.ParamByName('id').AsInteger:=a1;
    plik2.Open;
    if a2=-1 then
    begin
      //plik2.Delete;
      plik2.Close;
      mess.ShowInformation('Plik który chcesz ściągnąć nie istnieje, być może został wcześniej usunięty.');
      pliki.Refresh;
    end else if plikdlugosc1.AsLargeInt>i64 then
    begin
      //plik2.Delete;
      plik2.Close;
      mess.ShowInformation('Plik który chcesz ściągnąć jest krótszy niż wielkość oczekiwana.');
      pliki.Refresh;
    end else begin
      if not CheckBox1.Checked then
      begin
        if FileExists(cFILENAME) then DeleteFile(cFILENAME);
        ff:=TFileStream.Create(cFILENAME,fmCreate);
      end;
      cERR:=0;
      cIDX:=0;
      ccIDX:=0;
      cLENGTH:=i64;
      SendMessage('{FILE_DOWNLOAD}',plikid1.AsString+'$'+plikindeks1.AsString+'$'+IntToStr(cIDX)+'$');
      tDownload.Enabled:=true;
    end;
  end else
  if aKomenda='{FILE_DOWNLOADING}' then
  begin
    result:=true;
    s1:=GetLineToStr(aMsg,2,'$','');            //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    s2:=GetLineToStr(aMsg,4,'$','');            //indeks
    a2:=StrToInt(GetLineToStr(aMsg,5,'$','0')); //idx (segment bloku)
    cCRCHEX:=GetLineToStr(aMsg,6,'$','');       //src-hex
    a3:=StrToInt(GetLineToStr(aMsg,7,'$','0')); //wielkość bloku
    cIDX2:=a2;
    aReadBin:=true;
  end else
  if aKomenda='{FILE_DOWNLOADING_ZERO}' then
  begin
    result:=true;
    s1:=GetLineToStr(aMsg,2,'$','');            //key
    if s1<>key then exit;
    a1:=StrToInt(GetLineToStr(aMsg,3,'$','0')); //id
    s2:=GetLineToStr(aMsg,4,'$','');            //indeks
    a2:=StrToInt(GetLineToStr(aMsg,5,'$','0')); //idx (segment bloku)
    if plik2.Active then
    begin
      tDownLoad.Enabled:=false;
      plik2.Close;
    end;
  end;
end;

procedure TFPlikownia.monReceiveBinary(const outdata; size: longword;
  aSocket: TLSocket);
var
  crc: string;
  czas,mx: integer;
begin
  tDownload.Enabled:=false;

  if w_cancel then
  begin
    SendMessage('{FILE_END}',plikid1.AsString+'$'+plikindeks1.AsString+'$');
    plik2.Close;
    exit;
  end;

  mx:=cLENGTH div CONST_DW_FILE_BUFOR;
  if cLENGTH mod CONST_DW_FILE_BUFOR > 0 then inc(mx);
  postep.Position:=round(100*cIDX2/mx);
  if cIDX>mx then
  begin
    SendMessage('{FILE_END}',plikid1.AsString+'$'+plikindeks1.AsString+'$');
    plik2.Close;
    exit;
  end;

  bajty+=size;
  czas:=atom.GetIndexTime;
  if czas>atom.Tag+1000 then
  begin
    Label3.Caption:='Postęp pobierania pliku ('+NormalizeB('0.00',bajty)+'/s):';
    bajty:=0;
    atom.Tag:=czas;
  end;

  crc:=CrcBlockToHex(outdata,size);
  if crc<>cCRCHEX then
  begin
    tDownloadTimer(nil);
    exit;
  end;

  if not CheckBox1.Checked then ff.Write(outdata,size);
  if cIDX=cIDX2 then inc(cIDX);

  if cIDX>mx then
  begin
    SendMessage('{FILE_END}',plikid1.AsString+'$'+plikindeks1.AsString+'$');
    plik2.Close;
    exit;
  end;

  SendMessage('{FILE_DOWNLOAD}',plikid1.AsString+'$'+plikindeks1.AsString+'$'+IntToStr(cIDX)+'$');
  tDownload.Enabled:=true;
end;

procedure TFPlikownia.SetClose;
begin
  close;
end;

procedure TFPlikownia.BitBtn4Click(Sender: TObject);
begin
  close;
end;

procedure TFPlikownia.BitBtn5Click(Sender: TObject);
begin
  sdialog.FileName:=plikinazwa.AsString;
  sdialog.DefaultExt:=ExtractFileExt(sdialog.FileName);
  if sdialog.Execute then
  begin
    w_cancel:=false;
    cFILENAME:=sdialog.FileName;
    SendMessage('{FILE_STAT}',plikiid.AsString+'$'+plikiindeks.AsString+'$'+IntToStr(CONST_DW_FILE_BUFOR)+'$');
  end;
end;

procedure TFPlikownia.cFormatFileSizeChange(Sender: TObject);
begin
  pliki.Refresh;
end;

procedure TFPlikownia.cHideMyFilesChange(Sender: TObject);
begin
  reopen;
end;

procedure TFPlikownia.DBGridPlus1PrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  if plikistatus.AsInteger=1 then DBGridPlus1.Canvas.Font.Color:=clBlue else DBGridPlus1.Canvas.Font.Color:=clDefault;
end;

procedure TFPlikownia.BitBtn1Click(Sender: TObject);
var
  f: file of byte;
  a: int64;
  nazwa: string;
begin
  if odialog.Execute then
  begin
    assignfile(f,odialog.FileName);
    try
      reset(f,1);
    except
      mess.ShowWarning('Nie mogę otworzyć pliku, byc może używany jest przez inny program w trybie blokującym.^Przerywam.');
      exit;
    end;
    a:=filesize(f);
    closefile(f);
    if not FMonitor.Programistyczne.Visible then if a>5*1024*1024 then
    begin
      mess.ShowInformation('W tej chwili włączone jest ograniczenie w przesyłaniu plików powyżej 5 MB.^Twój plik łamie to ograniczenie, w związku z tym operacja zostaje przerwana.');
      exit;
    end;
    if cHideMyFiles.ItemIndex=2 then
    begin
      cHideMyFiles.ItemIndex:=0;
      reopen;
    end;
    w_cancel:=false;
    nazwa:=ExtractFileName(odialog.FileName);
    cFILENAME:=odialog.FileName;
    pliki.Append;
    plikinick.AsString:=FMonitor.danenazwa.AsString;
    plikiklucz.AsString:=EncryptString(DecryptString(FMonitor.daneklucz.AsString,dm.GetHashCode(3),true),dm.GetHashCode(4),64);
    plikinazwa.AsString:=nazwa;
    plikidlugosc.AsLargeInt:=a;
    plikiczas_wstawienia.AsString:=FormatDateTime('yyyy-mm-dd hh:nn:ss',now);
    plikiczas_zycia.AsString:=FormatDateTime('yyyy-mm-dd hh:nn:ss',now+7);
    plikistatus.AsInteger:=1;
    plikisciezka.AsString:=odialog.FileName;
    pliki.Post;
    SendMessage('{FILE_NEW}',FMonitor.danenazwa.AsString+'$'+nazwa+'$'+IntToStr(a)+'$'+plikiid.AsString+'$'+IntToStr(CONST_UP_FILE_BUFOR)+'$');
  end;
end;

procedure TFPlikownia.BitBtn2Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Czy usunąć plik "'+plikinazwa.AsString+'" z listy plików?') then
  begin
    if DecryptString(plikiklucz.AsString,dm.GetHashCode(4),true)=key then SendMessage('{FILE_DELETE}',plikiid.AsString+'$'+plikiindeks.AsString) else pliki.Delete;
  end;
end;

procedure TFPlikownia.BitBtn3Click(Sender: TObject);
begin
  w_cancel:=true;
end;

procedure TFPlikownia.dsplikiDataChange(Sender: TObject; Field: TField);
var
  p: boolean;
  a,ne,e: boolean;
  vplik: string;
  b_plik: boolean;
begin
  p:=(not plik.Active) and (not plik2.Active);
  master.State(dspliki,a,ne,e);
  BitBtn1.Enabled:=p and a;
  BitBtn2.Enabled:=p and ne;
  vplik:=plikisciezka.AsString;
  b_plik:=vplik<>'';
  if b_plik and (not FileExists(vplik)) then b_plik:=false;
  BitBtn5.Enabled:=p and ne;
  MenuItem1.Visible:=p and ne;
end;

end.

