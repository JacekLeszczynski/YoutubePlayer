unit podglad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  DBGridPlus, uETilePanel, Grids, StdCtrls, Buttons, XMLPropStorage,
  TplProgressBarUnit;

type

  { TFPodglad }

  TFPodglad = class(TForm)
    DBGrid1: TDBGridPlus;
    DBGrid2: TDBGridPlus;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memory_1: TSpeedButton;
    Memory_2: TSpeedButton;
    Memory_3: TSpeedButton;
    Memory_4: TSpeedButton;
    oo: TplProgressBar;
    Panel10: TuETilePanel;
    pp: TplProgressBar;
    propstorage: TXMLPropStorage;
    Splitter1: TSplitter;
    uETilePanel1: TuETilePanel;
    uETilePanel3: TuETilePanel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Memory_1Click(Sender: TObject);
    procedure Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_2Click(Sender: TObject);
    procedure Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_3Click(Sender: TObject);
    procedure Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_4Click(Sender: TObject);
    procedure Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ooMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
  b,b2: boolean;
begin
  DBGrid1.Canvas.Font.Bold:=false;
  b:=Form1.filmyc_plik_exist.AsBoolean;
  if b then
  begin
    b2:=ExtractFileExt(Form1.filmyplik.AsString)='.ogg';
    if b2 then DBGrid1.Canvas.Font.Color:=clGreen else DBGrid1.Canvas.Font.Color:=clBlue;
  end else DBGrid1.Canvas.Font.Color:=TColor($333333);
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

procedure TFPodglad.DBGrid1DblClick(Sender: TObject);
begin
  Form1.DBGrid1DblClick(Sender);
end;

procedure TFPodglad.DBGrid2DblClick(Sender: TObject);
begin
  Form1.DBGrid2DblClick(Sender);
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

procedure TFPodglad.FormCreate(Sender: TObject);
begin
  propstorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  propstorage.Active:=true;
end;

procedure TFPodglad.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.FormKeyDown(self,Key,Shift);
end;

procedure TFPodglad.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  Form1.FormKeyUp(self,Key,Shift);
end;

procedure TFPodglad.FormShow(Sender: TObject);
begin
  Memory_1.ImageIndex:=Form1.Memory_1.ImageIndex;
  Memory_2.ImageIndex:=Form1.Memory_2.ImageIndex;
  Memory_3.ImageIndex:=Form1.Memory_3.ImageIndex;
  Memory_4.ImageIndex:=Form1.Memory_4.ImageIndex;
end;

procedure TFPodglad.Memory_1Click(Sender: TObject);
begin
  Form1.Memory_1.Click;
end;

procedure TFPodglad.Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_1MouseDown(self,Button,Shift,X,Y);
end;

procedure TFPodglad.Memory_2Click(Sender: TObject);
begin
  Form1.Memory_2.Click;
end;

procedure TFPodglad.Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_2MouseDown(self,Button,Shift,X,Y);
end;

procedure TFPodglad.Memory_3Click(Sender: TObject);
begin
  Form1.Memory_3.Click;
end;

procedure TFPodglad.Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_3MouseDown(self,Button,Shift,X,Y);
end;

procedure TFPodglad.Memory_4Click(Sender: TObject);
begin
  Form1.Memory_4.Click;
end;

procedure TFPodglad.Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_4MouseDown(self,Button,Shift,X,Y);
end;

procedure TFPodglad.ooMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  c_akt,c_nast: integer;
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if Form1.GetPrivateVvObrazy then exit;
  if Form1.mplayer.Running and (Label5.Caption<>'-:--') then
  begin
    c_akt:=Form1.GetPrivateCzasAktualny;
    c_nast:=Form1.GetPrivateCzasNastepny;
    Form1.SetPrivatePStatusIgnore(true);
    if c_nast=-1 then max:=MiliSecToInteger(round(Form1.mplayer.Duration*1000))-c_akt
    else max:=c_nast-c_akt;
    a:=round(max*X/oo.Width)+c_akt;
    czas:=IntegerToTime(a)*SecsPerDay;
    Form1.mplayer.Position:=czas;
  end;
end;

procedure TFPodglad.ppMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if Form1.GetPrivateVvObrazy then exit;
  if Form1.mplayer.Running then
  begin
    Form1.SetPrivatePStatusIgnore(true);
    max:=Form1.mplayer.Duration;
    czas:=round(max*X/pp.Width);
    Form1.mplayer.Position:=czas;
    pp.Position:=MiliSecToInteger(round(czas*1000));
    aa:=czas/SecsPerDay;
    a:=TimeToInteger(aa);
    bPos:=a<3600000;
    if bPos then Label3.Caption:=FormatDateTime('nn:ss',aa) else Label3.Caption:=FormatDateTime('h:nn:ss',aa);
    //test_force:=true;
  end;
end;

end.

