unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons, ExtCtrls, Spin, ComCtrls;

type

  { TFConfig }

  TFConfig = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
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
    CheckBox19: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ComboBox15: TComboBox;
    ComboBox16: TComboBox;
    ComboBox17: TComboBox;
    ComboBox18: TComboBox;
    ComboBox19: TComboBox;
    ComboBox2: TComboBox;
    ComboBox20: TComboBox;
    ComboBox21: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    DirectoryEdit2: TDirectoryEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
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
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label7: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label8: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label9: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    PageControl1: TPageControl;
    SpinEdit1: TSpinEdit;
    SpinEdit10: TSpinEdit;
    SpinEdit11: TSpinEdit;
    SpinEdit12: TSpinEdit;
    SpinEdit13: TSpinEdit;
    SpinEdit14: TSpinEdit;
    SpinEdit15: TSpinEdit;
    SpinEdit16: TSpinEdit;
    SpinEdit17: TSpinEdit;
    SpinEdit18: TSpinEdit;
    SpinEdit19: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit20: TSpinEdit;
    SpinEdit21: TSpinEdit;
    SpinEdit22: TSpinEdit;
    SpinEdit23: TSpinEdit;
    SpinEdit24: TSpinEdit;
    SpinEdit25: TSpinEdit;
    SpinEdit26: TSpinEdit;
    SpinEdit27: TSpinEdit;
    SpinEdit28: TSpinEdit;
    SpinEdit29: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit30: TSpinEdit;
    SpinEdit31: TSpinEdit;
    SpinEdit32: TSpinEdit;
    SpinEdit33: TSpinEdit;
    SpinEdit34: TSpinEdit;
    SpinEdit35: TSpinEdit;
    SpinEdit36: TSpinEdit;
    SpinEdit37: TSpinEdit;
    SpinEdit38: TSpinEdit;
    SpinEdit39: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit40: TSpinEdit;
    SpinEdit41: TSpinEdit;
    SpinEdit42: TSpinEdit;
    SpinEdit43: TSpinEdit;
    SpinEdit44: TSpinEdit;
    SpinEdit45: TSpinEdit;
    SpinEdit46: TSpinEdit;
    SpinEdit47: TSpinEdit;
    SpinEdit48: TSpinEdit;
    SpinEdit49: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit50: TSpinEdit;
    SpinEdit51: TSpinEdit;
    SpinEdit52: TSpinEdit;
    SpinEdit53: TSpinEdit;
    SpinEdit54: TSpinEdit;
    SpinEdit55: TSpinEdit;
    SpinEdit56: TSpinEdit;
    SpinEdit57: TSpinEdit;
    SpinEdit58: TSpinEdit;
    SpinEdit59: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit60: TSpinEdit;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure _PRINT_KEY(Sender: TObject);
    procedure _SCAN_KEY(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure wczytaj;
    procedure zapisz;
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
  CloseAction:=caFree;
end;

procedure TFConfig.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex:=0;
  DirectoryEdit1.Text:=_DEF_MULTIMEDIA_SAVE_DIR;
  DirectoryEdit2.Text:=_DEF_SCREENSHOT_SAVE_DIR;
  ComboBox1.ItemIndex:=_DEF_SCREENSHOT_FORMAT;
  FileNameEdit1.FileName:=_DEF_COOKIES_FILE_YT;
  ComboBox3.Items.Assign(ComboBox2.Items);
  ComboBox4.Items.Assign(ComboBox2.Items);
  ComboBox5.Items.Assign(ComboBox2.Items);
  ComboBox6.Items.Assign(ComboBox2.Items);
  ComboBox7.Items.Assign(ComboBox2.Items);
  ComboBox8.Items.Assign(ComboBox2.Items);
  ComboBox9.Items.Assign(ComboBox2.Items);
  ComboBox10.Items.Assign(ComboBox2.Items);
  ComboBox11.Items.Assign(ComboBox2.Items);
  ComboBox12.Items.Assign(ComboBox2.Items);
  ComboBox13.Items.Assign(ComboBox2.Items);
  ComboBox14.Items.Assign(ComboBox2.Items);
  ComboBox15.Items.Assign(ComboBox2.Items);
  ComboBox16.Items.Assign(ComboBox2.Items);
  ComboBox17.Items.Assign(ComboBox2.Items);
  ComboBox18.Items.Assign(ComboBox2.Items);
  ComboBox19.Items.Assign(ComboBox2.Items);
  ComboBox20.Items.Assign(ComboBox2.Items);
  ComboBox21.Items.Assign(ComboBox2.Items);
  wczytaj;
end;

procedure TFConfig._PRINT_KEY(Sender: TObject);
var
  b: byte;
begin
  b:=TSpinEdit(Sender).Value;
  case TSpinEdit(Sender).Tag of
    46: Label46.Caption:=chr(b);
    47: Label47.Caption:=chr(b);
    48: Label48.Caption:=chr(b);
    49: Label49.Caption:=chr(b);
    50: Label50.Caption:=chr(b);
    51: Label51.Caption:=chr(b);
    52: Label52.Caption:=chr(b);
    53: Label53.Caption:=chr(b);
    54: Label54.Caption:=chr(b);
    55: Label55.Caption:=chr(b);
    56: Label56.Caption:=chr(b);
    57: Label57.Caption:=chr(b);
    58: Label58.Caption:=chr(b);
    59: Label59.Caption:=chr(b);
    60: Label60.Caption:=chr(b);
    61: Label61.Caption:=chr(b);
    62: Label62.Caption:=chr(b);
    63: Label63.Caption:=chr(b);
    64: Label64.Caption:=chr(b);
    65: Label65.Caption:=chr(b);
    66: Label66.Caption:=chr(b);
    67: Label67.Caption:=chr(b);
    68: Label68.Caption:=chr(b);
    69: Label69.Caption:=chr(b);
    70: Label70.Caption:=chr(b);
    71: Label71.Caption:=chr(b);
    72: Label72.Caption:=chr(b);
    73: Label73.Caption:=chr(b);
    74: Label74.Caption:=chr(b);
    75: Label75.Caption:=chr(b);
    76: Label76.Caption:=chr(b);
    77: Label77.Caption:=chr(b);
    78: Label78.Caption:=chr(b);
    79: Label79.Caption:=chr(b);
    80: Label80.Caption:=chr(b);
    81: Label81.Caption:=chr(b);
    82: Label82.Caption:=chr(b);
    83: Label83.Caption:=chr(b);
    84: Label84.Caption:=chr(b);
    85: Label85.Caption:=chr(b);
    86: Label86.Caption:=chr(b);
    87: Label87.Caption:=chr(b);
    88: Label88.Caption:=chr(b);
    89: Label89.Caption:=chr(b);
    90: Label90.Caption:=chr(b);
    91: Label91.Caption:=chr(b);
    92: Label92.Caption:=chr(b);
    93: Label93.Caption:=chr(b);
    94: Label94.Caption:=chr(b);
    95: Label95.Caption:=chr(b);
    96: Label96.Caption:=chr(b);
    97: Label97.Caption:=chr(b);
    98: Label98.Caption:=chr(b);
    99: Label99.Caption:=chr(b);
    100: Label100.Caption:=chr(b);
    101: Label101.Caption:=chr(b);
    102: Label102.Caption:=chr(b);
    103: Label103.Caption:=chr(b);
    104: Label104.Caption:=chr(b);
    105: Label105.Caption:=chr(b);
  end;
end;

procedure TFConfig._SCAN_KEY(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key=8 then TSpinEdit(Sender).Value:=0 else
  TSpinEdit(Sender).Value:=Key;
end;

procedure TFConfig.wczytaj;
var
  b: boolean;
  s: string;
  a: TArchitekt;
  f: file of TArchitekt;
begin
  s:=MyConfDir('keys.dat');
  b:=FileExists(s);
  if b then
  begin
    assignfile(f,s);
    reset(f);
  end else dm.zeruj(a);
  if b then read(f,a);
  ComboBox2.ItemIndex:=a.p1.funkcja_wewnetrzna;
  SpinEdit1.Value:=a.p1.kod_wewnetrzny;
  CheckBox1.Checked:=a.p1.operacja_zewnetrzna;
  SpinEdit2.Value:=a.p1.klik;
  SpinEdit3.Value:=a.p1.dwuklik;
  ComboBox3.ItemIndex:=a.p2.funkcja_wewnetrzna;
  SpinEdit4.Value:=a.p2.kod_wewnetrzny;
  CheckBox2.Checked:=a.p2.operacja_zewnetrzna;
  SpinEdit5.Value:=a.p2.klik;
  SpinEdit6.Value:=a.p2.dwuklik;
  ComboBox4.ItemIndex:=a.p3.funkcja_wewnetrzna;
  SpinEdit7.Value:=a.p3.kod_wewnetrzny;
  CheckBox3.Checked:=a.p3.operacja_zewnetrzna;
  SpinEdit8.Value:=a.p3.klik;
  SpinEdit9.Value:=a.p3.dwuklik;
  ComboBox5.ItemIndex:=a.p4.funkcja_wewnetrzna;
  SpinEdit10.Value:=a.p4.kod_wewnetrzny;
  CheckBox4.Checked:=a.p4.operacja_zewnetrzna;
  SpinEdit11.Value:=a.p4.klik;
  SpinEdit12.Value:=a.p4.dwuklik;
  ComboBox6.ItemIndex:=a.p5.funkcja_wewnetrzna;
  SpinEdit13.Value:=a.p5.kod_wewnetrzny;
  CheckBox5.Checked:=a.p5.operacja_zewnetrzna;
  SpinEdit14.Value:=a.p5.klik;
  SpinEdit15.Value:=a.p5.dwuklik;
  CheckBox6.Checked:=a.suma45;
  if b then read(f,a);
  ComboBox7.ItemIndex:=a.p1.funkcja_wewnetrzna;
  SpinEdit16.Value:=a.p1.kod_wewnetrzny;
  CheckBox7.Checked:=a.p1.operacja_zewnetrzna;
  SpinEdit17.Value:=a.p1.klik;
  SpinEdit18.Value:=a.p1.dwuklik;
  ComboBox8.ItemIndex:=a.p2.funkcja_wewnetrzna;
  SpinEdit19.Value:=a.p2.kod_wewnetrzny;
  CheckBox8.Checked:=a.p2.operacja_zewnetrzna;
  SpinEdit20.Value:=a.p2.klik;
  SpinEdit21.Value:=a.p2.dwuklik;
  ComboBox9.ItemIndex:=a.p3.funkcja_wewnetrzna;
  SpinEdit22.Value:=a.p3.kod_wewnetrzny;
  CheckBox9.Checked:=a.p3.operacja_zewnetrzna;
  SpinEdit23.Value:=a.p3.klik;
  SpinEdit24.Value:=a.p3.dwuklik;
  ComboBox10.ItemIndex:=a.p4.funkcja_wewnetrzna;
  SpinEdit25.Value:=a.p4.kod_wewnetrzny;
  CheckBox10.Checked:=a.p4.operacja_zewnetrzna;
  SpinEdit26.Value:=a.p4.klik;
  SpinEdit27.Value:=a.p4.dwuklik;
  ComboBox11.ItemIndex:=a.p5.funkcja_wewnetrzna;
  SpinEdit28.Value:=a.p5.kod_wewnetrzny;
  CheckBox11.Checked:=a.p5.operacja_zewnetrzna;
  SpinEdit29.Value:=a.p5.klik;
  SpinEdit30.Value:=a.p5.dwuklik;
  CheckBox22.Checked:=a.suma45;
  if b then read(f,a);
  ComboBox12.ItemIndex:=a.p1.funkcja_wewnetrzna;
  SpinEdit31.Value:=a.p1.kod_wewnetrzny;
  CheckBox12.Checked:=a.p1.operacja_zewnetrzna;
  SpinEdit32.Value:=a.p1.klik;
  SpinEdit33.Value:=a.p1.dwuklik;
  ComboBox13.ItemIndex:=a.p2.funkcja_wewnetrzna;
  SpinEdit34.Value:=a.p2.kod_wewnetrzny;
  CheckBox13.Checked:=a.p2.operacja_zewnetrzna;
  SpinEdit35.Value:=a.p2.klik;
  SpinEdit36.Value:=a.p2.dwuklik;
  ComboBox14.ItemIndex:=a.p3.funkcja_wewnetrzna;
  SpinEdit37.Value:=a.p3.kod_wewnetrzny;
  CheckBox14.Checked:=a.p3.operacja_zewnetrzna;
  SpinEdit38.Value:=a.p3.klik;
  SpinEdit39.Value:=a.p3.dwuklik;
  ComboBox15.ItemIndex:=a.p4.funkcja_wewnetrzna;
  SpinEdit40.Value:=a.p4.kod_wewnetrzny;
  CheckBox15.Checked:=a.p4.operacja_zewnetrzna;
  SpinEdit41.Value:=a.p4.klik;
  SpinEdit42.Value:=a.p4.dwuklik;
  ComboBox16.ItemIndex:=a.p5.funkcja_wewnetrzna;
  SpinEdit43.Value:=a.p5.kod_wewnetrzny;
  CheckBox16.Checked:=a.p5.operacja_zewnetrzna;
  SpinEdit44.Value:=a.p5.klik;
  SpinEdit45.Value:=a.p5.dwuklik;
  CheckBox23.Checked:=a.suma45;
  if b then read(f,a);
  ComboBox17.ItemIndex:=a.p1.funkcja_wewnetrzna;
  SpinEdit46.Value:=a.p1.kod_wewnetrzny;
  CheckBox17.Checked:=a.p1.operacja_zewnetrzna;
  SpinEdit47.Value:=a.p1.klik;
  SpinEdit48.Value:=a.p1.dwuklik;
  ComboBox18.ItemIndex:=a.p2.funkcja_wewnetrzna;
  SpinEdit49.Value:=a.p2.kod_wewnetrzny;
  CheckBox18.Checked:=a.p2.operacja_zewnetrzna;
  SpinEdit50.Value:=a.p2.klik;
  SpinEdit51.Value:=a.p2.dwuklik;
  ComboBox19.ItemIndex:=a.p3.funkcja_wewnetrzna;
  SpinEdit52.Value:=a.p3.kod_wewnetrzny;
  CheckBox19.Checked:=a.p3.operacja_zewnetrzna;
  SpinEdit53.Value:=a.p3.klik;
  SpinEdit54.Value:=a.p3.dwuklik;
  ComboBox20.ItemIndex:=a.p4.funkcja_wewnetrzna;
  SpinEdit55.Value:=a.p4.kod_wewnetrzny;
  CheckBox20.Checked:=a.p4.operacja_zewnetrzna;
  SpinEdit56.Value:=a.p4.klik;
  SpinEdit57.Value:=a.p4.dwuklik;
  ComboBox21.ItemIndex:=a.p5.funkcja_wewnetrzna;
  SpinEdit58.Value:=a.p5.kod_wewnetrzny;
  CheckBox21.Checked:=a.p5.operacja_zewnetrzna;
  SpinEdit59.Value:=a.p5.klik;
  SpinEdit60.Value:=a.p5.dwuklik;
  CheckBox24.Checked:=a.suma45;
  if b then closefile(f);
end;

procedure TFConfig.zapisz;
var
  a: TArchitekt;
  f: file of TArchitekt;
begin
  assignfile(f,MyConfDir('keys.dat'));
  rewrite(f);
  a.p1.funkcja_wewnetrzna:=ComboBox2.ItemIndex;
  a.p1.kod_wewnetrzny:=SpinEdit1.Value;
  a.p1.operacja_zewnetrzna:=CheckBox1.Checked;
  a.p1.klik:=SpinEdit2.Value;
  a.p1.dwuklik:=SpinEdit3.Value;
  a.p2.funkcja_wewnetrzna:=ComboBox3.ItemIndex;
  a.p2.kod_wewnetrzny:=SpinEdit4.Value;
  a.p2.operacja_zewnetrzna:=CheckBox2.Checked;
  a.p2.klik:=SpinEdit5.Value;
  a.p2.dwuklik:=SpinEdit6.Value;
  a.p3.funkcja_wewnetrzna:=ComboBox4.ItemIndex;
  a.p3.kod_wewnetrzny:=SpinEdit7.Value;
  a.p3.operacja_zewnetrzna:=CheckBox3.Checked;
  a.p3.klik:=SpinEdit8.Value;
  a.p3.dwuklik:=SpinEdit9.Value;
  a.p4.funkcja_wewnetrzna:=ComboBox5.ItemIndex;
  a.p4.kod_wewnetrzny:=SpinEdit10.Value;
  a.p4.operacja_zewnetrzna:=CheckBox4.Checked;
  a.p4.klik:=SpinEdit11.Value;
  a.p4.dwuklik:=SpinEdit12.Value;
  a.p5.funkcja_wewnetrzna:=ComboBox6.ItemIndex;
  a.p5.kod_wewnetrzny:=SpinEdit13.Value;
  a.p5.operacja_zewnetrzna:=CheckBox5.Checked;
  a.p5.klik:=SpinEdit14.Value;
  a.p5.dwuklik:=SpinEdit15.Value;
  a.suma45:=CheckBox6.Checked;
  write(f,a);
  a.p1.funkcja_wewnetrzna:=ComboBox7.ItemIndex;
  a.p1.kod_wewnetrzny:=SpinEdit16.Value;
  a.p1.operacja_zewnetrzna:=CheckBox7.Checked;
  a.p1.klik:=SpinEdit17.Value;
  a.p1.dwuklik:=SpinEdit18.Value;
  a.p2.funkcja_wewnetrzna:=ComboBox8.ItemIndex;
  a.p2.kod_wewnetrzny:=SpinEdit19.Value;
  a.p2.operacja_zewnetrzna:=CheckBox8.Checked;
  a.p2.klik:=SpinEdit20.Value;
  a.p2.dwuklik:=SpinEdit21.Value;
  a.p3.funkcja_wewnetrzna:=ComboBox9.ItemIndex;
  a.p3.kod_wewnetrzny:=SpinEdit22.Value;
  a.p3.operacja_zewnetrzna:=CheckBox9.Checked;
  a.p3.klik:=SpinEdit23.Value;
  a.p3.dwuklik:=SpinEdit24.Value;
  a.p4.funkcja_wewnetrzna:=ComboBox10.ItemIndex;
  a.p4.kod_wewnetrzny:=SpinEdit25.Value;
  a.p4.operacja_zewnetrzna:=CheckBox10.Checked;
  a.p4.klik:=SpinEdit26.Value;
  a.p4.dwuklik:=SpinEdit27.Value;
  a.p5.funkcja_wewnetrzna:=ComboBox11.ItemIndex;
  a.p5.kod_wewnetrzny:=SpinEdit28.Value;
  a.p5.operacja_zewnetrzna:=CheckBox11.Checked;
  a.p5.klik:=SpinEdit29.Value;
  a.p5.dwuklik:=SpinEdit30.Value;
  a.suma45:=CheckBox22.Checked;
  write(f,a);
  a.p1.funkcja_wewnetrzna:=ComboBox12.ItemIndex;
  a.p1.kod_wewnetrzny:=SpinEdit31.Value;
  a.p1.operacja_zewnetrzna:=CheckBox12.Checked;
  a.p1.klik:=SpinEdit32.Value;
  a.p1.dwuklik:=SpinEdit33.Value;
  a.p2.funkcja_wewnetrzna:=ComboBox13.ItemIndex;
  a.p2.kod_wewnetrzny:=SpinEdit34.Value;
  a.p2.operacja_zewnetrzna:=CheckBox13.Checked;
  a.p2.klik:=SpinEdit35.Value;
  a.p2.dwuklik:=SpinEdit36.Value;
  a.p3.funkcja_wewnetrzna:=ComboBox14.ItemIndex;
  a.p3.kod_wewnetrzny:=SpinEdit37.Value;
  a.p3.operacja_zewnetrzna:=CheckBox14.Checked;
  a.p3.klik:=SpinEdit38.Value;
  a.p3.dwuklik:=SpinEdit39.Value;
  a.p4.funkcja_wewnetrzna:=ComboBox15.ItemIndex;
  a.p4.kod_wewnetrzny:=SpinEdit40.Value;
  a.p4.operacja_zewnetrzna:=CheckBox15.Checked;
  a.p4.klik:=SpinEdit41.Value;
  a.p4.dwuklik:=SpinEdit42.Value;
  a.p5.funkcja_wewnetrzna:=ComboBox16.ItemIndex;
  a.p5.kod_wewnetrzny:=SpinEdit43.Value;
  a.p5.operacja_zewnetrzna:=CheckBox16.Checked;
  a.p5.klik:=SpinEdit44.Value;
  a.p5.dwuklik:=SpinEdit45.Value;
  a.suma45:=CheckBox23.Checked;
  write(f,a);
  a.p1.funkcja_wewnetrzna:=ComboBox17.ItemIndex;
  a.p1.kod_wewnetrzny:=SpinEdit46.Value;
  a.p1.operacja_zewnetrzna:=CheckBox17.Checked;
  a.p1.klik:=SpinEdit47.Value;
  a.p1.dwuklik:=SpinEdit48.Value;
  a.p2.funkcja_wewnetrzna:=ComboBox18.ItemIndex;
  a.p2.kod_wewnetrzny:=SpinEdit49.Value;
  a.p2.operacja_zewnetrzna:=CheckBox18.Checked;
  a.p2.klik:=SpinEdit50.Value;
  a.p2.dwuklik:=SpinEdit51.Value;
  a.p3.funkcja_wewnetrzna:=ComboBox19.ItemIndex;
  a.p3.kod_wewnetrzny:=SpinEdit52.Value;
  a.p3.operacja_zewnetrzna:=CheckBox19.Checked;
  a.p3.klik:=SpinEdit53.Value;
  a.p3.dwuklik:=SpinEdit54.Value;
  a.p4.funkcja_wewnetrzna:=ComboBox20.ItemIndex;
  a.p4.kod_wewnetrzny:=SpinEdit55.Value;
  a.p4.operacja_zewnetrzna:=CheckBox20.Checked;
  a.p4.klik:=SpinEdit56.Value;
  a.p4.dwuklik:=SpinEdit57.Value;
  a.p5.funkcja_wewnetrzna:=ComboBox21.ItemIndex;
  a.p5.kod_wewnetrzny:=SpinEdit58.Value;
  a.p5.operacja_zewnetrzna:=CheckBox21.Checked;
  a.p5.klik:=SpinEdit59.Value;
  a.p5.dwuklik:=SpinEdit60.Value;
  a.suma45:=CheckBox24.Checked;
  write(f,a);
  closefile(f);
end;

procedure TFConfig.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFConfig.BitBtn1Click(Sender: TObject);
begin
  _DEF_MULTIMEDIA_SAVE_DIR:=DirectoryEdit1.Text;
  _DEF_SCREENSHOT_SAVE_DIR:=DirectoryEdit2.Text;
  _DEF_SCREENSHOT_FORMAT:=ComboBox1.ItemIndex;
  _DEF_COOKIES_FILE_YT:=FileNameEdit1.FileName;
  dm.SetConfig('default-directory-save-files',_DEF_MULTIMEDIA_SAVE_DIR);
  dm.SetConfig('default-directory-save-files-ss',_DEF_SCREENSHOT_SAVE_DIR);
  dm.SetConfig('default-screenshot-format',_DEF_SCREENSHOT_FORMAT);
  dm.SetConfig('default-cookies-file-yt',_DEF_COOKIES_FILE_YT);
  zapisz;
  close;
end;

{ TFConfig }

end.

