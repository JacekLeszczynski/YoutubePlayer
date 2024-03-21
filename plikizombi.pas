unit PlikiZombi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, FileCtrl, TplProgressBarUnit, ZDataset;

type

  { TFPlikiZombi }

  TFPlikiZombi = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    db_dirdirectory: TStringField;
    dsDir: TDataSource;
    dsSzukaj: TDataSource;
    FileListBox1: TFileListBox;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    db_szukaj: TZReadOnlyQuery;
    db_szukajile: TLargeintField;
    db_dir: TZReadOnlyQuery;
    pp: TplProgressBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    procedure FindDirectoryNow(aDir: string);
  public

  end;

var
  FPlikiZombi: TFPlikiZombi;

implementation

uses
  ecode, serwis;

{$R *.lfm}

{ TFPlikiZombi }

procedure TFPlikiZombi.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFPlikiZombi.FindDirectoryNow(aDir: string);
var
  i,a: integer;
  s: string;
begin
  FileListBox1.Directory:=aDir;
  for i:=0 to FileListBox1.Count-1 do
  begin
    s:=aDir+_FF+FileListBox1.Items[i];
    s:=StringReplace(s,_FF+_FF,_FF,[rfReplaceAll]);
    db_szukaj.ParamByName('dir').AsString:=aDir;
    db_szukaj.ParamByName('plik').AsString:=ExtractFilename(s);
    db_szukaj.ParamByName('sciezka').AsString:=s;
    db_szukaj.Open;
    a:=db_szukajile.AsInteger;
    db_szukaj.Close;
    if a=0 then ListBox1.Items.Add(s);
    pp.StepIt;
    pp.Refresh;
  end;
end;

procedure TFPlikiZombi.BitBtn3Click(Sender: TObject);
begin
  close;
end;

procedure TFPlikiZombi.BitBtn1Click(Sender: TObject);
var
  a: integer;
begin
  //Domyślny katalog: _DEF_MULTIMEDIA_SAVE_DIR
  FindDirectoryNow(_DEF_MULTIMEDIA_SAVE_DIR);
  //Katalogi zdefiniowane w rozdziałach
  db_dir.Open;
  a:=db_dir.RecordCount;
  while not db_dir.EOF do
  begin
    FileListBox1.Directory:=db_dirdirectory.AsString;
    a:=a+FileListBox1.Count;
    db_dir.Next;
  end;
  pp.Max:=a;
  pp.Position:=0;
  db_dir.First;
  while not db_dir.EOF do
  begin
    FindDirectoryNow(db_dirdirectory.AsString);
    db_dir.Next;
    pp.StepIt;
    pp.Refresh;
  end;
  db_dir.Close;
end;

procedure TFPlikiZombi.BitBtn2Click(Sender: TObject);
var
  i: integer;
begin
  for i:=ListBox1.Count-1 downto 0 do
    if DeleteFile(ListBox1.Items[i]) then ListBox1.Items.Delete(i);
  pp.Position:=0;
end;

end.

