unit lista;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, Menus, UOSPlayer, ZDataset, uEKnob;

type

  { TFLista }

  TFLista = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Edit4: TEdit;
    Edit5: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenDialog2: TOpenDialog;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    timer_play: TTimer;
    timer_exit: TIdleTimer;
    roz: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    uEKnob1: TuEKnob;
    play: TUOSPlayer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure timer_exitTimer(Sender: TObject);
    procedure timer_playTimer(Sender: TObject);
  private
    rozdzialy: TStrings;
  public
    in_tryb: integer;
    out_ok: boolean;
    s_link, s_tytul, s_file, s_audio, s_lang: string;
    i_roz: integer;
    in_out_wzmocnienie,in_out_glosnosc: integer;
    in_out_obrazy: boolean;
    in_out_osd,in_out_audio,in_out_resample: integer;
    in_transmisja,in_szum: boolean;
  end;

var
  FLista: TFLista;

implementation

uses
  ecode, serwis;

{$R *.lfm}

{ TFLista }

procedure TFLista.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFLista.BitBtn2Click(Sender: TObject);
begin
  s_link:=trim(Edit1.Text);
  s_tytul:=trim(Edit2.Text);
  s_file:=trim(Edit3.Text);
  s_audio:=trim(Edit4.Text);
  s_lang:=trim(Edit5.Text);
  i_roz:=StrToInt(rozdzialy[ComboBox1.ItemIndex]);
  case ComboBox2.ItemIndex of
    0: in_out_wzmocnienie:=-1;
    1: in_out_wzmocnienie:=1;
    2: in_out_wzmocnienie:=0;
  end;
  if ComboBox2.ItemIndex=1 then in_out_glosnosc:=Round(uEKnob1.Position) else in_out_glosnosc:=-1;
  in_out_obrazy:=CheckBox1.Checked;
  in_out_osd:=ComboBox3.ItemIndex;
  in_out_audio:=ComboBox4.ItemIndex;
  in_out_resample:=ComboBox5.ItemIndex;
  if (s_link<>'') and (s_tytul='') then
  begin
    BitBtn3.Click;
    timer_exit.Enabled:=true;
  end;
  in_transmisja:=CheckBox2.Checked;
  in_szum:=CheckBox3.Checked;
  if (s_tytul='') and ((s_link='') or (s_file='')) then exit;
  out_ok:=true;
  close;
end;

procedure TFLista.BitBtn3Click(Sender: TObject);
begin
  if trim(Edit1.Text)='' then exit;
  Edit2.Text:=dm.GetTitleForYoutube(Edit1.Text);
end;

procedure TFLista.ComboBox2Change(Sender: TObject);
begin
  uEKnob1.Enabled:=ComboBox2.ItemIndex=1;
end;

procedure TFLista.Edit3Change(Sender: TObject);
begin
  if (Edit2.Text='') and (Edit3.Text<>'') then
  Edit2.Text:=ExtractFilename(Edit3.Text);
end;

procedure TFLista.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  play.Stop;
end;

procedure TFLista.FormCreate(Sender: TObject);
begin
  rozdzialy:=TStringList.Create;
  ComboBox1.Clear;
  rozdzialy.Clear;
  roz.Open;
  while not roz.EOF do
  begin
    ComboBox1.Items.Add(roz.FieldByName('nazwa').AsString);
    rozdzialy.Add(roz.FieldByName('id').AsString);
    roz.Next;
  end;
  roz.Close;
end;

procedure TFLista.FormDestroy(Sender: TObject);
begin
  rozdzialy.Free;
end;

procedure TFLista.FormShow(Sender: TObject);
begin
  if in_tryb>0 then
  begin
    case in_tryb of
      1: begin
           Edit1.Text:='';
           Edit2.Text:='';
           Edit3.Text:='';
           ComboBox2.ItemIndex:=0;
           uEKnob1.Position:=100;
           uEKnob1.Enabled:=false;
           CheckBox1.Checked:=false;
           ComboBox3.ItemIndex:=0;
           ComboBox4.ItemIndex:=0;
           ComboBox5.ItemIndex:=0;
           Edit4.Text:='';
           CheckBox2.Checked:=false;
           CheckBox3.Checked:=false;
           Edit5.Text:='';
         end;
      2: begin
           Edit1.Text:=s_link;
           Edit2.Text:=s_tytul;
           Edit3.Text:=s_file;
           case in_out_wzmocnienie of
             -1: ComboBox2.ItemIndex:=0;
             0: ComboBox2.ItemIndex:=2;
             1: ComboBox2.ItemIndex:=1;
           end;
           uEKnob1.Enabled:=in_out_wzmocnienie=1;
           if in_out_glosnosc=-1 then uEKnob1.Position:=100 else uEKnob1.Position:=in_out_glosnosc;
           CheckBox1.Checked:=in_out_obrazy;
           ComboBox3.ItemIndex:=in_out_osd;
           ComboBox4.ItemIndex:=in_out_audio;
           ComboBox5.ItemIndex:=in_out_resample;
           CheckBox2.Checked:=in_transmisja;
           CheckBox3.Checked:=in_szum;
           Edit4.Text:=s_audio;
           Edit5.Text:=s_lang;
         end;
    end;
    ComboBox1.ItemIndex:=StringToItemIndex(rozdzialy,IntToStr(i_roz));
    Edit1.SetFocus;
    in_tryb:=0;
  end;
end;

procedure TFLista.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit3.Text:=OpenDialog1.FileName;
end;

var
  pom_s: string = '';

procedure TFLista.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog2.InitialDir:=pom_s;
  if OpenDialog2.Execute then
  begin
    pom_s:=OpenDialog2.InitialDir;
    Edit4.Text:=OpenDialog2.FileName;
    if play.Busy then SpeedButton3.Click;
  end;
end;

procedure TFLista.SpeedButton3Click(Sender: TObject);
begin
  if Edit4.Text='' then exit;
  play.Stop;
  timer_play.Enabled:=true;
end;

procedure TFLista.SpeedButton4Click(Sender: TObject);
begin
  play.Stop;
end;

procedure TFLista.timer_exitTimer(Sender: TObject);
begin
  timer_exit.Enabled:=false;
  BitBtn2.Click;
end;

procedure TFLista.timer_playTimer(Sender: TObject);
begin
  timer_play.Enabled:=false;
  play.FileName:=Edit4.Text;
  play.Start;
end;

end.

