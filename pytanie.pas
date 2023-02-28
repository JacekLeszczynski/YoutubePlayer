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
  private
  public
    procedure SetPytanie(aNick,aText: string);
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
end;

procedure TFPytanie.SetPytanie(aNick, aText: string);
begin
  Label1.Caption:=aNick;
  Label2.Caption:=aText;
end;

end.

