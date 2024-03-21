unit NormPathFilms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, DSMaster, ZQueryPlus, ExtMessage, DB, ZDataset, ZSqlUpdate;

type

  { TFNormPathFilms }

  TFNormPathFilms = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    blokiid: TLargeintField;
    blokinazwa: TStringField;
    blokisort: TLongintField;
    CheckBox1: TCheckBox;
    dsFilmy: TDataSource;
    mess: TExtMessage;
    filmy: TZQueryPlus;
    filmyaudio: TLongintField;
    filmyaudioeq: TStringField;
    filmydata_uploaded: TDateField;
    filmydata_uploaded_noexist: TSmallintField;
    filmydeinterlace: TSmallintField;
    filmyduration: TLongintField;
    filmyfiledate: TDateTimeField;
    filmyfile_audio: TStringField;
    filmyfile_subtitle: TStringField;
    filmyflaga_fragment_archiwalny: TSmallintField;
    filmyflaga_material_odszumiony: TSmallintField;
    filmyflaga_prawo_cytatu: TSmallintField;
    filmygatunek: TLargeintField;
    filmyglosnosc: TLongintField;
    filmyid: TLargeintField;
    filmyignoruj: TSmallintField;
    filmyindex_recreate: TSmallintField;
    filmyinfo: TMemoField;
    filmyinfo_delay: TLongintField;
    filmylang: TStringField;
    filmylink: TMemoField;
    filmymonitor_off: TSmallintField;
    filmynazwa: TMemoField;
    filmynotatki: TMemoField;
    filmyobs_mic_active: TSmallintField;
    filmyosd: TLongintField;
    filmyplay_video_negative: TSmallintField;
    filmyplik: TMemoField;
    filmypoczekalnia_indeks_czasu: TLongintField;
    filmyposition: TLongintField;
    filmyposition_dt: TDateTimeField;
    filmypredkosc: TLongintField;
    filmyresample: TLongintField;
    filmyrozdzial: TLargeintField;
    filmyrozdzielczosc: TStringField;
    filmystart0: TLongintField;
    filmystatus: TLongintField;
    filmytonacja: TLongintField;
    filmytranspose: TLongintField;
    filmyvideo_aspect_16x9: TSmallintField;
    filmywektor_yt_1: TLongintField;
    filmywektor_yt_2: TLongintField;
    filmywektor_yt_3: TLongintField;
    filmywektor_yt_4: TLongintField;
    filmywsp_czasu_yt: TLongintField;
    filmywzmocnienie: TSmallintField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    rozdzialy: TZQuery;
    dsBloki: TDataSource;
    dsRoz: TDataSource;
    master: TDSMaster;
    bloki: TZQuery;
    rozdzialyautosort: TSmallintField;
    rozdzialyautosortdesc: TSmallintField;
    rozdzialychroniony: TSmallintField;
    rozdzialycrypted: TSmallintField;
    rozdzialydirectory: TStringField;
    rozdzialyfilm_id: TLargeintField;
    rozdzialyformatfile: TLongintField;
    rozdzialyid: TLargeintField;
    rozdzialyid_bloku: TLargeintField;
    rozdzialyignoruj: TSmallintField;
    rozdzialyluks_fstype: TStringField;
    rozdzialyluks_jednostka: TStringField;
    rozdzialyluks_kontener: TStringField;
    rozdzialyluks_wielkosc: TLargeintField;
    rozdzialymonitor_off: TSmallintField;
    rozdzialynazwa: TStringField;
    rozdzialynoarchive: TSmallintField;
    rozdzialynomemtime: TSmallintField;
    rozdzialynormalize_audio: TSmallintField;
    rozdzialynovideo: TSmallintField;
    rozdzialypoczekalnia_zapis_czasu: TSmallintField;
    rozdzialysort: TLongintField;
    ZUpdateSQL1: TZUpdateSQL;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure filmyBeforeOpenII(Sender: TObject);
    procedure ZUpdateSQL1BeforeInsertSQL(Sender: TObject);
    procedure ZUpdateSQL1BeforeModifySQL(Sender: TObject);
  private
    function PobierzPlikFilmu(aDir, aFile: string; var aPlik: string): string;
  public
    io_refresh: boolean;
  end;

var
  FNormPathFilms: TFNormPathFilms;

implementation

uses
  ecode, keystd;

{$R *.lfm}

{ TFNormPathFilms }

procedure TFNormPathFilms.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFNormPathFilms.filmyBeforeOpenII(Sender: TObject);
begin
  filmy.ParamByName('pass').AsString:=globalny_h1;
end;

procedure TFNormPathFilms.ZUpdateSQL1BeforeInsertSQL(Sender: TObject);
begin
  ZUpdateSQL1.Params.ParamByName('pass').AsString:=globalny_h1;
end;

procedure TFNormPathFilms.ZUpdateSQL1BeforeModifySQL(Sender: TObject);
begin
  ZUpdateSQL1.Params.ParamByName('pass').AsString:=globalny_h1;
end;

function TFNormPathFilms.PobierzPlikFilmu(aDir, aFile: string; var aPlik: string): string;
var
  s: string;
begin
  aPlik:='';
  aFile:=ExtractFilename(aFile);
  result:='';
  (* szukam pliku w katalogu *)
  s:=aDir+_FF+aFile;
  while pos(_FF+_FF,s)>0 do s:=StringReplace(s,_FF+_FF,_FF,[rfReplaceAll]);
  if FileExists(s) then
  begin
    aPlik:=s;
    if aDir<>'' then
    begin
      delete(aPlik,1,length(aDir));
      if aPlik[1]=_FF then delete(aPlik,1,1);
    end;
    result:=s;
    exit;
  end;
  (* szukam pliku w ścieżce aFile *)
  s:=aFile;
  if FileExists(s) then
  begin
    aPlik:=s;
    result:=s;
  end;
end;

procedure TFNormPathFilms.BitBtn1Click(Sender: TObject);
var
  dir,plik,s: string;
  a,b: integer;
begin
  a:=0;
  b:=0;
  master.Open;
  try
    ProgressBar1.Max:=bloki.RecordCount;
    ProgressBar1.Position:=0;
    ProgressBar1.Update;
    while not bloki.EOF do
    begin
      ProgressBar2.Max:=rozdzialy.RecordCount;
      ProgressBar2.Position:=0;
      ProgressBar2.Update;
      while not rozdzialy.EOF do
      begin
        dir:=rozdzialydirectory.AsString;
        ProgressBar3.Max:=filmy.RecordCount;
        ProgressBar3.Position:=0;
        ProgressBar3.Update;
        while not filmy.EOF do
        begin
          inc(a);
          plik:=filmyplik.AsString;
          PobierzPlikFilmu(dir,plik,s);
          writeln('[ ] Sprawdzam: Directory="',dir,'" File="',plik,'"');
          if s<>'' then
          begin
            if plik<>s then
            begin
              inc(b);
              if CheckBox1.Checked then
              begin
                writeln('[*] Aktualizuję: Nowa wartość="',s,'"');
              end else begin
                filmy.Edit;
                filmyplik.AsString:=s;
                filmy.Post;
              end;
            end;
          end;
          ProgressBar3.StepIt;
          ProgressBar3.Update;
          filmy.Next;
        end;
        ProgressBar2.StepIt;
        ProgressBar2.Update;
        rozdzialy.Next;
      end;
      ProgressBar1.StepIt;
      ProgressBar1.Update;
      bloki.Next;
    end;
  finally
    master.Close;
  end;
  mess.ShowInformation('Operacja zakończona.^^Przeczytanych rekordów = '+IntToStr(a)+'^Zaktualizowanych rekordów = '+IntToStr(b));
end;

end.

