unit czas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons, RxTimeEdit;

type

  { TFCzas }

  TFCzas = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TimeEdit1: TRxTimeEdit;
    TimeEdit2: TRxTimeEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimeEdit2Change(Sender: TObject);
  private
  public
    in_tryb: integer;
    out_ok: boolean;
    s_nazwa: string;
    i_od,i_do: longword;
  end;

var
  FCzas: TFCzas;

implementation

uses
  ecode;

{$R *.lfm}

{ TFCzas }

procedure TFCzas.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFCzas.BitBtn2Click(Sender: TObject);
begin
  s_nazwa:=trim(Edit1.Text);
  i_od:=TimeToInteger(TimeEdit1.Time);
  if CheckBox2.Checked then i_do:=TimeToInteger(TimeEdit2.Time) else i_do:=0;
  if s_nazwa='' then exit;
  out_ok:=true;
  close;
end;

procedure TFCzas.FormShow(Sender: TObject);
begin
  if in_tryb>0 then
  begin
    case in_tryb of
      1: begin
           Edit1.Text:='..';
           if i_od=0 then TimeEdit1.Time:=0
           else TimeEdit1.Time:=IntegerToTime(i_od);
           TimeEdit2.Time:=0;
           CheckBox2.Checked:=false;
         end;
      2: begin
           Edit1.Text:=s_nazwa;
           TimeEdit1.Time:=IntegerToTime(i_od);
           if i_do=0 then
           begin
             TimeEdit2.Time:=0;
             CheckBox2.Checked:=false;
           end else begin
             TimeEdit2.Time:=IntegerToTime(i_do);
             CheckBox2.Checked:=true;
           end;
         end;
    end;
    Edit1.SetFocus;
    Edit1.SelectAll;
    in_tryb:=0;
  end;
end;

procedure TFCzas.TimeEdit2Change(Sender: TObject);
begin
  if TimeEdit2.Time>0 then CheckBox2.Checked:=true;
end;

end.

