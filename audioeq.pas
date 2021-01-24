unit audioeq;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  XMLPropStorage, Buttons, ExtCtrls, TplSliderUnit, uETilePanel;

type

  { TFAEQ }

  TFAEQ = class(TForm)
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Shape1: TShape;
    TrackBar1: TplSlider;
    PropStorage: TXMLPropStorage;
    TrackBar10: TplSlider;
    TrackBar11: TplSlider;
    TrackBar12: TplSlider;
    TrackBar13: TplSlider;
    TrackBar14: TplSlider;
    TrackBar15: TplSlider;
    TrackBar16: TplSlider;
    TrackBar17: TplSlider;
    TrackBar18: TplSlider;
    TrackBar2: TplSlider;
    TrackBar3: TplSlider;
    TrackBar4: TplSlider;
    TrackBar5: TplSlider;
    TrackBar6: TplSlider;
    TrackBar7: TplSlider;
    TrackBar8: TplSlider;
    TrackBar9: TplSlider;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure _CHANGE(Sender: TObject);
  private
    BLOKADA: boolean;
  public
    in_out_filtr: string;
    out_zapisz: boolean;
  end;

var
  FAEQ: TFAEQ;

implementation

uses
  main, ecode, serwis, full_screen;

{$R *.lfm}

{ TFAEQ }

procedure TFAEQ._CHANGE(Sender: TObject);
var
  s: string;
begin
  if BLOKADA then exit;
  if CheckBox1.Checked then
  begin
    s:='1b='+FormatFloat('0.0',TrackBar1.Value/10) +
      ':2b='+FormatFloat('0.0',TrackBar2.Value/10) +
      ':3b='+FormatFloat('0.0',TrackBar3.Value/10) +
      ':4b='+FormatFloat('0.0',TrackBar4.Value/10) +
      ':5b='+FormatFloat('0.0',TrackBar5.Value/10) +
      ':6b='+FormatFloat('0.0',TrackBar6.Value/10) +
      ':7b='+FormatFloat('0.0',TrackBar7.Value/10) +
      ':8b='+FormatFloat('0.0',TrackBar8.Value/10) +
      ':9b='+FormatFloat('0.0',TrackBar9.Value/10) +
     ':10b='+FormatFloat('0.0',TrackBar10.Value/10) +
     ':11b='+FormatFloat('0.0',TrackBar11.Value/10) +
     ':12b='+FormatFloat('0.0',TrackBar12.Value/10) +
     ':13b='+FormatFloat('0.0',TrackBar13.Value/10) +
     ':14b='+FormatFloat('0.0',TrackBar14.Value/10) +
     ':15b='+FormatFloat('0.0',TrackBar15.Value/10) +
     ':16b='+FormatFloat('0.0',TrackBar16.Value/10) +
     ':17b='+FormatFloat('0.0',TrackBar17.Value/10) +
     ':18b='+FormatFloat('0.0',TrackBar18.Value/10);
    if Form1.mplayer.Running then
    begin
      Form1.mplayer.SetAudioEQ(s);
      if _FULL_SCREEN then FFullScreen.mplayer.SetAudioEQ(s);
    end;
    in_out_filtr:=s;
  end;
end;

procedure TFAEQ.CheckBox1Change(Sender: TObject);
begin
  if BLOKADA then exit;
  if Form1.mplayer.Running then if CheckBox1.Checked then _CHANGE(Sender) else
  begin
    Form1.mplayer.SetAudioEQ;
    if _FULL_SCREEN then FFullScreen.mplayer.SetAudioEQ;
    in_out_filtr:='';
  end;
end;

procedure TFAEQ.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFAEQ.BitBtn1Click(Sender: TObject);
begin
  BLOKADA:=true;
  TrackBar1.Value:=10;
  TrackBar2.Value:=10;
  TrackBar3.Value:=10;
  TrackBar4.Value:=10;
  TrackBar5.Value:=10;
  TrackBar6.Value:=10;
  TrackBar7.Value:=10;
  TrackBar8.Value:=10;
  TrackBar9.Value:=10;
  TrackBar10.Value:=10;
  TrackBar11.Value:=10;
  TrackBar12.Value:=10;
  TrackBar13.Value:=10;
  TrackBar14.Value:=10;
  TrackBar15.Value:=10;
  TrackBar16.Value:=10;
  TrackBar17.Value:=10;
  TrackBar18.Value:=10;
  BLOKADA:=false;
  _CHANGE(Sender);
end;

procedure TFAEQ.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  out_zapisz:=CheckBox2.Checked;
end;

procedure TFAEQ.FormCreate(Sender: TObject);
begin
  PropStorage.FileName:=MyConfDir('ustawienia.xml');
  PropStorage.Active:=true;
  BLOKADA:=false;
end;

procedure TFAEQ.FormShow(Sender: TObject);
var
  s,s1: string;
  i,a: integer;
begin
  CheckBox2.Checked:=false;
  s:=in_out_filtr;
  if s<>'' then
  begin
    BLOKADA:=true;
    {1b=0:2b=0:3b=0:4b=0:5b=0:6b=0:7b=0:8b=0:9b=0:10b=0:11b=0:12b=0:13b=0:14b=0:15b=0:16b=0:17b=0:18b=0}
    for i:=1 to 18 do
    begin
      s1:=GetLineToStr(s,i,':');
      a:=StrToInt(StringReplace(GetLineToStr(s1,2,'='),'.','',[rfReplaceAll]));
      case i of
         1: TrackBar1.Value:=a;
         2: TrackBar2.Value:=a;
         3: TrackBar3.Value:=a;
         4: TrackBar4.Value:=a;
         5: TrackBar5.Value:=a;
         6: TrackBar6.Value:=a;
         7: TrackBar7.Value:=a;
         8: TrackBar8.Value:=a;
         9: TrackBar9.Value:=a;
        10: TrackBar10.Value:=a;
        11: TrackBar11.Value:=a;
        12: TrackBar12.Value:=a;
        13: TrackBar13.Value:=a;
        14: TrackBar14.Value:=a;
        15: TrackBar15.Value:=a;
        16: TrackBar16.Value:=a;
        17: TrackBar17.Value:=a;
        18: TrackBar18.Value:=a;
      end;
    end;
    CheckBox1.Checked:=true;
  end;
  BLOKADA:=false;
end;

end.

