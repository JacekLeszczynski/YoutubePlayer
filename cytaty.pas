unit cytaty;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBCtrls, StdCtrls, DBGridPlus, DSMaster, ZDataset;

type

  { TFCytaty }

  TFCytaty = class(TForm)
    ankcytat: TMemoField;
    ankid: TLargeintField;
    anktytul: TMemoField;
    ankzrodlo: TMemoField;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    master: TDSMaster;
    ds_ank: TDataSource;
    DBGridPlus1: TDBGridPlus;
    Panel1: TPanel;
    Panel2: TPanel;
    ank: TZQuery;
    Panel3: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure DBGridPlus1DblClick(Sender: TObject);
    procedure ds_ankDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
  public
    io_tryb: integer;
    io_tytul,io_cytat,io_zrodlo: string;
  end;

var
  FCytaty: TFCytaty;

implementation

{$R *.lfm}

{ TFCytaty }

procedure TFCytaty.FormShow(Sender: TObject);
begin
  if not ank.Active then
  begin
    if io_tryb=1 then
    begin
      Panel2.Visible:=true;
      Panel3.Visible:=false;
    end else begin
      Panel2.Visible:=false;
      Panel3.Visible:=true;
    end;
    master.Open;
  end;
end;

procedure TFCytaty.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  master.Close;
  if io_tryb=1 then CloseAction:=caFree;
end;

procedure TFCytaty.BitBtn1Click(Sender: TObject);
begin
  ank.Append;
end;

procedure TFCytaty.BitBtn2Click(Sender: TObject);
begin
  ank.Edit;
end;

procedure TFCytaty.BitBtn3Click(Sender: TObject);
begin
  ank.Delete;
end;

procedure TFCytaty.BitBtn4Click(Sender: TObject);
begin
  ank.Post;
end;

procedure TFCytaty.BitBtn5Click(Sender: TObject);
begin
  ank.Cancel;
end;

procedure TFCytaty.BitBtn6Click(Sender: TObject);
begin
  io_tytul:='';
  io_cytat:='';
  io_zrodlo:='';
  close;
end;

procedure TFCytaty.BitBtn7Click(Sender: TObject);
begin
  io_tytul:=anktytul.AsString;
  io_cytat:=ankcytat.AsString;
  io_zrodlo:=ankzrodlo.AsString;
  close;
end;

procedure TFCytaty.DBGridPlus1DblClick(Sender: TObject);
begin
  if ank.IsEmpty then exit;
  if io_tryb=1 then exit;
  BitBtn7.Click;
end;

procedure TFCytaty.ds_ankDataChange(Sender: TObject; Field: TField);
var
  a,ne,e: boolean;
begin
  master.State(ds_ank,a,ne,e);
  BitBtn1.Enabled:=a;
  BitBtn2.Enabled:=ne;
  BitBtn3.Enabled:=ne;
  BitBtn4.Enabled:=e;
  BitBtn5.Enabled:=e;
end;

end.
