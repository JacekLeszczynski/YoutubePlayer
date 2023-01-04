unit zapis_tasmy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  Buttons, StdCtrls, Spin, ExtMessage, ZDataset, ZSqlProcessor;

type

  { TFZapisTasmy }

  TFZapisTasmy = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    DBGrid1: TDBGrid;
    ds_tasma: TDataSource;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    aktualizacja: TZSQLProcessor;
    Panel3: TPanel;
    wektor: TSpinEdit;
    tasma: TZQuery;
    tasmaczas: TLargeintField;
    tasmanazwa_czasu: TMemoField;
    tasmanazwa_filmu: TMemoField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
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
  ecode_c, serwis, Clipbrd;

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
  b1,b2: boolean;
begin
  if CheckBox6.Checked then
  begin
    b1:=CheckBox5.Checked;
    b2:=(not CheckBox5.Checked) and CheckBox4.Checked;
  end else begin
    b1:=false;
    b2:=false;
  end;
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
        if a<0 then a:=0;
        if a<1000*60*60 then
          pom:=FormatDateTime('nn:ss',IntegerToTime(a))
        else
          pom:=FormatDateTime('h:nn:ss',IntegerToTime(a));
        if s='' then s:=pom else s:=s+' - '+pom;
      end;
      if CheckBox5.Checked then if s='' then s:=FirstMinusToGeneratePlane(tasmanazwa_filmu.AsString,b1) else s:=s+' - '+FirstMinusToGeneratePlane(tasmanazwa_filmu.AsString,b1);
      if CheckBox4.Checked then if s='' then s:=FirstMinusToGeneratePlane(tasmanazwa_czasu.AsString,b2) else s:=s+' - '+FirstMinusToGeneratePlane(tasmanazwa_czasu.AsString,b2);
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

procedure TFZapisTasmy.BitBtn3Click(Sender: TObject);
begin
  aktualizacja.ParamByName('wektor').AsInteger:=wektor.Value*100;
  aktualizacja.Execute;
  wektor.Value:=0;
  tasma.Refresh;
end;

procedure TFZapisTasmy.BitBtn4Click(Sender: TObject);
begin
  if tasma.IsEmpty then exit;
  if mess.ShowConfirmationYesNo('Czy usunąć wskazaną pozycję?') then tasma.Delete;
end;

procedure TFZapisTasmy.FormCreate(Sender: TObject);
begin
  tasma.Open;
end;

procedure TFZapisTasmy.tasmaczasGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
var
  a: integer;
begin
  a:=Sender.AsInteger+(wektor.Value*100);
  if a<0 then a:=0;
  aText:=FormatDateTime('hh:nn:ss',IntegerToTime(a));
end;

procedure TFZapisTasmy.wektorChange(Sender: TObject);
begin
  tasma.Refresh;
end;

end.

