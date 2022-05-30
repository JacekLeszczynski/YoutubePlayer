unit conf_ogg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TFConfOGG }

  TFConfOGG = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
  public
    in_file: string;
    out_ok: boolean;
    out_quality,out_channels: integer;
    procedure init;
  end;

var
  FConfOGG: TFConfOGG;

implementation

{$R *.lfm}

{ TFConfOGG }

procedure TFConfOGG.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFConfOGG.BitBtn2Click(Sender: TObject);
begin
  out_quality:=RadioGroup1.ItemIndex-1;
  case RadioGroup2.ItemIndex of
    0: out_channels:=0;
    1: out_channels:=2;
    2: out_channels:=1;
  end;
  out_ok:=true;
  close;
end;

procedure TFConfOGG.init;
begin
  Label2.Caption:=in_file;
end;

end.

