unit lista;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ZDataset;

type

  { TFLista }

  TFLista = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    roz: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    rozdzialy: TStrings;
  public
    in_tryb: integer;
    out_ok: boolean;
    s_link, s_tytul, s_file: string;
    i_roz: integer;
  end;

var
  FLista: TFLista;

implementation

uses
  ecode;

{$R *.lfm}

{ TFLista }

procedure TFLista.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFLista.BitBtn2Click(Sender: TObject);
begin
  s_link:=trim(Edit1.Text);
  s_tytul:=trim(Edit2.Text);
  s_file:=trim(Edit3.Text);
  i_roz:=StrToInt(rozdzialy[ComboBox1.ItemIndex]);
  if (s_tytul='') and ((s_link='') or (s_file='')) then exit;
  out_ok:=true;
  close;
end;

procedure TFLista.FormCreate(Sender: TObject);
begin
  rozdzialy:=TStringList.Create;
  ComboBox1.Clear;
  rozdzialy.Clear;
  roz.Open;
  while not roz.EOF do
  begin
    ComboBox1.Items.Add(roz.FieldByName('nazwa').AsString);
    rozdzialy.Add(roz.FieldByName('id').AsString);
    roz.Next;
  end;
  roz.Close;
end;

procedure TFLista.FormDestroy(Sender: TObject);
begin
  rozdzialy.Free;
end;

procedure TFLista.FormShow(Sender: TObject);
begin
  if in_tryb>0 then
  begin
    case in_tryb of
      1: begin
           Edit1.Text:='';
           Edit2.Text:='';
           Edit3.Text:='';
         end;
      2: begin
           Edit1.Text:=s_link;
           Edit2.Text:=s_tytul;
           Edit3.Text:=s_file;
         end;
    end;
    ComboBox1.ItemIndex:=StringToItemIndex(rozdzialy,IntToStr(i_roz));
    Edit1.SetFocus;
    in_tryb:=0;
  end;
end;

procedure TFLista.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit3.Text:=OpenDialog1.FileName;
end;

end.

