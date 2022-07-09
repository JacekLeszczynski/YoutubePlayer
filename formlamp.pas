unit FormLamp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ueled;

type

  { TFLamp }

  TFLamp = class(TForm)
    Label1: TLabel;
    uELED1: TuELED;
  private

  public

  end;

var
  FLamp1,FLamp2: TFLamp;

implementation

{$R *.lfm}

end.

