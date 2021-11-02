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
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LabelTop: TLabel;
    oo: TplProgressBar;
    Panel1: TPanel;
    Panel2: TPanel;
    pCytat: TPanel;
    t20: TTimer;
    tSleep: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure t20Timer(Sender: TObject);
    procedure tSleepTimer(Sender: TObject);
  private
    vTytul,vWatek: string;
    vMs1,vMs2: string;
    vM1,vM2: string;
  public
    procedure MemReset;
    procedure film(aWidocznosc: boolean);
    procedure film(aTytul: string = ''; aWatek: string = ''; aWidocznosc: boolean = true);
    procedure pytanie(aPytanie: string = '');
    procedure tak_nie(aTak,aNie: integer; aTemat: string = '');
    procedure tak_nie;
    procedure cytat(aTytul,aCytat,aZrodlo: string);
    procedure cytat;
    procedure cytat_refresh;
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

procedure TFScreen.t20Timer(Sender: TObject);
var
  a: integer;
begin
  a:=Label20.Font.Size;
  if pCytat.Top<0 then
  begin
    dec(a);
    Label20.Font.Size:=a;
  end else t20.Enabled:=false;
end;

procedure TFScreen.tSleepTimer(Sender: TObject);
begin
  tSleep.Enabled:=false;
  film('','');
  vM1:=vMs1;
  vM2:=vMs2;
end;

procedure TFScreen.MemReset;
begin
  vM1:='';
  vM2:='';
end;

procedure TFScreen.film(aWidocznosc: boolean);
begin
  film(vTytul,vWatek,aWidocznosc);
end;

procedure TFScreen.film(aTytul: string; aWatek: string; aWidocznosc: boolean);
var
  s1,s2: string;
begin
  if aTytul<>'' then vMs1:=aTytul;
  if aWatek<>'' then vMs2:=aWatek;
  if (vM1=vMs1) and (vM2=vMs2) then exit;
  tSleep.Enabled:=false;
  if (aWatek=aTytul) or (aWatek='..') then aWatek:='';
  if vTytul<>aTytul then vTytul:=aTytul;
  if vWatek<>aWatek then vWatek:=aWatek;
  if (vTytul='') and (vWatek='') then aWidocznosc:=false;
  //tSleep.Enabled:=(vTytul<>'') and (vWatek<>'');
  if aWidocznosc then
  begin
    Panel2.Visible:=true;
    if vWatek='' then
    begin
      s1:='';
      s2:=vTytul;
    end else begin
      s1:=vTytul;
      s2:=vWatek;
    end;
  end else begin
    Panel2.Visible:=false;
    s1:='';
    s2:='';
  end;
  Label1.Visible:=s1<>'';
  Label2.Visible:=Label1.Visible;
  Label3.Visible:=Label1.Visible;
  Label4.Visible:=Label1.Visible;
  Label5.Visible:=Label1.Visible;
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
  cytat_refresh;
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
  cytat_refresh;
end;

procedure TFScreen.tak_nie;
begin
  Panel1.Visible:=false;
end;

procedure TFScreen.cytat(aTytul, aCytat, aZrodlo: string);
begin
  label20.Font.Size:=15;
  Label19.Caption:=aTytul;
  Label20.Caption:=aCytat;
  Label21.Caption:=aZrodlo;
  pCytat.Visible:=true;
  t20.Enabled:=true;
end;

procedure TFScreen.cytat;
begin
  pCytat.Visible:=false;
  Label19.Caption:='';
  Label20.Caption:='';
  Label21.Caption:='';
end;

procedure TFScreen.cytat_refresh;
begin
  if pCytat.Visible then
  begin
    label20.Font.Size:=15;
    t20.Enabled:=true;
  end;
end;

end.

