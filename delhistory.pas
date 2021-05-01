unit DelHistory;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TFDelHistory }

  TFDelHistory = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
    io_ok: boolean;
    io_id: integer;
  end;

var
  FDelHistory: TFDelHistory;

implementation

uses
  lcltype;

{$R *.lfm}

{ TFDelHistory }

procedure TFDelHistory.BitBtn2Click(Sender: TObject);
begin
  io_ok:=true;
  if RadioButton1.Checked then io_id:=1 else
  if RadioButton2.Checked then io_id:=2 else
  if RadioButton3.Checked then io_id:=3 else
  if RadioButton4.Checked then io_id:=4;
  close;
end;

procedure TFDelHistory.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then BitBtn1.Click;
end;

procedure TFDelHistory.BitBtn1Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

end.

