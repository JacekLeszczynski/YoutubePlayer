unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Buttons, ExtCtrls, Spin, ComCtrls, DBCtrls, DBGridPlus, DSMaster,
  ExtMessage, ZDataset, rxdbcomb;

type

  { TFConfig }

  TFConfig = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    CheckBox25: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox22: TComboBox;
    ComboBox23: TComboBox;
    ComboBox24: TComboBox;
    ComboBox25: TComboBox;
    ComboBox26: TComboBox;
    ComboBox27: TComboBox;
    ComboBox28: TComboBox;
    DBEdit1: TDBEdit;
    DBGridPlus1: TDBGridPlus;
    dbpilotcode: TStringField;
    dbpilotexec: TStringField;
    dbpilotid: TLargeintField;
    dbpilotlevel: TLongintField;
    dbpilotvalue: TLongintField;
    Label138: TLabel;
    Label4: TLabel;
    mess: TExtMessage;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    master: TDSMaster;
    dsPilot: TDataSource;
    DirectoryEdit1: TDirectoryEdit;
    DirectoryEdit2: TDirectoryEdit;
    Edit61: TEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label106: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label45: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    RxDBComboBox1: TRxDBComboBox;
    RxDBComboBox2: TRxDBComboBox;
    SpinEdit61: TSpinEdit;
    SpinEdit62: TSpinEdit;
    SpinEdit63: TSpinEdit;
    SpinEdit64: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet6: TTabSheet;
    dbpilot: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure ComboBox28Change(Sender: TObject);
    procedure dbpilotAfterInsert(DataSet: TDataSet);
    procedure dbpilotBeforeOpen(DataSet: TDataSet);
    procedure dbpilotcodeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure dbpilotvalueGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure dsPilotDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ad_values: TStringList;
    procedure audio_device_refresh;
  public
  end;

var
  FConfig: TFConfig;

implementation

uses
  ecode, serwis, lcltype;

{$R *.lfm}

{ TFConfig }

procedure TFConfig.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  _DEF_CONFIG_MEMORY[0]:=PageControl1.ActivePageIndex;
  _DEF_CONFIG_MEMORY[1]:=ComboBox28.ItemIndex;
  master.Close;
  CloseAction:=caFree;
end;

procedure TFConfig.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex:=_DEF_CONFIG_MEMORY[0];
  ComboBox28.ItemIndex:=_DEF_CONFIG_MEMORY[1];
  master.Open;
  ad_values:=TStringList.Create;
  (* pierwsza zakładka *)
  ComboBox2.ItemIndex:=_DEF_SHUTDOWN_MODE;
  Edit61.Text:=_DEF_MULTIDESKTOP;
  DirectoryEdit1.Text:=_DEF_MULTIMEDIA_SAVE_DIR;
  DirectoryEdit2.Text:=_DEF_SCREENSHOT_SAVE_DIR;
  SpinEdit61.Value:=_DEF_CACHE;
  SpinEdit62.Value:=_DEF_CACHE_PREINIT;
  SpinEdit63.Value:=_DEF_ONLINE_CACHE;
  SpinEdit64.Value:=_DEF_ONLINE_CACHE_PREINIT;
  ComboBox1.ItemIndex:=_DEF_SCREENSHOT_FORMAT;
  FileNameEdit1.FileName:=_DEF_COOKIES_FILE_YT;
  CheckBox25.Checked:=_DEF_YT_AUTOSELECT;
  case _DEF_YT_AS_QUALITY of
       0: ComboBox23.ItemIndex:=0;
     144: ComboBox23.ItemIndex:=1;
     240: ComboBox23.ItemIndex:=2;
     360: ComboBox23.ItemIndex:=3;
     480: ComboBox23.ItemIndex:=4;
     720: ComboBox23.ItemIndex:=5;
    1080: ComboBox23.ItemIndex:=6;
    1440: ComboBox23.ItemIndex:=7;
    2160: ComboBox23.ItemIndex:=8;
  end;
  case _DEF_YT_AS_QUALITY_PLAY of
       0: ComboBox27.ItemIndex:=0;
     144: ComboBox27.ItemIndex:=1;
     240: ComboBox27.ItemIndex:=2;
     360: ComboBox27.ItemIndex:=3;
     480: ComboBox27.ItemIndex:=4;
     720: ComboBox27.ItemIndex:=5;
    1080: ComboBox27.ItemIndex:=6;
    1440: ComboBox27.ItemIndex:=7;
    2160: ComboBox27.ItemIndex:=8;
  end;
  ComboBox22.ItemIndex:=_DEF_ENGINE_PLAYER;
  ComboBox24.ItemIndex:=_DEF_ACCEL_PLAYER;
  audio_device_refresh;
  ComboBox25.ItemIndex:=StringToItemIndex(ad_values,_DEF_AUDIO_DEVICE,0);
  ComboBox26.ItemIndex:=StringToItemIndex(ad_values,_DEF_AUDIO_DEVICE_MONITOR,0);
end;

procedure TFConfig.FormDestroy(Sender: TObject);
begin
  ad_values.Free;
end;

procedure mpvAD(aStr: string; var aS1,aS2: string);
var
  s,s1,s2: string;
begin
  s:=trim(aStr);
  s1:=trim(GetLineToStr(s,2,''''));
  s2:=trim(GetLineToStr(s,3,''''));
  if s2[1]='(' then
  begin
    delete(s2,1,1);
    delete(s2,length(s2),1);
  end;
  aS1:=s1;
  aS2:=s2;
end;

procedure TFConfig.audio_device_refresh;
var
  p: TProcess;
  ss: TStringList;
  s,s1,s2: string;
  i: integer;
begin
  ad_values.Clear;
  ComboBox25.Clear;
  ad_values.Add('default');
  ComboBox25.Items.Add('Default');
  p:=TProcess.Create(self);
  try
    p.Options:=[poWaitOnExit,poUsePipes,poNoConsole];
    p.ShowWindow:=swoHIDE;
    p.Executable:='sh';
    p.Parameters.Add('-c');
    p.Parameters.Add('mpv --audio-device=help | grep pulse');
    p.Execute;
    ss:=TStringList.Create;
    try
      if p.Output.NumBytesAvailable>0 then
      begin
        ss.LoadFromStream(p.Output);
        for i:=0 to ss.Count-1 do
        begin
          s:=ss[i];
          mpvAD(s,s1,s2);
          ad_values.Add(s1);
          ComboBox25.Items.Add(s2);
        end;
        ComboBox26.Items.Assign(ComboBox25.Items);
      end;
    finally
      ss.Free;
    end;
  finally
    p.Terminate(0);
    p.Free;
  end;
end;

procedure TFConfig.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFConfig.BitBtn3Click(Sender: TObject);
begin
  dbpilot.Append;
end;

procedure TFConfig.BitBtn4Click(Sender: TObject);
begin
  dbpilot.Edit;
end;

procedure TFConfig.BitBtn5Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Potwierdź usunięcie wpisu!') then dbpilot.Delete;
end;

procedure TFConfig.BitBtn6Click(Sender: TObject);
begin
  dbpilot.Post;
end;

procedure TFConfig.BitBtn7Click(Sender: TObject);
begin
  dbpilot.Cancel;
end;

procedure TFConfig.ComboBox28Change(Sender: TObject);
begin
  master.Reopen;
end;

procedure TFConfig.dbpilotAfterInsert(DataSet: TDataSet);
begin
  dbpilotlevel.AsInteger:=ComboBox28.ItemIndex;
end;

procedure TFConfig.dbpilotBeforeOpen(DataSet: TDataSet);
begin
  dbpilot.ParamByName('level').AsInteger:=ComboBox28.ItemIndex;
end;

procedure TFConfig.dbpilotcodeGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
var
  s: string;
  i: integer;
begin
  s:=Sender.AsString;
  for i:=0 to RxDBComboBox2.Items.Count-1 do
  if s=RxDBComboBox2.Values[i] then
  begin
    aText:=RxDBComboBox2.Items[i];
    break;
  end;
end;

procedure TFConfig.dbpilotvalueGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
var
  s: string;
  i: integer;
begin
  s:=Sender.AsString;
  for i:=0 to RxDBComboBox1.Items.Count-1 do
  if s=RxDBComboBox1.Values[i] then
  begin
    aText:=RxDBComboBox1.Items[i];
    break;
  end;
end;

procedure TFConfig.dsPilotDataChange(Sender: TObject; Field: TField);
var
  a,ne,e: boolean;
begin
  master.State(dsPilot,a,ne,e);
  BitBtn3.Enabled:=a;
  BitBtn4.Enabled:=ne;
  BitBtn5.Enabled:=ne;
  BitBtn6.Enabled:=e;
  BitBtn7.Enabled:=e;
  ComboBox28.Enabled:=a;
end;

procedure TFConfig.BitBtn1Click(Sender: TObject);
begin
  _DEF_SHUTDOWN_MODE:=ComboBox2.ItemIndex;
  _DEF_MULTIDESKTOP:=Edit61.Text;
  _DEF_MULTIMEDIA_SAVE_DIR:=DirectoryEdit1.Text;
  _DEF_SCREENSHOT_SAVE_DIR:=DirectoryEdit2.Text;
  _DEF_SCREENSHOT_FORMAT:=ComboBox1.ItemIndex;
  _DEF_COOKIES_FILE_YT:=FileNameEdit1.FileName;
  _DEF_ENGINE_PLAYER:=ComboBox22.ItemIndex;
  _DEF_ACCEL_PLAYER:=ComboBox24.ItemIndex;
  _DEF_AUDIO_DEVICE:=ad_values[ComboBox25.ItemIndex];
  _DEF_AUDIO_DEVICE_MONITOR:=ad_values[ComboBox26.ItemIndex];
  _DEF_YT_AUTOSELECT:=CheckBox25.Checked;
  _DEF_CACHE:=SpinEdit61.Value;
  _DEF_CACHE_PREINIT:=SpinEdit62.Value;
  _DEF_ONLINE_CACHE:=SpinEdit63.Value;
  _DEF_ONLINE_CACHE_PREINIT:=SpinEdit64.Value;
  case ComboBox23.ItemIndex of
    0: _DEF_YT_AS_QUALITY:=0;
    1: _DEF_YT_AS_QUALITY:=144;
    2: _DEF_YT_AS_QUALITY:=240;
    3: _DEF_YT_AS_QUALITY:=360;
    4: _DEF_YT_AS_QUALITY:=480;
    5: _DEF_YT_AS_QUALITY:=720;
    6: _DEF_YT_AS_QUALITY:=1080;
    7: _DEF_YT_AS_QUALITY:=1440;
    8: _DEF_YT_AS_QUALITY:=2160;
  end;
  case ComboBox27.ItemIndex of
    0: _DEF_YT_AS_QUALITY_PLAY:=0;
    1: _DEF_YT_AS_QUALITY_PLAY:=144;
    2: _DEF_YT_AS_QUALITY_PLAY:=240;
    3: _DEF_YT_AS_QUALITY_PLAY:=360;
    4: _DEF_YT_AS_QUALITY_PLAY:=480;
    5: _DEF_YT_AS_QUALITY_PLAY:=720;
    6: _DEF_YT_AS_QUALITY_PLAY:=1080;
    7: _DEF_YT_AS_QUALITY_PLAY:=1440;
    8: _DEF_YT_AS_QUALITY_PLAY:=2160;
  end;
  dm.SetConfig('default-shutdown-mode',_DEF_SHUTDOWN_MODE);
  dm.SetConfig('default-multi-desktop',_DEF_MULTIDESKTOP);
  dm.SetConfig('default-directory-save-files',_DEF_MULTIMEDIA_SAVE_DIR);
  dm.SetConfig('default-directory-save-files-ss',_DEF_SCREENSHOT_SAVE_DIR);
  dm.SetConfig('default-screenshot-format',_DEF_SCREENSHOT_FORMAT);
  dm.SetConfig('default-cookies-file-yt',_DEF_COOKIES_FILE_YT);
  dm.SetConfig('default-engine-player',_DEF_ENGINE_PLAYER);
  dm.SetConfig('default-cache-player',_DEF_CACHE);
  dm.SetConfig('default-cache-preinit-player',_DEF_CACHE_PREINIT);
  dm.SetConfig('default-cache-online-player',_DEF_ONLINE_CACHE);
  dm.SetConfig('default-cache-online-preinit-player',_DEF_ONLINE_CACHE_PREINIT);
  dm.SetConfig('default-accel-player',_DEF_ACCEL_PLAYER);
  dm.SetConfig('default-audio-device',_DEF_AUDIO_DEVICE);
  dm.SetConfig('default-audio-device-monitor',_DEF_AUDIO_DEVICE_MONITOR);
  dm.SetConfig('default-yt-autoselect',_DEF_YT_AUTOSELECT);
  dm.SetConfig('default-yt-autoselect-quality',_DEF_YT_AS_QUALITY);
  dm.SetConfig('default-yt-autoselect-quality-play',_DEF_YT_AS_QUALITY_PLAY);
  close;
end;

{ TFConfig }

end.

