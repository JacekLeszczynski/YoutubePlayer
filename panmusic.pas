unit panmusic;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, TplProgressBarUnit, UOSPlayer, Types;

type

  { TFPanMusic }

  TFPanMusic = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    play: TUOSPlayer;
    pp: TplProgressBar;
    aloop: TTimer;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ameter: TTimer;
    procedure ameterTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure playAfterStart(Sender: TObject);
    procedure playStop(Sender: TObject; aBusy, aPlaying, aPauseing,
      aPause: boolean);
    procedure ppMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aloopTimer(Sender: TObject);
  private
    procedure poz_wyzej;
    procedure poz_nizej;
    procedure go(aIndex: integer);
  public

  end;

var
  FPanMusic: TFPanMusic;

implementation

uses
  ecode, lcltype, Clipbrd;

{$R *.lfm}

{ TFPanMusic }

procedure TFPanMusic.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  if play.Busy then
  begin
    play.Stop(true);
    sleep(500);
  end;
end;

procedure TFPanMusic.FormCreate(Sender: TObject);
var
  c: string;
begin
  c:=MyConfDir('music.conf');
  if c<>'' then ListBox1.Items.LoadFromFile(c);
end;

procedure TFPanMusic.ListBox1DblClick(Sender: TObject);
begin
  BitBtn5.Click;
end;

procedure TFPanMusic.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  if Index<10 then ListBox1.Canvas.Font.Color:=clBlue else ListBox1.Canvas.Font.Color:=clBlack;
  ListBox1.Canvas.Font.Bold:=(Index=play.Tag) and play.Busy;
  ListBox1.Canvas.TextRect(ARect,2,ARect.Top+2,ListBox1.Items[Index]);
end;

procedure TFPanMusic.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  a: integer;
begin
  if ssCtrl in Shift then
  begin
    if Key=VK_UP then poz_wyzej else
    if Key=VK_DOWN then poz_nizej;
    Key:=0;
  end else
  if Key=VK_DELETE then
  begin
    a:=ListBox1.ItemIndex;
    if a=play.Tag then play.Tag:=-1 else
    if a<play.Tag then play.Tag:=play.Tag-1;
    ListBox1.Items.Delete(a);
    if a>ListBox1.Count-1 then a:=ListBox1.Count-1;
    ListBox1.ItemIndex:=a;
  end else begin
    case Key of
      VK_1: go(0);
      VK_2: go(1);
      VK_3: go(2);
      VK_4: go(3);
      VK_5: go(4);
      VK_6: go(5);
      VK_7: go(6);
      VK_8: go(7);
      VK_9: go(8);
      VK_0: go(9);
    end;
    Key:=0;
  end;
end;

procedure TFPanMusic.playAfterStart(Sender: TObject);
begin
  aloop.Enabled:=true;
  ameter.Enabled:=true;
  ListBox1.Refresh;
end;

procedure TFPanMusic.playStop(Sender: TObject; aBusy, aPlaying, aPauseing,
  aPause: boolean);
begin
  aloop.Enabled:=aBusy;
  ameter.Enabled:=aBusy;
  pp.Position:=0;
  Label3.Caption:='-:--';
  Label4.Caption:='-:--';
  ProgressBar1.Position:=0;
  ProgressBar2.Position:=0;
  if not aBusy then ListBox1.Refresh;
end;

procedure TFPanMusic.ppMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  max,czas: TTime;
  a: integer;
  bPos: boolean;
begin
  if play.Busy then
  begin
    max:=play.GetLengthTime;
    czas:=max*X/pp.Width;
    play.SeekTime(czas);
    a:=TimeToInteger(czas);
    //pp.Position:=a;
    bPos:=a<3600000;
    if bPos then Label3.Caption:=FormatDateTime('nn:ss',czas) else Label3.Caption:=FormatDateTime('h:nn:ss',czas);
    //test_force:=true;
  end;
end;

procedure TFPanMusic.aloopTimer(Sender: TObject);
var
  L,P: TTime;
  a,b: integer;
  bPos,bMax: boolean;
begin
  if not play.Busy then exit;
  L:=play.GetLengthTime;
  P:=play.PositionTime;
  a:=TimeToInteger(L);
  b:=TimeToInteger(P);
  bMax:=a<3600000;
  bPos:=b<3600000;
  if bPos then Label3.Caption:=FormatDateTime('nn:ss',P) else Label3.Caption:=FormatDateTime('h:nn:ss',P);
  if bMax then Label4.Caption:=FormatDateTime('nn:ss',L) else Label4.Caption:=FormatDateTime('h:nn:ss',L);
  pp.Max:=a;
  pp.Position:=b;
end;

procedure TFPanMusic.poz_wyzej;
var
  a: integer;
  s: string;
  b: boolean;
begin
  a:=ListBox1.ItemIndex;
  if a=0 then exit;
  b:=a=play.Tag;
  s:=ListBox1.Items[ListBox1.ItemIndex];
  ListBox1.Items.Delete(a);
  dec(a);
  if b then play.Tag:=a;
  ListBox1.Items.Insert(a,s);
  ListBox1.ItemIndex:=a;
end;

procedure TFPanMusic.poz_nizej;
var
  a: integer;
  s: string;
  b: boolean;
begin
  a:=ListBox1.ItemIndex;
  if a=ListBox1.Count-1 then exit;
  b:=a=play.Tag;
  s:=ListBox1.Items[ListBox1.ItemIndex];
  ListBox1.Items.Delete(a);
  inc(a);
  if b then play.Tag:=a;
  ListBox1.Items.Insert(a,s);
  ListBox1.ItemIndex:=a;
end;

procedure TFPanMusic.go(aIndex: integer);
begin
  if aIndex=-1 then exit;
  play.Tag:=aIndex;
  play.Stop(true);
  while play.Busy do application.ProcessMessages;
  play.FileName:=ListBox1.Items[aIndex];
  play.Start;
end;

procedure TFPanMusic.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFPanMusic.ameterTimer(Sender: TObject);
var
  l,r: integer;
begin
  play.GetMeter(l,r);
  ProgressBar1.Position:=l;
  ProgressBar2.Position:=r;
end;

procedure TFPanMusic.BitBtn2Click(Sender: TObject);
var
  i: integer;
begin
  if OpenDialog1.Execute then for i:=0 to OpenDialog1.Files.Count-1 do ListBox1.Items.Add(OpenDialog1.Files[i]);
end;

procedure TFPanMusic.BitBtn3Click(Sender: TObject);
begin
  ListBox1.Items.SaveToFile(MyConfDir('music.conf'));
end;

procedure TFPanMusic.BitBtn4Click(Sender: TObject);
begin
  ListBox1.Clear;
end;

procedure TFPanMusic.BitBtn5Click(Sender: TObject);
begin
  go(ListBox1.ItemIndex);
end;

procedure TFPanMusic.BitBtn6Click(Sender: TObject);
begin
  play.Stop(true);
end;

procedure TFPanMusic.BitBtn7Click(Sender: TObject);
begin
  if ListBox1.ItemIndex>-1 then Clipboard.AsText:=ListBox1.Items[ListBox1.ItemIndex];
end;

end.

