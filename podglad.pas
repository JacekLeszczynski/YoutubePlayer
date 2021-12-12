unit podglad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  DBGridPlus, uETilePanel, Grids, StdCtrls, TplProgressBarUnit;

type

  { TFPodglad }

  TFPodglad = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    oo: TplProgressBar;
    Panel10: TuETilePanel;
    pp: TplProgressBar;
    Splitter1: TSplitter;
    uETilePanel1: TuETilePanel;
    uETilePanel3: TuETilePanel;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private

  public

  end;

var
  FPodglad: TFPodglad;

implementation

uses
  main, ecode;

{$R *.lfm}

{ TFPodglad }

procedure TFPodglad.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  b: boolean;
begin
  DBGrid1.Canvas.Font.Bold:=false;
  b:=Form1.filmyc_plik_exist.AsBoolean;
  if b then DBGrid1.Canvas.Font.Color:=clBlue else DBGrid1.Canvas.Font.Color:=TColor($333333);
  if Form1.GetPrivateIndexPlay=Form1.filmyid.AsInteger then
  begin
    DBGrid1.Canvas.Font.Bold:=true;
    if b then
      DBGrid1.Canvas.Font.Color:=TColor($0E0044)
    else
      DBGrid1.Canvas.Font.Color:=clBlack;
  end;
  DBGrid1.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFPodglad.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  a: integer;
  b,c: boolean;
begin
  a:=Form1.czasystatus.AsInteger;
  b:=ecode.GetBit(a,0);
  c:=ecode.GetBit(a,1);
  DBGrid2.Canvas.Font.Bold:=false;

  if b then DBGrid2.Canvas.Font.Color:=clRed else
  //if c then DBGrid2.Canvas.Font.Color:=clGray else
  DBGrid2.Canvas.Font.Color:=TColor($333333);

  if Form1.GetPrivateIndexCzas=Form1.czasy.FieldByName('id').AsInteger then
  begin
    DBGrid2.Canvas.Font.Bold:=true;
    if b then DBGrid2.Canvas.Font.Color:=clGray
         else DBGrid2.Canvas.Font.Color:=clBlack;
  end;
  DBGrid2.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

end.

