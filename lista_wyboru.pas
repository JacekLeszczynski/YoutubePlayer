unit lista_wyboru;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, CheckLst, StdCtrls,
  Buttons;

type

  { TFLista_wyboru }

  TFLista_wyboru = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public
    klucze_wyboru: TStrings;
    out_ok: boolean;
  end;

var
  FLista_wyboru: TFLista_wyboru;

implementation

{$R *.lfm}

{ TFLista_wyboru }

procedure TFLista_wyboru.BitBtn1Click(Sender: TObject);
begin
  out_ok:=false;
  close;
end;

procedure TFLista_wyboru.BitBtn2Click(Sender: TObject);
begin
  out_ok:=true;
  close;
end;

procedure TFLista_wyboru.BitBtn3Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to CheckListBox1.Count-1 do
    CheckListBox1.Checked[i]:=not CheckListBox1.Checked[i];
end;

procedure TFLista_wyboru.FormCreate(Sender: TObject);
begin
  klucze_wyboru:=TStringList.Create;
  out_ok:=false;
end;

procedure TFLista_wyboru.FormDestroy(Sender: TObject);
begin
  klucze_wyboru.Free;
end;

end.

