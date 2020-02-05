unit zapis_tasmy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  Buttons, StdCtrls, Spin, ExtMessage, ZDataset;

type

  { TFZapisTasmy }

  TFZapisTasmy = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    DBGrid1: TDBGrid;
    ds_tasma: TDataSource;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    wektor: TSpinEdit;
    tasma: TZQuery;
    tasmaczas: TLargeintField;
    tasmanazwa_czasu: TMemoField;
    tasmanazwa_filmu: TMemoField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tasmaczasGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure wektorChange(Sender: TObject);
  private

  public

  end;

var
  FZapisTasmy: TFZapisTasmy;

implementation

uses
  ecode, Clipbrd;

{$R *.lfm}

{ TFZapisTasmy }

procedure TFZapisTasmy.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  tasma.Close;
end;

procedure TFZapisTasmy.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TFZapisTasmy.BitBtn2Click(Sender: TObject);
var
  a: integer;
  t: TBookmark;
  ss: TStrings;
  s,pom: string;
begin
  ss:=TStringList.Create;
  ss.Clear;
  try
    t:=tasma.GetBookmark;
    tasma.DisableControls;
    tasma.First;
    while not tasma.EOF do
    begin
      s:='';
      if CheckBox3.Checked then
      begin
        a:=tasmaczas.AsInteger+(wektor.Value*100);
        if a<1000*60*60 then
          pom:=FormatDateTime('nn:ss',IntegerToTime(a))
        else
          pom:=FormatDateTime('h:nn:ss',IntegerToTime(a));
        if s='' then s:=pom else s:=s+' - '+pom;
      end;
      if CheckBox2.Checked then if s='' then s:=tasmanazwa_filmu.AsString else s:=s+' - '+tasmanazwa_filmu.AsString;
      if CheckBox3.Checked then if s='' then s:=tasmanazwa_czasu.AsString else s:=s+' - '+tasmanazwa_czasu.AsString;
      ss.Add(s);
      tasma.Next;
    end;
    tasma.GotoBookmark(t);
    tasma.EnableControls;
    Clipboard.AsText:=ss.Text;
  finally
    ss.Free;
  end;
  mess.ShowInformation('Zawartość taśmy została skopiowana do schowka.');
end;

procedure TFZapisTasmy.FormCreate(Sender: TObject);
begin
  tasma.Open;
end;

procedure TFZapisTasmy.tasmaczasGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText:=FormatDateTime('hh:nn:ss',IntegerToTime(Sender.AsInteger+(wektor.Value*100)));
end;

procedure TFZapisTasmy.wektorChange(Sender: TObject);
begin
  tasma.Refresh;
end;

end.

