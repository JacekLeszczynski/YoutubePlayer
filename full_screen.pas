unit full_screen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, MPlayerCtrl;

type

  { TFFullScreen }

  TFFullScreen = class(TForm)
    mplayer: TMPlayerControl;
  private

  public

  end;

var
  FFullScreen: TFFullScreen;

implementation

{$R *.lfm}

end.

