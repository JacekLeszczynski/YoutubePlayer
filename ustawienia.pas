unit ustawienia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  StdCtrls, Spin, ColorBox, uETilePanel, IniFiles;

type

  { TFUstawienia }

  TFUstawieniaOnIntEvent = procedure (aValue: integer) of object;
  TFUstawieniaOnSetChatEvent = procedure (aFont, aFont2: string; aSize, aSize2, aColor: integer) of object;
  TFUstawienia = class(TForm)
    BitBtn1: TBitBtn;
    ColorBox1: TColorBox;
    ComboBox1: TComboBox;
    ImageList1: TImageList;
    Label27: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListFonts: TComboBox;
    ListFonts1: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    TabSheet2: TTabSheet;
    TestBeep: TSpeedButton;
    uCloseToTray: TCheckBox;
    uETilePanel5: TuETilePanel;
    uStartInMinimize: TCheckBox;
    uSystemSound: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    uETilePanel1: TuETilePanel;
    uETilePanel2: TuETilePanel;
    uETilePanel3: TuETilePanel;
    uETilePanel4: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListFonts1Change(Sender: TObject);
    procedure ListFontsChange(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure TestBeepClick(Sender: TObject);
    procedure uCloseToTrayChange(Sender: TObject);
    procedure uStartInMinimizeChange(Sender: TObject);
    procedure uSystemSoundChange(Sender: TObject);
  private
    FOnGoBeep: TFUstawieniaOnIntEvent;
    FOnSetChat: TFUstawieniaOnSetChatEvent;
  public
  published
    property OnGoBeep: TFUstawieniaOnIntEvent read FOnGoBeep write FOnGoBeep;
    property OnSetChat: TFUstawieniaOnSetChatEvent read FOnSetChat write FOnSetChat;
  end;

var
  FUstawienia: TFUstawienia;
  ustawienia_run: boolean = false;

var
  ini: TIniFile;
  LIBUOS: boolean = false;

procedure IniOpen(aConfFile: string);
procedure IniClose;
procedure IniWriteInteger(aSekcja,aIdent: string; aValue: integer);
function IniReadInteger(aSekcja,aIdent: string; aDefault: integer): integer;
procedure IniWriteString(aSekcja,aIdent: string; aValue: string);
function IniReadString(aSekcja,aIdent: string; aDefault: string): string;
procedure IniWriteBool(aSekcja,aIdent: string; aValue: boolean);
function IniReadBool(aSekcja,aIdent: string; aDefault: boolean): boolean;

implementation

uses
  ecode;

procedure IniOpen(aConfFile: string);
begin
  ini:=TIniFile.Create(aConfFile);
end;

procedure IniClose;
begin
  ini.Free;
end;

procedure IniWriteInteger(aSekcja, aIdent: string; aValue: integer);
begin
  ini.WriteInteger(aSekcja,aIdent,aValue);
end;

function IniReadInteger(aSekcja, aIdent: string; aDefault: integer): integer;
begin
  result:=ini.ReadInteger(aSekcja,aIdent,aDefault);
end;

procedure IniWriteString(aSekcja, aIdent: string; aValue: string);
begin
  ini.WriteString(aSekcja,aIdent,aValue);
end;

function IniReadString(aSekcja, aIdent: string; aDefault: string): string;
begin
  result:=ini.ReadString(aSekcja,aIdent,aDefault);
end;

procedure IniWriteBool(aSekcja, aIdent: string; aValue: boolean);
begin
  ini.WriteBool(aSekcja,aIdent,aValue);
end;

function IniReadBool(aSekcja, aIdent: string; aDefault: boolean): boolean;
begin
  result:=ini.ReadBool(aSekcja,aIdent,aDefault);
end;

{$R *.lfm}

{ TFUstawienia }

procedure TFUstawienia.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFUstawienia.ColorBox1Change(Sender: TObject);
begin
  IniWriteInteger('Chat','BackgroundColor',ColorBox1.Selected);
  if assigned(FOnSetChat) then FOnSetChat(ListFonts.Text,ListFonts1.Text,SpinEdit1.Value,SpinEdit2.Value,ColorBox1.Selected);
end;

procedure TFUstawienia.ComboBox1Change(Sender: TObject);
begin
  IniWriteInteger('Audio','DefaultBeep',ComboBox1.ItemIndex);
end;

procedure TFUstawienia.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=caFree;
end;

procedure TFUstawienia.FormCreate(Sender: TObject);
begin
  (* ogólne *)
  ListFonts.Items:=Screen.Fonts;
  ListFonts1.Items:=Screen.Fonts;
  ListFonts.ItemIndex:=StringToItemIndex(ListFonts.Items,'Sans');
  ListFonts1.ItemIndex:=ListFonts.ItemIndex;
  uCloseToTray.Checked:=IniReadBool('Flags','CloseToTray',false);
  uStartInMinimize.Checked:=IniReadBool('Flags','StartMinimize',false);
  uSystemSound.ItemIndex:=IniReadInteger('Audio','SystemSound',0);
  (* chat *)
  {$IFDEF UNIX}
  ListFonts.Text:=IniReadString('Chat','Font','Sans');
  ListFonts1.Text:=IniReadString('Chat','Font2','Sans');
  {$ELSE}
  ListFonts.Text:=IniReadString('Chat','Font','Arial');
  ListFonts1.Text:=IniReadString('Chat','Font2','Arial');
  {$ENDIF}
  SpinEdit1.Value:=IniReadInteger('Chat','FontSize',12);
  SpinEdit2.Value:=IniReadInteger('Chat','FontSize2',12);
  ColorBox1.Selected:=IniReadInteger('Chat','BackgroundColor',clWhite);
  ComboBox1.ItemIndex:=IniReadInteger('Audio','DefaultBeep',0);
end;

procedure TFUstawienia.FormDestroy(Sender: TObject);
begin
  ustawienia_run:=false;
end;

procedure TFUstawienia.ListFonts1Change(Sender: TObject);
begin
  IniWriteString('Chat','Font2',ListFonts1.Text);
  if assigned(FOnSetChat) then FOnSetChat(ListFonts.Text,ListFonts1.Text,SpinEdit1.Value,SpinEdit2.Value,ColorBox1.Selected);
end;

procedure TFUstawienia.ListFontsChange(Sender: TObject);
begin
  IniWriteString('Chat','Font',ListFonts.Text);
  if assigned(FOnSetChat) then FOnSetChat(ListFonts.Text,ListFonts1.Text,SpinEdit1.Value,SpinEdit2.Value,ColorBox1.Selected);
end;

procedure TFUstawienia.SpinEdit1Change(Sender: TObject);
begin
  IniWriteInteger('Chat','FontSize',SpinEdit1.Value);
  if assigned(FOnSetChat) then FOnSetChat(ListFonts.Text,ListFonts1.Text,SpinEdit1.Value,SpinEdit2.Value,ColorBox1.Selected);
end;

procedure TFUstawienia.SpinEdit2Change(Sender: TObject);
begin
  IniWriteInteger('Chat','FontSize2',SpinEdit2.Value);
  if assigned(FOnSetChat) then FOnSetChat(ListFonts.Text,ListFonts1.Text,SpinEdit1.Value,SpinEdit2.Value,ColorBox1.Selected);
end;

procedure TFUstawienia.TestBeepClick(Sender: TObject);
begin
  FOnGoBeep(ComboBox1.ItemIndex);
end;

procedure TFUstawienia.uCloseToTrayChange(Sender: TObject);
var
  b: boolean;
begin
  b:=uCloseToTray.Checked;
  IniWriteBool('Flags','CloseToTray',b);
  uStartInMinimize.Enabled:=b;
end;

procedure TFUstawienia.uStartInMinimizeChange(Sender: TObject);
begin
  IniWriteBool('Flags','StartMinimize',uStartInMinimize.Checked);
end;

procedure TFUstawienia.uSystemSoundChange(Sender: TObject);
begin
  IniWriteInteger('Audio','SystemSound',uSystemSound.ItemIndex);
end;

end.

