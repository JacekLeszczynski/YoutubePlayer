unit rozdzial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, EditBtn, Spin, FileCtrl, ExtMessage, LuksCrypter, ZDataset;

type

  { TFRozdzial }

  TFRozdzial = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    blokiid: TLargeintField;
    blokinazwa: TStringField;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
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
    cBloki: TComboBox;
    ComboBox5: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit2: TEdit;
    FileListBox1: TFileListBox;
    Label6: TLabel;
    mess: TExtMessage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lNazwa: TLabel;
    cNazwa: TEdit;
    lNazwa1: TLabel;
    Panel1: TPanel;
    bloki: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    starter: boolean;
    ssBloki: TStringList;
    procedure wczytaj_bloki;
    procedure odczyt(aSetEnabled: boolean = true);
    procedure zapis;
    function test_crypted: boolean;
  public
    luks: TLuksCrypter;
    io_id_bloku: integer;
    io_nazwa,io_dir: string;
    io_sort,io_autosort,io_nomem,io_noarchive,io_novideo,io_normalize_audio,io_chroniony: boolean;
    io_zmiany,io_poczekalnia,io_ignoruj,io_crypted,io_crypted2: boolean;
    io_format: integer;
    io_luks_nazwa: string;
    io_luks_wielkosc: integer;
    io_luks_jednostka,io_fstype: string;
  end;

var
  FRozdzial: TFRozdzial;

{
function wewnCopyFile(src,dest,passwd: string): boolean;
var
  p: TProcess;
begin
  p:=TProcess.Create(nil);
  try
    p.Options:=[poWaitOnExit];
    p.Executable:='/bin/sh';
    p.Parameters.Add('-c');
    p.Parameters.Add('echo '+passwd+' | sudo -S cp -f "'+src+'" "'+dest+'"');
    p.Execute;
  finally
    p.Terminate(0);
    p.Free;
  end;
  result:=p.ExitStatus=0;
end;
}

implementation

uses
  ecode, serwis;

{$R *.lfm}

{ TFRozdzial }

procedure TFRozdzial.FormShow(Sender: TObject);
begin
  if starter then odczyt;
end;

procedure TFRozdzial.wczytaj_bloki;
begin
  bloki.Open;
  while not bloki.EOF do
  begin
    ssBloki.Add(blokiid.AsString);
    cBloki.Items.Add(blokinazwa.AsString);
    bloki.Next;
  end;
  bloki.Close;
end;

procedure TFRozdzial.BitBtn3Click(Sender: TObject);
begin
  odczyt(false);
end;

procedure TFRozdzial.ComboBox4Change(Sender: TObject);
begin
  if ComboBox4.Text='' then ComboBox4.Text:='[auto]';
end;

procedure TFRozdzial.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  Key:=ecode.OnlyNumeric(Key);
end;

procedure TFRozdzial.FormCreate(Sender: TObject);
var
  i: integer;
begin
  ssBloki:=TStringList.Create;
  wczytaj_bloki;
  ComboBox1.Clear;
  ComboBox1.Items.BeginUpdate;
  for i:=0 to _genre-1 do ComboBox1.Items.Add(_genre2[i]);
  ComboBox1.Items.EndUpdate;
  ComboBox1.ItemIndex:=StringToItemIndex(ComboBox1.Items,'None');
  starter:=true;
end;

procedure TFRozdzial.FormDestroy(Sender: TObject);
begin
  ssBloki.Free;
end;

procedure TFRozdzial.BitBtn2Click(Sender: TObject);
var
  pass,plik,nazwa,kontener,tmp: string; //sciezka do konteneru
  b,bs,sa_pliki: boolean;
  ss: TStringList;
  i: integer;
  jedn: TLuksCrypterUnits;
  err: string;
begin
  if trim(cNazwa.Text)='' then exit;
  zapis;
  if not test_crypted then
  begin
    mess.ShowWarning('Nieprawidłowa konfiguracja kontenera luks, wprowadź poprawne wartości i spróbuj jeszcze raz, lub anuluj.');
    exit;
  end;
  if io_crypted<>io_crypted2 then
  begin
    bs:=false;
    err:='';
    ss:=TStringList.Create;
    try
      if io_crypted then
      begin
        (* ZASZYFROWANIE KATALOGU *)
        (* prośba o wpisanie hasła *)
        pass:=PasswordBox('Hasło chroniące wolumin','Podaj hasło:');
        application.ProcessMessages;
        if pass='' then exit;
        (* reszta *)
        mess.ShowInfo('Szyfrowanie katalogu...');
        application.ProcessMessages;
        bs:=true;
        plik:=dm.GetLuksKontenerFilename(io_nazwa,io_dir,io_luks_nazwa); // db_rozluks_kontener.AsString;
        if FileExists(plik) then
        begin
          err:='Plik kontenera już istnieje, przerywam!';
          exit;
        end;
        nazwa:=StringReplace(plik,'.','',[rfReplaceAll]);
        kontener:=MyConfDir(plik);
        (* sprawdzam czy katalog jest pusty, czy są w nim jakies pliki *)
        FileListBox1.Directory:=DirectoryEdit1.Directory;
        FileListBox1.UpdateFileList;
        ss.Assign(FileListBox1.Items);
        for i:=ss.Count-1 downto 0 do
        begin
          if ss[i]='.' then ss.Delete(i) else
          if ss[i]='..' then ss.Delete(i);
        end;
        sa_pliki:=ss.Count=0;
        (* jeśli katalog nie jest pusty *)
        if sa_pliki then
        begin
          tmp:=DirectoryEdit1.Directory+'.tmp';
          if not RenameFile(DirectoryEdit1.Directory,tmp) then
          begin
            err:='Katalog nie jest pusty i nie można zmienić katalogu, przerywam!';
            exit;
          end;
          mkdir(DirectoryEdit1.Directory);
        end;
        (* tworzę kontener *)
        if io_luks_jednostka='B' then jedn:=ucBajt else
        if io_luks_jednostka='K' then jedn:=ucKiloBajt else
        if io_luks_jednostka='M' then jedn:=ucMegaBajt else
        if io_luks_jednostka='G' then jedn:=ucGigaBajt else
        if io_luks_jednostka='T' then jedn:=ucTeraBajt else
        begin
          err:='Coś jest źle z jednostką, przerywam!';
          exit;
        end;
        luks.PassOpen(pass);
        try
          if not luks.CreateFile(kontener,io_luks_wielkosc,jedn) then
          begin
            err:='Plik na kontener nie został stworzony, przerywam!';
            exit;
          end;
          if not luks.FormatFile(kontener,DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS)) then
          begin
            err:='Plik konteneru nie został prawidłowo sformatowany, przerywam!';
            exit;
          end;
          if not luks.Open(nazwa,io_nazwa,kontener,DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS)) then
          begin
            err:='Plik konteneru nie został prawidłowo otwarty, przerywam!';
            exit;
          end;
          if not luks.FormatImage(nazwa,io_fstype,DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS)) then
          begin
            err:='Otwarty plik konteneru na poziomie plików - nie został prawidłowo sformatowany, wychodzę.';
            exit;
          end;
          if sa_pliki then
          begin
            if luks.OpenAndMount(nazwa,io_nazwa,kontener,DirectoryEdit1.Directory,DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS)) then
            begin
              (* przekopiowanie danych - BEGIN *)
              (* przekopiowanie danych - END *)
              luks.UmountAndClose(nazwa,DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS));
            end else begin
              err:='Nie udało się zamontować kontenera, wychodzę.';
              exit;
            end;
          end else luks.Close(nazwa,DecryptStr(_DEF_SUDO_PASSWORD,CONST_PASS));
        finally
          luks.PassClose;
        end;

      end else begin
        (* ODSZYFROWANIE KATALOGU *)
        mess.ShowInfo('Odszyfrowywanie katalogu...');
        application.ProcessMessages;
        bs:=true;
      end;
    finally
      ss.Free;
      if bs then
      begin
        mess.HideInfo;
        application.ProcessMessages;
      end;
      if err<>'' then mess.ShowError(err);
    end;
  end;
  close;
end;

procedure TFRozdzial.BitBtn1Click(Sender: TObject);
begin
  io_zmiany:=false;
  close;
end;

procedure TFRozdzial.odczyt(aSetEnabled: boolean);
begin
  starter:=false;
  io_zmiany:=false;
  cNazwa.Text:=io_nazwa;
  DirectoryEdit1.Directory:=io_dir;
  cBloki.ItemIndex:=StringToItemIndex(ssBloki,IntToStr(io_id_bloku));
  CheckBox1.Checked:=io_sort;
  CheckBox2.Checked:=io_autosort;
  CheckBox3.Checked:=io_nomem;
  CheckBox4.Checked:=io_noarchive;
  CheckBox5.Checked:=io_novideo;
  CheckBox6.Checked:=io_normalize_audio;
  CombOBox2.ItemIndex:=io_format;
  CheckBox7.Checked:=io_chroniony;
  CheckBox8.Checked:=io_poczekalnia;
  CheckBox9.Checked:=io_ignoruj;
  CheckBox10.Checked:=io_crypted;
  io_crypted2:=io_crypted;
  ComboBox4.Text:=io_luks_nazwa;
  Edit2.Text:=IntToStr(io_luks_wielkosc);
  if io_luks_jednostka='B' then ComboBox3.ItemIndex:=0 else
  if io_luks_jednostka='K' then ComboBox3.ItemIndex:=1 else
  if io_luks_jednostka='M' then ComboBox3.ItemIndex:=2 else
  if io_luks_jednostka='G' then ComboBox3.ItemIndex:=3 else
  if io_luks_jednostka='T' then ComboBox3.ItemIndex:=4 else ComboBox3.ItemIndex:=2;
  ComboBox5.Text:=io_fstype;
  (* FLAGA: ENABLED *)
  if aSetEnabled then
  begin
    ComboBox4.Enabled:=not CheckBox10.Checked;
    Edit2.Enabled:=not CheckBox10.Checked;
    ComboBox3.Enabled:=not CheckBox10.Checked;
    ComboBox5.Enabled:=not CheckBox10.Checked;
  end;
end;

procedure TFRozdzial.zapis;
begin
  io_zmiany:=true;
  io_nazwa:=cNazwa.Text;
  io_dir:=DirectoryEdit1.Directory;
  io_id_bloku:=StrToInt(ssBloki[cBloki.ItemIndex]);
  io_sort:=CheckBox1.Checked;
  io_autosort:=CheckBox2.Checked;
  io_nomem:=CheckBox3.Checked;
  io_noarchive:=CheckBox4.Checked;
  io_novideo:=CheckBox5.Checked;
  io_normalize_audio:=CheckBox6.Checked;
  io_format:=CombOBox2.ItemIndex;
  io_chroniony:=CheckBox7.Checked;
  io_poczekalnia:=CheckBox8.Checked;
  io_ignoruj:=CheckBox9.Checked;
  io_crypted:=CheckBox10.Checked;
  io_luks_nazwa:=ComboBox4.Text;
  if Edit2.Text='' then io_luks_wielkosc:=0 else io_luks_wielkosc:=StrToInt(Edit2.Text);
  case ComboBox3.ItemIndex of
    0: io_luks_jednostka:='B';
    1: io_luks_jednostka:='K';
    2: io_luks_jednostka:='M';
    3: io_luks_jednostka:='G';
    4: io_luks_jednostka:='T';
  end;
  io_fstype:=ComboBox5.Text;
end;

function TFRozdzial.test_crypted: boolean;
var
  b: boolean;
begin
  b:=true;
  if io_crypted and (not io_crypted2) then
  begin
    if StrToInt(Edit2.Text)=0 then b:=false;
    if trim(io_dir)='' then b:=false;
  end;
  result:=b;
end;

end.

