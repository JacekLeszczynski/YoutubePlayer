unit ignores;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGridPlus, DSMaster, ExtMessage, ZDataset, uETilePanel;

type

  { TFIgnores }

  TFIgnores = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGridPlus1: TDBGridPlus;
    dsignores: TDataSource;
    mess: TExtMessage;
    master: TDSMaster;
    ignores: TZQuery;
    autorun: TTimer;
    ignoresid: TLargeintField;
    ignoresnick: TMemoField;
    Label1: TLabel;
    uETilePanel1: TuETilePanel;
    procedure autorunTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure dsignoresDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FIgnores: TFIgnores;

implementation

{$R *.lfm}

{ TFIgnores }

procedure TFIgnores.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  master.Close;
  CloseAction:=caFree;
end;

procedure TFIgnores.autorunTimer(Sender: TObject);
begin
  autorun.Enabled:=false;
  master.Open;
end;

procedure TFIgnores.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFIgnores.BitBtn2Click(Sender: TObject);
begin
  if mess.ShowConfirmationYesNo('Czy rzeczywiście chcesz usunąć nicka '+ignoresnick.AsString+' z listy ignorowanych kontaktów?') then ignores.Delete;
end;

procedure TFIgnores.dsignoresDataChange(Sender: TObject; Field: TField);
var
  a,ne,e: boolean;
begin
  master.State(dsignores,a,ne,e);
  BitBtn2.Enabled:=ne;
end;

procedure TFIgnores.FormCreate(Sender: TObject);
begin
  autorun.Enabled:=true;
end;

end.

