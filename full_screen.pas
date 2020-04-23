unit full_screen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, MPlayerCtrl;

type

  { TFFullScreen }

  TFFullScreen = class(TForm)
    mplayer: TMPlayerControl;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FFullScreen: TFFullScreen;

implementation

{$R *.lfm}

{ TFFullScreen }

procedure TFFullScreen.FormCreate(Sender: TObject);
begin
  self.Width:=1280;
  self.Height:=720;
end;

end.

