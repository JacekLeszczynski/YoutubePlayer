unit MojProfil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, uETilePanel;

type

  { TFMojProfil }

  TFMojProfil = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FMojProfil: TFMojProfil;

implementation

uses
  main_monitor;

{$R *.lfm}

{ TFMojProfil }

procedure TFMojProfil.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFMojProfil.BitBtn1Click(Sender: TObject);
begin
  DBEdit1.DataSource.DataSet.Cancel;
  close;
end;

procedure TFMojProfil.BitBtn2Click(Sender: TObject);
begin
  DBEdit1.DataSource.DataSet.Post;
  close;
end;

procedure TFMojProfil.FormCreate(Sender: TObject);
begin
  DBEdit1.DataSource.DataSet.Edit;
end;

end.

