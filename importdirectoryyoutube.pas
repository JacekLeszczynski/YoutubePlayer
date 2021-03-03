unit ImportDirectoryYoutube;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls;

type

  { TFImportDirectoryYoutube }

  TFImportDirectoryYoutube = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    procedure import;
  public
    io_ok: boolean;
  end;

var
  FImportDirectoryYoutube: TFImportDirectoryYoutube;

implementation

uses
  ecode, serwis, main;

{$R *.lfm}

{ TFImportDirectoryYoutube }

procedure TFImportDirectoryYoutube.BitBtn2Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

procedure TFImportDirectoryYoutube.BitBtn3Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.PasteFromClipboard;
end;

procedure TFImportDirectoryYoutube.import;
var
  q,plik: TStrings;
  ss,s: string;
  a: integer;
  i: integer;
  link,nazwa: string;
  vstatus: integer;
begin
  q:=TStringList.Create;
  try
    ss:=Memo1.Text;
    while true do
    begin
      a:=pos('<a id="thumbnail"',ss);
      if a=0 then break;
      delete(ss,1,a+16);
      s:=ss;
      delete(s,1,a);
      a:=pos('href="/watch?v=',s);
      delete(s,1,a);
      a:=pos('"',s);
      delete(s,1,a);
      a:=pos('"',s);
      delete(s,a,maxint);
      a:=pos('&',s);
      if a>0 then delete(s,a,maxint);
      q.Add(s);
    end;
    dm.trans.StartTransaction;
    ProgressBar1.Max:=q.Count-1;
    ProgressBar1.Position:=0;
    if CheckBox1.Checked then
    begin
      plik:=TStringList.Create;
      try
        for i:=0 to q.Count-1 do
        begin
          s:=q[i];
          link:='https://www.youtube.com'+s;
          plik.Add('youtube-dl '+link);
        end;
        if SaveDialog1.Execute then plik.SaveToFile(SaveDialog1.FileName);
      finally
        plik.Free;
      end;
      exit;
    end;
    for i:=0 to q.Count-1 do
    begin
      s:=q[i];
      link:='https://www.youtube.com'+s;
      nazwa:=dm.GetTitleForYoutube(link);

      if (link='https://www.youtube.com') or (nazwa='IE=edge') then
      begin
        ProgressBar1.StepIt;
        ProgressBar1.Update;
        continue;
      end;

      Form1.filmy.Append;
      Form1.filmy.FieldByName('nazwa').AsString:=nazwa;
      Form1.filmy.FieldByName('link').AsString:=link;
      Form1.filmy.FieldByName('plik').Clear;
      Form1.filmyfile_audio.Clear;
      if Form1.db_roz.FieldByName('id').AsInteger=0 then Form1.filmy.FieldByName('rozdzial').Clear
      else Form1.filmy.FieldByName('rozdzial').AsInteger:=Form1.db_roz.FieldByName('id').AsInteger;
      vstatus:=0;
      Form1.filmystatus.AsInteger:=vstatus;
      Form1.filmy.Post;
      dm.dbini.Execute;

      ProgressBar1.StepIt;
      application.ProcessMessages;
    end;
    dm.trans.Commit;
  finally
    q.Free;
  end;
end;

procedure TFImportDirectoryYoutube.BitBtn1Click(Sender: TObject);
begin
  import;
  io_ok:=true;
  close;
end;

end.

