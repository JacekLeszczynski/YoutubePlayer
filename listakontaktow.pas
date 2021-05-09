unit ListaKontaktow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  DSMaster, DBGridPlus, ZDataset, uETilePanel;

type

  { TFListaKontaktow }

  TFListaKontaktow = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGridPlus1: TDBGridPlus;
    dskontakty: TDataSource;
    Label1: TLabel;
    master: TDSMaster;
    kontakty: TZQuery;
    kontaktyemail: TMemoField;
    kontaktyid: TLargeintField;
    kontaktyimie: TMemoField;
    kontaktyklucz: TMemoField;
    kontaktynazwa: TMemoField;
    kontaktynazwisko: TMemoField;
    kontaktyopis: TMemoField;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
    io_ok: boolean;
    io_id: integer;
    io_klucz: string;
  end;

var
  FListaKontaktow: TFListaKontaktow;

implementation

uses
  ecode, serwis, lcltype;

{$R *.lfm}

{ TFListaKontaktow }

procedure TFListaKontaktow.FormCreate(Sender: TObject);
begin
  master.Open;
end;

procedure TFListaKontaktow.BitBtn2Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

procedure TFListaKontaktow.BitBtn1Click(Sender: TObject);
begin
  io_ok:=true;
  io_id:=kontaktyid.AsInteger;
  io_klucz:=DecryptString(kontaktyklucz.AsString,dm.GetHashCode(4),true);
  close;
end;

procedure TFListaKontaktow.FormDestroy(Sender: TObject);
begin
  master.Close;
end;

procedure TFListaKontaktow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then BitBtn2.Click;
end;

end.

