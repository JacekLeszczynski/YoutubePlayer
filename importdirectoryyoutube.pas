unit ImportDirectoryYoutube;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, XMLPropStorage, ZDataset, ZStoredProcedure;

type

  { TFImportDirectoryYoutube }

  TFImportDirectoryYoutube = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    addfilm: TZStoredProc;
    propstorage: TXMLPropStorage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    function import: boolean;
  public
    io_roz: integer;
  end;

//var
//  FImportDirectoryYoutube: TFImportDirectoryYoutube;

implementation

uses
  ecode, serwis, main;

{$R *.lfm}

{ TFImportDirectoryYoutube }

procedure TFImportDirectoryYoutube.BitBtn2Click(Sender: TObject);
begin
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

procedure TFImportDirectoryYoutube.FormCreate(Sender: TObject);
begin
  PropStorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  PropStorage.Active:=true;
end;

function TFImportDirectoryYoutube.import: boolean;
var
  q,plik: TStrings;
  ss,s,s1,s2: string;
  a,a2,x: integer;
  ile,i,c,cl: integer;
  link,nazwa: string;
  vstatus: integer;
  dt: TDate;
  b: boolean;
begin
  result:=true;
  cl:=0;
  q:=TStringList.Create;
  try
    ile:=0;
    ss:=Memo1.Text;
    while true do
    begin
      inc(ile);
      a:=pos('rel="null"',ss);
      x:=a;
      if a>0 then
      begin
        delete(ss,1,a+16);
        s:=copy(ss,1,100);
        a:=pos('"',s);
        delete(s,a,maxint);
        a:=pos('&',s);
        if a>0 then delete(s,a,maxint);
        link:=s;
        (* szukam tytułu filmu *)
        a2:=pos('<yt-formatted-string id="video-title"',ss);
        if a2>0 then
        begin
          delete(ss,1,a2+37);
          a2:=pos('</div>',ss);
          s:=copy(ss,1,a2);
          a2:=pos('>',s);
          delete(s,1,a2);
          a2:=pos('<',s);
          delete(s,a2,maxint);
          s:=StringReplace(s,';','{$1}',[rfReplaceAll]);
          s:=StringReplace(s,'"','{$2}',[rfReplaceAll]);
          link:=link+';'+s;
        end;
        q.Add(link);
      end;
      if x=0 then break;
    end;
    if CheckBox3.Checked then
    begin
      Memo1.Clear;
      for i:=0 to q.Count-1 do Memo1.Lines.Add(q[i]);
      result:=false;
      exit;
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
          s1:=GetLineToStr(s,1,';');
          link:='https://www.youtube.com'+s1;
          plik.Add('youtube-dl '+link);
        end;
        if SaveDialog1.Execute then plik.SaveToFile(SaveDialog1.FileName);
      finally
        plik.Free;
      end;
      exit;
    end;

    if CheckBox2.Checked then
    begin
      for i:=q.Count-1 downto 0 do
      begin
        s:=q[i];
        s1:=GetLineToStr(s,1,';');
        s2:=GetLineToStr(s,2,';');
        link:='https://www.youtube.com'+s1;
        s2:=StringReplace(s2,'{$1}',';',[rfReplaceAll]);
        s2:=StringReplace(s2,'{$2}','"',[rfReplaceAll]);
        nazwa:=s2;

        if (link='https://www.youtube.com') or (nazwa='IE=edge') then
        begin
          inc(cl);
          ProgressBar1.StepIt;
          ProgressBar1.Update;
          continue;
        end;

        dm.film_link.ParamByName('rozdzial').AsInteger:=io_roz;
        dm.film_link.ParamByName('link').AsString:=link;
        dm.film_link.Open;
        c:=dm.film_link.Fields[0].AsInteger;
        dm.film_link.Close;

        if c>0 then
        begin
          inc(cl);
          ProgressBar1.StepIt;
          ProgressBar1.Update;
          continue;
        end;

        addfilm.ParamByName('a_link').AsString:=link;
        addfilm.ParamByName('a_rozdzial').AsInteger:=io_roz;
        addfilm.ParamByName('a_nazwa').AsString:=nazwa;
        addfilm.ParamByName('a_status').AsInteger:=0;
        addfilm.ExecProc;

        ProgressBar1.StepIt;
        application.ProcessMessages;
      end;
    end else begin
      for i:=0 to q.Count-1 do
      begin
        s:=q[i];
        s1:=GetLineToStr(s,1,';');
        s2:=GetLineToStr(s,2,';');
        link:='https://www.youtube.com'+s1;
        s2:=StringReplace(s2,'{$1}',';',[rfReplaceAll]);
        s2:=StringReplace(s2,'{$2}','"',[rfReplaceAll]);
        nazwa:=s2;

        if (link='https://www.youtube.com') or (nazwa='IE=edge') then
        begin
          inc(cl);
          ProgressBar1.StepIt;
          ProgressBar1.Update;
          continue;
        end;

        dm.film_link.ParamByName('rozdzial').AsInteger:=io_roz;
        dm.film_link.ParamByName('link').AsString:=link;
        dm.film_link.Open;
        c:=dm.film_link.Fields[0].AsInteger;
        dm.film_link.Close;

        if c>0 then
        begin
          inc(cl);
          ProgressBar1.StepIt;
          ProgressBar1.Update;
          continue;
        end;

        addfilm.ParamByName('a_link').AsString:=link;
        addfilm.ParamByName('a_rozdzial').AsInteger:=io_roz;
        addfilm.ParamByName('a_nazwa').AsString:=nazwa;
        addfilm.ParamByName('a_status').AsInteger:=0;
        addfilm.ExecProc;

        ProgressBar1.StepIt;
        application.ProcessMessages;
      end;
    end;
    Form1.filmy.Refresh;
  finally
    Label2.Caption:='Zaimportowanych: '+IntToStr(q.Count-cl)+' rekordów';
    q.Free;
  end;
end;

procedure TFImportDirectoryYoutube.BitBtn1Click(Sender: TObject);
begin
  if import then Memo1.Clear;
end;

end.

