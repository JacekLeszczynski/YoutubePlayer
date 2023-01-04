unit ImportDirectoryYoutube;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, ZDataset, ZStoredProcedure;

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
    addfilm: TZStoredProc;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    procedure import;
  public
    io_roz: integer;
    io_ok: boolean;
  end;

//var
//  FImportDirectoryYoutube: TFImportDirectoryYoutube;

implementation

uses
  ecode_c, serwis, main;

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

procedure TFImportDirectoryYoutube.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFImportDirectoryYoutube.import;
var
  q,plik: TStrings;
  ss,s: string;
  a: integer;
  ile,i: integer;
  link,nazwa: string;
  vstatus: integer;
  dt: TDate;
  b: boolean;
begin
  q:=TStringList.Create;
  try
    ile:=0;
    ss:=Memo1.Text;
    while true do
    begin
      inc(ile);
      a:=pos('rel="null"',ss);
      if a=0 then break;
      delete(ss,1,a+16);
      s:=copy(ss,1,100);
      a:=pos('"',s);
      delete(s,a,maxint);
      a:=pos('&',s);
      if a>0 then delete(s,a,maxint);
      q.Add(s);
    end;
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

    for i:=q.Count-1 downto 0 do
    begin
      s:=q[i];
      link:='https://www.youtube.com'+s;

      if (link='https://www.youtube.com') or (nazwa='IE=edge') then
      begin
        ProgressBar1.StepIt;
        ProgressBar1.Update;
        continue;
      end;

      addfilm.ParamByName('a_link').AsString:=link;
      addfilm.ParamByName('a_rozdzial').AsInteger:=io_roz;
      addfilm.ParamByName('a_status').AsInteger:=0;
      addfilm.ExecProc;

      ProgressBar1.StepIt;
      application.ProcessMessages;
    end;
    Form1.filmy.Refresh;
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

