unit KontoExport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ExtMessage, DB, uETilePanel, DCPrijndael, DCPsha512, ZDataset;

type

  { TFExport }

  TFExportOnRequestRegisterKeyEvent = procedure (aKey: string; aUsunStaryKlucz: boolean) of object;
  TFExport = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    aes: TDCP_rijndael;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    dane: TZQuery;
    daneemail: TMemoField;
    daneid: TLargeintField;
    daneimie: TMemoField;
    daneklucz: TMemoField;
    danenazwa: TMemoField;
    danenazwisko: TMemoField;
    daneopis: TMemoField;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ODialog: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    SDialog: TSaveDialog;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FOnRequestRegisterKey: TFExportOnRequestRegisterKeyEvent;
  public
    io_refresh: boolean;
  published
    property OnRequestRegisterKey: TFExportOnRequestRegisterKeyEvent read FOnRequestRegisterKey write FOnRequestRegisterKey;
  end;

var
  FExport: TFExport;

implementation

uses
  ecode, serwis;

{$R *.lfm}

type
  TCertyf = packed record
    io: string[12];
    klucz: string[255];
    nazwa,opis,imie,nazwisko,email: string[255];
  end;

{ TFExport }

procedure TFExport.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFExport.BitBtn3Click(Sender: TObject);
var
  ss: TStringList;
  s1,s: string;
  a: ^TCertyf;
  i,j,l: integer;
var
  vec: string;
  size: integer;
  tab1,tab2: array [0..65535] of byte;
begin
  s1:=Edit3.Text;
  if s1='' then
  begin
    mess.ShowWarning('Brak hasła zabezpieczającego,^wprowadź hasło zabezpieczające i spróbuj ponownie.');
    exit;
  end;
  if not ODialog.Execute then exit;
  ss:=TStringList.Create;
  try
    ss.LoadFromFile(ODialog.FileName);
    s:=ss[0];
    if s<>'-----BEGIN STUDIO JAHU CERTIFICAT-----' then
    begin
      mess.ShowInformation('To nie jest prawidłowy plik Certyfikatu Tożsamości!');
      exit;
    end;
    s:=ss[ss.Count-1];
    if s<>'-----END STUDIO JAHU CERTIFICAT-----' then
    begin
      mess.ShowInformation('To nie jest prawidłowy plik Certyfikatu Tożsamości!');
      exit;
    end;
    l:=0;
    for i:=1 to ss.Count-2 do
    begin
      s:=ss[i];
      for j:=1 to round(length(s)/2) do
      begin
        s1:=copy(s,j*2-1,2);
        tab1[l]:=HexToDec(s1);
        inc(l);
      end;
    end;
    size:=l;
  finally
    ss.Free;
  end;
  vec:=Edit3.Text+dm.GetHashCode(5);
  aes.InitStr(vec,TDCP_sha512);
  aes.Decrypt(&tab1[0],&tab2[0],size);
  aes.Burn;
  a:=@tab2[0];
  if a^.io<>'{CERTYFIKAT}' then
  begin
    mess.ShowInformation('Podane hasło zabezpieczające jest niewłaściwe, konto nie może zostać odtworzone.');
    exit;
  end;
  (* zapis danych do tabeli *)
  if dane.IsEmpty then
  begin
    dane.Append;
    daneid.AsInteger:=0;
  end else dane.Edit;
  danenazwa.AsString:=a^.nazwa;
  daneopis.AsString:=a^.opis;
  daneimie.AsString:=a^.imie;
  danenazwisko.AsString:=a^.nazwisko;
  daneemail.AsString:=a^.email;
  dane.Post;
  io_refresh:=true;
  (* wszystko *)
  mess.ShowInformation('Dane zostały odtworzone, zostanie wysłane żądanie rejestrujące tożsamość do serwera zdalnego, jeśli nie otrzymasz informacji, że zmiana została zarejestrowana, spróbuj zaimportować tożsamość jeszcze raz.');
  (* wysłanie żądania aktualizacji tożsamości - stara tożsamość zostanie usunięta  *)
  if assigned(FOnRequestRegisterKey) then FOnRequestRegisterKey(a^.klucz,not CheckBox1.Checked);
end;

procedure TFExport.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then if not mess.ShowWarningYesNo('Stara tożsamość nie zostanie usunięta!^Rozważ bardzo świadomie, czy faktycznie zechcesz ją zachować!^^Czy chcesz ją naprawdę zachować?') then CheckBox1.Checked:=false;
end;

procedure TFExport.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dane.Close;
end;

procedure TFExport.BitBtn1Click(Sender: TObject);
var
  ss: TStringList;
  s1,s2,s: string;
  a: ^TCertyf;
  i: integer;
  b1: byte;
var
  vec: string;
  size: integer;
  tab1,tab2: array [0..65535] of byte;
begin
  s1:=Edit1.Text;
  s2:=Edit2.Text;
  if (s1<>s2) or (s1='') then
  begin
    mess.ShowWarning('Brak hasła zabezpieczającego lub hasła się różnią,^wprowadź hasło zabezpieczające i spróbuj ponownie.');
    exit;
  end;
  if not SDialog.Execute then exit;
  //EncryptString(DecryptString(klucz,GetHashCode(3),true),dm.GetHashCode(5),1024);
  a:=@tab1[0];
  a^.io:='{CERTYFIKAT}';
  a^.klucz:=DecryptString(daneklucz.AsString,dm.GetHashCode(3),true);
  a^.nazwa:=danenazwa.AsString;
  a^.opis:=daneopis.AsString;
  a^.imie:=daneimie.AsString;
  a^.nazwisko:=danenazwisko.AsString;
  a^.email:=daneemail.AsString;
  vec:=s1+dm.GetHashCode(5);;
  size:=CalcBuffer(sizeof(TCertyf),16);
  aes.InitStr(vec,TDCP_sha512);
  aes.Encrypt(&tab1[0],&tab2[0],size);
  aes.Burn;
  ss:=TStringList.Create;
  try
    ss.Add('-----BEGIN STUDIO JAHU CERTIFICAT-----');
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
    ss.Add('-----END STUDIO JAHU CERTIFICAT-----');
    ss.SaveToFile(SDialog.FileName);
  finally
    ss.Free;
  end;
  mess.ShowInformation('Certyfikat tożsamości został zapisany do pliku.');
end;

procedure TFExport.FormCreate(Sender: TObject);
begin
  io_refresh:=false;
  dane.Open;
end;

end.

