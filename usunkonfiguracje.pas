unit UsunKonfiguracje;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TFUsunKonfiguracje }

  TFUsunKonfiguracje = class(TForm)
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private

  public
    io_usun: boolean;
  end;

var
  FUsunKonfiguracje: TFUsunKonfiguracje;

implementation

{$R *.lfm}

{ TFUsunKonfiguracje }

procedure TFUsunKonfiguracje.CheckBox1Change(Sender: TObject);
begin
  io_usun:=CheckBox1.Checked;
end;

procedure TFUsunKonfiguracje.BitBtn1Click(Sender: TObject);
begin
  close;
end;

end.

