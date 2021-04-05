unit KontoExport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtMessage, uETilePanel;

type

  { TFExport }

  TFExport = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SDialog: TSaveDialog;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  FExport: TFExport;

implementation

{$R *.lfm}

{ TFExport }

procedure TFExport.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFExport.BitBtn1Click(Sender: TObject);
begin
  mess.ShowInformation('Narzędzie jeszcze nie działa, jest w trakcie tworzenia.^Zajrzyj tu w niedalekiej przyszłosci.');
end;

procedure TFExport.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

end.

