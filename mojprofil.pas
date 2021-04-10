unit MojProfil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, uETilePanel, ZDataset;

type

  { TFMojProfil }

  TFMojProfil = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dane: TZQuery;
    daneemail: TMemoField;
    daneid: TLargeintField;
    daneimie: TMemoField;
    daneklucz: TMemoField;
    danenazwa: TMemoField;
    danenazwisko: TMemoField;
    daneopis: TMemoField;
    dsdane: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure _SetText(Sender: TField; const aText: string);
    procedure _GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
  public
    io_id: integer;
  end;

var
  FMojProfil: TFMojProfil;

implementation

uses
  lcltype, main_monitor;

{$R *.lfm}

{ TFMojProfil }

procedure TFMojProfil.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dane.Close;
  CloseAction:=caFree;
end;

procedure TFMojProfil.BitBtn1Click(Sender: TObject);
begin
  dane.Cancel;
  close;
end;

procedure TFMojProfil.BitBtn2Click(Sender: TObject);
begin
  dane.Post;
  close;
end;

procedure TFMojProfil.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then BitBtn1.Click;
end;

procedure TFMojProfil.FormShow(Sender: TObject);
begin
  if dane.Active then exit;
  dane.ParamByName('id').AsInteger:=io_id;
  dane.Open;
  if dane.RecordCount=0 then
  begin
    dane.Append;
    daneid.AsInteger:=io_id;
  end else dane.Edit;
end;

procedure TFMojProfil._SetText(Sender: TField; const aText: string);
begin
  Sender.AsString:=aText;
end;

procedure TFMojProfil._GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText:=Sender.AsString;
end;

end.

