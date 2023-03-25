unit pytanie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, XMLPropStorage,
  StdCtrls;

type

  { TFPytanie }

  TFPytanie = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    propstorage: TXMLPropStorage;
    procedure FormCreate(Sender: TObject);
    function Test(aIsPytanie: boolean; aNastepne: boolean = false): integer;
    procedure Clear;
  private
    krok: integer; //0 = NULL, 1 = PYTANIE WYŚWIETLONE, 2 = PYTANIE WYSŁANE
  public
    procedure SetPytanie(aNick,aText: string; aWyswietlone: boolean = false);
    function GetPytanie: string;
  end;

var
  FPytanie: TFPytanie;

implementation

uses
  ecode;

{$R *.lfm}

{ TFPytanie }

procedure TFPytanie.FormCreate(Sender: TObject);
begin
  propstorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  propstorage.Active:=true;
  Clear;
end;

function TFPytanie.Test(aIsPytanie: boolean; aNastepne: boolean): integer;
begin
  if aIsPytanie then
  begin
    if aNastepne then krok:=1 else
    if krok=0 then krok:=1 else
    if krok=1 then krok:=2 else
    if krok=2 then krok:=1;
  end else begin
    if aNastepne then krok:=0 else
    if krok=1 then krok:=2 else
    krok:=0;
  end;
  result:=krok;
end;

procedure TFPytanie.Clear;
begin
  krok:=0;
end;

procedure TFPytanie.SetPytanie(aNick, aText: string; aWyswietlone: boolean);
begin
  if aWyswietlone then Caption:='Pytanie [WYŚWIETLONE]' else
  Caption:='Pytanie [DO WYŚWIETLENIA]';
  Label1.Caption:=aNick;
  Label2.Caption:=aText;
end;

function TFPytanie.GetPytanie: string;
begin
  Caption:='Pytanie [WYŚWIETLONE]';
  result:=Label2.Caption;
end;

end.

