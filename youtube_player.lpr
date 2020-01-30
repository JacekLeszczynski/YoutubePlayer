program youtube_player;

{$mode objfpc}{$H+}

uses
  cthreads,
  cmem,
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, rxnew, uecontrols, main, lista, czas, lista_wyboru, serwis,
  youtube_unit, config
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFCzas, FCzas);
  Application.Run;
end.

