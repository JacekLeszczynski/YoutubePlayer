unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons;

type

  { TFConfig }

  TFConfig = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DirectoryEdit1: TDirectoryEdit;
    DirectoryEdit2: TDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  FConfig: TFConfig;

implementation

uses
  ecode, serwis;

{$R *.lfm}

{ TFConfig }

procedure TFConfig.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TFConfig.FormCreate(Sender: TObject);
begin
  DirectoryEdit1.Text:=_DEF_MULTIMEDIA_SAVE_DIR;
  DirectoryEdit2.Text:=_DEF_SCREENSHOT_SAVE_DIR;
end;

procedure TFConfig.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFConfig.BitBtn1Click(Sender: TObject);
begin
  _DEF_MULTIMEDIA_SAVE_DIR:=DirectoryEdit1.Text;
  _DEF_SCREENSHOT_SAVE_DIR:=DirectoryEdit2.Text;
  dm.SetConfig('default-directory-save-files',_DEF_MULTIMEDIA_SAVE_DIR);
  dm.SetConfig('default-directory-save-files-ss',_DEF_SCREENSHOT_SAVE_DIR);
  close;
end;

{ TFConfig }

end.

