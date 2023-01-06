unit rozdzial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, EditBtn;

type

  { TFRozdzial }

  TFRozdzial = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lNazwa: TLabel;
    cNazwa: TEdit;
    lNazwa1: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure odczyt;
    procedure zapis;
  public
    io_nazwa,io_dir: string;
    io_sort,io_autosort,io_nomem,io_noarchive,io_novideo,io_normalize_audio,io_chroniony: boolean;
    io_zmiany: boolean;
    io_format: integer;
  end;

var
  FRozdzial: TFRozdzial;

implementation

uses
  ecode, serwis;

{$R *.lfm}

{ TFRozdzial }

procedure TFRozdzial.FormShow(Sender: TObject);
begin
  odczyt;
end;

procedure TFRozdzial.BitBtn3Click(Sender: TObject);
begin
  odczyt;
end;

procedure TFRozdzial.FormCreate(Sender: TObject);
var
  i: integer;
begin
  ComboBox1.Clear;
  ComboBox1.Items.BeginUpdate;
  for i:=0 to _genre-1 do ComboBox1.Items.Add(_genre2[i]);
  ComboBox1.Items.EndUpdate;
  ComboBox1.ItemIndex:=StringToItemIndex(ComboBox1.Items,'None');
end;

procedure TFRozdzial.BitBtn2Click(Sender: TObject);
begin
  if trim(cNazwa.Text)='' then exit;
  zapis;
  close;
end;

procedure TFRozdzial.BitBtn1Click(Sender: TObject);
begin
  io_zmiany:=false;
  close;
end;

procedure TFRozdzial.odczyt;
begin
  io_zmiany:=false;
  cNazwa.Text:=io_nazwa;
  DirectoryEdit1.Directory:=io_dir;
  CheckBox1.Checked:=io_sort;
  CheckBox2.Checked:=io_autosort;
  CheckBox3.Checked:=io_nomem;
  CheckBox4.Checked:=io_noarchive;
  CheckBox5.Checked:=io_novideo;
  CheckBox6.Checked:=io_normalize_audio;
  CombOBox2.ItemIndex:=io_format;
  CheckBox7.Checked:=io_chroniony;
end;

procedure TFRozdzial.zapis;
begin
  io_zmiany:=true;
  io_nazwa:=cNazwa.Text;
  io_dir:=DirectoryEdit1.Directory;
  io_sort:=CheckBox1.Checked;
  io_autosort:=CheckBox2.Checked;
  io_nomem:=CheckBox3.Checked;
  io_noarchive:=CheckBox4.Checked;
  io_novideo:=CheckBox5.Checked;
  io_normalize_audio:=CheckBox6.Checked;
  io_format:=CombOBox2.ItemIndex;
  io_chroniony:=CheckBox7.Checked;
end;

end.

