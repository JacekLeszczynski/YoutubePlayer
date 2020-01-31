program youtube_player;

{$mode objfpc}{$H+}

uses
  cthreads,
  cmem,
  Classes, CustApp, ExtParams, cverinfo,
  Interfaces, // this includes the LCL widgetset
  Forms,
  {$IFDEF APP} main, {$ENDIF}
  {$IFDEF CLIENT} main_client, {$ENDIF}
  serwis
  { you can add units after this };

{$R *.res}

type

  { TYoutubePlayer }

  TYoutubePlayer = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    par: TExtParams;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure TYoutubePlayer.DoRun;
var
  v1,v2,v3,v4: integer;
  go_exit: boolean;
begin
  inherited DoRun;
  go_exit:=false;

  par:=TExtParams.Create(nil);
  try
    par.Execute;
    if par.IsParam('ver') then
    begin
      GetProgramVersion(v1,v2,v3,v4);
      if v4>0 then writeln(v1,'.',v2,'.',v3,'-',v4) else
      if v3>0 then writeln(v1,'.',v2,'.',v3) else
      if v2>0 then writeln(v1,'.',v2) else writeln(v1,'.',v2);
      go_exit:=true;
    end;
    //if par.IsParam('dev') then _DEV:=true;
    //if par.IsParam('debug') then _DEBUG:=true;
    //if par.IsParam('polfan') then _CUSTOM_POLFAN:=par.GetValue('polfan');
    //if par.IsParam('chat-identify') then _DEV_CHAT_IDENTIFY:=par.GetValue('chat-identify');
  finally
    par.Free;
  end;
  if go_exit then
  begin
    terminate;
    exit;
  end;

  {uruchomienie głównej formy}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  {$IFDEF APP} Application.CreateForm(TForm1, Form1); {$ENDIF}
  {$IFDEF CLIENT} Application.CreateForm(TFClient, FClient); {$ENDIF}
  Application.Run;
  {wygaszenie procesu}
  Terminate;
end;

constructor TYoutubePlayer.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=true;
end;

destructor TYoutubePlayer.Destroy;
begin
  inherited Destroy;
end;

var
  Application: TYoutubePlayer;
begin
  Application:=TYoutubePlayer.Create(nil);
  Application.Title:='youtube_player';
  Application.Run;
  Application.Free;
end.

