unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP, IniFiles;

type

  { Tdm }

  Tdm = class(TDataModule)
    http: TNetSynHTTP;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    ini: TIniFile;
  public
    procedure Init;
    procedure SetConfig(AName: string; AValue: boolean);
    procedure SetConfig(AName: string; AValue: integer);
    procedure SetConfig(AName: string; AValue: int64);
    procedure SetConfig(AName: string; AValue: string);
    function GetConfig(AName: string; ADefault: boolean = false): boolean;
    function GetConfig(AName: string; ADefault: integer = 0): integer;
    function GetConfig(AName: string; ADefault: int64 = 0): int64;
    function GetConfig(AName: string; ADefault: string = ''): string;
    procedure GetInformationsForYoutube(aLink: string; var aTitle,aDescription,aKeywords: string);
    function GetTitleForYoutube(aLink: string): string;
  end;

var
  dm: Tdm;

implementation

uses
  ecode;

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  Init;
  ini:=TIniFile.Create(MyConfDir('config.ini'));
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  ini.Free;
end;

procedure Tdm.Init;
begin
  SetConfDir('youtube_player');
end;

procedure Tdm.SetConfig(AName: string; AValue: boolean);
begin
  ini.WriteBool('Zmienne',AName,AValue);
end;

procedure Tdm.SetConfig(AName: string; AValue: integer);
begin
  ini.WriteInteger('Zmienne',AName,AValue);
end;

procedure Tdm.SetConfig(AName: string; AValue: int64);
begin
  ini.WriteInt64('Zmienne',AName,AValue);
end;

procedure Tdm.SetConfig(AName: string; AValue: string);
begin
  ini.WriteString('Zmienne',AName,AValue);
end;

function Tdm.GetConfig(AName: string; ADefault: boolean): boolean;
begin
  result:=ini.ReadBool('Zmienne',AName,ADefault);
end;

function Tdm.GetConfig(AName: string; ADefault: integer): integer;
begin
  result:=ini.ReadInteger('Zmienne',AName,ADefault);
end;

function Tdm.GetConfig(AName: string; ADefault: int64): int64;
begin
  result:=ini.ReadInt64('Zmienne',AName,ADefault);
end;

function Tdm.GetConfig(AName: string; ADefault: string): string;
begin
  result:=ini.ReadString('Zmienne',AName,ADefault);
end;

procedure Tdm.GetInformationsForYoutube(aLink: string; var aTitle,
  aDescription, aKeywords: string);
var
  s: string;
  a: integer;
begin
  http.execute(aLink,s);
  a:=pos('meta name="title"',s);
  if a>0 then delete(s,1,a+16);
  a:=pos('content="',s);
  if a>0 then delete(s,1,a+8);
  a:=pos('"',s);
  aTitle:=copy(s,1,a-1);

  a:=pos('meta name="description"',s);
  if a>0 then delete(s,1,a+22);
  a:=pos('content="',s);
  if a>0 then delete(s,1,a+8);
  a:=pos('"',s);
  aDescription:=copy(s,1,a-1);

  a:=pos('meta name="keywords"',s);
  if a>0 then delete(s,1,a+19);
  a:=pos('content="',s);
  if a>0 then delete(s,1,a+8);
  a:=pos('"',s);
  aKeywords:=copy(s,1,a-1);
end;

function Tdm.GetTitleForYoutube(aLink: string): string;
var
  vTitle,vDescription,vKeywords: string;
begin
  GetInformationsForYoutube(aLink,vTitle,vDescription,vKeywords);
  result:=vTitle;
end;

end.

