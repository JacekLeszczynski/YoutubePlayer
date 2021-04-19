unit Chat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, XMLPropStorage, Menus, ExtCtrls, HtmlView, uETilePanel, uETileImage,
  ueled, lNet, switches, ZDataset, HtmlGlobals, HTMLUn2, ExtMessage, DB, Types;

type

  { TFChat }

  TFChatOnVoidEvent = procedure of object;
  TFChatOnBoolEvent = procedure (aValue: boolean) of object;
  TFChatOnIntEvent = procedure (aValue: integer) of object;
  TFChatOnPointerEvent = procedure (aPointer: pointer) of object;
  TFChatOnStrEvent = procedure (aValue: string) of object;
  TFChatOnStrStrEvent = procedure (aStr1,aStr2: string; aSzary: boolean) of object;
  TFChatOnStrStrVarEvent = procedure (aStr1: string; var aStr2: string) of object;
  TFChatOnSendMessageEvent = procedure(aKomenda: string; aValue: string) of object;
  TFChat = class(TForm)
    CheckBox1: TCheckBox;
    ColorButton1: TColorButton;
    dsprive: TDataSource;
    html: THtmlViewer;
    ImageList1: TImageList;
    Label1: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mess: TExtMessage;
    PopupMenu1: TPopupMenu;
    priveadresat: TMemoField;
    priveformatowanie: TMemoField;
    priveid: TLargeintField;
    priveinsertdt: TMemoField;
    privenadawca: TMemoField;
    privenick: TMemoField;
    priveprzeczytane: TLargeintField;
    privetresc: TMemoField;
    autorun: TTimer;
    uELED1: TuELED;
    propstorage: TXMLPropStorage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    uETilePanel1: TuETilePanel;
    uETilePanel2: TuETilePanel;
    uETilePanel3: TuETilePanel;
    uETilePanel4: TuETilePanel;
    wyslij: TSpeedButton;
    wyslij_source: TSpeedButton;
    prive: TZQuery;
    procedure autorunTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure htmlHotSpotClick(Sender: TObject; const SRC: ThtString;
      var Handled: Boolean);
    procedure htmlImageRequest(Sender: TObject; const SRC: ThtString;
      var Stream: TStream);
    procedure htmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure htmlMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure htmlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure TRZY_PRZYCISKI(Sender: TObject);
    procedure wyslijClick(Sender: TObject);
  private
    BLOCK_CHAT_REFRESH: boolean;
    FOnClearPrive: TFChatOnStrEvent;
    FOnGoBeep: TFChatOnIntEvent;
    root_name: string;
    FOnAddKontakt: TFChatOnStrStrEvent;
    FOnKeyToNazwa: TFChatOnStrStrVarEvent;
    FOnTrayIconMessage: TFChatOnIntEvent;
    vZaloguj: boolean;
    isHide: boolean;
    niki,niki2,keye,niki_keye: TStringList;
    schat: TStringList;
    skey: string;
    FOnExecDestroy: TFChatOnPointerEvent;
    FOnSendMessage: TFChatOnSendMessageEvent;
    FOnSendMessageNoKey: TFChatOnSendMessageEvent;
    simage: TMemoryStream;
    FormatView: integer;
    procedure emotki(var aStr: string);
    function ImgToEmotka(aImage: TMemoryStream; aFile: string): boolean;
    function res_load(aImage: TMemoryStream; aName: string; aResType: PChar): boolean;
    function KeyToSName(aKey,aName: string): string;
    procedure ChatInit(aStr: string = '');
    procedure ChatAdd(aKey,aOd,aDoKey,aFormatowanie,aTresc,aCzas: String; aZapis: boolean = false);
    procedure ChatRefresh;
    procedure SendMessage(aKomenda: string;  aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure Send(aOd,aDoKey,aFormatowanie,aTresc: string);
    procedure TestMessageActive;
  public
    IDENT: integer;
    zablokowano: boolean;
    key,nick: string;
    key2,nick2: string;
    constructor Create(AOwner: TComponent; const ARootName: string; aIdent: integer; const aNick,aKey,aNick2,aKey2: string);
    procedure blokuj;
    procedure odblokuj(aId: integer);
    function monReceiveString(aMsg,aKomenda: string; aSocket: TLSocket; aID: integer): boolean;
    procedure GoSetChat(aFont, aFont2: string; aSize, aSize2, aColor, aFormat, aMaxLineChat: integer);
  published
    //property OnChatGetData: TFChatOnVoidEvent read FOnGetData write FOnGetData;
    property OnSendMessage: TFChatOnSendMessageEvent read FOnSendMessage write FOnSendMessage;
    property OnSendMessageNoKey: TFChatOnSendMessageEvent read FOnSendMessageNoKey write FOnSendMessageNoKey;
    property OnExecuteDestroy: TFChatOnPointerEvent read FOnExecDestroy write FOnExecDestroy;
    property OnTrayIconMessage: TFChatOnIntEvent read FOnTrayIconMessage write FOnTrayIconMessage;
    property OnAddKontakt: TFChatOnStrStrEvent read FOnAddKontakt write FOnAddKontakt;
    property OnKeyToNazwa: TFChatOnStrStrVarEvent read FOnKeyToNazwa write FOnKeyToNazwa;
    property OnGoBeep: TFChatOnIntEvent read FOnGoBeep write FOnGoBeep;
    property OnClearPrive: TFChatOnStrEvent read FOnClearPrive write FOnClearPrive;
  end;

var
  FChat: TFChat;

implementation

uses
  ustawienia, serwis, main_monitor, ecode, lcltype, lclintf, RegExpr;

{$R *.lfm}

function IsCharWord(ch: char): boolean;
begin
  Result:= ch in ['a'..'z', 'A'..'Z', '_', '0'..'9'];
end;

function IsCharHex(ch: char): boolean;
begin
  Result:= ch in ['0'..'9', 'a'..'f', 'A'..'F'];
end;

function SColorToHtmlColor(Color: TColor): string;
var
  N: Longint;
begin
  if Color=clNone then
    begin Result:= ''; exit end;
  N:= ColorToRGB(Color);
  Result:= '#'+
    IntToHex(Red(N), 2)+
    IntToHex(Green(N), 2)+
    IntToHex(Blue(N), 2);
end;

function SHtmlColorToColor(s: string; out Len: integer; Default: TColor): TColor;
var
  N1, N2, N3: integer;
  i: integer;
begin
  Result:= Default;
  Len:= 0;
  if (s<>'') and (s[1]='#') then Delete(s, 1, 1);
  if (s='') then exit;

  //delete after first nonword char
  i:= 1;
  while (i<=Length(s)) and IsCharWord(s[i]) do Inc(i);
  Delete(s, i, Maxint);

  //allow only #rgb, #rrggbb
  Len:= Length(s);
  if (Len<>3) and (Len<>6) then exit;

  for i:= 1 to Len do
    if not IsCharHex(s[i]) then exit;

  if Len=6 then
  begin
    N1:= StrToInt('$'+Copy(s, 1, 2));
    N2:= StrToInt('$'+Copy(s, 3, 2));
    N3:= StrToInt('$'+Copy(s, 5, 2));
  end
  else
  begin
    N1:= StrToInt('$'+s[1]+s[1]);
    N2:= StrToInt('$'+s[2]+s[2]);
    N3:= StrToInt('$'+s[3]+s[3]);
  end;

  Result:= RGBToColor(N1, N2, N3);
end;

{ TFChat }

procedure TFChat.TRZY_PRZYCISKI(Sender: TObject);
begin
  TSpeedButton(Sender).Visible:=false;
end;

procedure TFChat.wyslijClick(Sender: TObject);
var
  s: string;
  s1,s2,s3,f: string;
begin
  if not uELED1.Active then
  begin
    mess.PosLeft:=round(Left+(Width/2)-150);
    mess.PosTop:=round(Top+(Height/2)-50);
    mess.ShowInformation('Brak połączenia!','Połączenie z serwerem zostało przerwane.^Poczekaj na wznowienie połączenia.');
    exit;
  end;
  s:=trim(Memo1.Lines.Text);
  if s='' then exit;
  if SpeedButton4.Visible then s1:='1' else s1:='0';
  if SpeedButton5.Visible then s2:='1' else s2:='0';
  if SpeedButton6.Visible then s3:='1' else s3:='0';
  f:=IntToStr(ColorButton1.ButtonColor);
//  s:=EncodeEncjon(s);
  s:=StringReplace(s,'$','{#S}',[rfReplaceAll]);
  s:=StringReplace(s,'"','{#C}',[rfReplaceAll]);
  s:=StringReplace(s,'<','{#1}',[rfReplaceAll]);
  s:=StringReplace(s,'>','{#2}',[rfReplaceAll]);
  Send(nick,key2,s1+s2+s3+f,s);
  Memo1.Clear;
  Memo1.SetFocus;
end;

procedure TFChat.emotki(var aStr: string);
var
  i: integer;
begin
  for i:=0 to FMonitor.img1.Count-1 do
    aStr:=StringReplace(aStr,FMonitor.img1[i],'{$1}img src="'+FMonitor.img2[i]+'" alt="'+FMonitor.img1[i]+'"{$2}',[rfReplaceAll]);
end;

function TFChat.ImgToEmotka(aImage: TMemoryStream; aFile: string): boolean;
var
  s: string;
begin
  s:=MyConfDir('img'+_FF+aFile);
  if FileExists(s) then
  begin
    aImage.LoadFromFile(s);
    result:=true;
  end else result:=false;
end;

function TFChat.res_load(aImage: TMemoryStream; aName: string; aResType: PChar
  ): boolean;
var
  res: TResourceStream;
begin
  try
    res:=TResourceStream.Create(hInstance,aName,aResType);
    aImage.LoadFromStream(res);
  finally
    res.Free;
  end;
  result:=true;
end;

function TFChat.KeyToSName(aKey, aName: string): string;
var
  a: integer;
begin
  //    niki,niki2,keye,niki_keye: TStringList;
  a:=StringToItemIndex(keye,aKey);
  if a=-1 then result:=aName else result:=niki2[a];
end;

procedure TFChat.ChatInit(aStr: string);
begin
  if aStr='' then schat.Add('<p>Czat prywatny - <b>'+nick2+'</b>:</p>') else schat.Add(aStr);
  ChatRefresh;
end;

function TextUrlsToLinks(url: string): string;
var
  a,b,c: integer;
  s,s1,ss: string;
  znak: char;
begin
  s:=StringReplace(url,#13,'',[rfReplaceAll]);
  ss:='';
  while length(s)>0 do
  begin
    znak:=' ';
    a:=pos(' ',s);
    b:=pos(#10,s);
    if (b>0) and ((b<a) or (a=0)) then a:=b;
    if a=0 then
    begin
      s1:=s;
      s:='';
      znak:=#0;
    end else begin
      znak:=s[a];
      s1:=trim(copy(s,1,a-1));
      delete(s,1,a);
    end;
    c:=pos('http://',s1); if c=0 then c:=pos('https://',s1);
    if c=1 then ss:=ss+'{$1}a href="'+s1+'"{$2}'+s1+'{$1}/a{$2}' else ss:=ss+s1;
    if znak<>#0 then ss:=ss+znak;
  end;
  result:=ss;
end;

procedure TFChat.ChatAdd(aKey, aOd, aDoKey, aFormatowanie, aTresc,
  aCzas: String; aZapis: boolean);
var
  ja: string;
  s,s1,s2,s3,sczas: string;
  i,pom: integer;
  data,czas: TDateTime;
  fs: TFormatSettings;
begin
  fs.ShortDateFormat:='y/m/d';
  fs.DateSeparator:='-';
  fs.TimeSeparator:=':';
  data:=StrToDate(copy(aCzas,1,10),fs);
  czas:=StrToTime(copy(aCzas,12,8),fs);
  if data<date then sczas:=FormatDateTime('yyyy-mm-dd hh:nn',data+czas) else sczas:=FormatDateTime('hh:nn',czas);
  if aZapis and (IDENT>-1) then
  begin
    (* zapis do bazy danych *)
    prive.Append;
    priveinsertdt.AsString:=aCzas;
    privenadawca.AsString:=EncryptString(aKey,dm.GetHashCode(4),64);
    privenick.AsString:=aOd;
    priveadresat.AsString:=EncryptString(aDoKey,dm.GetHashCode(4),64);
    priveformatowanie.AsString:=aFormatowanie;
    privetresc.AsString:=aTresc;
    priveprzeczytane.AsInteger:=1;
    prive.Post;
  end;
  //<font color=#ff0000><b>Samu</b></font>: <font color=#000000>aaa <a href="http://www.youtube.com/watch?v=2Aio_sh-Ia0,">http://www.youtube.com/watch?v=2Aio_sh-Ia0,</a> sss</font><br>
  if FormatView=0 then
  begin
    if aKey=key then s1:='<span style="font-size: small; color: gray"><b>'+aOd+', '+sczas+'</b></span><br>'
    else begin
      s1:='<span style="font-size: small; color: gray">'+KeyToSName(aKey,aOd)+', '+sczas+'</span><br>';
      if not BLOCK_CHAT_REFRESH then if Screen.ActiveForm<>self then FOnGoBeep(0);
    end;
  end else
  if FormatView=1 then
  begin
    s1:=sczas+', <b>'+aOd+'</b>: ';
    if aKey<>key then if not BLOCK_CHAT_REFRESH then if Screen.ActiveForm<>self then FOnGoBeep(0);
  end;
  s:=StringReplace(aTresc,'{#S}','$',[rfReplaceAll]);
  s:=StringReplace(s,'{#C}','"',[rfReplaceAll]);
  s:=StringReplace(s,'{#1}','<',[rfReplaceAll]);
  s:=StringReplace(s,'{#2}','>',[rfReplaceAll]);
  s:=TextUrlsToLinks(s);
  (* emotki >> *)
  emotki(s);
  s:=EncodeEncjon(s);
  s:=StringReplace(s,'{$1}','<',[rfReplaceAll]);
  s:=StringReplace(s,'{$2}','>',[rfReplaceAll]);
  (* << emotki *)
  s2:=StringReplace(s,#10,'<br>',[rfReplaceAll]);
  if aFormatowanie[1]='1' then s2:='<b>'+s2+'</b>';
  if aFormatowanie[2]='1' then s2:='<i>'+s2+'</i>';
  if aFormatowanie[3]='1' then s2:='<u>'+s2+'</u>';
  pom:=StrToInt(copy(aFormatowanie,4,maxint));
  s2:='<span style="color: '+SColorToHtmlColor(pom)+'">'+s2+'</span>';
  s:=s1+' '+s2;
  if FormatView=0 then s:='<p>'+s+'</p>' else s:=s+'<br>';
  schat.Add(s);
  if schat.Count>200 then schat.Delete(0);
  ChatRefresh;
end;

procedure TFChat.ChatRefresh;
begin
  if BLOCK_CHAT_REFRESH then exit;
  html.LoadFromString(schat.Text);
end;

procedure TFChat.SendMessage(aKomenda: string; aValue: string);
begin
  if assigned(FOnSendMessage) then FOnSendMessage(aKomenda,aValue);
end;

procedure TFChat.SendMessageNoKey(aKomenda: string; aValue: string);
begin
  if assigned(FOnSendMessageNoKey) then FOnSendMessageNoKey(aKomenda,aValue);
end;

procedure TFChat.Send(aOd, aDoKey, aFormatowanie, aTresc: string);
var
  s: string;
begin
  s:=aOd+'$'+aDoKey+'$'+aFormatowanie+'$'+aTresc;
  SendMessage('{CHAT}',s);
end;

procedure TFChat.TestMessageActive;
begin
  if isHide then FOnTrayIconMessage(2);
end;

constructor TFChat.Create(AOwner: TComponent; const ARootName: string;
  aIdent: integer; const aNick, aKey, aNick2, aKey2: string);
begin
  inherited Create(AOwner);
  root_name:=ARootName;
  IDENT:=aIdent;
  Name:=ARootName;
  nick:=aNick;
  key:=aKey;
  nick2:=aNick2;
  key2:=aKey2;
end;

procedure TFChat.blokuj;
begin
  zablokowano:=true;
  uELED1.Active:=false;
end;

procedure TFChat.odblokuj(aId: integer);
begin
  //tOdblokuj.Enabled:=true;
  if aId=-1 then
  begin
    zablokowano:=false;
    niki.Clear;
    keye.Clear;
    niki2.Clear;
    niki_keye.Clear;
  end;
  vZaloguj:=false;
  if aId=-1 then
  begin
    SendMessageNoKey('{SET_ACTIVE}','5$1$'+nick);
    //SendMessageNoKey('{CHAT_INIT}');
  end;
  uELED1.Active:=true;
end;

function TFChat.monReceiveString(aMsg, aKomenda: string; aSocket: TLSocket;
  aID: integer): boolean;
var
  vOdKey,vDoKey: string;
  s1,s2,s3,s4,s5: string;
  a,b: integer;
  bb: boolean;
begin
  bb:=false;
  vOdKey:=GetLineToStr(aMsg,2,'$','');
  vDoKey:=GetLineToStr(aMsg,4,'$','');
  if (IDENT=-1) and (aKomenda='{CHAT_USER}') then
  begin
    uELED1.Active:=true;
    s1:=GetLineToStr(aMsg,2,'$',''); //nick
    s2:=GetLineToStr(aMsg,3,'$',''); //key
    s3:=s1;
    if s2<>key then FOnKeyToNazwa(s2,s3); //pobieram nazwę z własnej tabeli jeśli jest
    s4:=s3+#1+s2+#1+s1;
    niki_keye.Add(s4);
    a:=StringToItemIndex(niki_keye,s4);
    niki.Insert(a,s1);  //niki ustawione przez zdalnych ludzi
    niki2.Insert(a,s3); //niki ustawione przeze mnie
    keye.Insert(a,s2);
    ListBox1.Items.Assign(niki2);
    bb:=true;
  end else
  if (aKomenda='{CHAT}') and
    (
      ((IDENT=-1) and (vDoKey=''))
      or
      ((IDENT>-1) and (((vOdKey=key2) and (vDoKey=key)) or ((vOdKey=key) and (vDoKey=key2))))
    ) then
  begin
    s1:=GetLineToStr(aMsg,3,'$','');
    s2:=GetLineToStr(aMsg,5,'$','');
    s3:=GetLineToStr(aMsg,6,'$','');
    s4:=GetLineToStr(aMsg,7,'$','');
    ChatAdd(vOdKey,s1,vDoKey,s2,s3,s4,true);
    TestMessageActive;
    bb:=true;
  end else
  if (IDENT=-1) and (aKomenda='{CHAT_LOGOUT}') then
  begin
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    a:=StringToItemIndex(keye,s1);
    if a>-1 then
    begin
      niki_keye.Delete(a);
      niki.Delete(a);
      niki2.Delete(a);
      keye.Delete(a);
      ListBox1.Items.Assign(niki2);
    end;
    bb:=true;
  end else
  if (IDENT=-1) and (aKomenda='{CHAT_INIT}') then
  begin
    ChatInit(GetLineToStr(aMsg,2,'$',''));
    bb:=true;
  end;
  result:=bb;
end;

procedure TFChat.GoSetChat(aFont, aFont2: string; aSize, aSize2, aColor,
  aFormat, aMaxLineChat: integer);
begin
  html.DefFontName:=aFont;
  html.DefFontSize:=aSize;
  html.DefBackground:=aColor;
  html.HistoryMaxCount:=aMaxLineChat;
  ListBox1.Font.Name:=aFont2;
  ListBox1.Font.Size:=aSize2;
  FormatView:=aFormat;
  ChatRefresh;
end;

procedure TFChat.SpeedButton1Click(Sender: TObject);
begin
  SpeedButton4.Visible:=true;
end;

procedure TFChat.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caNone;
  if CheckBox1.Checked then hide else FOnExecDestroy(self);
end;

procedure TFChat.autorunTimer(Sender: TObject);
var
  s1,s2: string;
  b: boolean;
begin
  autorun.Enabled:=false;
  if IDENT>-1 then
  begin
    try
      b:=false;
      if prive.RecordCount>0 then
      begin
        mess.PosLeft:=round(Left+(Width/2)-150);
        mess.PosTop:=round(Top+(Height/2)-50);
        mess.ShowInfo('Ładowanie historii... Czekaj!');
        application.ProcessMessages;
        b:=true;
      end;
      (* odtwarzam historię czata prywatnego *)
      prive.First;
      BLOCK_CHAT_REFRESH:=true;
      while not prive.EOF do
      begin
        s1:=DecryptString(privenadawca.AsString,dm.GetHashCode(4),true);
        s2:=DecryptString(priveadresat.AsString,dm.GetHashCode(4),true);
        ChatAdd(s1,privenick.AsString,s2,priveformatowanie.AsString,privetresc.AsString,priveinsertdt.AsString);
        prive.Next;
      end;
      if assigned(FOnClearPrive) then FOnClearPrive(EncryptString(key2,dm.GetHashCode(4),64));
      BLOCK_CHAT_REFRESH:=false;
      ChatRefresh;
    finally
      if b then mess.HideInfo;
    end;
  end;
end;

procedure TFChat.FormCreate(Sender: TObject);
var
  s1,s2: string;
begin
  PropStorage.Active:=false;
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.RootNodePath:=root_name;
  PropStorage.Active:=true;
  zablokowano:=false;
  BLOCK_CHAT_REFRESH:=false;
  simage:=TMemoryStream.Create;
  niki:=TStringList.Create;
  niki2:=TStringList.Create;
  keye:=TStringList.Create;
  niki_keye:=TStringList.Create;
  niki_keye.Sorted:=true;
  schat:=TStringList.Create;
  vZaloguj:=true;
  s1:=IniReadString('Chat','Font','Sans');
  s2:=IniReadString('Chat','Font2','Sans');
  if s1='' then s1:='Sans';
  if s2='' then s2:='Sans';
  html.DefFontName:=s1;
  html.DefFontSize:=IniReadInteger('Chat','FontSize',12);
  html.DefBackground:=IniReadInteger('Chat','BackgroundColor',clWhite);
  html.HistoryMaxCount:=IniReadInteger('Chat','MaxHistoryLine',200);;
  ListBox1.Font.Name:=s2;
  ListBox1.Font.Size:=IniReadInteger('Chat','FontSize2',12);
  FormatView:=IniReadInteger('Chat','FormatView',0);
  if IDENT<>-1 then
  begin
    prive.ParamByName('user').AsString:=EncryptString(key2,dm.GetHashCode(4),64);
    prive.Open;
    CheckBox1.Visible:=false;
    ListBox1.Visible:=false;
    uETilePanel3.Width:=4;
    skey:=key2;
    setlength(skey,5);
    //prive.ParamByName('user').AsString:=skey;
    //prive.Open;
    ChatInit;
  end;
  autorun.Enabled:=true;
end;

procedure TFChat.FormDestroy(Sender: TObject);
begin
  simage.Free;
  keye.Free;
  niki.Free;
  niki2.Free;
  niki_keye.Free;
  schat.Free;
  if IDENT>-1 then
  begin
    prive.Close;
    exit;
  end;
  SendMessageNoKey('{SET_ACTIVE}','5$0');
end;

procedure TFChat.FormHide(Sender: TObject);
begin
  isHide:=true;
end;

procedure TFChat.FormShow(Sender: TObject);
begin
  if IDENT>-1 then exit;
  isHide:=false;
  FOnTrayIconMessage(1);
  if vZaloguj then
  begin
    vZaloguj:=false;
    SendMessageNoKey('{SET_ACTIVE}','5$1$'+nick);
    SendMessageNoKey('{CHAT_INIT}');
    uELED1.Active:=true;
  end;
end;

procedure TFChat.htmlHotSpotClick(Sender: TObject; const SRC: ThtString;
  var Handled: Boolean);
begin
  {Kliknięcie w link}
  Handled:=true;
  if SRC='' then exit;
  OpenURL(SRC);
end;

procedure TFChat.htmlImageRequest(Sender: TObject; const SRC: ThtString;
  var Stream: TStream);
var
  b: boolean;
begin
  b:=ImgToEmotka(simage,SRC);
  if b then Stream:=simage;
end;

procedure TFChat.htmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  s: string;
begin
  {kopiowanie zaznaczonego tekstu do schowka}
  if (ssCtrl in Shift) and ((Key=ord('c')) or (Key=ord('C'))) then html.CopyToClipboard;
end;

procedure TFChat.htmlMouseDouble(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  html.CopyToClipboard;
end;

procedure TFChat.htmlMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then html.CopyToClipboard;
end;

procedure TFChat.Memo1Change(Sender: TObject);
var
  s: string;
begin
  s:=trim(Memo1.Lines.Text);
  wyslij.Enabled:=length(s)>0;
end;

procedure TFChat.Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  vshift: boolean;
begin
  vshift:=ssShift in Shift;
  if (Key=VK_RETURN) and (not vshift) then
  begin
    wyslij.Click;
    Key:=0;
  end;
end;

procedure TFChat.MenuItem2Click(Sender: TObject);
var
  s,s1,s2: string;
begin
  s:=niki_keye[ListBox1.ItemIndex];
  s1:=GetLineToStr(s,1,#1); //nazwa
  s2:=GetLineToStr(s,2,#1); //klucz
  if s2=key then
  begin
    mess.PosLeft:=round(Left+(Width/2)-150);
    mess.PosTop:=round(Top+(Height/2)-50);
    mess.ShowInformation('Próbujesz dodać siebie do kontaktów?^To nie wyjdzie :)');
  end else FOnAddKontakt(s2,s1,false);
end;

procedure TFChat.SpeedButton2Click(Sender: TObject);
begin
  SpeedButton5.Visible:=true;
end;

procedure TFChat.SpeedButton3Click(Sender: TObject);
begin
  SpeedButton6.Visible:=true;
end;

end.

