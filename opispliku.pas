unit OpisPliku;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ExtMessage, uETilePanel;

type

  { TFOpisPliku }

  TFOpisPliku = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    mess: TExtMessage;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    uETilePanel1: TuETilePanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    io_ok: boolean;
    io_avatar: boolean;
  end;

var
  FOpisPliku: TFOpisPliku;

implementation

{$R *.lfm}

{ TFOpisPliku }

procedure TFOpisPliku.BitBtn3Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

procedure TFOpisPliku.BitBtn2Click(Sender: TObject);
begin
  Image1.Picture.Clear;
  io_avatar:=false;
end;

procedure TFOpisPliku.BitBtn1Click(Sender: TObject);
var
  f: file of byte;
  a: int64;
begin
  if OpenDialog1.Execute then
  begin
    try
      assignfile(f,OpenDialog1.FileName);
      reset(f,1);
      a:=filesize(f);
      closefile(f);
    except
      mess.ShowWarning('Nie mogę pobrać długości pliku, przerywam!');
      exit;
    end;
    if a>512*1024 then
    begin
      mess.ShowWarning('Przekroczona wartość maksymalnej wielkości pliku graficznego, przerywam!^Ograniczenie wynosi 512kB.');
      exit;
    end;
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    io_avatar:=true;
  end;
end;

procedure TFOpisPliku.BitBtn4Click(Sender: TObject);
begin
  io_ok:=true;
  close;
end;

procedure TFOpisPliku.FormCreate(Sender: TObject);
begin
  io_avatar:=false;
end;

end.

