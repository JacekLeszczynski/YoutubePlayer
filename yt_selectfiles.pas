unit yt_selectfiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, CheckLst, StdCtrls,
  Buttons;

type

  { TFSelectYT }

  TFSelectYT = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox2ClickCheck(Sender: TObject);
  private
  public
    io_ok: boolean;
    io_result: string;
    io_audio,io_video: integer;
  end;

var
  FSelectYT: TFSelectYT;

implementation

uses
  ecode;

{$R *.lfm}

{ TFSelectYT }

procedure TFSelectYT.BitBtn1Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

procedure TFSelectYT.BitBtn2Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  s:='';
  io_audio:=0;
  io_video:=0;
  for i:=0 to CheckListBox2.Count-1 do
  begin
    if CheckListBox2.Checked[i] then
    begin
      io_video:=StrToInt(GetLineToStr(CheckListBox2.Items[i],1,' '));
      s:=IntToStr(io_video);
      break;
    end;
  end;
  for i:=0 to CheckListBox1.Count-1 do
  begin
    if CheckListBox1.Checked[i] then
    begin
      io_audio:=StrToInt(GetLineToStr(CheckListBox1.Items[i],1,' '));
      if s='' then s:=IntToStr(io_audio) else
      s:=s+'+'+IntToStr(io_audio);
      break;
    end;
  end;
  io_result:=s;
  io_ok:=true;
  close;
end;

procedure TFSelectYT.CheckListBox1ClickCheck(Sender: TObject);
var
  a,i: integer;
begin
  a:=CheckListBox1.ItemIndex;
  for i:=0 to CheckListBox1.Count-1 do if i<>a then CheckListBox1.Checked[i]:=false;
end;

procedure TFSelectYT.CheckListBox2ClickCheck(Sender: TObject);
var
  a,i: integer;
begin
  a:=CheckListBox2.ItemIndex;
  for i:=0 to CheckListBox2.Count-1 do if i<>a then CheckListBox2.Checked[i]:=false;
end;

end.

