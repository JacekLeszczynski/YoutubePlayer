unit rozdzial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

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
    Label1: TLabel;
    lNazwa: TLabel;
    cNazwa: TEdit;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure odczyt;
    procedure zapis;
  public
    io_nazwa: string;
    io_sort,io_autosort,io_nomem,io_noarchive,io_novideo,io_normalize_audio: boolean;
    io_zmiany: boolean;
  end;

var
  FRozdzial: TFRozdzial;

implementation

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
  CheckBox1.Checked:=io_sort;
  CheckBox2.Checked:=io_autosort;
  CheckBox3.Checked:=io_nomem;
  CheckBox4.Checked:=io_noarchive;
  CheckBox5.Checked:=io_novideo;
  CheckBox6.Checked:=io_normalize_audio;
end;

procedure TFRozdzial.zapis;
begin
  io_zmiany:=true;
  io_nazwa:=cNazwa.Text;
  io_sort:=CheckBox1.Checked;
  io_autosort:=CheckBox2.Checked;
  io_nomem:=CheckBox3.Checked;
  io_noarchive:=CheckBox4.Checked;
  io_novideo:=CheckBox5.Checked;
  io_normalize_audio:=CheckBox6.Checked;
end;

end.

