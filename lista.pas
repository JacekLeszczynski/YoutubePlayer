unit lista;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, Menus, ZDataset, uEKnob;

type

  { TFLista }

  TFLista = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    timer_exit: TIdleTimer;
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
    uEKnob1: TuEKnob;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure timer_exitTimer(Sender: TObject);
  private
    rozdzialy: TStrings;
  public
    in_tryb: integer;
    out_ok: boolean;
    s_link, s_tytul, s_file: string;
    i_roz: integer;
    in_out_wzmocnienie,in_out_glosnosc: integer;
  end;

var
  FLista: TFLista;

implementation

uses
  ecode, serwis;

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
  case ComboBox2.ItemIndex of
    0: in_out_wzmocnienie:=-1;
    1: in_out_wzmocnienie:=1;
    2: in_out_wzmocnienie:=0;
  end;
  if ComboBox2.ItemIndex=1 then in_out_glosnosc:=Round(uEKnob1.Position) else in_out_glosnosc:=-1;
  if (s_link<>'') and (s_tytul='') then
  begin
    BitBtn3.Click;
    timer_exit.Enabled:=true;
  end;
  if (s_tytul='') and ((s_link='') or (s_file='')) then exit;
  out_ok:=true;
  close;
end;

procedure TFLista.BitBtn3Click(Sender: TObject);
begin
  if trim(Edit1.Text)='' then exit;
  Edit2.Text:=dm.GetTitleForYoutube(Edit1.Text);
end;

procedure TFLista.ComboBox2Change(Sender: TObject);
begin
  uEKnob1.Enabled:=ComboBox2.ItemIndex=1;
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
           ComboBox2.ItemIndex:=0;
           uEKnob1.Position:=100;
           uEKnob1.Enabled:=false;
         end;
      2: begin
           Edit1.Text:=s_link;
           Edit2.Text:=s_tytul;
           Edit3.Text:=s_file;
           case in_out_wzmocnienie of
             -1: ComboBox2.ItemIndex:=0;
             0: ComboBox2.ItemIndex:=2;
             1: ComboBox2.ItemIndex:=1;
           end;
           uEKnob1.Enabled:=in_out_wzmocnienie=1;
           if in_out_glosnosc=-1 then uEKnob1.Position:=100 else uEKnob1.Position:=in_out_glosnosc;
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

procedure TFLista.timer_exitTimer(Sender: TObject);
begin
  timer_exit.Enabled:=false;
  BitBtn2.Click;
end;

end.

