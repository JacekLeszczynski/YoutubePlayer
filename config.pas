unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Buttons, ExtCtrls, Spin, ComCtrls, DBCtrls, DBGrids, DBGridPlus,
  DSMaster, ExtMessage, NetSynHTTP, ZDataset, ZSqlUpdate, rxdbcomb;

type

  { TFConfig }

  TFConfig = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn24: TBitBtn;
    BitBtn25: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn28: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
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
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBGridPlus4: TDBGridPlus;
    dsTools: TDataSource;
    DBGrid2: TDBGrid;
    dsObsKon: TDataSource;
    DBGrid1: TDBGrid;
    dsObsFunc: TDataSource;
    dbdanedelay: TLongintField;
    dbdaneexec: TStringField;
    dbdaneexec2: TStringField;
    dbdaneid: TLargeintField;
    dbdanenazwa_id: TLargeintField;
    dbdanevalue: TLongintField;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBGridPlus2: TDBGridPlus;
    DBGridPlus3: TDBGridPlus;
    DBLookupComboBox3: TDBLookupComboBox;
    DBLookupComboBox4: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    dbaliasyid: TLargeintField;
    dbaliasynazwa: TStringField;
    dbaliasyopis: TMemoField;
    dbpilotalias_id: TLargeintField;
    dsAliasy: TDataSource;
    DBLookupComboBox2: TDBLookupComboBox;
    dsDane: TDataSource;
    dsValue: TDataSource;
    dsCode: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBGridPlus1: TDBGridPlus;
    DBLookupComboBox1: TDBLookupComboBox;
    dbpilotcode: TStringField;
    dbpilotdelay: TLongintField;
    dbpilotexec: TStringField;
    dbpilotexec2: TStringField;
    dbpilotid: TLargeintField;
    dbpilotlevel: TLongintField;
    dbpilotvalue: TLongintField;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label14: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
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
    http: TNetSynHTTP;
    obs_funcfunkcja: TStringField;
    obs_funcid: TLargeintField;
    obs_konfunkcja_id: TLargeintField;
    obs_konid: TLargeintField;
    obs_konkontrolka: TStringField;
    OpenPng: TOpenDialog;
    OpenTools: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    SavePng: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpinEdit61: TSpinEdit;
    SpinEdit62: TSpinEdit;
    SpinEdit63: TSpinEdit;
    SpinEdit64: TSpinEdit;
    Splitter1: TSplitter;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    s_codecode: TStringField;
    s_codenazwa: TStringField;
    s_valuenazwa: TStringField;
    s_valuevalue: TLongintField;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    dbpilot: TZQuery;
    s_code: TZReadOnlyQuery;
    s_value: TZReadOnlyQuery;
    dbaliasy: TZQuery;
    dbdane: TZQuery;
    obs_func: TZQuery;
    obs_kon: TZQuery;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    tools: TZQuery;
    toolscaption: TStringField;
    toolsid: TLargeintField;
    toolspath: TStringField;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn28Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure ComboBox28Change(Sender: TObject);
    procedure dbdaneAfterInsert(DataSet: TDataSet);
    procedure dbpilotAfterInsert(DataSet: TDataSet);
    procedure dbpilotBeforeOpen(DataSet: TDataSet);
    procedure dsAliasyDataChange(Sender: TObject; Field: TField);
    procedure dsDaneDataChange(Sender: TObject; Field: TField);
    procedure dsPilotDataChange(Sender: TObject; Field: TField);
    procedure dsToolsDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure _ON_UPDATE_MENU(DataSet: TDataSet);
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
  mplayer2_logo_picture.Position:=0;
  if (mplayer2_logo_czas<>'') and (mplayer2_logo_picture<>nil) then Image1.Picture.LoadFromStream(mplayer2_logo_picture);
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
  ComboBox3.ItemIndex:=_DEF_COUNT_PROCESS_UPDATE_DATA;
  CheckBox1.Checked:=_DEF_DEBUG;
  CheckBox2.Checked:=_DEF_FULLSCREEN_ALT1;
  Edit1.Text:=_DEF_YOUTUBE_APIKEY;
  Edit2.Text:=_DEF_YOUTUBE_VIDEOID;
  Label18.Caption:=_DEF_YOUTUBE_LIVECHATID;
  Edit4.Text:=_DEF_INFOTEXT_MPLAYER_NOACTIVE;
  ComboBox4.ItemIndex:=_DEF_DOWNLOADER_ENGINE;
  if _DEF_SUDO_PASSWORD='' then Edit3.Text:='' else Edit3.Text:=DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS);
end;

procedure TFConfig.FormDestroy(Sender: TObject);
begin
  ad_values.Free;
  Edit3.Text:='';
end;

procedure TFConfig.SpeedButton1Click(Sender: TObject);
begin
  if OpenTools.Execute then DBEdit9.Field.AsString:=OpenTools.FileName;
end;

procedure TFConfig.SpeedButton2Click(Sender: TObject);
var
  error: integer;
  s: string;
begin
  error:=GetLiveChatId(Edit2.Text,Edit1.Text,s);
  if error=0 then Label18.Caption:=s else
  begin
    if s='' then s:='ERROR: '+IntToStr(error) else s:='ERROR ('+IntToStr(error)+'): '+s;
    Label18.Caption:=s;
  end;
end;

procedure TFConfig._ON_UPDATE_MENU(DataSet: TDataSet);
begin
  _DEF_UPDATE_MENU:=true;
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

procedure TFConfig.BitBtn8Click(Sender: TObject);
begin
  dbaliasy.Append;
end;

procedure TFConfig.BitBtn9Click(Sender: TObject);
begin
  dbaliasy.Edit;
end;

procedure TFConfig.ComboBox28Change(Sender: TObject);
begin
  master.Reopen;
end;

procedure TFConfig.dbdaneAfterInsert(DataSet: TDataSet);
begin
  dbdanenazwa_id.AsInteger:=dbaliasyid.AsInteger;
end;

procedure TFConfig.dbpilotAfterInsert(DataSet: TDataSet);
begin
  dbpilotlevel.AsInteger:=ComboBox28.ItemIndex;
end;

procedure TFConfig.dbpilotBeforeOpen(DataSet: TDataSet);
begin
  dbpilot.ParamByName('level').AsInteger:=ComboBox28.ItemIndex;
end;

procedure TFConfig.dsAliasyDataChange(Sender: TObject; Field: TField);
var
  a,ne,e: boolean;
begin
  master.State(dsAliasy,a,ne,e);
  BitBtn8.Enabled:=a;
  BitBtn9.Enabled:=ne;
  BitBtn10.Enabled:=ne;
  BitBtn11.Enabled:=e;
  BitBtn12.Enabled:=e;
end;

procedure TFConfig.dsDaneDataChange(Sender: TObject; Field: TField);
var
  a,ne,e: boolean;
begin
  master.State(dsDane,a,ne,e);
  BitBtn13.Enabled:=a;
  BitBtn14.Enabled:=ne;
  BitBtn15.Enabled:=ne;
  BitBtn16.Enabled:=e;
  BitBtn17.Enabled:=e;
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

procedure TFConfig.dsToolsDataChange(Sender: TObject; Field: TField);
var
  a,ne,e: boolean;
begin
  master.State(dsTools,a,ne,e);
  BitBtn21.Enabled:=a;
  BitBtn22.Enabled:=ne;
  BitBtn23.Enabled:=ne;
  BitBtn24.Enabled:=e;
  BitBtn25.Enabled:=e;
  SpeedButton1.Enabled:=e;
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
  _DEF_COUNT_PROCESS_UPDATE_DATA:=ComboBox3.ItemIndex;
  _DEF_DEBUG:=CheckBox1.Checked;
  _DEF_FULLSCREEN_ALT1:=CheckBox2.Checked;
  _DEF_YOUTUBE_APIKEY:=Edit1.Text;
  _DEF_YOUTUBE_VIDEOID:=Edit2.Text;
  _DEF_YOUTUBE_LIVECHATID:=Label18.Caption;
  _DEF_INFOTEXT_MPLAYER_NOACTIVE:=Edit4.Text;
  _DEF_DOWNLOADER_ENGINE:=ComboBox4.ItemIndex;
  if Edit3.Text='' then _DEF_SUDO_PASSWORD:='' else _DEF_SUDO_PASSWORD:=EncryptStr(Edit3.Text,CONST_PASS);
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
  dm.SetConfig('default-count-process-update-data',_DEF_COUNT_PROCESS_UPDATE_DATA);
  dm.SetConfig('default-debug-code',_DEF_DEBUG);
  dm.SetConfig('default-fullscreen-alt1',_DEF_FULLSCREEN_ALT1);
  dm.SetConfig('default-youtube-apikey',_DEF_YOUTUBE_APIKEY);
  dm.SetConfig('default-youtube-videoid',_DEF_YOUTUBE_VIDEOID);
  dm.SetConfig('default-youtube-livechatid',_DEF_YOUTUBE_LIVECHATID);
  dm.SetConfig('default-infotext-mplayer-noactive',_DEF_INFOTEXT_MPLAYER_NOACTIVE);
  dm.SetConfig('default-downloader-engine',_DEF_DOWNLOADER_ENGINE);
  dm.SetConfig('default-sudo-password',_DEF_SUDO_PASSWORD);
  close;
end;

procedure TFConfig.BitBtn20Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Chcesz usunąć kontrolkę "'+obs_konkontrolka.AsString+'"^Kontynuować?') then obs_kon.Delete;
end;

procedure TFConfig.BitBtn21Click(Sender: TObject);
begin
  tools.Append;
end;

procedure TFConfig.BitBtn22Click(Sender: TObject);
begin
  tools.Edit;
end;

procedure TFConfig.BitBtn23Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Usunąć te narzędzie?') then tools.Delete;
end;

procedure TFConfig.BitBtn24Click(Sender: TObject);
begin
  tools.Post;
end;

procedure TFConfig.BitBtn25Click(Sender: TObject);
begin
  tools.Cancel;
end;

procedure TFConfig.BitBtn26Click(Sender: TObject);
begin
  Image1.Picture.Clear;
  dm.SetConfig('default-logo-yt',nil);
  dm.SetConfig('default-logo-yt-time','');
  mplayer2_logo_picture.Clear;
  mplayer2_logo_czas:='';
end;

procedure TFConfig.BitBtn27Click(Sender: TObject);
var
  s: string;
  mem: TMemoryStream;
begin
  if OpenPng.Execute then
  begin
    s:=FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',now);
    mem:=TMemoryStream.Create;
    try
      Image1.Picture.LoadFromFile(OpenPng.FileName);
      Image1.Picture.SaveToStream(mem);
      dm.SetConfig('default-logo-yt',mem);
      dm.SetConfig('default-logo-yt-time',s);
      mplayer2_logo_picture.Clear;
      mplayer2_logo_picture.LoadFromStream(mem);
      mplayer2_logo_czas:=s;
    finally
      mem.Free;
    end;
  end;
end;

procedure TFConfig.BitBtn28Click(Sender: TObject);
begin
  if SavePng.Execute then Image1.Picture.SaveToFile(SavePng.FileName);
end;

procedure TFConfig.BitBtn10Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Potwierdź usunięcie wpisu!') then dbaliasy.Delete;
end;

procedure TFConfig.BitBtn11Click(Sender: TObject);
begin
  dbaliasy.Post;
  dbaliasy.Refresh;
end;

procedure TFConfig.BitBtn12Click(Sender: TObject);
begin
  dbaliasy.Cancel;
end;

procedure TFConfig.BitBtn13Click(Sender: TObject);
begin
  dbdane.Append;
end;

procedure TFConfig.BitBtn14Click(Sender: TObject);
begin
  dbdane.Edit;
end;

procedure TFConfig.BitBtn15Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Potwierdź usunięcie wpisu!') then dbdane.Delete;
end;

procedure TFConfig.BitBtn16Click(Sender: TObject);
begin
  dbdane.Post;
end;

procedure TFConfig.BitBtn17Click(Sender: TObject);
begin
  dbdane.Cancel;
end;

procedure TFConfig.BitBtn18Click(Sender: TObject);
var
  s: string;
begin
  s:=trim(InputBox('Dodanie nowej kontrolki OBS','Nazwa kontrolki',''));
  if s<>'' then
  begin
    obs_kon.Append;
    obs_konfunkcja_id.AsInteger:=obs_funcid.AsInteger;
    obs_konkontrolka.AsString:=s;
    obs_kon.Post;
  end;
end;

procedure TFConfig.BitBtn19Click(Sender: TObject);
var
  s: string;
begin
  s:=trim(InputBox('Edycja kontrolki OBS','Nazwa kontrolki',obs_konkontrolka.AsString));
  if s<>obs_konkontrolka.AsString then
  begin
    obs_kon.Edit;
    obs_konkontrolka.AsString:=s;
    obs_kon.Post;
  end;
end;

{ TFConfig }

end.

