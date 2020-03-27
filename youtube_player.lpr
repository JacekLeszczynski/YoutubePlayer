program youtube_player;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  cmem,
  {$ENDIF}
  Classes, CustApp, ExtParams, cverinfo,
  Interfaces, // this includes the LCL widgetset
  Forms,
  {$IFDEF APP} main, {$ENDIF}
  {$IFDEF CLIENT} main_client, {$ENDIF}
  serwis, audioeq
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
  randomize;

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
    par.ParamsForValues.Add('db');
    if par.IsParam('db') then sciezka_db:=par.GetValue('db');
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
  Application.CreateForm(TFAEQ, FAEQ);
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

