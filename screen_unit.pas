unit screen_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFScreen }

  TFScreen = class(TForm)
    Label20: TLabel;
    Label22: TLabel;
    Panel2: TPanel;
    t20: TTimer;
    procedure t20Timer(Sender: TObject);
  private
  public
    procedure MemReset;
    procedure tytul_fragmentu(aText: string = '');
    procedure tytul_fragmentu(OnOff: boolean);
    function info_play(aText: string = ''): boolean;
  end;

var
  FScreen: TFScreen;

implementation

{$R *.lfm}

{ TFScreen }

procedure TFScreen.t20Timer(Sender: TObject);
begin
  Label20.Left:=Label20.Left-1;
  if Label20.Left<(0-Label20.Width-50) then info_play;
end;

procedure TFScreen.MemReset;
begin
  Panel2.Visible:=false;
  Label22.Visible:=false;
end;

procedure TFScreen.tytul_fragmentu(aText: string);
var
  s: string;
begin
  Label22.Visible:=false;
  s:=trim(aText);
  s:=StringReplace(s,' ^ ',#13#10,[rfReplaceAll]);
  s:=StringReplace(s,'^ ',#13#10,[rfReplaceAll]);
  s:=StringReplace(s,' ^ ',#13#10,[rfReplaceAll]);
  s:=StringReplace(s,'^',#13#10,[rfReplaceAll]);
  Label22.Caption:=s;
end;

procedure TFScreen.tytul_fragmentu(OnOff: boolean);
begin
  if OnOff then info_play;
  Label22.Visible:=OnOff and (Label22.Caption<>'');
  application.ProcessMessages;
end;

function TFScreen.info_play(aText: string): boolean;
begin
  Label20.Caption:=aText;
  if (aText='') or Label22.Visible then
  begin
    t20.Enabled:=false;
    Panel2.Visible:=false;
    result:=false;
  end else begin
    Label20.Left:=FScreen.Width+50;
    Panel2.Visible:=true;
    t20.Enabled:=true;
    result:=true;
  end;
end;

end.

