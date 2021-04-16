unit Pobieranie;

{
INFO:   Moduł domyślnie ma nawiązywać połączenie ze zdalnym hostem MPLAYER.HQ,
        następnie odnajdywać najnowsze binarki pod windows w wersji 32bit-generic,
        następnie ma ją ściągnąć i rozpakować do właściwego katalogu.
STATUS: Na razie w fazie testów.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ColorProgress, ExtMessage, HTTPSend, BlckSock,
  ssl_openssl, ssl_openssl_lib, AbUnzper, AbArcTyp, AbUtils;

type

  { TFPobieranie }

  TFPobieranie = class(TForm)
    Label3: TLabel;
    mess: TExtMessage;
    Label2: TLabel;
    unzip: TAbUnZipper;
    zrodlo: TLabel;
    Label4: TLabel;
    cel: TLabel;
    pr: TColorProgress;
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure unzipArchiveProgress(Sender: TObject; Progress: Byte;
      var Abort: Boolean);
    procedure unzipConfirmOverwrite(var AName: string; var AConfirm: Boolean);
    procedure unzipConfirmProcessItem(Sender: TObject; AItem: TAbArchiveItem;
      AProcessType: TAbProcessType; var AConfirm: Boolean);
  private
    { private declarations }
    START: boolean;
    procedure SockCallBack(Sender: TObject; Reason: THookSocketReason; const Value: string);
  public
    { public declarations }
    base_directory: string;
    tytul: string;
    hide_dest_filename: boolean;
    show_info_end: boolean;
    info_end_caption: string;
    link_download: string;
    plik: string;
    unzipping: boolean;
    delete_for_exit: boolean;
  end; 

var
  FPobieranie: TFPobieranie;

implementation

uses
  strutils, ecode;

var
  H: THTTPSend;

{$R *.lfm}

function DownloadHTTPStream(URL: string; Buffer: TStream): boolean;
  // Download file; retry if necessary.
const
  MaxRetries = 3;
var
  RetryAttempt: integer;
  HTTPGetResult: boolean;
begin
  Result:=false;
  RetryAttempt := 1;
  HTTPGetResult := False;
  while ((HTTPGetResult = False) and (RetryAttempt < MaxRetries)) do
  begin
    HTTPGetResult := HttpGetBinary(URL, Buffer);
    //Application.ProcessMessages;
    Sleep(100 * RetryAttempt);
    RetryAttempt := RetryAttempt + 1;
  end;
  if HTTPGetResult = False then
    raise Exception.Create('Cannot load document from remote server');
  Buffer.Position := 0;
  if Buffer.Size = 0 then
    raise Exception.Create('Downloaded document is empty.');
  Result := True;
end;

function SFDirectLinkURL(URL: string; Document: TMemoryStream): string;
{
Transform this part of the body:
<noscript>
<meta http-equiv="refresh" content="5; url=http://downloads.sourceforge.net/project/base64decoder/base64decoder/version%202.0/b64util.zip?r=&amp;ts=1329648745&amp;use_mirror=kent">
</noscript>
into a valid URL:
http://downloads.sourceforge.net/project/base64decoder/base64decoder/version%202.0/b64util.zip?r=&amp;ts=1329648745&amp;use_mirror=kent
}
const
  Refresh='<meta http-equiv="refresh"';
  URLMarker='url=';
var
  Counter: integer;
  HTMLBody: TStringList;
  RefreshStart: integer;
  URLStart: integer;
begin
  HTMLBody:=TStringList.Create;
  try
    HTMLBody.LoadFromStream(Document);
    for Counter:=0 to HTMLBody.Count-1 do
    begin
      // This line should be between noscript tags and give the direct download locations:
      RefreshStart:=Ansipos(Refresh, HTMLBody[Counter]);
      if RefreshStart>0 then
      begin
        URLStart:=AnsiPos(URLMarker, HTMLBody[Counter])+Length(URLMarker);
        if URLStart>RefreshStart then
        begin
          // Look for closing "
          URL:=Copy(HTMLBody[Counter],
            URLStart,
            PosEx('"',HTMLBody[Counter],URLStart+1)-URLStart);
          //infoln('debug: new url after sf noscript:');
          //infoln(URL);
          break;
        end;
      end;
    end;
  finally
    HTMLBody.Free;
  end;
  result:=URL;
end;

function SourceForgeURL(URL: string): string;
// Detects sourceforge download and tries to deal with
// redirection, and extracting direct download link.
// Thanks to
// Ocye: http://lazarus.freepascal.org/index.php/topic,13425.msg70575.html#msg70575
const
  SFProjectPart = '//sourceforge.net/projects/';
  SFFilesPart = '/files/';
  SFDownloadPart ='/download';
var
  HTTPSender: THTTPSend;
  i, j: integer;
  FoundCorrectURL: boolean;
  SFDirectory: string; //Sourceforge directory
  SFDirectoryBegin: integer;
  SFFileBegin: integer;
  SFFilename: string; //Sourceforge name of file
  SFProject: string;
  SFProjectBegin: integer;
begin
  // Detect SourceForge download; e.g. from URL
  //          1         2         3         4         5         6         7         8         9
  // 1234557890123456789012345578901234567890123455789012345678901234557890123456789012345578901234567890
  // http://sourceforge.net/projects/base64decoder/files/base64decoder/version%202.0/b64util.zip/download
  //                                 ^^^project^^^       ^^^directory............^^^ ^^^file^^^
  FoundCorrectURL:=true; //Assume not a SF download
  i:=Pos(SFProjectPart, URL);
  if i>0 then
  begin
    // Possibly found project; now extract project, directory and filename parts.
    SFProjectBegin:=i+Length(SFProjectPart);
    j := PosEx(SFFilesPart, URL, SFProjectBegin);
    if (j>0) then
    begin
      SFProject:=Copy(URL, SFProjectBegin, j-SFProjectBegin);
      SFDirectoryBegin:=PosEx(SFFilesPart, URL, SFProjectBegin)+Length(SFFilesPart);
      if SFDirectoryBegin>0 then
      begin
        // Find file
        // URL might have trailing arguments... so: search for first
        // /download coming up from the right, but it should be after
        // /files/
        i:=RPos(SFDownloadPart, URL);
        // Now look for previous / so we can make out the file
        // This might perhaps be the trailing / in /files/
        SFFileBegin:=RPosEx('/',URL,i-1)+1;

        if SFFileBegin>0 then
        begin
          SFFilename:=Copy(URL,SFFileBegin, i-SFFileBegin);
          //Include trailing /
          SFDirectory:=Copy(URL, SFDirectoryBegin, SFFileBegin-SFDirectoryBegin);
          FoundCorrectURL:=false;
        end;
      end;
    end;
  end;

  if not FoundCorrectURL then
  begin
    try
      // Rewrite URL if needed for Sourceforge download redirection
      // Detect direct link in HTML body and get URL from that
      HTTPSender := THTTPSend.Create;
      //Who knows, this might help:
      HTTPSender.UserAgent:='curl/7.21.0 (i686-pc-linux-gnu) libcurl/7.21.0 OpenSSL/0.9.8o zlib/1.2.3.4 libidn/1.18';
      while not FoundCorrectURL do
      begin
        HTTPSender.HTTPMethod('GET', URL);
        //infoln('debug: headers:');
        //infoln(HTTPSender.Headers.Text);
        case HTTPSender.Resultcode of
          301, 302, 307:
            begin
              for i := 0 to HTTPSender.Headers.Count - 1 do
                if (Pos('Location: ', HTTPSender.Headers.Strings[i]) > 0) or
                  (Pos('location: ', HTTPSender.Headers.Strings[i]) > 0) then
                begin
                  j := Pos('use_mirror=', HTTPSender.Headers.Strings[i]);
                  if j > 0 then
                    URL :=
                      'http://' + RightStr(HTTPSender.Headers.Strings[i],
                      length(HTTPSender.Headers.Strings[i]) - j - 10) +
                      '.dl.sourceforge.net/project/' +
                      SFProject + '/' + SFDirectory + SFFilename
                  else
                    URL:=StringReplace(
                      HTTPSender.Headers.Strings[i], 'Location: ', '', []);
                  HTTPSender.Clear;//httpsend
                  FoundCorrectURL:=true;
                  break; //out of rewriting loop
              end;
            end;
          100..200:
            begin
              //Assume a sourceforge timer/direct link page
              URL:=SFDirectLinkURL(URL, HTTPSender.Document); //Find out
              FoundCorrectURL:=true; //We're done by now
            end;
          500: raise Exception.Create('No internet connection available');
            //Internal Server Error ('+aURL+')');
          else
            raise Exception.Create('Download failed with error code ' +
              IntToStr(HTTPSender.ResultCode) + ' (' + HTTPSender.ResultString + ')');
        end;//case
      end;//while
      //infoln('debug: resulting url after sf redir: *' + URL + '*');
    finally
      HTTPSender.Free;
    end;
  end;
  result:=URL;
end;

{ TFPobieranie }

resourcestring
  STR_001 = 'Właśnie trwa pobieranie pliku, proszę czekać...';
  STR_002 = 'Rozpakowuję zawartość pliku...';
  STR_003 = 'Plik został pobrany.';
  STR_004 = 'Lokalny system plików';

procedure TFPobieranie.Timer1Timer(Sender: TObject);
var
  URL: string;
begin
  Timer1.Enabled:=false;
  Label1.Caption:=STR_001;
  application.ProcessMessages;
  pr.Progress:=0;
  //pr.MaxValue:=1;
  if pos('/sourceforge.net/',link_download)>0 then URL:=SourceForgeURL(link_download)
                                              else URL:=link_download;
  H:=THTTPSend.Create;
  try
    H.ProxyHost:='';
    H.ProxyPort:='';
    H.Sock.OnStatus:=@SockCallBack;
    H.HTTPMethod('GET',URL);
    H.Document.SaveToFile(plik);
  finally
    H.Free;
  end;
  pr.Progress:=pr.MaxValue;
  sleep(200);

  if unzipping then
  begin
    pr.BackColor:=clMoneyGreen;
    pr.ForeColor:=clYellow;
    pr.Progress:=0;
    pr.MaxValue:=100;
    Application.ProcessMessages;
    Label1.Caption:=STR_002;
    application.ProcessMessages;
    unzip.BaseDirectory:=base_directory;
    unzip.FileName:=plik;
    unzip.ExtractFiles('*.*');
    sleep(200);
  end;

  if delete_for_exit then DeleteFile(plik);
  if show_info_end then
  begin
    if info_end_caption='' then mess.ShowInformation(STR_003)
                           else mess.ShowInformation(info_end_caption);
  end;
  close;
end;

procedure TFPobieranie.unzipArchiveProgress(Sender: TObject; Progress: Byte;
  var Abort: Boolean);
begin
  pr.Progress:=Progress;
end;

procedure TFPobieranie.unzipConfirmOverwrite(var AName: string;
  var AConfirm: Boolean);
begin
  AConfirm:=true;
end;

procedure TFPobieranie.unzipConfirmProcessItem(Sender: TObject;
  AItem: TAbArchiveItem; AProcessType: TAbProcessType; var AConfirm: Boolean);
begin
  AConfirm:=true;
end;

procedure TFPobieranie.SockCallBack(Sender: TObject; Reason: THookSocketReason;
  const Value: string);
begin
  if H.DownloadSize > 0 then
  begin
    //if pr.MaxValue=0 then pr.MaxValue:=H.DownloadSize;
    pr.MaxValue:=H.DownloadSize;
    if (Reason=HR_ReadCount) then pr.Progress:=pr.Progress+StrToInt(Value);
    Application.ProcessMessages;
  end;
end;

procedure TFPobieranie.FormShow(Sender: TObject);
begin
  if START then
  begin
    START:=false;
    Application.ProcessMessages;
    Caption:=tytul;
    zrodlo.Caption:=link_download;
    if hide_dest_filename then cel.Caption:=STR_004 else cel.Caption:=plik;
    Timer1.Enabled:=true;
  end;
end;

procedure TFPobieranie.FormCreate(Sender: TObject);
begin
  pr.BackColor:=clWhite;
  pr.ForeColor:=clMoneyGreen;
  START:=true;
end;

end.

