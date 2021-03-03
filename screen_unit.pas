unit screen_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  BCLabel, TplProgressBarUnit;

type

  { TFScreen }

  TFScreen = class(TForm)
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    LabelTop: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    oo: TplProgressBar;
    Panel1: TPanel;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
  private
    vTytul,vWatek: string;
  public
    procedure film(aWidocznosc: boolean);
    procedure film(aTytul: string = ''; aWatek: string = ''; aWidocznosc: boolean = true);
    procedure pytanie(aPytanie: string = '');
    procedure tak_nie(aTak,aNie: integer; aTemat: string = '');
    procedure tak_nie;
  end;

var
  FScreen: TFScreen;

implementation

{$R *.lfm}

{ TFScreen }

procedure TFScreen.FormCreate(Sender: TObject);
begin
  film;
  pytanie;
end;

procedure TFScreen.film(aWidocznosc: boolean);
begin
  film(vTytul,vWatek,aWidocznosc);
end;

procedure TFScreen.film(aTytul: string; aWatek: string; aWidocznosc: boolean);
var
  s1,s2: string;
begin
  if vTytul<>aTytul then vTytul:=aTytul;
  if vWatek<>aWatek then vWatek:=aWatek;
  if aWidocznosc then
  begin
    s1:=vTytul;
    s2:=vWatek
  end else begin
    s1:='';
    s2:='';
  end;
  Shape1.Visible:=(s1<>'') or (s2<>'');
  Label1.Caption:=s1;
  Label2.Caption:=Label1.Caption;
  Label3.Caption:=Label1.Caption;
  Label4.Caption:=Label1.Caption;
  Label5.Caption:=Label1.Caption;
  Label6.Caption:=s2;
  Label7.Caption:=Label6.Caption;
  Label8.Caption:=Label6.Caption;
  Label9.Caption:=Label6.Caption;
  Label10.Caption:=Label6.Caption;
end;

procedure TFScreen.pytanie(aPytanie: string);
begin
  Label15.Caption:=aPytanie;
  Label11.Caption:=Label15.Caption;
  Label12.Caption:=Label15.Caption;
  Label13.Caption:=Label15.Caption;
  Label14.Caption:=Label15.Caption;
end;

procedure TFScreen.tak_nie(aTak, aNie: integer; aTemat: string);
begin
  Panel1.Visible:=true;
  if not Panel1.Visible then exit;
  if aTemat<>'' then Label18.Caption:=aTemat;
  Label16.Caption:='NIE = '+IntToStr(aNie);
  Label17.Caption:='TAK = '+IntToStr(aTak);
  if (aTak=0) and (aNie=0) then oo.Position:=50 else oo.Position:=round(aNie*100/(aTak+aNie));
end;

procedure TFScreen.tak_nie;
begin
  Panel1.Visible:=false;
end;

end.

