unit transmisja;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  XMLPropStorage;

type

  { TFTransmisja }

  TFTransmisja = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    FCode: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    PropStorage: TXMLPropStorage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    out_ok: boolean;
  end;

var
  FTransmisja: TFTransmisja;

implementation

uses
  ecode, serwis;

{$R *.lfm}

{ TFTransmisja }

procedure TFTransmisja.FormCreate(Sender: TObject);
begin
  PropStorage.FileName:=MyConfDir('studio_jahu_player_youtube.xml');
  PropStorage.Active:=true;
end;

procedure TFTransmisja.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFTransmisja.BitBtn2Click(Sender: TObject);
begin
  out_ok:=true;
  close;
end;

procedure TFTransmisja.BitBtn3Click(Sender: TObject);
var
  i,j: integer;
  s,ss: string;
begin
  ss:='';
  for i:=1 to random(6)+2 do
  begin
    s:='';
    for j:=1 to random(4)+4 do s:=s+chr(random(25)+98);
    if ss='' then ss:=s else ss:=ss+','+s;
  end;
  ss:=ss+','+Edit2.Text;
  for i:=1 to random(6)+2 do
  begin
    s:='';
    for j:=1 to random(4)+4 do s:=s+chr(random(25)+98);
    ss:=ss+','+s;
  end;
  Edit2.Text:=EncryptString(ss,dm.GetHashCode(1));
end;

procedure TFTransmisja.BitBtn4Click(Sender: TObject);
var
  ss,s: string;
  i: integer;
begin
  ss:=DecryptString(Edit2.Text,dm.GetHashCode(1));
  i:=1;
  while true do
  begin
    s:=GetLineToStr(ss,i,',');
    if s='' then break;
    if ecode.IsDigit(s[1]) then
    begin
      Edit2.Text:=s;
      break;
    end;
    inc(i);
  end;
end;

end.

