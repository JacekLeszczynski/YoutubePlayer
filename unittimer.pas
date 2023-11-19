unit UnitTimer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons, RxTimeEdit;

type

  { TFUnitTimer }

  TFUnitTimer = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    RxTimeEdit1: TRxTimeEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    io_ok: boolean;
    io_stan: integer;
    io_czas: TTime;
  end;

var
  FUnitTimer: TFUnitTimer;

implementation

{$R *.lfm}

{ TFUnitTimer }

procedure TFUnitTimer.FormCreate(Sender: TObject);
begin
  io_ok:=false;
end;

procedure TFUnitTimer.FormShow(Sender: TObject);
begin
  if ComboBox1.ItemIndex=-1 then
  begin
    ComboBox1.ItemIndex:=io_stan;
    RXTimeEdit1.Time:=io_czas;
  end;
end;

procedure TFUnitTimer.BitBtn2Click(Sender: TObject);
begin
  io_ok:=true;
  io_czas:=RXTimeEdit1.Time;
  io_stan:=ComboBox1.ItemIndex;
  close;
end;

procedure TFUnitTimer.BitBtn1Click(Sender: TObject);
begin
  close;
end;

end.

