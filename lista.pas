unit lista;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, Menus, DBCtrls, EditBtn, Spin, TplSliderUnit, UOSPlayer,
  ZQueryPlus, ZDataset, uEKnob, uETilePanel, RxTimeEdit;

type

  { TFLista }

  TFLista = class(TForm)
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    BitBtn3: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    OpenDialog2: TOpenDialog;
    plSlider1: TplSlider;
    plSlider2: TplSlider;
    RadioGroup1: TRadioGroup;
    SpinEdit1: TSpinEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    autorun: TTimer;
    timer_play: TTimer;
    timer_exit: TIdleTimer;
    OpenDialog1: TOpenDialog;
    play: TUOSPlayer;
    uEKnob1: TuEKnob;
    uETilePanel1: TuETilePanel;
    roz: TZQueryPlus;
    uETilePanel2: TuETilePanel;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox17Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure plSlider1Change(Sender: TObject);
    procedure plSlider1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure plSlider2Change(Sender: TObject);
    procedure rozBeforeOpen(DataSet: TDataSet);
    procedure rozBeforeOpenII(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure timer_exitTimer(Sender: TObject);
    procedure timer_playTimer(Sender: TObject);
  private
    rozdzialy: TStrings;
    procedure wypelnij_liste_rozdzialow;
  public
    io_dir: string;
    www_link: string;
    in_tryb: integer;
    out_ok: boolean;
    ro_dir,ro_file: string;
    s_link, s_tytul, s_file, s_audio, s_lang, s_subtitle: string;
    i_bloku,i_roz: integer;
    in_out_wzmocnienie,in_out_glosnosc: integer;
    in_out_obrazy,in_out_start0: boolean;
    in_out_osd,in_out_audio,in_out_resample,io_transpose,io_predkosc,io_tonacja: integer;
    io_wsp_czasu_yt,io_w1_yt,io_w2_yt,io_w3_yt,io_w4_yt: integer;
    in_transmisja,in_szum,in_normalize,in_normalize_not,in_play_start0,in_play_novideo: boolean;
    io_deinterlace,io_prawo_cytatu,io_fragment_archiwalny,io_material_odszumiony,io_index_recreate: boolean;
    io_play_video_in_negative,io_obs_mic_active,io_video_aspect_16x9,io_monitors_off: boolean;
    s_notatki: string;
    io_info,io_rozdzielczosc: string;
    io_info_delay: integer;
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

procedure TFLista.autorunTimer(Sender: TObject);
begin
  autorun.Enabled:=false;
  if www_link<>'' then
  begin
    Edit1.Text:=www_link;
    BitBtn2.Click;
  end;
end;

procedure TFLista.BitBtn2Click(Sender: TObject);
begin
  s_link:=trim(Edit1.Text);
  s_tytul:=trim(Edit2.Text);
  s_file:=trim(Edit3.Text);
  if (s_tytul='') and (s_link='') and (s_file='') then exit;
  s_audio:=trim(Edit4.Text);
  s_lang:=trim(Edit5.Text);
  s_subtitle:=trim(Edit6.Text);
  s_notatki:=Memo1.Lines.Text;
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
  //if (s_link<>'') and (s_tytul='') then
  //begin
  //  BitBtn3.Click;
  //  timer_exit.Enabled:=true;
  //end;
  in_transmisja:=CheckBox2.Checked;
  in_szum:=CheckBox3.Checked;
  in_out_start0:=CheckBox4.Checked;
  in_normalize:=CheckBox5.Checked;
  in_normalize_not:=CheckBox8.Checked;
  in_play_start0:=CheckBox6.Checked;
  in_play_novideo:=CheckBox7.Checked;
  io_transpose:=RadioGroup1.ItemIndex;
  io_predkosc:=plSlider1.Value;
  io_tonacja:=plSlider2.Value;
  io_deinterlace:=CheckBox9.Checked;
  io_prawo_cytatu:=CheckBox10.Checked;
  io_material_odszumiony:=CheckBox11.Checked;
  io_index_recreate:=CheckBox12.Checked;
  io_fragment_archiwalny:=CheckBox13.Checked;
  io_play_video_in_negative:=CheckBox14.Checked;
  io_obs_mic_active:=CheckBox15.Checked;
  io_video_aspect_16x9:=CheckBox16.Checked;
  io_info:=Edit7.Caption;
  io_info_delay:=SpinEdit1.Value;
  io_rozdzielczosc:=ComboBox6.Text;
  if io_rozdzielczosc='[brak definicji]' then io_rozdzielczosc:='';
  io_monitors_off:=CheckBox18.Checked;
  out_ok:=true;
  close;
end;

procedure TFLista.BitBtn3Click(Sender: TObject);
begin
  if trim(Edit1.Text)='' then exit;
  Edit2.Text:=dm.GetTitleForYoutube(Edit1.Text);
end;

procedure TFLista.CheckBox17Change(Sender: TObject);
begin
  wypelnij_liste_rozdzialow;
end;

procedure TFLista.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.Checked then CheckBox8.Checked:=false;
end;

procedure TFLista.CheckBox8Change(Sender: TObject);
begin
  if CheckBox8.Checked then CheckBox5.Checked:=false;
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
  www_link:='';
  rozdzialy:=TStringList.Create;
  ComboBox1.Clear;
  rozdzialy.Clear;
  autorun.Enabled:=true;
end;

procedure TFLista.FormDestroy(Sender: TObject);
begin
  rozdzialy.Free;
end;

procedure TFLista.FormShow(Sender: TObject);
begin
  if in_tryb>0 then
  begin
    wypelnij_liste_rozdzialow;
    case in_tryb of
      1: begin
           Label21.Caption:='[nieustawiona]';
           Label22.Caption:='[nieustawiona]';
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
           CheckBox4.Checked:=false;
           CheckBox5.Checked:=false;
           CheckBox6.Checked:=false;
           CheckBox7.Checked:=false;
           CheckBox8.Checked:=false;
           CheckBox9.Checked:=false;
           CheckBox10.Checked:=false;
           CheckBox11.Checked:=false;
           CheckBox12.Checked:=false;
           CheckBox13.Checked:=false;
           CheckBox14.Checked:=false;
           CheckBox15.Checked:=false;
           CheckBox16.Checked:=false;
           CheckBox18.Checked:=false;
           Edit5.Text:='';
           Edit6.Text:='';
           Memo1.Clear;
           RadioGroup1.ItemIndex:=0;
           plSlider1.Value:=0;
           plSlider2.Value:=0;
           Edit7.Caption:='';
           SpinEdit1.Value:=10;
           ComboBox6.Text:='[brak definicji]';
         end;
      2: begin
           if ro_dir='' then ro_dir:='[nieustawiona]';
           if ro_file='' then ro_file:='[nieustawiona]';
           Label21.Caption:=ro_dir;
           Label22.Caption:=ro_file;
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
           CheckBox4.Checked:=in_out_start0;
           CheckBox5.Checked:=in_normalize;
           CheckBox8.Checked:=in_normalize_not;
           CheckBox6.Checked:=in_play_start0;
           CheckBox7.Checked:=in_play_novideo;
           CheckBox9.Checked:=io_deinterlace;
           CheckBox10.Checked:=io_prawo_cytatu;
           CheckBox11.Checked:=io_material_odszumiony;
           CheckBox12.Checked:=io_index_recreate;
           CheckBox13.Checked:=io_fragment_archiwalny;
           CheckBox14.Checked:=io_play_video_in_negative;
           CheckBox15.Checked:=io_obs_mic_active;
           CheckBox16.Checked:=io_video_aspect_16x9;
           CheckBox18.Checked:=io_monitors_off;
           Edit4.Text:=s_audio;
           Edit5.Text:=s_lang;
           Edit6.Text:=s_subtitle;
           Memo1.Lines.AddText(s_notatki);
           RadioGroup1.ItemIndex:=io_transpose;
           plSlider1.Value:=io_predkosc;
           plSlider2.Value:=io_tonacja;
           Edit7.Caption:=io_info;
           SpinEdit1.Value:=io_info_delay;
           if io_rozdzielczosc='' then ComboBox6.Text:='[brak definicji]' else ComboBox6.Text:=io_rozdzielczosc;
         end;
    end;
    ComboBox1.ItemIndex:=StringToItemIndex(rozdzialy,IntToStr(i_roz));
    Edit1.SetFocus;
    in_tryb:=0;
  end;
end;

procedure TFLista.plSlider1Change(Sender: TObject);
begin
  Label15.Caption:=IntToStr(plSlider1.Value);
end;

procedure TFLista.plSlider1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then plSlider1.Value:=0;
end;

procedure TFLista.plSlider2Change(Sender: TObject);
begin
  Label17.Caption:=IntToStr(plSlider2.Value);
end;

procedure TFLista.rozBeforeOpen(DataSet: TDataSet);
begin
  roz.ClearDefs;
  if not CheckBox17.Checked then roz.AddDef('-- where','where id_bloku=:id');
end;

procedure TFLista.rozBeforeOpenII(Sender: TObject);
begin
  if not CheckBox17.Checked then roz.ParamByName('id').AsInteger:=i_bloku;
end;

procedure TFLista.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir:=io_dir;
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

procedure TFLista.wypelnij_liste_rozdzialow;
var
  b: boolean;
  a: integer;
begin
  b:=ComboBox1.ItemIndex>-1;
  if b then a:=StrToInt(rozdzialy[ComboBox1.ItemIndex]);
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
  if b then ComboBox1.ItemIndex:=StringToItemIndex(rozdzialy,IntToStr(a),StringToItemIndex(rozdzialy,IntToStr(i_roz),0))
  else ComboBox1.ItemIndex:=StringToItemIndex(rozdzialy,IntToStr(i_roz));
end;

end.

