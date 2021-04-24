unit MojProfil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, ExtMessage, uETilePanel, DCPrijndael,
  DCPsha512, ZDataset;

type
  TCertyfWizytowka = packed record
    io: string[12];
    klucz: string[24];
    nazwa,imie,nazwisko,email: string[50];
    opis,url: string[255];
  end;

type

  { TFMojProfil }

  TFMojProfil = class(TForm)
    aes: TDCP_rijndael;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    dane: TZQuery;
    daneemail: TMemoField;
    daneid: TLargeintField;
    daneimie: TMemoField;
    daneklucz: TMemoField;
    danenazwa: TMemoField;
    danenazwisko: TMemoField;
    daneopis: TMemoField;
    daneurl: TMemoField;
    DBEdit6: TDBEdit;
    dsdane: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Label9: TLabel;
    MarginesB: TLabel;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SDialog: TSaveDialog;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _SetText(Sender: TField; const aText: string);
    procedure _GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
  public
    io_id: integer;
  end;

var
  FMojProfil: TFMojProfil;

implementation

uses
  lcltype, main_monitor, serwis, ecode;

{$R *.lfm}

{ TFMojProfil }

procedure TFMojProfil.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dane.Close;
  CloseAction:=caFree;
end;

procedure TFMojProfil.BitBtn1Click(Sender: TObject);
begin
  dane.Cancel;
  close;
end;

procedure TFMojProfil.BitBtn2Click(Sender: TObject);
begin
  if danenazwa.AsString='' then
  begin
    mess.ShowInformation('Pole nazwa jest wymagane, wypełnij je i spróbuj jeszcze raz.');
    exit;
  end;
  dane.Post;
  close;
end;

procedure TFMojProfil.BitBtn3Click(Sender: TObject);
var
  ss: TStringList;
  plik,s: string;
  a: ^TCertyfWizytowka;
  tab1,tab2: array [0..65535] of byte;
  vec: string;
  size,i: integer;
  b1: byte;
begin
  if danenazwa.IsNull or (danenazwa.AsString='') then
  begin
    mess.ShowInformation('Wypełnij najpierw pole nazwa/nick.');
    exit;
  end;
  if SDialog.Execute then plik:=SDialog.FileName;
  if plik='' then exit;
  (* generowanie wizytówki *)
  a:=@tab1[0];
  a^.io:='{WIZYTOWKA}';
  a^.klucz:=DecryptString(daneklucz.AsString,dm.GetHashCode(3),true);
  a^.nazwa:=danenazwa.AsString;
  if CheckBox2.Checked then a^.imie:=daneimie.AsString else a^.imie:='';
  if CheckBox3.Checked then a^.nazwisko:=danenazwisko.AsString else a^.nazwisko:='';
  if CheckBox4.Checked then a^.email:=daneemail.AsString else a^.email:='';
  if CheckBox5.Checked then a^.opis:=daneopis.AsString else a^.opis:='';
  if CheckBox6.Checked then a^.url:=daneurl.AsString else a^.url:='';
  vec:=dm.GetHashCode(6);
  size:=CalcBuffer(sizeof(TCertyfWizytowka),16);
  aes.InitStr(vec,TDCP_sha512);
  aes.Encrypt(&tab1[0],&tab2[0],size);
  aes.Burn;
  ss:=TStringList.Create;
  try
    ss.Add('-----BEGIN STUDIO JAHU CONTACT-----');
    s:='';
    for i:=0 to size-1 do
    begin
      b1:=tab2[i];
      s:=s+IntToHex(b1,2);
      if length(s)>69 then
      begin
        ss.Add(s);
        s:='';
      end;
    end;
    if length(s)>69 then
    begin
      ss.Add(s);
      s:='';
    end;
    ss.Add('-----END STUDIO JAHU CONTACT-----');
    ss.SaveToFile(plik);
  finally
    ss.Free;
  end;
  mess.ShowInformation('Wizytówka wygenerowana.');
end;

procedure TFMojProfil.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then BitBtn1.Click;
end;

procedure TFMojProfil.FormShow(Sender: TObject);
begin
  if dane.Active then exit;
  BitBtn3.Visible:=io_id=0;
  CheckBox1.Visible:=BitBtn3.Visible;
  CheckBox2.Visible:=BitBtn3.Visible;
  CheckBox3.Visible:=BitBtn3.Visible;
  CheckBox4.Visible:=BitBtn3.Visible;
  CheckBox5.Visible:=BitBtn3.Visible;
  CheckBox6.Visible:=BitBtn3.Visible;
  dane.ParamByName('id').AsInteger:=io_id;
  dane.Open;
  if dane.RecordCount=0 then
  begin
    dane.Append;
    daneid.AsInteger:=io_id;
  end else dane.Edit;
end;

procedure TFMojProfil._SetText(Sender: TField; const aText: string);
begin
  Sender.AsString:=aText;
end;

procedure TFMojProfil._GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText:=Sender.AsString;
end;

end.

