program studio_jahu;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp, ExtParams, cverinfo,
  Interfaces, // this includes the LCL widgetset
  Forms,
  {$IFDEF APP} main, ExtSharedMemory, {$ENDIF}
  serwis;

{$R studio_jahu.res}
{$IFDEF APP}{$R media.res}{$ENDIF}

type

  { TYoutubePlayer }

  { TStudioJahu }

  TStudioJahu = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    par: TExtParams;
    {$IFDEF APP}mem: TExtSharedMemory;{$ENDIF}
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
    if par.IsParam('debug') then _DEF_DEBUG:=true;
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
    parametr:=par.GetVar;
  finally
    par.Free;
  end;
  if go_exit then
  begin
    terminate;
    exit;
  end;

  {$IFDEF APP}
  mem.Execute;
  {$ENDIF}

  {wygaszenie procesu}
  Terminate;
end;

procedure TStudioJahu.memServer(Sender: TObject);
begin
  {$IFDEF APP}
  {uruchomienie głównej formy}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  dm.aVER:=ver;
  Application.CreateForm(TForm1, Form1);
  if parametr<>'' then Form1.parametr:=parametr;
  Application.Run;
  {$ENDIF}
end;

procedure TStudioJahu.memMessage(Sender: TObject; AMessage: string);
begin
  {$IFDEF APP}
  Form1.RunParameter(AMEssage);
  {$ENDIF}
end;

procedure TStudioJahu.memSendMessage(Sender: TObject; var AMessage: string);
//var
//  i: integer;
//  s: string;
begin
  {$IFDEF APP}
  if parametr<>'' then AMessage:=parametr;
  //s:='';
  //for i:=1 to ParamCount do s:=s+ParamStr(i)+' ';
  //AMessage:=trim(s);
  {$ENDIF}
end;

constructor TStudioJahu.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=true;
  {$IFDEF APP}
  mem:=TExtSharedMemory.Create(self);
  mem.ApplicationKey:='{STUDIO-JAHU-44BB-BE1D-9F6CD73EA221}';
  mem.OnServer:=@memServer;
  mem.OnMessage:=@memMessage;
  mem.OnSendMessage:=@memSendMessage;
  {$ENDIF}
end;

destructor TStudioJahu.Destroy;
begin
  {$IFDEF APP}
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

