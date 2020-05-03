unit youtube_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, AsyncProcess, Process;

type

  { TWatekYoutube }

  TWatekYoutube = class(TThread)
  private
    YTData: TAsyncProcess;
    link,directory: string;
    film: integer;
    plik1,plik2: string;
    zrobione: boolean;
    dowyswietlenia: string;
    fs: TFormatSettings;
    v_pos: integer;
    v_plik: string;
    procedure wyswietl;
    procedure wykonaj;
    procedure pobierz_pozycje;
    procedure progress_on;
    procedure Execute; override;
    procedure position_refresh;
    procedure film_refresh;
    procedure YTReadData(Sender: TObject);
  protected
  public
    Constructor Create;
    destructor Destroy; override;
  published
    //property OnProgressVisible: TWatekYoutubeProgressVisible read FOnProgressVisible write FOnProgressVisible;
  end;

implementation

uses
  main, lcltype;

{ TWatekYoutube }

procedure TWatekYoutube.wyswietl;
begin
  writeln(dowyswietlenia);
end;

procedure TWatekYoutube.wykonaj;
begin
  zrobione:=false;
  YTData.Parameters.Clear;
  YTData.Parameters.Add(link);
  YTData.CurrentDirectory:=directory;
  YTData.Execute;
  while YTData.Running and (not zrobione) do if self.Terminated then YTData.Terminate(0) else sleep(10);
  if YTData.Running then YTData.Terminate(0);
end;

procedure TWatekYoutube.pobierz_pozycje;
var
  b: boolean;
begin
  b:=Form1.GetYoutubeElement(link,film,directory);
  if b then
  begin
    plik1:='';
    plik2:='';
  end else link:='';
  if link='' then
  begin
    Form1.ProgressBar1.Visible:=false;
    Form1.SetYoutubeProcessOff;
  end;
end;

procedure TWatekYoutube.progress_on;
begin
  Form1.ProgressBar1.Position:=0;
  Form1.ProgressBar1.Visible:=true;
end;

procedure TWatekYoutube.Execute;
begin
  {pobieram dane}
  synchronize(@progress_on);
  while true do
  begin
    synchronize(@pobierz_pozycje);
    if link='' then break;
    wykonaj;
    sleep(10);
  end;
end;

procedure TWatekYoutube.position_refresh;
begin
  Form1.ProgressBar1.Position:=v_pos;
end;

procedure TWatekYoutube.film_refresh;
var
  q: string[1];
begin
  Form1.film.ParamByName('id').AsInteger:=film;
  Form1.film.Open;
  Form1.film.Edit;
  {$IFDEF LINUX}
  q:='/';
  {$ELSE}
  q:='\';
  {$ENDIF}
  Form1.film.FieldByName('plik').AsString:=YTData.CurrentDirectory+q+v_plik;
  Form1.film.Post;
  Form1.film.Close;
  Form1.rfilmy.Enabled:=true;
end;

procedure TWatekYoutube.YTReadData(Sender: TObject);
var
  s: string;
  str: TStringList;
  i,a: integer;
begin
  str:=TStringList.Create;
  try
    if YTData.Output.NumBytesAvailable>0 then
    begin
      str.LoadFromStream(YTData.Output);
      for i:=0 to str.Count-1 do
      begin
        s:=str[i];
        if s='' then continue;
        if pos('[download] Destination:',s)>0 then
        begin
          //ProgressBar1.Visible:=true;
          delete(s,1,23);
          s:=trim(StringReplace(s,'"','',[rfReplaceAll]));
          if plik1='' then plik1:=s else if plik2='' then plik2:=s;
        end else
        if pos('[download]',s)>0 then
        begin
          delete(s,1,10);
          s:=trim(StringReplace(s,'"','',[rfReplaceAll]));
          a:=pos('%',s);
          delete(s,a,1000);
          v_pos:=round(StrToFloat(s,fs)*10);
          synchronize(@position_refresh);
        end else
        if pos('[ffmpeg] Merging formats into',s)>0 then
        begin
          delete(s,1,29);
          v_plik:=trim(StringReplace(s,'"','',[rfReplaceAll]));
        end else
        if pos('Deleting original file',s)>0 then
        begin
          delete(s,1,22);
          s:=StringReplace(s,'"','',[rfReplaceAll]);
          a:=pos('(pass -k to keep)',s);
          delete(s,a,1000);
          s:=trim(s);
          if plik1=s then plik1:='';
          if plik2=s then plik2:='';
          if (plik1='') and (plik2='') then zrobione:=true;
          synchronize(@film_refresh);
        end;
      end;
    end;
  finally
    str.Free;
  end;
end;

constructor TWatekYoutube.Create;
begin
  Form1.SetYoutubeProcessOn;
  FreeOnTerminate:=true;
  YTData:=TAsyncProcess.Create(nil);
  YTData.Executable:='youtube-dl';
  YTData.Options:=[poUsePipes,poNoConsole];
  YTData.Priority:=ppNormal;
  YTData.ShowWindow:=swoNone;
  YTData.OnReadData:=@YTReadData;
  fs.DecimalSeparator:='.';
  inherited Create(false);
end;

destructor TWatekYoutube.Destroy;
begin
  if YTData.Running then YTData.Terminate(0);
  FreeAndNil(YTData);
  inherited Destroy;
end;

end.

