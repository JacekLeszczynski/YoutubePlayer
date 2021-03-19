program youtube_player_server;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, server, CustApp
  { you can add units after this };

type

  { TYTServer }

  TYTServer = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TYTServer }

procedure TYTServer.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  dms.execute;

  // stop program loop
  Terminate;
end;

constructor TYTServer.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
  dms:=Tdms.Create(nil);
end;

destructor TYTServer.Destroy;
begin
  dms.Free;
  inherited Destroy;
end;

procedure TYTServer.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TYTServer;

begin
  Application:=TYTServer.Create(nil);
  Application.Title:='Youtube Player - Server';
  Application.Run;
  Application.Free;
end.

