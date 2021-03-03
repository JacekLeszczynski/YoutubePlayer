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
    DBMemo1: TDBMemo;
    Label1: TLabel;
    master: TDSMaster;
    ds_ank: TDataSource;
    DBGridPlus1: TDBGridPlus;
    Panel1: TPanel;
    Panel2: TPanel;
    ank: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure ds_ankDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FAnkiety: TFAnkiety;

implementation

{$R *.lfm}

{ TFAnkiety }

procedure TFAnkiety.FormShow(Sender: TObject);
begin
  if not ank.Active then master.Open;
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

