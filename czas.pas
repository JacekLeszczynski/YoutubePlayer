unit czas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons, ExtCtrls, XMLPropStorage, DBCtrls, UOSPlayer, RxTimeEdit,
  uETilePanel;

type

  { TFCzas }

  TFCzas = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OpenDialog2: TOpenDialog;
    play: TUOSPlayer;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    TimeEdit1: TRxTimeEdit;
    TimeEdit2: TRxTimeEdit;
    timer_play: TTimer;
    uETilePanel1: TuETilePanel;
    propstorage: TXMLPropStorage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure TimeEdit2Change(Sender: TObject);
    procedure timer_playTimer(Sender: TObject);
  private
  public
    in_tryb: integer;
    out_ok: boolean;
    s_nazwa,s_autor,s_audio,s_keybiblia: string;
    i_od,i_do: longword;
    io_link_id_czasu: integer;
    b_mute: boolean;
  end;

var
  FCzas: TFCzas;

implementation

uses
  ecode, lcltype;

{$R *.lfm}

{ TFCzas }

procedure TFCzas.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFCzas.BitBtn2Click(Sender: TObject);
begin
  s_nazwa:=trim(Edit1.Text);
  s_autor:=trim(Edit2.Text);
  s_audio:=trim(Edit4.Text);
  s_keybiblia:=trim(Edit5.Text);
  i_od:=TimeToInteger(TimeEdit1.Time);
  if CheckBox2.Checked then i_do:=TimeToInteger(TimeEdit2.Time) else i_do:=0;
  if s_nazwa='' then exit;
  b_mute:=CheckBox3.Checked;
  try
    if Edit3.Text='' then io_link_id_czasu:=0 else io_link_id_czasu:=StrToInt(Edit3.Text);
  except
    io_link_id_czasu:=0;
  end;
  out_ok:=true;
  close;
end;

procedure TFCzas.Edit1Change(Sender: TObject);
var
  s: string;
begin
  s:=trim(Edit1.Text);
  s:=StringReplace(s,' ^ ',#13#10,[rfReplaceAll]);
  s:=StringReplace(s,'^ ',#13#10,[rfReplaceAll]);
  s:=StringReplace(s,' ^ ',#13#10,[rfReplaceAll]);
  s:=StringReplace(s,'^',#13#10,[rfReplaceAll]);
  Label5.Caption:=s;
  Label5.Visible:=s<>'';
end;

procedure TFCzas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  play.Stop;
end;

procedure TFCzas.FormCreate(Sender: TObject);
begin
  PropStorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  PropStorage.Active:=true;
end;

procedure TFCzas.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key of
    VK_RETURN: BitBtn2.Click;
    VK_ESCAPE: BitBtn1.Click;
  end;
end;

procedure TFCzas.FormShow(Sender: TObject);
begin
  if in_tryb>0 then
  begin
    case in_tryb of
      1: begin
           Edit1.Text:='..';
           Edit2.Text:='';
           Edit4.Text:='';
           Edit5.Text:='';
           if i_od=0 then TimeEdit1.Time:=0
           else TimeEdit1.Time:=IntegerToTime(i_od);
           TimeEdit2.Time:=0;
           CheckBox2.Checked:=false;
           CheckBox3.Checked:=false;
           Edit3.Text:='';
         end;
      2: begin
           Edit1.Text:=s_nazwa;
           Edit2.Text:=s_autor;
           Edit4.Text:=s_audio;
           Edit5.Text:=s_keybiblia;
           TimeEdit1.Time:=IntegerToTime(i_od);
           if i_do=0 then
           begin
             TimeEdit2.Time:=0;
             CheckBox2.Checked:=false;
           end else begin
             TimeEdit2.Time:=IntegerToTime(i_do);
             CheckBox2.Checked:=true;
           end;
           if io_link_id_czasu=0 then Edit3.Text:='' else Edit3.Text:=IntToStr(io_link_id_czasu);
         end;
    end;
    CheckBox3.Checked:=b_mute;
    Edit1.SetFocus;
    Edit1.SelectAll;
    in_tryb:=0;
  end;
end;

var
  pom_s: string = '';

procedure TFCzas.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog2.InitialDir:=pom_s;
  if OpenDialog2.Execute then
  begin
    pom_s:=OpenDialog2.InitialDir;
    Edit4.Text:=OpenDialog2.FileName;
    if play.Busy then SpeedButton3.Click;
  end;
end;

procedure TFCzas.SpeedButton3Click(Sender: TObject);
begin
  if Edit4.Text='' then exit;
  play.Stop;
  timer_play.Enabled:=true;
end;

procedure TFCzas.SpeedButton4Click(Sender: TObject);
begin
  play.Stop;
end;

procedure TFCzas.TimeEdit2Change(Sender: TObject);
begin
  if TimeEdit2.Time>0 then CheckBox2.Checked:=true;
end;

procedure TFCzas.timer_playTimer(Sender: TObject);
begin
  timer_play.Enabled:=false;
  play.FileName:=Edit4.Text;
  play.Start;
end;

end.

