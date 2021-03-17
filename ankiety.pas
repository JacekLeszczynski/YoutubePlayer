unit ankiety;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBCtrls, StdCtrls, DBGridPlus, DSMaster, ZDataset;

type

  { TFAnkiety }

  TFAnkiety = class(TForm)
    ankid: TLargeintField;
    anktemat: TMemoField;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    DBMemo1: TDBMemo;
    Label1: TLabel;
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
    procedure BitBtn8Click(Sender: TObject);
    procedure DBGridPlus1DblClick(Sender: TObject);
    procedure ds_ankDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure masterAfterOpen(Sender: TObject);
    procedure masterBeforeClose(Sender: TObject);
  private
  public
    io_tryb: integer;
    io_tekst: string;
  end;

var
  FAnkiety: TFAnkiety;

implementation

uses
  serwis;

{$R *.lfm}

{ TFAnkiety }

procedure TFAnkiety.FormShow(Sender: TObject);
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

procedure TFAnkiety.masterAfterOpen(Sender: TObject);
begin
  ank.Locate('id',ankieta_id,[]);
end;

procedure TFAnkiety.masterBeforeClose(Sender: TObject);
begin
  ankieta_id:=ankid.AsInteger;
end;

procedure TFAnkiety.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  master.Close;
end;

procedure TFAnkiety.BitBtn1Click(Sender: TObject);
begin
  ank.Append;
end;

procedure TFAnkiety.BitBtn2Click(Sender: TObject);
begin
  ank.Edit;
end;

procedure TFAnkiety.BitBtn3Click(Sender: TObject);
begin
  ank.Delete;
end;

procedure TFAnkiety.BitBtn4Click(Sender: TObject);
begin
  ank.Post;
end;

procedure TFAnkiety.BitBtn5Click(Sender: TObject);
begin
  ank.Cancel;
end;

procedure TFAnkiety.BitBtn6Click(Sender: TObject);
begin
  io_tekst:='';
  close;
end;

procedure TFAnkiety.BitBtn7Click(Sender: TObject);
begin
  io_tekst:=anktemat.AsString;
  close;
end;

procedure TFAnkiety.BitBtn8Click(Sender: TObject);
begin
  io_tekst:='[ANULUJ]';
  close;
end;

procedure TFAnkiety.DBGridPlus1DblClick(Sender: TObject);
begin
  if ank.IsEmpty then exit;
  if io_tryb=1 then exit;
  BitBtn7.Click;
end;

procedure TFAnkiety.ds_ankDataChange(Sender: TObject; Field: TField);
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

