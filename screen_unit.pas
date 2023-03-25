unit screen_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFScreen }

  TFScreen = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    t20: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure t20Timer(Sender: TObject);
  private
    _PYTANIE: boolean;
  public
    procedure MemReset;
    procedure tytul_fragmentu(aText: string = '');
    procedure tytul_fragmentu(OnOff: boolean);
    function info_play(aText: string = ''): boolean;
    procedure SetPytanieInScreen(aText: string = '');
    procedure SetPytanieInScreen(aPokaz: boolean);
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

procedure TFScreen.FormCreate(Sender: TObject);
begin
  _PYTANIE:=false;
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
  if t20.Enabled then
  begin
    if OnOff then Panel2.Visible:=false else Panel2.Visible:=t20.Enabled;
  end;
  Label22.Visible:=OnOff and (Label22.Caption<>'');
  Label1.Visible:=OnOff and _PYTANIE;
  Label2.Visible:=OnOff and _PYTANIE;
  Label3.Visible:=OnOff and _PYTANIE;
  Label4.Visible:=OnOff and _PYTANIE;
  Label5.Visible:=OnOff and _PYTANIE;
  application.ProcessMessages;
end;

function TFScreen.info_play(aText: string): boolean;
var
  s: string;
begin
  s:=trim(aText);
  if ((Label20.Caption<>s) and (s<>'')) or ((Label20.Caption<>'') and (s='')) then Label20.Caption:=s;
  if (s='') or Label22.Visible then
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

procedure TFScreen.SetPytanieInScreen(aText: string);
var
  s: string;
begin
  Label1.Visible:=false;
  s:=trim(aText);
  _PYTANIE:=s<>'';
  Label1.Caption:=s;
  Label2.Caption:=s;
  Label3.Caption:=s;
  Label4.Caption:=s;
  Label5.Caption:=s;
  Label1.Visible:=_PYTANIE;
  Label2.Visible:=_PYTANIE;
  Label3.Visible:=_PYTANIE;
  Label4.Visible:=_PYTANIE;
  Label5.Visible:=_PYTANIE;
end;

procedure TFScreen.SetPytanieInScreen(aPokaz: boolean);
begin
  Label1.Visible:=aPOkaz and _PYTANIE;
  Label2.Visible:=aPOkaz and _PYTANIE;
  Label3.Visible:=aPOkaz and _PYTANIE;
  Label4.Visible:=aPOkaz and _PYTANIE;
  Label5.Visible:=aPOkaz and _PYTANIE;
end;

end.

