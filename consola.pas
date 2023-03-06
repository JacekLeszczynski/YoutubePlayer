unit Consola;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFConsola }

  TFConsola = class(TForm)
    Memo1: TMemo;
  private
  public
    procedure Add(aText: string; aLiterka: string = 'I');
  end;

var
  FConsola: TFConsola;

implementation

{$R *.lfm}

{ TFConsola }

procedure TFConsola.Add(aText: string; aLiterka: string);
var
  s: string;
begin
  Memo1.BeginUpdateBounds;
  s:=FormatDateTime('hh:nn:ss',now)+'['+aLiterka+']: '+aText;
  Memo1.Append(s);
  Memo1.EndUpdateBounds;
end;

end.

