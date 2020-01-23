unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NetSynHTTP;

type

  { Tdm }

  Tdm = class(TDataModule)
    http: TNetSynHTTP;
  private
  public
    procedure GetInformationsForYoutube(aLink: string; var aTitle,aDescription,aKeywords: string);
    function GetTitleForYoutube(aLink: string): string;
  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

{ Tdm }

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

