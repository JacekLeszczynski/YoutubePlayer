program studio_jahu;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  cmem,
  {$ENDIF}
  Classes, SysUtils, CustApp, ExtParams, cverinfo,
  Interfaces, // this includes the LCL widgetset
  {$IFNDEF SERVER}
  Forms,
  {$ENDIF}
  {$IFDEF APP} main, {$ENDIF}
  {$IFDEF MONITOR} main_monitor, ExtSharedMemory, {$ENDIF}
  serwis;

{$R studio_jahu.res}
{$IFDEF APP}{$R media.res}{$ENDIF}
{$IFDEF MONITOR}{$R sounds.res}{$ENDIF}

type

  { TYoutubePlayer }

  TStudioJahu = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    par: TExtParams;
    {$IFDEF MONITOR}mem: TExtSharedMemory;{$ENDIF}
    procedure memServer(Sender: TObject);
    procedure memMessage(Sender: TObject; AMessage: string);
    procedure memSendMessage(Sender: TObject; var AMessage: string);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  ver: string;
  parametr: string = '';

procedure TStudioJahu.DoRun;
var
  v1,v2,v3,v4: integer;
  go_exit: boolean;
  MajorVersion,MinorVersion,Release,Build: integer;
begin
  inherited DoRun;
  go_exit:=false;
  randomize;
  GetProgramVersion(MajorVersion,MinorVersion,Release,Build);
  if Build=0 then ver:=IntToStr(MajorVersion)+'.'+IntToStr(MinorVersion)+'.'+IntToStr(Release)
             else ver:=IntToStr(MajorVersion)+'.'+IntToStr(MinorVersion)+'.'+IntToStr(Release)+'-'+IntToStr(Build);

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
    if par.IsParam('dev') then _DEV_ON:=true;
    parametr:=par.GetVar(0);
  finally
    par.Free;
  end;
  if go_exit then
  begin
    terminate;
    exit;
  end;

  {$IFDEF MONITOR}
  mem.ApplicationKey:='shared_ECB8AE77-63F2-4DFC-B184-D1E3CC84AA63';
  mem.Execute;
  {$ELSE}
  {uruchomienie głównej formy}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  dm.aVER:=ver;
  {$IFDEF APP} Application.CreateForm(TForm1, Form1); {$ENDIF}
  Application.Run;
  {$ENDIF}

  {wygaszenie procesu}
  Terminate;
end;

procedure TStudioJahu.memServer(Sender: TObject);
begin
  {uruchomienie głównej formy}
  {$IFDEF MONITOR}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  dm.aVER:=ver;
  Application.CreateForm(TFMonitor, FMonitor); Application.ShowMainForm:=false;
  Application.Run;
  {$ENDIF}
end;

procedure TStudioJahu.memMessage(Sender: TObject; AMessage: string);
begin
  {$IFDEF MONITOR}
  FMonitor.RunParameter(AMEssage);
  {$ENDIF}
end;

procedure TStudioJahu.memSendMessage(Sender: TObject; var AMessage: string);
begin
  if parametr<>'' then AMessage:=parametr;
end;

constructor TStudioJahu.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=true;
  {$IFDEF MONITOR}
  mem:=TExtSharedMemory.Create(self);
  mem.OnServer:=@memServer;
  mem.OnMessage:=@memMessage;
  mem.OnSendMessage:=@memSendMessage;
  {$ENDIF}
end;

destructor TStudioJahu.Destroy;
begin
  {$IFDEF MONITOR}
  mem.Uninstall;
  mem.Free;
  {$ENDIF}
  inherited Destroy;
end;

var
  Application: TStudioJahu;
begin
  Application:=TStudioJahu.Create(nil);
  Application.Title:='Studio Jahu';
  Application.Run;
  Application.Free;
end.

