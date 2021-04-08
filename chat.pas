unit Chat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, XMLPropStorage, Menus, HtmlView, uETilePanel, uETileImage, ueled,
  lNet, switches, HtmlGlobals, HTMLUn2, ExtMessage;

type

  { TFChat }

  TFChatOnVoidEvent = procedure of object;
  TFChatOnBoolEvent = procedure (aValue: boolean) of object;
  TFChatOnStrStrEvent = procedure (aStr1,aStr2: string) of object;
  TFChatOnSendMessageEvent = procedure(aKomenda: string; aValue: string) of object;
  TFChat = class(TForm)
    CheckBox1: TCheckBox;
    ColorButton1: TColorButton;
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
    FOnAddKontakt: TFChatOnStrStrEvent;
    FOnTrayIconMessage: TFChatOnBoolEvent;
    vZaloguj: boolean;
    isHide: boolean;
    niki,keye,niki_keye: TStringList;
    schat: TStringList;
    FOnExecDestroy: TFChatOnVoidEvent;
    FOnSendMessage: TFChatOnSendMessageEvent;
    FOnSendMessageNoKey: TFChatOnSendMessageEvent;
    procedure ChatInit(aStr: string = '');
    procedure ChatAdd(aKey,aOd,aDo,aFormatowanie,aTresc: String);
    procedure ChatRefresh;
    procedure SendMessage(aKomenda: string;  aValue: string = '');
    procedure SendMessageNoKey(aKomenda: string; aValue: string = '');
    procedure Send(aOd,aDo,aFormatowanie,aTresc: string);
    procedure TestMessageActive;
  public
    zablokowano: boolean;
    key,nick: string;
    key2,nick2: string;
    procedure blokuj;
    procedure odblokuj;
    procedure monReceiveString(aMsg,aKomenda: string; aSocket: TLSocket; aID: integer);
  published
    //property OnChatGetData: TFChatOnVoidEvent read FOnGetData write FOnGetData;
    property OnSendMessage: TFChatOnSendMessageEvent read FOnSendMessage write FOnSendMessage;
    property OnSendMessageNoKey: TFChatOnSendMessageEvent read FOnSendMessageNoKey write FOnSendMessageNoKey;
    property OnExecuteDestroy: TFChatOnVoidEvent read FOnExecDestroy write FOnExecDestroy;
    property OnTrayIconMessage: TFChatOnBoolEvent read FOnTrayIconMessage write FOnTrayIconMessage;
    property OnAddKontakt: TFChatOnStrStrEvent read FOnAddKontakt write FOnAddKontakt;
  end;

var
  FChat: TFChat;

implementation

uses
  ecode, lcltype, lclintf, RegExpr;

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
    mess.ShowInformation('Brak połączenia!','Połączenie z serwerem zostało przerwane.^Poczekaj na wznowienie połączenia.');
    exit;
  end;
  if SpeedButton4.Visible then s1:='1' else s1:='0';
  if SpeedButton5.Visible then s2:='1' else s2:='0';
  if SpeedButton6.Visible then s3:='1' else s3:='0';
  f:=IntToStr(ColorButton1.ButtonColor);
  s:=trim(Memo1.Lines.Text);
  s:=StringReplace(s,'$','{#S}',[rfReplaceAll]);
  s:=StringReplace(s,'"','{#C}',[rfReplaceAll]);
  s:=StringReplace(s,'<','{#1}',[rfReplaceAll]);
  s:=StringReplace(s,'>','{#2}',[rfReplaceAll]);
  Send(nick,'',s1+s2+s3+f,s);
  Memo1.Clear;
  Memo1.SetFocus;
end;

procedure TFChat.ChatInit(aStr: string);
begin
  if aStr='' then schat.Add('<p>Witaj Mistrzu!</p>') else schat.Add(aStr);
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
    if c=1 then ss:=ss+'<a href="'+s1+'">'+s1+'</a>' else ss:=ss+s1;
    if znak<>#0 then ss:=ss+znak;
  end;
  result:=ss;
end;

procedure TFChat.ChatAdd(aKey, aOd, aDo, aFormatowanie, aTresc: String);
var
  ja: string;
  s,s1,s2,s3: string;
  pom: integer;
begin
  //<font color=#ff0000><b>Samu</b></font>: <font color=#000000>aaa <a href="http://www.youtube.com/watch?v=2Aio_sh-Ia0,">http://www.youtube.com/watch?v=2Aio_sh-Ia0,</a> sss</font><br>
  if aKey=key then s1:='<span style="font-size: small; color: gray"><b>'+aOd+', '+FormatDateTime('hh:nn',now)+'</b></span><br>'
  else s1:='<span style="font-size: small; color: gray">'+aOd+', '+FormatDateTime('hh:nn',now)+'</span><br>';
  s:=StringReplace(aTresc,'{#S}','$',[rfReplaceAll]);
  s:=StringReplace(s,'{#C}','"',[rfReplaceAll]);
  s:=StringReplace(s,'{#1}','<',[rfReplaceAll]);
  s:=StringReplace(s,'{#2}','>',[rfReplaceAll]);
  s:=TextUrlsToLinks(s);
  s2:=StringReplace(s,#10,'<br>',[rfReplaceAll]);
  if aFormatowanie[1]='1' then s2:='<b>'+s2+'</b>';
  if aFormatowanie[2]='1' then s2:='<i>'+s2+'</i>';
  if aFormatowanie[3]='1' then s2:='<u>'+s2+'</u>';
  pom:=StrToInt(copy(aFormatowanie,4,maxint));
  s2:='<span style="color: '+SColorToHtmlColor(pom)+'">'+s2+'</span>';
  s:=s1+' '+s2;
  s:='<p>'+s+'</p>';
  schat.Add(s);
  if schat.Count>200 then schat.Delete(0);
  ChatRefresh;
end;

procedure TFChat.ChatRefresh;
begin
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

procedure TFChat.Send(aOd, aDo, aFormatowanie, aTresc: string);
var
  s: string;
begin
  s:=aOd+'$'+aDo+'$'+aFormatowanie+'$'+aTresc;
  SendMessage('{CHAT}',s);
end;

procedure TFChat.TestMessageActive;
begin
  if isHide then FOnTrayIconMessage(true);
end;

procedure TFChat.blokuj;
begin
  zablokowano:=true;
  uELED1.Active:=false;
end;

procedure TFChat.odblokuj;
begin
  zablokowano:=false;
  niki.Clear;
  keye.Clear;
  SendMessageNoKey('{SET_ACTIVE}','5$1$'+nick);
end;

procedure TFChat.monReceiveString(aMsg, aKomenda: string; aSocket: TLSocket;
  aID: integer);
var
  s1,s2,s3,s4,s5: string;
  a,b: integer;
begin
  //writeln(aMsg);
  if aKomenda='{CHAT_USER}' then
  begin
    uELED1.Active:=true;
    s1:=GetLineToStr(aMsg,2,'$',''); //nick
    s2:=GetLineToStr(aMsg,3,'$',''); //key
    niki.Add(s1);
    keye.Add(s2);
    niki_keye.Add(s1+#1+s2);
    ListBox1.Items.Assign(niki);
  end else
  if aKomenda='{CHAT}' then
  begin
    //writeln('Odebrałem: ',aMsg);
    s1:=GetLineToStr(aMsg,2,'$','');
    s2:=GetLineToStr(aMsg,3,'$','');
    s3:=GetLineToStr(aMsg,4,'$','');
    s4:=GetLineToStr(aMsg,5,'$','');
    s5:=GetLineToStr(aMsg,6,'$','');
    ChatAdd(s1,s2,s3,s4,s5);
    TestMessageActive;
  end else
  if aKomenda='{CHAT_LOGOUT}' then
  begin
    s1:=GetLineToStr(aMsg,2,'$',''); //key
    a:=StringToItemIndex(keye,s1);
    if a>-1 then
    begin
      b:=StringToItemIndex(niki_keye,niki[a]+#1+s1);
      niki.Delete(a);
      keye.Delete(a);
      ListBox1.Items.Assign(niki);
      niki_keye.Delete(b);
    end;
  end else
  if aKomenda='{CHAT_INIT}' then ChatInit(GetLineToStr(aMsg,2,'$',''));
end;

procedure TFChat.SpeedButton1Click(Sender: TObject);
begin
  SpeedButton4.Visible:=true;
end;

procedure TFChat.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caNone;
  if CheckBox1.Checked then hide else if assigned(FOnExecDestroy) then FOnExecDestroy;
end;

procedure TFChat.FormCreate(Sender: TObject);
begin
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  zablokowano:=false;
  niki:=TStringList.Create;
  keye:=TStringList.Create;
  niki_keye:=TStringList.Create;
  niki_keye.Sorted:=true;
  schat:=TStringList.Create;
  vZaloguj:=true;
  //ChatInit;
end;

procedure TFChat.FormDestroy(Sender: TObject);
begin
  keye.Free;
  niki.Free;
  niki_keye.Free;
  schat.Free;
  SendMessageNoKey('{SET_ACTIVE}','5$0');
end;

procedure TFChat.FormHide(Sender: TObject);
begin
  isHide:=true;
end;

procedure TFChat.FormShow(Sender: TObject);
begin
  isHide:=false;
  FOnTrayIconMessage(false);
  if vZaloguj then
  begin
    vZaloguj:=false;
    SendMessageNoKey('{SET_ACTIVE}','5$1$'+nick);
    SendMessageNoKey('{CHAT_INIT}');
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
  plik: string;
begin
  //writeln(SRC);
  //plik:=MyConfDir+_FF+SRC;
  //if not FileExists(plik) then exit;
  //simage.LoadFromFile(plik);
  //Stream:=simage;
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
  a: integer;
begin
  s:=niki_keye[ListBox1.ItemIndex];
  s1:=GetLineToStr(s,1,#1); //nazwa
  s2:=GetLineToStr(s,2,#1); //klucz
  if s2=key then mess.ShowInformation('Próbujesz dodać siebie do kontaktów?^To nie wyjdzie :)') else FOnAddKontakt(s2,s1);
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

