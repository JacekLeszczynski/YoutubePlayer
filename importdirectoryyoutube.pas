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
    Label1: TLabel;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
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
  q: TStrings;
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
      if trim(s)='https://www.youtube.com' then continue;
      q.Add(s);
    end;
    Form1.trans.StartTransaction;
    ProgressBar1.Max:=q.Count-1;
    ProgressBar1.Position:=0;
    for i:=0 to q.Count-1 do
    begin
      s:=q[i];
      link:='https://www.youtube.com'+s;
      nazwa:=dm.GetTitleForYoutube(link);

      //writeln('Importuję film:');
      //writeln('  nazwa=['+nazwa+']');
      //writeln('  link=['+link+']');

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
      Form1.ini.Execute;

      ProgressBar1.StepIt;
      ProgressBar1.Update;
    end;
    Form1.trans.Commit;
  finally
    q.Free;
  end;
{
<ytd-grid-video-renderer class="style-scope ytd-grid-renderer" lockup=""><!--css-build:shady--><div id="dismissable" class="style-scope ytd-grid-video-renderer"><ytd-thumbnail use-hovered-property="" class="style-scope ytd-grid-video-renderer"><!--css-build:shady-->

    <a id="thumbnail" class="yt-simple-endpoint inline-block style-scope ytd-thumbnail" aria-hidden="true" tabindex="-1" rel="null" href="/watch?v=mhS553xywxc">
      <yt-img-shadow ftl-eligible="" class="style-scope ytd-thumbnail no-transition" style="background-color: transparent;" loaded=""><!--css-build:shady--><img id="img" class="style-scope yt-img-shadow" alt="" width="210" src="https://i.ytimg.com/vi/mhS553xywxc/hqdefault.jpg?sqp=-oaymwEZCPYBEIoBSFXyq4qpAwsIARUAAIhCGAFwAQ==&amp;rs=AOn4CLA4LXdD7KkHlSc5yCJymbXUU9vS5Q"></yt-img-shadow>

      <div id="overlays" class="style-scope ytd-thumbnail"><ytd-thumbnail-overlay-time-status-renderer class="style-scope ytd-thumbnail" overlay-style="DEFAULT"><!--css-build:shady--><yt-icon class="style-scope ytd-thumbnail-overlay-time-status-renderer" disable-upgrade="" hidden=""></yt-icon><span class="style-scope ytd-thumbnail-overlay-time-status-renderer" aria-label="2 minuty i 46 sekund">
      2:46
    </span></ytd-thumbnail-overlay-time-status-renderer><ytd-thumbnail-overlay-now-playing-renderer class="style-scope ytd-thumbnail"><!--css-build:shady-->

    <span class="style-scope ytd-thumbnail-overlay-now-playing-renderer">Teraz odtwarzane</span>
  </ytd-thumbnail-overlay-now-playing-renderer></div>
      <div id="mouseover-overlay" class="style-scope ytd-thumbnail"></div>
      <div id="hover-overlays" class="style-scope ytd-thumbnail"></div>
    </a>
  </ytd-thumbnail><div id="details" class="style-scope ytd-grid-video-renderer"><div id="meta" class="style-scope ytd-grid-video-renderer"><h3 class="style-scope ytd-grid-video-renderer"><ytd-badge-supported-renderer class="style-scope ytd-grid-video-renderer" disable-upgrade="" hidden=""></ytd-badge-supported-renderer><a id="video-title" class="yt-simple-endpoint style-scope ytd-grid-video-renderer" aria-label="Co to Jest &quot;Front Butt?&quot; - Szybka Lekcja Angielskiego Autor: Dave z Ameryki 20 godzin temu 2 minuty i 46 sekund 9497 wyświetleń" title="Co to Jest &quot;Front Butt?&quot; - Szybka Lekcja Angielskiego" href="/watch?v=mhS553xywxc">Co to Jest "Front Butt?" - Szybka Lekcja Angielskiego</a></h3><div id="metadata-container" class="grid style-scope ytd-grid-video-renderer" meta-block=""><div id="metadata" class="style-scope ytd-grid-video-renderer"><div id="byline-container" class="style-scope ytd-grid-video-renderer" hidden=""><ytd-channel-name id="channel-name" class="style-scope ytd-grid-video-renderer"><!--css-build:shady-->

    <div id="container" class="style-scope ytd-channel-name">
      <div id="text-container" class="style-scope ytd-channel-name">
        <yt-formatted-string id="text" title="" class="style-scope ytd-channel-name" ellipsis-truncate=""></yt-formatted-string>
      </div>
      <paper-tooltip fit-to-visible-bounds="" offset="10" class="style-scope ytd-channel-name" role="tooltip" tabindex="-1"><!--css-build:shady-->


    <div id="tooltip" class="hidden style-scope paper-tooltip">



    </div>
</paper-tooltip>
    </div>
    <ytd-badge-supported-renderer class="style-scope ytd-channel-name" disable-upgrade="" hidden="">
    </ytd-badge-supported-renderer>
  </ytd-channel-name></div><div id="metadata-line" class="style-scope ytd-grid-video-renderer">
                  <span class="style-scope ytd-grid-video-renderer">9,4&nbsp;tys. wyświetleń</span>

                  <span class="style-scope ytd-grid-video-renderer">20 godzin temu</span>
                <dom-repeat strip-whitespace="" class="style-scope ytd-grid-video-renderer"><template is="dom-repeat"></template></dom-repeat></div></div><div id="additional-metadata-line" class="style-scope ytd-grid-video-renderer"><dom-repeat strip-whitespace="" class="style-scope ytd-grid-video-renderer"><template is="dom-repeat"></template></dom-repeat></div></div></div><ytd-badge-supported-renderer id="video-badges" class="style-scope ytd-grid-video-renderer" disable-upgrade="" hidden=""></ytd-badge-supported-renderer><div id="menu" class="style-scope ytd-grid-video-renderer"><ytd-menu-renderer class="style-scope ytd-grid-video-renderer"><!--css-build:shady-->

    <div id="top-level-buttons" class="style-scope ytd-menu-renderer"></div>
    <yt-icon-button id="button" class="dropdown-trigger style-scope ytd-menu-renderer"><!--css-build:shady--><button id="button" class="style-scope yt-icon-button" aria-label="Menu czynności">
      <yt-icon class="style-scope ytd-menu-renderer"><svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" class="style-scope yt-icon" style="pointer-events: none; display: block; width: 100%; height: 100%;"><g class="style-scope yt-icon">
        <path d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" class="style-scope yt-icon"></path>
      </g></svg><!--css-build:shady-->

</yt-icon>
    </button></yt-icon-button>
  </ytd-menu-renderer></div></div><div id="buttons" class="style-scope ytd-grid-video-renderer"></div></div><div id="dismissed" class="style-scope ytd-grid-video-renderer"><div id="dismissed-content" class="style-scope ytd-grid-video-renderer"></div></div></ytd-grid-video-renderer>
  }
end;

procedure TFImportDirectoryYoutube.BitBtn1Click(Sender: TObject);
begin
  import;
  io_ok:=true;
  close;
end;

end.

