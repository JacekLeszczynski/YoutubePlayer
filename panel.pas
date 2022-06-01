unit panel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ComCtrls,
  StdCtrls, ExtCtrls, XMLPropStorage, TplProgressBarUnit, uETilePanel, ueled,
  uEKnob;

type

  { TFPanel }

  TFPanel = class(TForm)
    BExit: TSpeedButton;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Memory_1: TSpeedButton;
    Memory_2: TSpeedButton;
    Memory_3: TSpeedButton;
    Memory_4: TSpeedButton;
    oo: TplProgressBar;
    Panel10: TuETilePanel;
    Panel11: TuETilePanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    Play: TSpeedButton;
    PlayCB: TSpeedButton;
    PlayRec: TSpeedButton;
    podpowiedz: TLabel;
    podpowiedz2: TLabel;
    pp: TplProgressBar;
    ProgressBar1: TProgressBar;
    Rewind: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Stop: TSpeedButton;
    autorun: TTimer;
    timer_monitor: TTimer;
    uEKnob1: TuEKnob;
    uELED3: TuELED;
    uELED4: TuELED;
    propstorage: TXMLPropStorage;
    procedure autorunTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure PlayCBClick(Sender: TObject);
    procedure PlayCBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayClick(Sender: TObject);
    procedure PlayRecClick(Sender: TObject);
    procedure ppMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RewindClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure timer_monitorTimer(Sender: TObject);
    procedure uEKnob1Change(Sender: TObject);
    procedure uEKnob1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  FPanel: TFPanel;

implementation

uses
  ecode,serwis,main;

{$R *.lfm}

{ TFPanel }

procedure TFPanel.FormDestroy(Sender: TObject);
begin
  _DEF_PANEL:=false;
end;

procedure TFPanel.Memory_1Click(Sender: TObject);
begin
  Form1.Memory_1.Click;
end;

procedure TFPanel.Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_1MouseDown(Sender,Button,Shift,X,Y);
end;

procedure TFPanel.Memory_2Click(Sender: TObject);
begin
  Form1.Memory_2.Click;
end;

procedure TFPanel.Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_2MouseDown(Sender,Button,Shift,X,Y);
end;

procedure TFPanel.Memory_3Click(Sender: TObject);
begin
  Form1.Memory_3.Click;
end;

procedure TFPanel.Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_3MouseDown(Sender,Button,Shift,X,Y);
end;

procedure TFPanel.Memory_4Click(Sender: TObject);
begin
  Form1.Memory_4.Click;
end;

procedure TFPanel.Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.Memory_4MouseDown(Sender,Button,Shift,X,Y);
end;

procedure TFPanel.ooMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TFPanel.PlayCBClick(Sender: TObject);
begin
  Form1.PlayCB.Click;
end;

procedure TFPanel.PlayCBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.PlayCBMouseDown(self,Button,Shift,X,Y);
end;

procedure TFPanel.PlayClick(Sender: TObject);
begin
  Form1.Play.Click;
end;

procedure TFPanel.PlayRecClick(Sender: TObject);
begin
  Form1.MenuItem93.Click;
end;

procedure TFPanel.ppMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TFPanel.RewindClick(Sender: TObject);
begin
  Form1.Rewind.Click;
end;

procedure TFPanel.SpeedButton1Click(Sender: TObject);
begin
  Form1.MenuItem93.Click;
end;

procedure TFPanel.SpeedButton2Click(Sender: TObject);
begin
  Form1.MenuItem77.Click;
end;

procedure TFPanel.SpeedButton3Click(Sender: TObject);
begin
  Form1.go_fullscreen;
end;

procedure TFPanel.StopClick(Sender: TObject);
begin
  Form1.Stop.Click;
end;

procedure TFPanel.timer_monitorTimer(Sender: TObject);
begin
  if screen.ActiveForm.Name<>'FPanel' then
  begin
    timer_monitor.Enabled:=false;
    close;
  end;
end;

procedure TFPanel.uEKnob1Change(Sender: TObject);
begin
  Form1.uEKnob1.Position:=uEKnob1.Position;
  Form1.uEKnob1Change(Sender);
end;

procedure TFPanel.uEKnob1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then uEKnob1.Position:=100;
  Form1.uEKnob1.Position:=uEKnob1.Position;
  Form1.uEKnob1Change(Sender);
end;

procedure TFPanel.FormCreate(Sender: TObject);
begin
  _DEF_PANEL:=true;
  PropStorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  PropStorage.Active:=true;
  uEKnob1.Position:=Form1.uEKnob1.Position;
  Play.ImageIndex:=Form1.Play.ImageIndex;
  Memory_1.ImageIndex:=Form1.Memory_1.ImageIndex;
  Memory_2.ImageIndex:=Form1.Memory_2.ImageIndex;
  Memory_3.ImageIndex:=Form1.Memory_3.ImageIndex;
  Memory_4.ImageIndex:=Form1.Memory_4.ImageIndex;
end;

procedure TFPanel.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFPanel.autorunTimer(Sender: TObject);
begin
  autorun.Enabled:=false;
  timer_monitor.Enabled:=true;
end;

end.

