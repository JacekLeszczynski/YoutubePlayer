unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Menus, XMLPropStorage, DBGrids, ZConnection, ZDataset,
  ZSqlProcessor, MPlayerCtrl, CsvParser, ExtMessage, ZTransaction, UOSEngine,
  UOSPlayer, PointerTab, Types, db, process, Grids, ComCtrls, DBCtrls,
  AsyncProcess, ueled, TplProgressBarUnit;

type

  { TForm1 }

  TForm1 = class(TForm)
    add_rec0: TZSQLProcessor;
    add_rec2: TZSQLProcessor;
    filmy_roz: TZQuery;
    roz_del1: TZSQLProcessor;
    rfilmy: TIdleTimer;
    ppp: TPointerTab;
    ProgressBar1: TProgressBar;
    roz_del2: TZSQLProcessor;
    uELED2: TuELED;
    BExit: TSpeedButton;
    filmyc_plik_exist: TBooleanField;
    filmyid: TLargeintField;
    filmylink: TMemoField;
    filmynazwa: TMemoField;
    filmyplik: TMemoField;
    filmyrozdzial: TLargeintField;
    filmysort: TLargeintField;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    ytdir: TSelectDirectoryDialog;
    rename_id0: TZSQLProcessor;
    roz_id: TZQuery;
    MenuItem25: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    roz_add: TZQuery;
    DBLookupComboBox1: TDBLookupComboBox;
    db_roz: TZQuery;
    db_rozid: TLargeintField;
    db_roznazwa: TMemoField;
    db_rozsort: TLargeintField;
    ds_roz: TDataSource;
    czasy_od_id: TZQuery;
    czasy_max: TZQuery;
    czasy_id: TZQuery;
    czasy_nast: TZQuery;
    czasy_przed: TZQuery;
    czasy_po: TZQuery;
    czasy_up_id: TZQuery;
    Edit1: TEdit;
    czasy2: TZQuery;
    roz2: TZQuery;
    roz_upd: TZQuery;
    roz_del: TZQuery;
    timer_bufor: TIdleTimer;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    film: TZQuery;
    MainMenu1: TMainMenu;
    Memory_2: TSpeedButton;
    Memory_3: TSpeedButton;
    Memory_4: TSpeedButton;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    oo: TplProgressBar;
    Panel1: TPanel;
    Panel9: TPanel;
    Play: TSpeedButton;
    podpowiedz: TLabel;
    podpowiedz2: TLabel;
    pp: TplProgressBar;
    rename_id: TZSQLProcessor;
    last_id: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ds_test_czas: TDataSource;
    Label2: TLabel;
    filmy2: TZQuery;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    N3: TMenuItem;
    OpenDialogCsv: TOpenDialog;
    Panel7: TPanel;
    Panel8: TPanel;
    oo_mouse: TIdleTimer;
    pakowanie_db: TZSQLProcessor;
    rename_id2: TZSQLProcessor;
    Rewind: TSpeedButton;
    Memory_1: TSpeedButton;
    Splitter2: TSplitter;
    Stop: TSpeedButton;
    test_czas: TZQuery;
    del_czasy_film: TZSQLProcessor;
    csv: TCsvParser;
    filmy_id: TZQuery;
    pp_mouse: TIdleTimer;
    ImageList1: TImageList;
    ini: TZSQLProcessor;
    del_all: TZSQLProcessor;
    ds_filmy: TDataSource;
    ds_czasy: TDataSource;
    add_rec: TZSQLProcessor;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    pop_czasy: TPopupMenu;
    test_czas2: TZQuery;
    restart_csv: TTimer;
    uELED1: TuELED;
    UOSEngine: TUOSEngine;
    UOSPlayer: TUOSPlayer;
    update_sort: TZSQLProcessor;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    N2: TMenuItem;
    mess: TExtMessage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mplayer: TMPlayerControl;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel6: TPanel;
    pop_lista: TPopupMenu;
    Splitter1: TSplitter;
    PropStorage: TXMLPropStorage;
    db: TZConnection;
    filmy: TZQuery;
    czasy: TZQuery;
    cr: TZSQLProcessor;
    trans: TZTransaction;
    procedure csvAfterRead(Sender: TObject);
    procedure csvBeforeRead(Sender: TObject);
    procedure csvRead(Sender: TObject; NumberRec, PosRec: integer; sName,
      sValue: string; var Stopped: boolean);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
    procedure DBLookupComboBox1DropDown(Sender: TObject);
    procedure DBLookupComboBox1Select(Sender: TObject);
    procedure db_roznazwaGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure filmyBeforeOpen(DataSet: TDataSet);
    procedure filmyCalcFields(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure mplayerPlay(Sender: TObject);
    procedure mplayerPlaying(ASender: TObject; APosition, ADuration: single);
    procedure mplayerSetPosition(Sender: TObject);
    procedure mplayerStop(Sender: TObject);
    procedure ooMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ooMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure oo_mouseStartTimer(Sender: TObject);
    procedure oo_mouseTimer(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure ppMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pppCreateElement(Sender: TObject; var AWskaznik: Pointer);
    procedure pppDestroyElement(Sender: TObject; var AWskaznik: Pointer);
    procedure pppReadElement(Sender: TObject; var AWskaznik: Pointer);
    procedure pppWriteElement(Sender: TObject; var AWskaznik: Pointer);
    procedure pp_mouseStartTimer(Sender: TObject);
    procedure pp_mouseTimer(Sender: TObject);
    procedure restart_csvTimer(Sender: TObject);
    procedure RewindClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure rfilmyTimer(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure test_czasBeforeOpen(DataSet: TDataSet);
    procedure timer_buforTimer(Sender: TObject);
    procedure _OPEN_CLOSE(DataSet: TDataSet);
    procedure _OPEN_CLOSE_TEST(DataSet: TDataSet);
    procedure _PLAY_MEMORY(Sender: TObject);
    procedure _ROZ_OPEN_CLOSE(DataSet: TDataSet);
  private
    film_tytul: string;
    lista_wybor,klucze_wybor: TStrings;
    cenzura: TMemoryStream;
    procedure SendKey(vkey: word; vcount: integer = 1);
    procedure db_open;
    procedure db_close;
    function get_last_id: integer;
    procedure przyciski(v_playing: boolean);
    procedure wygeneruj_plik(nazwa: string = '');
    procedure komenda_up;
    procedure komenda_down;
    function go_up(force_id: integer = 0): boolean;
    function go_first(force_id: integer = 0): boolean;
    function go_down(force_id: integer = 0): boolean;
    function go_last(force_id: integer = 0): boolean;
    procedure resize_update_grid;
    procedure test(APositionForce: single = 0.0);
    procedure czasy_edycja_188;
    procedure czasy_edycja_190;
    procedure czasy_edycja_191;
    procedure reset_oo;
    procedure play_memory(nr: integer);
    procedure zmiana(aTryb: integer = 0);
  public
    function GetYoutubeElement(var aLink: string; var aFilm: integer; var aDirectory: string): boolean;
    procedure SetYoutubeProcessOn;
    procedure SetYoutubeProcessOff;
  end;

var
  Form1: TForm1;

implementation

uses
  lista, czas, lista_wyboru, ecode, lcltype, MouseAndKeyInput, youtube_unit;

type
  TMemoryLamp = record
    active: boolean;
    rozdzial,indeks,indeks_czasu: integer;
    time: single;
  end;
  TYoutubeElement = record
    link: string;
    film: integer;
    dir: string;
  end;
  PYoutubeElement = ^TYoutubeElement;

var
  YoutubeElement: TYoutubeElement;
  YoutubeIsProcess: boolean = false;

var
  indeks_play: integer = -1;
  indeks_czas: integer = -1;
  force_position: boolean = false;
  force_end: integer = 0;
  rec: record
    typ: string[1];
    id,sort,film,czas_od,czas_do,rozdzial: integer;
    nazwa,link,plik: string;
  end;
  mem_lamp: array [1..4] of TMemoryLamp;
  key_buf: word = 0;
  bufor: array [1..2] of word;
  key_last: word;
  ytdl_id: integer;
  _yt_d1,_yt_d2: string;
  tryb: integer = 1;


var
  test_force: boolean = false;
  czas_aktualny: integer = -1;
  czas_nastepny: integer = -1;
  czas_aktualny_nazwa: string;
  czas_aktualny_indeks: integer = -1;
  bcenzura: boolean = false;

{$R *.lfm}

{ TForm1 }

procedure TForm1.PlayClick(Sender: TObject);
begin
  if mplayer.Paused then
  begin
    mplayer.Replay;
    if mplayer.Playing then Play.ImageIndex:=1 else Play.ImageIndex:=0;
    exit;
  end;
  if mplayer.Playing then
  begin
    mplayer.Pause;
    if mplayer.Playing then Play.ImageIndex:=1 else Play.ImageIndex:=0;
    exit;
  end;
  mplayer.Filename:=Edit1.Text;
  mplayer.Play;
  wygeneruj_plik(film_tytul)
end;

procedure TForm1.czasy_edycja_188;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  czasy.FieldByName('czas_od').AsInteger:=MiliSecToInteger(round(mplayer.GetPositionOnlyRead*1000));
  czasy.Post;
  test;
end;

procedure TForm1.czasy_edycja_190;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  czasy.FieldByName('czas_do').AsInteger:=MiliSecToInteger(round(mplayer.GetPositionOnlyRead*1000));
  czasy.Post;
  test;
end;

procedure TForm1.czasy_edycja_191;
begin
  if czasy.IsEmpty then exit;
  czasy.Edit;
  czasy.FieldByName('czas_do').Clear;
  czasy.Post;
  test;
end;

procedure TForm1.reset_oo;
begin
  oo.Min:=0;
  oo.Max:=10;
  oo.Position:=0;
  Label5.Caption:='-:--';
  Label6.Caption:='-:--';
end;

procedure TForm1.play_memory(nr: integer);
var
  t: single;
  r,i,i2: integer;
  czas: TTime;
  nazwa,link,plik: string;
  s,s1: string;
begin
  if not mem_lamp[nr].active then exit;
  r:=mem_lamp[nr].rozdzial;
  i:=mem_lamp[nr].indeks;
  i2:=mem_lamp[nr].indeks_czasu;
  t:=mem_lamp[nr].time;
  czas:=MiliSecToTime(round(t*1000));
  if mplayer.Running and (indeks_play=i) then mplayer.Position:=t else
  begin
    {ustawienia dot. list}
    db_roz.First;
    db_roz.Locate('id',r,[]);
    filmy.First;
    filmy.Locate('id',i,[]);
    czasy.First;
    czasy.Locate('id',i2,[]);
    {uruchomienie filmu}
    film.ParamByName('id').AsInteger:=i;
    film.Open;
    nazwa:=film.FieldByName('nazwa').AsString;
    link:=film.FieldByName('link').AsString;
    plik:=film.FieldByName('plik').AsString;
    film.Close;
    if mplayer.Running then mplayer.Stop;
    s:=plik;
    if (s='') or (not FileExists(s)) then s:=link;
    Edit1.Text:=s;
    film_tytul:=nazwa;
    s1:=FormatDateTime('hh:nn:ss',czas);
    force_position:=false;
    mplayer.StartParam:='--start='+s1;
    indeks_play:=i;
    indeks_czas:=i2;
    Play.Click;
  end;
  if MenuItem26.Checked then
  begin
    mem_lamp[nr].active:=false;
    case nr of
      1: Memory_1.ImageIndex:=27;
      2: Memory_2.ImageIndex:=29;
      3: Memory_3.ImageIndex:=31;
      4: Memory_4.ImageIndex:=33;
    end;
  end;
end;

procedure TForm1.zmiana(aTryb: integer);
begin
  if aTryb>0 then
  begin
    tryb:=aTryb;
    uELED1.Active:=tryb=1;
    uELED2.Active:=tryb=2;
  end else begin
    uELED1.Active:=false;
    uELED2.Active:=false;
  end;
end;

function TForm1.GetYoutubeElement(var aLink: string; var aFilm: integer;
  var aDirectory: string): boolean;
var
  b: boolean;
begin
  b:=ppp.Read;
  if b then
  begin
    aLink:=YoutubeElement.link;
    aFilm:=YoutubeElement.film;
    aDirectory:=YoutubeElement.dir;
  end else begin
    aLink:='';
    aFilm:=0;
    aDirectory:='';
  end;
  result:=b;
end;

procedure TForm1.SetYoutubeProcessOn;
begin
  YoutubeIsProcess:=true;
end;

procedure TForm1.SetYoutubeProcessOff;
begin
  YoutubeIsProcess:=false;
end;

procedure TForm1.csvAfterRead(Sender: TObject);
begin
  case TCsvParser(Sender).Tag of
    0: begin
         trans.Commit;
         db_roz.Refresh;
       end;
    1: restart_csv.Enabled:=true;
    2: begin
         ini.Execute;
         trans.Commit;
         db_roz.Refresh;
         lista_wybor.Clear;
         klucze_wybor.Clear;
       end;
  end;
end;

procedure TForm1.csvBeforeRead(Sender: TObject);
begin
  case TCsvParser(Sender).Tag of
    0: begin
         trans.StartTransaction;
         del_all.Execute;
       end;
    1: begin
         lista_wybor.Clear;
         klucze_wybor.Clear;
       end;
    2: trans.StartTransaction;
  end;
end;

procedure TForm1.csvRead(Sender: TObject; NumberRec, PosRec: integer; sName,
  sValue: string; var Stopped: boolean);
var
  i,id: integer;
begin
  if PosRec=1 then rec.typ:=sValue;
  if rec.typ='R' then
  begin
    case PosRec of
      1: rec.typ:=sValue;
      2: rec.id:=StrToInt(sValue);
      3: rec.sort:=StrToInt(sValue);
      4: rec.nazwa:=sValue;
    end;
    if PosRec=4 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             add_rec0.ParamByName('id').AsInteger:=rec.id;
             add_rec0.ParamByName('sort').AsInteger:=rec.sort;
             add_rec0.ParamByName('nazwa').AsString:=rec.nazwa;
             add_rec0.Execute;
           end;
      end; {case}
    end; {if PosRec=4}
  end else
  if rec.typ='F' then
  begin
    case PosRec of
      1: rec.typ:=sValue;
      2: rec.id:=StrToInt(sValue);
      3: rec.sort:=StrToInt(sValue);
      4: rec.link:=sValue;
      5: rec.plik:=sValue;
      6: if sValue='[null]' then rec.rozdzial:=-1 else rec.rozdzial:=StrToInt(sValue);
      7: rec.nazwa:=sValue;
    end;
    if PosRec=7 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             add_rec.ParamByName('id').AsInteger:=rec.id;
             add_rec.ParamByName('sort').AsInteger:=rec.sort;
             add_rec.ParamByName('nazwa').AsString:=rec.nazwa;
             if rec.link='' then add_rec.ParamByName('link').Clear else add_rec.ParamByName('link').AsString:=rec.link;
             if rec.plik='' then add_rec.ParamByName('plik').Clear else add_rec.ParamByName('plik').AsString:=rec.plik;
             if rec.rozdzial=-1 then add_rec.ParamByName('rozdzial').Clear
                                else add_rec.ParamByName('rozdzial').AsInteger:=rec.rozdzial;
             add_rec.Execute;
           end;
        1: begin
             {odczyt listy filmów by później wybrać niektóre z nich do doczytania}
             lista_wybor.Add(rec.nazwa);
             klucze_wybor.Add(IntToStr(rec.id));
           end;
        2: begin
             {zapis do bazy tylko wybranych pozycji}
             i:=ecode.StringToItemIndex(klucze_wybor,IntToStr(rec.id));
             if i>-1 then
             begin
               add_rec.ParamByName('id').Clear;
               add_rec.ParamByName('sort').Clear;
               add_rec.ParamByName('nazwa').AsString:=rec.nazwa;
               if rec.link='' then add_rec.ParamByName('link').Clear else add_rec.ParamByName('link').AsString:=rec.link;
               if rec.plik='' then add_rec.ParamByName('plik').Clear else add_rec.ParamByName('plik').AsString:=rec.plik;
               add_rec.ParamByName('rozdzial').Clear;
               //if rec.rozdzial='[null]' then add_rec.ParamByName('rozdzial').Clear
               //                         else add_rec.ParamByName('rozdzial').AsInteger:=rec.rozdzial;
               add_rec.Execute;
               id:=get_last_id;
               lista_wybor.Delete(i);
               lista_wybor.Insert(i,IntToStr(id));
             end;
           end;
      end; {case}
    end; {if PosRec=7}
  end else begin {CZASY}
    if TCsvParser(Sender).Tag=1 then
    begin
      Stopped:=true;
      exit;
    end;
    case PosRec of
      1: rec.typ:=sValue;
      2: rec.id:=StrToInt(sValue);
      3: rec.film:=StrToInt(sValue);
      4: rec.nazwa:=sValue;
      5: rec.czas_od:=StrToInt(sValue);
      6: rec.czas_do:=StrToInt(sValue);
    end;
    if PosRec=6 then
    begin
      case TCsvParser(Sender).Tag of
        0: begin
             {zapis do bazy}
             add_rec2.ParamByName('id').AsInteger:=rec.id;
             add_rec2.ParamByName('film').AsInteger:=rec.film;
             add_rec2.ParamByName('nazwa').AsString:=rec.nazwa;
             add_rec2.ParamByName('czas_od').AsInteger:=rec.czas_od;
             if rec.czas_do=0 then add_rec2.ParamByName('czas_do').Clear
             else add_rec2.ParamByName('czas_do').AsInteger:=rec.czas_do;
             add_rec2.Execute;
           end;
        2: begin
             {zapis do bazy tylko wybranych pozycji}
             i:=ecode.StringToItemIndex(klucze_wybor,IntToStr(rec.film));
             if i>-1 then
             begin
               id:=StrToInt(lista_wybor[i]);
               add_rec2.ParamByName('id').Clear;
               add_rec2.ParamByName('film').AsInteger:=id;
               add_rec2.ParamByName('nazwa').AsString:=rec.nazwa;
               add_rec2.ParamByName('czas_od').AsInteger:=rec.czas_od;
               if rec.czas_do=0 then add_rec2.ParamByName('czas_do').Clear
               else add_rec2.ParamByName('czas_do').AsInteger:=rec.czas_do;
               add_rec2.Execute;
             end;
           end;
      end; {case}
    end; {if PosRec=6}
  end; {CZASY}
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
var
  s: string;
begin
  if filmy.IsEmpty then exit;
  if mplayer.Playing then mplayer.Stop;
  indeks_czas:=-1;
  s:=filmy.FieldByName('plik').AsString;
  if (s='') or (not FileExists(s)) then s:=filmy.FieldByName('link').AsString;
  Edit1.Text:=s;
  film_tytul:=filmy.FieldByName('nazwa').AsString;
  indeks_play:=filmy.FieldByName('id').AsInteger;
  indeks_czas:=-1;
  Play.Click;
end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  b: boolean;
begin
  DBGrid1.Canvas.Font.Bold:=false;
  b:=filmyc_plik_exist.AsBoolean;
  if b then DBGrid1.Canvas.Font.Color:=clBlue else DBGrid1.Canvas.Font.Color:=TColor($333333);
  if indeks_play=filmyid.AsInteger then
  begin
    DBGrid1.Canvas.Font.Bold:=true;
    if b then
      DBGrid1.Canvas.Font.Color:=TColor($0E0044)
    else
      DBGrid1.Canvas.Font.Color:=clBlack;
  end;
  DBGrid1.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
var
  s,s1,s2: string;
  t: TTime;
  Hour, Minute, Second, MilliSecond: word;
  a: single;
begin
  if czasy.IsEmpty then exit;
  {player działa}
  if (mplayer.Playing or mplayer.Paused) and (indeks_play=filmy.FieldByName('id').AsInteger) then
  begin
    t:=IntegerToTime(czasy.FieldByName('czas_od').AsInteger);
    DecodeTime(t,Hour,Minute,Second,MilliSecond);
    a:=(Hour*60*60)+(Minute*60)+Second+(MilliSecond/1000);
    mplayer.Position:=a;
    //film_tytul:=filmy.FieldByName('nazwa').AsString+' - '+czasy.FieldByName('nazwa').AsString;
    //wygeneruj_plik(film_tytul);
    //test_force:=true;
    exit;
  end;
  {player nie działa - uruchamiam i lece od danego momentu}
  if mplayer.Playing or mplayer.Paused then mplayer.Stop;
  s:=filmy.FieldByName('plik').AsString;
  if (s='') or (not FileExists(s)) then s:=filmy.FieldByName('link').AsString;
  Edit1.Text:=s;
  film_tytul:=filmy.FieldByName('nazwa').AsString;//+' - '+czasy.FieldByName('nazwa').AsString;
  s1:=FormatDateTime('hh:nn:ss',IntegerToTime(czasy.FieldByName('czas_od').AsInteger));
  force_position:=false;
  mplayer.StartParam:='--start='+s1;
  indeks_play:=filmy.FieldByName('id').AsInteger;
  if indeks_czas>-1 then indeks_czas:=czasy.FieldByName('id').AsInteger;
  Play.Click;
end;

procedure TForm1.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DBGrid2.Canvas.Font.Bold:=false;
  DBGrid2.Canvas.Font.Color:=TColor($333333);
  if indeks_czas=czasy.FieldByName('id').AsInteger then
  begin
    DBGrid2.Canvas.Font.Bold:=true;
    DBGrid2.Canvas.Font.Color:=clBlack;
  end;
  DBGrid2.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TForm1.DBLookupComboBox1CloseUp(Sender: TObject);
begin
  DBLookupComboBox1.DataSource:=ds_roz;
  DBLookupComboBox1.DataField:='id';
end;

procedure TForm1.DBLookupComboBox1DropDown(Sender: TObject);
begin
  DBLookupComboBox1.DataSource:=nil;
end;

procedure TForm1.DBLookupComboBox1Select(Sender: TObject);
var
  id: integer;
begin
  id:=DBLookupComboBox1.KeyValue;
  db_roz.Locate('id',id,[]);
end;

procedure TForm1.db_roznazwaGetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText:=Sender.AsString;
end;

procedure TForm1.filmyBeforeOpen(DataSet: TDataSet);
begin
  if MenuItem25.Checked then filmy.ParamByName('all').AsInteger:=0
                        else filmy.ParamByName('all').AsInteger:=1;
end;

procedure TForm1.filmyCalcFields(DataSet: TDataSet);
var
  b: boolean;
  s: string;
begin
  s:=filmyplik.AsString;
  if (s='') or (not FileExists(s)) then b:=false else b:=true;
  filmyc_plik_exist.AsBoolean:=b;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if mplayer.Playing or mplayer.Paused then mplayer.Stop;
  wygeneruj_plik;
  db_close;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  b: boolean;
  res: TResourceStream;
begin
  case Key of
    VK_SPACE: if mplayer.Running then if mplayer.Playing then mplayer.Pause else if mplayer.Paused then mplayer.Replay;
    VK_LEFT: if mplayer.Running and (not MenuItem18.Checked) then mplayer.Position:=mplayer.Position-4;
    VK_RIGHT: if mplayer.Running and (not MenuItem18.Checked) then mplayer.Position:=mplayer.Position+4;
    VK_UP: komenda_up;
    VK_DOWN: komenda_down;
    VK_R: if mplayer.Running then test_force:=true;
    VK_E: if mplayer.Running and MenuItem15.Checked then MenuItem11.Click; //'E'
    VK_RETURN: if mplayer.Running and MenuItem15.Checked then DBGrid2DblClick(Sender); //'ENTER'
    107: if mplayer.Running and MenuItem15.Checked then MenuItem10.Click; //'+'
    188: if mplayer.Running and MenuItem15.Checked then czasy_edycja_188; //'<'
    190: if mplayer.Running and MenuItem15.Checked then czasy_edycja_190; //'>'
    191: if mplayer.Running and MenuItem15.Checked then czasy_edycja_191; //'/'
    else if MenuItem17.Checked then writeln('Klawisz: ',Key);
  end;
  if MenuItem18.Checked then
  begin
    if Key=45 then if bcenzura then
    begin
      UOSPlayer.Stop;
      bcenzura:=false;
    end else
    begin
      try
        cenzura:=TMemoryStream.Create;
        res:=TResourceStream.Create(hInstance,'CENZURA',RT_RCDATA);
        cenzura.LoadFromStream(res);
      finally
        res.Free;
      end;
      UOSPlayer.Volume:=0.04;
      UOSPlayer.Start(cenzura);
      bcenzura:=true;
    end;
    if Key=46 then
    begin
      try
        cenzura:=TMemoryStream.Create;
        res:=TResourceStream.Create(hInstance,'PRZERYWNIK2',RT_RCDATA);
        cenzura.LoadFromStream(res);
      finally
        res.Free;
      end;
      UOSPlayer.Volume:=1;
      UOSPlayer.Start(cenzura);
    end;
    b:=false;
    if (Key=66) and (key_buf<>17) then
    begin
      bufor[2]:=bufor[1];
      bufor[1]:=1;
      if not timer_bufor.Enabled then timer_bufor.Enabled:=true;
    end else
    if Key=33 then
    begin
      bufor[2]:=bufor[1];
      bufor[1]:=2;
      if not timer_bufor.Enabled then timer_bufor.Enabled:=true;
    end else
    if Key=34 then
    begin
      bufor[2]:=bufor[1];
      bufor[1]:=3;
      if not timer_bufor.Enabled then timer_bufor.Enabled:=true;
    end else
    if ((Key=18) and (key_buf=66)) then
    begin
      bufor[2]:=bufor[1];
      bufor[1]:=4;
      if not timer_bufor.Enabled then timer_bufor.Enabled:=true;
    end else
    if Key=VK_ESCAPE then
    begin
      bufor[2]:=bufor[1];
      bufor[1]:=5;
      if not timer_bufor.Enabled then timer_bufor.Enabled:=true;
    end;
  end;
  if Key>0 then key_buf:=Key;
  Key:=0;
end;

procedure TForm1.Memory_1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[1].active:=false;
    Memory_1.ImageIndex:=27;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[1].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[1].indeks:=indeks_play;
    mem_lamp[1].indeks_czasu:=indeks_czas;
    mem_lamp[1].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[1].active:=true;
    Memory_1.ImageIndex:=28;
  end;
end;

procedure TForm1.Memory_2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[2].active:=false;
    Memory_2.ImageIndex:=29;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[2].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[2].indeks:=indeks_play;
    mem_lamp[2].indeks_czasu:=indeks_czas;
    mem_lamp[2].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[2].active:=true;
    Memory_2.ImageIndex:=30;
  end;
end;

procedure TForm1.Memory_3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[3].active:=false;
    Memory_3.ImageIndex:=31;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[3].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[3].indeks:=indeks_play;
    mem_lamp[3].indeks_czasu:=indeks_czas;
    mem_lamp[3].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[3].active:=true;
    Memory_3.ImageIndex:=32;
  end;
end;

procedure TForm1.Memory_4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbMiddle then
  begin
    mem_lamp[4].active:=false;
    Memory_4.ImageIndex:=33;
  end else
  if Button=mbRight then
  begin
    if not mplayer.Running then exit;
    mem_lamp[4].rozdzial:=db_roz.FieldByName('id').AsInteger;
    mem_lamp[4].indeks:=indeks_play;
    mem_lamp[4].indeks_czasu:=indeks_czas;
    mem_lamp[4].time:=mplayer.GetPositionOnlyRead;
    mem_lamp[4].active:=true;
    Memory_4.ImageIndex:=34;
  end;
end;

procedure TForm1.mplayerStop(Sender: TObject);
begin
  mplayer.StartParam:='';
  indeks_play:=-1;
  indeks_czas:=-1;
  czas_aktualny:=-1;
  czas_nastepny:=-1;
  DBGrid1.Refresh;
  DBGrid2.Refresh;
  przyciski(false);
  Play.ImageIndex:=0;
  Label3.Caption:='-:--';
  Label4.Caption:='-:--';
  pp.Position:=0;
  reset_oo;
end;

procedure TForm1.ooMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if mplayer.Running and (Label5.Caption<>'-:--') then
  begin
    if czas_nastepny=-1 then max:=MiliSecToInteger(round(mplayer.Duration*1000))-czas_aktualny
    else max:=czas_nastepny-czas_aktualny;
    a:=round(max*X/oo.Width)+czas_aktualny;
    czas:=IntegerToTime(a)*SecsPerDay;
    mplayer.Position:=czas;
  end;
end;

procedure TForm1.ooMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var
  max: integer;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if mplayer.Running and (Label5.Caption<>'-:--') then
  begin
    if czas_nastepny=-1 then max:=MiliSecToInteger(round(mplayer.Duration*1000))-czas_aktualny
    else max:=czas_nastepny-czas_aktualny;
    a:=round(max*X/oo.Width)+czas_aktualny;
    aa:=IntegerToTime(a);
    bPos:=a<3600000;
    if bPos then podpowiedz2.Caption:=FormatDateTime('nn:ss',aa) else podpowiedz2.Caption:=FormatDateTime('h:nn:ss',aa);
    podpowiedz2.Left:=X+oo.Left-round(podpowiedz2.Width/2);
    podpowiedz2.Visible:=true;
    oo_mouse.Enabled:=false;
    oo_mouse.Enabled:=true;
  end;
end;

procedure TForm1.oo_mouseStartTimer(Sender: TObject);
begin
  podpowiedz2.Visible:=true;
end;

procedure TForm1.oo_mouseTimer(Sender: TObject);
begin
  oo_mouse.Enabled:=false;
  podpowiedz2.Visible:=false;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
var
  a,b: integer;
begin
  b:=MiliSecToInteger(Round(mplayer.GetPositionOnlyRead*1000));
  czasy_max.Open;
  if czasy_max.IsEmpty then a:=0 else
  begin
    if czasy_max.FieldByName('czas_do').IsNull then
      a:=czasy_max.FieldByName('czas_od').AsInteger
    else
    a:=czasy_max.FieldByName('czas_do').AsInteger;
  end;
  czasy_max.Close;

  trans.StartTransaction;
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  czasy.FieldByName('nazwa').AsString:='..';
  if b<a then czasy.FieldByName('czas_od').AsInteger:=a
         else czasy.FieldByName('czas_od').AsInteger:=b;
  czasy.Post;
  trans.Commit;
  test;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
var
  id: integer;
begin
  if czasy.RecordCount=0 then exit;
  id:=czasy.FieldByName('id').AsInteger;
  FCzas.s_nazwa:=czasy.FieldByName('nazwa').AsString;
  FCzas.i_od:=czasy.FieldByName('czas_od').AsInteger;
  if czasy.FieldByName('czas_do').IsNull then FCzas.i_do:=0
  else FCzas.i_do:=czasy.FieldByName('czas_do').AsInteger;
  FCzas.in_tryb:=2;
  FCzas.ShowModal;
  if FCzas.out_ok then
  begin
    trans.StartTransaction;
    czasy.Edit;
    czasy.FieldByName('nazwa').AsString:=FCzas.s_nazwa;
    czasy.Post;
    trans.Commit;
  end;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  if czasy.RecordCount=0 then exit;
  if not mess.ShowConfirmationYesNo('Czy faktycznie chcesz usunąć ten wpis?') then exit;
  czasy.Delete;
  test_force:=true;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
var
  a_id,a_od,a_do: integer;
  p_id,p_od,p_do: integer;
  id,pom1,pom2: integer;
  cod: integer;
begin
  a_id:=czasy.FieldByName('id').AsInteger;
  a_od:=czasy.FieldByName('czas_od').AsInteger;
  if czasy.FieldByName('czas_do').IsNull then a_do:=-1 else a_do:=czasy.FieldByName('czas_do').AsInteger;
  czasy_przed.ParamByName('id_aktualne').AsInteger:=a_id;
  czasy_przed.Open;
  if czasy_przed.IsEmpty then
  begin
    p_od:=0;
    p_do:=0;
  end else begin
    p_id:=czasy_przed.FieldByName('id').AsInteger;
    p_od:=czasy_przed.FieldByName('czas_od').AsInteger;
    if czasy_przed.FieldByName('czas_do').IsNull then p_do:=-1 else p_do:=czasy_przed.FieldByName('czas_do').AsInteger;
  end;
  czasy_przed.Close;

  if p_do=-1 then cod:=p_od else cod:=p_do;

  trans.StartTransaction;
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  czasy.FieldByName('nazwa').AsString:='..';
  czasy.FieldByName('czas_od').AsInteger:=cod;
  czasy.FieldByName('czas_do').Clear;
  czasy.Post;
  czasy.Last;
  id:=czasy.FieldByName('id').AsInteger;
  czasy_up_id.ParamByName('id').AsInteger:=id;
  czasy_up_id.ParamByName('new_id').AsInteger:=0;
  czasy_up_id.ExecSQL;

  czasy_od_id.ParamByName('id_aktualne').AsInteger:=a_id;
  czasy_od_id.Open;
  pom1:=id;
  while not czasy_od_id.EOF do
  begin
    pom2:=czasy_od_id.Fields[0].AsInteger;
    czasy_up_id.ParamByName('id').AsInteger:=pom2;
    czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
    czasy_up_id.ExecSQL;
    czasy_od_id.Next;
    pom1:=pom2;
  end;
  czasy_up_id.ParamByName('id').AsInteger:=0;
  czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
  czasy_up_id.ExecSQL;
  czasy_od_id.Close;
  trans.Commit;
  czasy.Refresh;
  czasy.Locate('id',pom1,[]);
  test;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
var
  a_id,a_od,a_do: integer;
  p_id,p_od,p_do: integer;
  id,pom1,pom2: integer;
  cod: integer;
  ostatni: boolean;
begin
  a_id:=czasy.FieldByName('id').AsInteger;
  a_od:=czasy.FieldByName('czas_od').AsInteger;
  if czasy.FieldByName('czas_do').IsNull then a_do:=-1 else a_do:=czasy.FieldByName('czas_do').AsInteger;
  czasy_po.ParamByName('id_aktualne').AsInteger:=a_id;
  czasy_po.Open;
  if czasy_po.IsEmpty then ostatni:=true else
  begin
    p_id:=czasy_po.FieldByName('id').AsInteger;
    p_od:=czasy_po.FieldByName('czas_od').AsInteger;
    if czasy_po.FieldByName('czas_do').IsNull then p_do:=-1 else p_do:=czasy_po.FieldByName('czas_do').AsInteger;
    ostatni:=false;
  end;
  czasy_po.Close;

  if a_do=-1 then cod:=a_od else cod:=a_do;

  trans.StartTransaction;
  czasy.Append;
  czasy.FieldByName('film').AsInteger:=filmy.FieldByName('id').AsInteger;
  czasy.FieldByName('nazwa').AsString:='..';
  czasy.FieldByName('czas_od').AsInteger:=cod;
  czasy.FieldByName('czas_do').Clear;
  czasy.Post;
  czasy.Last;
  if ostatni then
  begin
    trans.Commit;
    exit;
  end;
  id:=czasy.FieldByName('id').AsInteger;
  czasy_up_id.ParamByName('id').AsInteger:=id;
  czasy_up_id.ParamByName('new_id').AsInteger:=0;
  czasy_up_id.ExecSQL;

  czasy_od_id.ParamByName('id_aktualne').AsInteger:=p_id;
  czasy_od_id.Open;
  pom1:=id;
  while not czasy_od_id.EOF do
  begin
    pom2:=czasy_od_id.Fields[0].AsInteger;
    czasy_up_id.ParamByName('id').AsInteger:=pom2;
    czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
    czasy_up_id.ExecSQL;
    czasy_od_id.Next;
    pom1:=pom2;
  end;
  czasy_up_id.ParamByName('id').AsInteger:=0;
  czasy_up_id.ParamByName('new_id').AsInteger:=pom1;
  czasy_up_id.ExecSQL;
  czasy_od_id.Close;
  trans.Commit;
  czasy.Refresh;
  czasy.Locate('id',pom1,[]);
  test;
end;

procedure TForm1.MenuItem15Click(Sender: TObject);
begin
  MenuItem15.Checked:=not MenuItem15.Checked;
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
begin
  if OpenDialogCsv.Execute then
  begin
    csv.Filename:=OpenDialogCsv.FileName;
    csv.Tag:=1;
    csv.Execute;
  end;
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
  MenuItem17.Checked:=not MenuItem17.Checked;
end;

procedure TForm1.MenuItem18Click(Sender: TObject);
begin
  MenuItem18.Checked:=not MenuItem18.Checked;
  if MenuItem18.Checked then zmiana(tryb) else zmiana;
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
var
  id_roz,id_filmu,id_czasu: integer;
  id,new_id: integer;
begin
  if not mess.ShowConfirmationYesNo('Baza danych zostanie zrestrukturyzowana, identyfikatory zostaną przepisane i nadane na nowo, po tej operacji baza zostanie spakowana, by zwolnić zajmowane miejsce na dysku.^^Czy kontynuować?') then exit;
  if filmy.IsEmpty then exit;
  id_roz:=db_roz.FieldByName('id').AsInteger;
  id_filmu:=filmy.FieldByName('id').AsInteger;
  if czasy.IsEmpty then id_czasu:=-1 else id_czasu:=czasy.FieldByName('id').AsInteger;
  trans.StartTransaction;
  {rozdziały}
  roz2.Open;
  new_id:=1;
  while not roz2.EOF do
  begin
    id:=roz2.FieldByName('id').AsInteger;
    if id<>new_id then
    begin
      if id=id_roz then id_roz:=new_id;
      rename_id0.ParamByName('id').AsInteger:=id;
      rename_id0.ParamByName('new_id').AsInteger:=new_id;
      rename_id0.Execute;
    end;
    inc(new_id);
    roz2.Next;
  end;
  roz2.Close;
  {filmy}
  filmy2.Open;
  new_id:=1;
  while not filmy2.EOF do
  begin
    id:=filmy2.FieldByName('id').AsInteger;
    if id<>new_id then
    begin
      if id=id_filmu then id_filmu:=new_id;
      rename_id.ParamByName('id').AsInteger:=id;
      rename_id.ParamByName('new_id').AsInteger:=new_id;
      rename_id.Execute;
    end;
    inc(new_id);
    filmy2.Next;
  end;
  filmy2.Close;
  {czasy}
  czasy2.Open;
  new_id:=1;
  while not czasy2.EOF do
  begin
    id:=czasy2.FieldByName('id').AsInteger;
    if id<>new_id then
    begin
      if id=id_czasu then id_czasu:=new_id;
      rename_id2.ParamByName('id').AsInteger:=id;
      rename_id2.ParamByName('new_id').AsInteger:=new_id;
      rename_id2.Execute;
    end;
    inc(new_id);
    czasy2.Next;
  end;
  czasy2.Close;
  trans.Commit;
  pakowanie_db.Execute;
  //filmy.Close;
  db_roz.Close;
  db.Disconnect;
  db.Connect;
  //filmy.Open;
  db_roz.Open;
  db_roz.Locate('id',id_roz,[]);
  filmy.Locate('id',id_filmu,[]);
  if id_czasu>-1 then czasy.Locate('id',id_czasu,[]);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  FLista:=TFLista.Create(self);
  try
    FLista.in_tryb:=1;
    FLista.i_roz:=db_roz.FieldByName('id').AsInteger;
    FLista.ShowModal;
    if FLista.out_ok then
    begin
      trans.StartTransaction;
      filmy.Append;
      filmy.FieldByName('nazwa').AsString:=FLista.s_tytul;
      if FLista.s_link='' then filmy.FieldByName('link').Clear else filmy.FieldByName('link').AsString:=FLista.s_link;
      if FLista.s_file='' then filmy.FieldByName('plik').Clear else filmy.FieldByName('plik').AsString:=FLista.s_file;
      if FLista.i_roz=0 then filmy.FieldByName('rozdzial').Clear
      else filmy.FieldByName('rozdzial').AsInteger:=FLista.i_roz;
      filmy.Post;
      ini.Execute;
      trans.Commit;
    end;
  finally
    FLista.Free;
  end;
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var
  id_roz,id_filmu,id_czasu: integer;
begin
  if mess.ShowConfirmationYesNo('Baza danych zostanie spakowana, tj. usunięte zostaną rekordy wcześniej usunięte, które zajmują już tylko pamięć dyskową.^^Czy kontynuować?') then
  begin
    id_roz:=db_roz.FieldByName('id').AsInteger;
    if filmy.IsEmpty then id_filmu:=-1 else id_filmu:=filmy.FieldByName('id').AsInteger;
    if czasy.IsEmpty then id_czasu:=-1 else id_czasu:=czasy.FieldByName('id').AsInteger;
    pakowanie_db.Execute;
    //filmy.Close;
    db_roz.Close;
    db.Disconnect;
    db.Connect;

    //filmy.Open;
    //if id_filmu>-1 then filmy.Locate('id',id_filmu,[]);
    //if id_czasu>-1 then czasy.Locate('id',id_czasu,[]);

    db_roz.Open;
    db_roz.Locate('id',id_roz,[]);
    filmy.Locate('id',id_filmu,[]);
    if id_czasu>-1 then czasy.Locate('id',id_czasu,[]);
  end;
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
  MenuItem25.Checked:=not MenuItem25.Checked;
  filmy.Close;
  filmy.Open;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  MenuItem26.Checked:=not MenuItem26.Checked;
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
var
  s: string;
  id: integer;
begin
  s:=InputBox('Nowy rozdział','Podaj nazwę:','');
  if s<>'' then
  begin
    roz_add.ParamByName('nazwa').AsString:=s;
    roz_add.ExecSQL;
    id:=get_last_id;
    db_roz.Refresh;
    db_roz.Locate('id',id,[]);
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if filmy.RecordCount=0 then exit;
  FLista:=TFLista.Create(self);
  try
    FLista.s_tytul:=filmy.FieldByName('nazwa').AsString;
    FLista.s_link:=filmy.FieldByName('link').AsString;
    FLista.s_file:=filmy.FieldByName('plik').AsString;
    if filmy.FieldByName('rozdzial').IsNull then FLista.i_roz:=0
    else FLista.i_roz:=filmy.FieldByName('rozdzial').AsInteger;
    FLista.in_tryb:=2;
    FLista.ShowModal;
    if FLista.out_ok then
    begin
      trans.StartTransaction;
      filmy.Edit;
      filmy.FieldByName('nazwa').AsString:=FLista.s_tytul;
      if FLista.s_link='' then filmy.FieldByName('link').Clear else filmy.FieldByName('link').AsString:=FLista.s_link;
      if FLista.s_file='' then filmy.FieldByName('plik').Clear else filmy.FieldByName('plik').AsString:=FLista.s_file;
      if FLista.i_roz=0 then filmy.FieldByName('rozdzial').Clear
      else filmy.FieldByName('rozdzial').AsInteger:=FLista.i_roz;
      filmy.Post;
      trans.Commit;
      filmy.Refresh;
    end;
  finally
    FLista.Free;
  end;
end;

procedure TForm1.MenuItem30Click(Sender: TObject);
var
  pom,s: string;
  id: integer;
begin
  if db_roz.FieldByName('id').AsInteger=0 then exit;
  id:=db_roz.FieldByName('id').AsInteger;
  pom:=db_roz.FieldByName('nazwa').AsString;
  s:=InputBox('Edycja rozdziału','Podaj nową nazwę:','');
  if (s<>'') and (s<>pom) then
  begin
    db_roz.Edit;
    db_roz.FieldByName('nazwa').AsString:=s;
    db_roz.Post;
  end;
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
var
  id: integer;
  b: boolean;
  link,plik: string;
begin
  if db_roz.FieldByName('id').AsInteger=0 then exit;
  if mess.ShowConfirmationYesNo('Czy usunąć wskazany rozdział?') then
  begin
    id:=db_roz.FieldByName('id').AsInteger;
    trans.StartTransaction;
    if mess.ShowConfirmationYesNo('Czy usunąć jednocześnie z bazy danych wszystkie filmy należące do usuwanego rozdziału?') then
    begin
      b:=mess.ShowConfirmationYesNo('Czy istniejące pliki skojarzone z filmami także usunąć?^^Zwróć uwagę, że zostaną tylko usunięte pliki, których film ma wypełniony link do Youtube, więc pozycje bez tego linku nie zostaną usunięte.');
      filmy_roz.Open;
      while not filmy_roz.EOF do
      begin
        if b then
        begin
          if filmy_roz.FieldByName('link').IsNull then link:='' else  link:=filmy_roz.FieldByName('link').AsString;
          plik:=filmy_roz.FieldByName('plik').AsString;
          if (link<>'') and (plik<>'') then if FileExists(plik) then DeleteFile(plik);
        end;
        del_czasy_film.ParamByName('id').AsInteger:=filmy_roz.FieldByName('id').AsInteger;
        del_czasy_film.Execute;
        filmy_roz.Next;
      end;
      filmy_roz.Close;
      roz_del2.ParamByName('id').AsInteger:=id;
      roz_del2.Execute;
      db_roz.Delete;
    end else begin
      roz_del1.ParamByName('id').AsInteger:=id;
      roz_del1.Execute;
      db_roz.Delete;
    end;
    trans.Commit;
  end;
end;

procedure TForm1.MenuItem32Click(Sender: TObject);
begin
  if filmyc_plik_exist.AsBoolean then exit;
  if not ytdir.Execute then exit;
  YoutubeElement.link:=filmylink.AsString;
  YoutubeElement.film:=filmyid.AsInteger;
  YoutubeElement.dir:=ytdir.FileName;
  ppp.Add;
  if not YoutubeIsProcess then TWatekYoutube.Create;
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
var
  t: TBookmark;
begin
  if filmy.IsEmpty then exit;
  if not ytdir.Execute then exit;
  filmy.DisableControls;
  t:=filmy.GetBookmark;
  filmy.First;
  while not filmy.EOF do
  begin
    if filmyc_plik_exist.AsBoolean then
    begin
      filmy.Next;
      continue;
    end;
    YoutubeElement.link:=filmylink.AsString;
    YoutubeElement.film:=filmyid.AsInteger;
    YoutubeElement.dir:=ytdir.FileName;
    ppp.Add;
    filmy.Next;
  end;
  filmy.GotoBookmark(t);
  filmy.EnableControls;
  if not YoutubeIsProcess then TWatekYoutube.Create;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var
  id,i: integer;
  link,plik: string;
begin
  if filmy.RecordCount=0 then exit;
  if not mess.ShowConfirmationYesNo('Czy usunąć pozycję z listy filmów?') then exit;
  id:=filmy.FieldByName('id').AsInteger;
  if filmylink.IsNull then link:='' else link:=filmylink.AsString;
  for i:=1 to 4 do if mem_lamp[i].active and (mem_lamp[i].indeks=id) then
  begin
    mem_lamp[i].active:=false;
    case i of
      1: Memory_1.ImageIndex:=27;
      2: Memory_2.ImageIndex:=29;
      3: Memory_3.ImageIndex:=31;
      4: Memory_4.ImageIndex:=33;
    end;
  end;
  if id=indeks_play then mplayer.Stop;
  plik:=filmy.FieldByName('plik').AsString;
  trans.StartTransaction;
  del_czasy_film.ParamByName('id').AsInteger:=id;
  del_czasy_film.Execute;
  filmy.Delete;
  trans.Commit;
  if (link<>'') and (plik<>'') and FileExists(plik) then if mess.ShowConfirmationYesNo('Znaleziono plik na dysku do którego odnosiła się ta pozycja, czy chcesz także usunąć plik z dysku?') then DeleteFile(plik);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  if not mess.ShowConfirmationYesNo('Aktualne pozycje zostaną usunięte, kontynuować?') then exit;
  csv.Tag:=0;
  csv.Filename:='archiwum.csv';
  csv.Execute;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
var
  f: textfile;
  s,p1: string;
begin
  if filmy.RecordCount=0 then exit;
  assignfile(f,'archiwum.csv');
  rewrite(f);
  roz_id.Open;
  roz_id.First;
  while not roz_id.EOF do
  begin
    s:='R;'+roz_id.FieldByName('id').AsString+';'+roz_id.FieldByName('sort').AsString+';"'+roz_id.FieldByName('nazwa').AsString+'";[null];[null];[null]';
    writeln(f,s);
    roz_id.Next;
  end;
  roz_id.Close;
  filmy_id.Open;
  filmy_id.First;
  while not filmy_id.EOF do
  begin
    if filmy_id.FieldByName('rozdzial').IsNull then p1:='[null]' else p1:=filmy_id.FieldByName('rozdzial').AsString;
    s:='F;'+filmy_id.FieldByName('id').AsString+';'+filmy_id.FieldByName('sort').AsString+';"'+filmy_id.FieldByName('link').AsString+'";"'+filmy_id.FieldByName('plik').AsString+'";'+p1+';"'+filmy_id.FieldByName('nazwa').AsString+'"';
    writeln(f,s);
    filmy_id.Next;
  end;
  filmy_id.Close;
  czasy_id.Open;
  while not czasy_id.EOF do
  begin
    if czasy_id.FieldByName('czas_do').IsNull then p1:='0' else p1:=czasy_id.FieldByName('czas_do').AsString;
    s:='C;'+czasy_id.FieldByName('id').AsString+';'+czasy_id.FieldByName('film').AsString+';"'+czasy_id.FieldByName('nazwa').AsString+'";'+czasy_id.FieldByName('czas_od').AsString+';'+p1+';[null]';
    writeln(f,s);
    czasy_id.Next;
  end;
  czasy_id.Close;
  closefile(f);
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  go_up;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  go_down;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  go_first;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  go_last;
end;

procedure TForm1.mplayerPlay(Sender: TObject);
begin
  DBGrid1.Refresh;
  DBGrid2.Refresh;
  przyciski(true);
  if mplayer.Playing then Play.ImageIndex:=1 else Play.ImageIndex:=0;
  test;
end;

procedure TForm1.mplayerPlaying(ASender: TObject; APosition, ADuration: single);
var
  a,b,n: integer;
  aa,bb: TTime;
  bPos,bMax: boolean;
begin
  {kod dotyczy kontrolki "pp"}
  if ADuration=0 then exit;
  aa:=ADuration/SecsPerDay;
  bb:=APosition/SecsPerDay;
  a:=TimeToInteger(aa);
  b:=TimeToInteger(bb);
  pp.Min:=0;
  pp.Max:=a;
  pp.Position:=b;
  bMax:=a<3600000;
  bPos:=b<3600000;
  if bPos then Label3.Caption:=FormatDateTime('nn:ss',bb) else Label3.Caption:=FormatDateTime('h:nn:ss',bb);
  if bMax then Label4.Caption:=FormatDateTime('nn:ss',aa) else Label4.Caption:=FormatDateTime('h:nn:ss',aa);
  if test_force or ((czas_nastepny>-1) and (czas_nastepny<b)) then test;
  {kod dotyczy kontrolki "oo"}
  if czas_aktualny>-1 then
  begin
    if czas_nastepny=-1 then n:=TimeToInteger(ADuration/SecsPerDay) else n:=czas_nastepny;
    if n-czas_aktualny<=0 then
    begin
      if oo.Position>0 then reset_oo;
      exit;
    end;
    bPos:=czas_aktualny<3600000;
    bMax:=n<3600000;
    oo.Min:=0; //czas_aktualny;
    oo.Max:=n-czas_aktualny;
    oo.Position:=b-czas_aktualny;
    if bPos then Label5.Caption:=FormatDateTime('nn:ss',IntegerToTime(czas_aktualny)) else Label5.Caption:=FormatDateTime('h:nn:ss',IntegerToTime(czas_aktualny));
    if bMax then Label6.Caption:=FormatDateTime('nn:ss',IntegerToTime(n)) else Label6.Caption:=FormatDateTime('h:nn:ss',IntegerToTime(n));
  end;
end;

procedure TForm1.mplayerSetPosition(Sender: TObject);
begin
  test_force:=true;
end;

procedure TForm1.Panel3Resize(Sender: TObject);
begin
  resize_update_grid;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  UOSEngine.LibDirectory:=MyDir('uos');
  UOSEngine.LoadLibrary;
  bufor[1]:=0;
  bufor[2]:=0;
  key_last:=0;
  mem_lamp[1].active:=false;
  mem_lamp[2].active:=false;
  mem_lamp[3].active:=false;
  mem_lamp[4].active:=false;
  lista_wybor:=TStringList.Create;
  klucze_wybor:=TStringList.Create;
  PropStorage.FileName:='ustawienia.xml';
  PropStorage.Active:=true;
  db_open;
  przyciski(mplayer.Playing);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ppp.Clear;
  UOSEngine.UnLoadLibrary;
  lista_wybor.Free;
  klucze_wybor.Free;
end;

procedure TForm1.ppMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if mplayer.Running then
  begin
    max:=mplayer.Duration;
    czas:=round(max*X/pp.Width);
    mplayer.Position:=czas;
    pp.Position:=MiliSecToInteger(round(czas*1000));
    aa:=czas/SecsPerDay;
    a:=TimeToInteger(aa);
    bPos:=a<3600000;
    if bPos then Label3.Caption:=FormatDateTime('nn:ss',aa) else Label3.Caption:=FormatDateTime('h:nn:ss',aa);
    //test_force:=true;
  end;
end;

procedure TForm1.ppMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var
  max,czas: single;
  a: integer;
  aa: TTime;
  bPos: boolean;
begin
  if mplayer.Running then
  begin
    max:=mplayer.Duration;
    czas:=round(max*X/pp.Width);
    aa:=czas/SecsPerDay;
    a:=TimeToInteger(aa);
    bPos:=a<3600000;
    if bPos then podpowiedz.Caption:=FormatDateTime('nn:ss',aa) else podpowiedz.Caption:=FormatDateTime('h:nn:ss',aa);
    podpowiedz.Left:=X+pp.Left-round(podpowiedz.Width/2);
    podpowiedz.Visible:=true;
    pp_mouse.Enabled:=false;
    pp_mouse.Enabled:=true;
  end;
end;

procedure TForm1.pppCreateElement(Sender: TObject; var AWskaznik: Pointer);
var
  p: PYoutubeElement;
begin
  new(p);
  AWskaznik:=p;
end;

procedure TForm1.pppDestroyElement(Sender: TObject; var AWskaznik: Pointer);
var
  p: PYoutubeElement;
begin
  p:=AWskaznik;
  dispose(p);
  AWskaznik:=nil;
end;

procedure TForm1.pppReadElement(Sender: TObject; var AWskaznik: Pointer);
var
  p: PYoutubeElement;
begin
  p:=AWskaznik;
  YoutubeElement:=p^;
end;

procedure TForm1.pppWriteElement(Sender: TObject; var AWskaznik: Pointer);
var
  p: PYoutubeElement;
begin
  p:=AWskaznik;
  p^:=YoutubeElement;
end;

procedure TForm1.pp_mouseStartTimer(Sender: TObject);
begin
  podpowiedz.Visible:=true;
end;

procedure TForm1.pp_mouseTimer(Sender: TObject);
begin
  pp_mouse.Enabled:=false;
  podpowiedz.Visible:=false;
end;

procedure TForm1.restart_csvTimer(Sender: TObject);
var
  b: boolean;
  i: integer;
begin
  restart_csv.Enabled:=false;
  if lista_wybor.Count>0 then
  begin
    FLista_wyboru:=TFLista_wyboru.Create(self);
    try
      FLista_wyboru.CheckListBox1.Items.Assign(lista_wybor);
      FLista_wyboru.klucze_wyboru.Assign(klucze_wybor);
      FLista_wyboru.ShowModal;
      if FLista_wyboru.out_ok then
      begin
        lista_wybor.Clear;
        klucze_wybor.Clear;
        for i:=0 to FLista_wyboru.CheckListBox1.Items.Count-1 do
        begin
          if FLista_wyboru.CheckListBox1.Checked[i] then
          begin
            lista_wybor.Add(FLista_wyboru.CheckListBox1.Items[i]);
            klucze_wybor.Add(FLista_wyboru.klucze_wyboru[i]);
          end;
          b:=klucze_wybor.Count>0;
        end;
      end else b:=false;
    finally
      FLista_wyboru.Free;
    end;
    if b then
    begin
      csv.Tag:=csv.Tag+1;
      csv.Execute;
    end;
  end;
end;

procedure TForm1.RewindClick(Sender: TObject);
begin
  mplayer.Position:=0;
  pp.Position:=0;
  Label3.Caption:=FormatDateTime('nn:ss',0);
  test_force:=true;
end;

procedure TForm1.BExitClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.rfilmyTimer(Sender: TObject);
begin
  rfilmy.Enabled:=false;
  filmy.Refresh;
  DBGrid1.Refresh;
end;

procedure TForm1.StopClick(Sender: TObject);
begin
  if mplayer.Playing or mplayer.Paused then mplayer.Stop;
  wygeneruj_plik;
end;

procedure TForm1.test_czasBeforeOpen(DataSet: TDataSet);
begin
  test_czas.ParamByName('id').AsInteger:=indeks_play;
end;

procedure TForm1.timer_buforTimer(Sender: TObject);
var
  a: word;
begin
  timer_bufor.Enabled:=false;
  a:=0;

  if bufor[1]=1 then
  begin
    if bufor[1]=bufor[2] then
    begin
      a:=2;
      case tryb of
        1: SendKey(VK_C,20);
        2: SendKey(VK_D,20);
      end;
    end else begin
      a:=1;
      case tryb of
        1: SendKey(VK_A,20);
        2: SendKey(VK_O,20);
      end;
      if tryb=2 then if mplayer.Playing then mplayer.Pause else mplayer.Replay;
    end;
  end else
  if bufor[1]=2 then
  begin
    if bufor[1]=bufor[2] then
    begin
      a:=4;
      case tryb of
        1: SendKey(VK_G,20);
        2: SendKey(VK_H,20);
      end;
      if (tryb=2) and mplayer.Playing then mplayer.Pause;
    end else begin
      a:=3;
      case tryb of
        1: SendKey(VK_E,20);
        2: SendKey(VK_F,20);
      end;
    end;
  end else
  if bufor[1]=3 then
  begin
    if bufor[1]=bufor[2] then
    begin
      a:=6;
      case tryb of
        1: SendKey(VK_K,20);
        2: SendKey(VK_L,20);
      end;
    end else begin
      a:=5;
      case tryb of
        1: SendKey(VK_I,20);
        2: SendKey(VK_J,20);
      end;
      if (tryb=2) and mplayer.Running then if mplayer.Paused then mplayer.Replay;
    end;
  end else

  if (bufor[1]=4) and (bufor[2]=0) then
  begin
    a:=7;
    zmiana(1);
    SendKey(VK_M,20);
  end else
  if (bufor[1]=5) and (bufor[2]=0) then
  begin
    a:=8;
    zmiana(2);
    SendKey(VK_N,20);
  end else
  if ((bufor[1]=4) and (bufor[2]=5)) or ((bufor[1]=5) and (bufor[2]=4)) then
  begin
    a:=9;
    case tryb of
      1: SendKey(VK_M,20);
      2: SendKey(VK_N,20);
    end;
  end;
  key_last:=a;
  bufor[1]:=0;
  bufor[2]:=0;
end;

procedure TForm1._OPEN_CLOSE(DataSet: TDataSet);
begin
  czasy.Active:=DataSet.Active;
end;

procedure TForm1._OPEN_CLOSE_TEST(DataSet: TDataSet);
begin
  test_czas2.Active:=DataSet.Active;
end;

procedure TForm1._PLAY_MEMORY(Sender: TObject);
begin
  play_memory(TSpeedButton(Sender).Tag);
end;

procedure TForm1._ROZ_OPEN_CLOSE(DataSet: TDataSet);
begin
  filmy.Active:=DataSet.Active;
end;

procedure TForm1.SendKey(vkey: word; vcount: integer);
var
  i: integer;
begin
  //writeln(vkey);
  //if tryb=2 then KeyInput.Apply([ssCtrl]);
  for i:=1 to vcount do
  begin
    KeyInput.Press(vKey);
    if i<vcount then sleep(20);
  end;
  //if tryb=2 then KeyInput.Unapply([ssCtrl]);
end;

procedure TForm1.db_open;
var
  fo: boolean;
begin
  db.Database:=MyDir('db.sqlite');
  fo:=not FileExists(db.Database);
  db.Connect;
  if fo then cr.Execute;
  db_roz.Open;
  //filmy.Open;
end;

procedure TForm1.db_close;
begin
  //filmy.Close;
  db_roz.Close;
  db.Disconnect;
end;

function TForm1.get_last_id: integer;
begin
  last_id.Open;
  result:=last_id.Fields[0].AsInteger;
  last_id.Close;
end;

procedure TForm1.przyciski(v_playing: boolean);
begin
  exit;
  Play.Enabled:=not v_playing;
  Stop.Enabled:=v_playing;
end;

procedure TForm1.wygeneruj_plik(nazwa: string);
var
  f: textfile;
begin
  assignfile(f,MyDir('nazwa_filmu.txt'));
  rewrite(f);
  writeln(f,' '+nazwa+' ');
  closefile(f);
end;

procedure TForm1.komenda_up;
begin
  if DBGrid1.Focused then filmy.Prior else
  if DBGrid2.Focused then czasy.Prior;
end;

procedure TForm1.komenda_down;
begin
  if DBGrid1.Focused then filmy.Next else
  if DBGrid2.Focused then czasy.Next;
end;

function TForm1.go_up(force_id: integer): boolean;
var
  id,id2: integer;
  s1,s2: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  if force_id=0 then filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    s1:=filmy.FieldByName('sort').AsInteger;
    filmy.Prior;
    id2:=filmy.FieldByName('id').AsInteger;
    s2:=filmy.FieldByName('sort').AsInteger;
    if id=id2 then exit;
    if force_id=0 then trans.StartTransaction;
    update_sort.ParamByName('id').AsInteger:=id;
    update_sort.ParamByName('sort').AsInteger:=s2;
    update_sort.Execute;
    update_sort.ParamByName('id').AsInteger:=id2;
    update_sort.ParamByName('sort').AsInteger:=s1;
    update_sort.Execute;
    if force_id=0 then trans.Commit;
    filmy.Refresh;
    filmy.Locate('id',id,[]);
    result:=true;
  finally
    if force_id=0 then filmy.EnableControls;
  end;
end;

function TForm1.go_first(force_id: integer): boolean;
var
  id: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    trans.StartTransaction;
    repeat until not go_up(id);
    trans.Commit;
  finally
    filmy.EnableControls;
  end;
end;

function TForm1.go_down(force_id: integer): boolean;
var
  id,id2: integer;
  s1,s2: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  if force_id=0 then filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    s1:=filmy.FieldByName('sort').AsInteger;
    filmy.Next;
    id2:=filmy.FieldByName('id').AsInteger;
    s2:=filmy.FieldByName('sort').AsInteger;
    if id=id2 then exit;
    if force_id=0 then trans.StartTransaction;
    update_sort.ParamByName('id').AsInteger:=id;
    update_sort.ParamByName('sort').AsInteger:=s2;
    update_sort.Execute;
    update_sort.ParamByName('id').AsInteger:=id2;
    update_sort.ParamByName('sort').AsInteger:=s1;
    update_sort.Execute;
    if force_id=0 then trans.Commit;
    filmy.Refresh;
    filmy.Locate('id',id,[]);
    result:=true;
  finally
    if force_id=0 then filmy.EnableControls;
  end;
end;

function TForm1.go_last(force_id: integer): boolean;
var
  id: integer;
  b: boolean;
begin
  result:=false;
  if filmy.RecordCount=0 then exit;
  filmy.DisableControls;
  try
    if force_id>0 then
    begin
      filmy.First;
      b:=filmy.Locate('id',force_id,[]);
      if not b then exit;
    end;
    id:=filmy.FieldByName('id').AsInteger;
    trans.StartTransaction;
    repeat until not go_down(id);
    trans.Commit;
  finally
    filmy.EnableControls;
  end;
end;

procedure TForm1.resize_update_grid;
begin
  DBGrid1.Columns[1].Width:=Panel3.Width-14;
  DBGrid2.Columns[1].Width:=DBGrid1.Columns[1].Width;
end;

procedure TForm1.test(APositionForce: single);
var
  vposition: single;
  teraz,teraz1,teraz2: integer;
  czas_od,czas_do: integer;
  nazwa: string;
begin
  test_force:=false;
  czas_aktualny:=-1;
  czas_nastepny:=-1;
  if not mplayer.Running then exit;
  if APositionForce>0.0000001 then vposition:=APositionForce else vposition:=mplayer.GetPositionOnlyRead;
  test_czas.Open;
  try
    if test_czas.IsEmpty then exit;
    teraz:=MiliSecToInteger(round(vposition*1000));
    teraz1:=teraz-1000;
    teraz2:=teraz+1000;
    while not test_czas.EOF do
    begin
      nazwa:=film_tytul+' - '+test_czas.FieldByName('nazwa').AsString;
      czas_od:=test_czas.FieldByName('czas_od').AsInteger;
      if test_czas.FieldByName('czas_do').IsNull then
      begin
        if test_czas2.IsEmpty then czas_do:=-1
        else czas_do:=test_czas2.FieldByName('czas_od').AsInteger;
      end else czas_do:=test_czas.FieldByName('czas_do').AsInteger;
      if (teraz2>czas_od) and ((czas_do=-1) or (teraz<czas_do)) then
      begin
        {CZAS AKTUALNY JEST TERAZ!}
        if (czas_od<=teraz2) and ((czas_do=-1) or (czas_do>teraz)) then
        begin
          czas_aktualny:=czas_od;
          czas_aktualny_nazwa:=nazwa;
          czas_aktualny_indeks:=test_czas.FieldByName('id').AsInteger;
          if czas_do>teraz then czas_nastepny:=czas_do;
        end;
        if czas_nastepny>-1 then break;
      end;
      if czas_od>teraz then czas_nastepny:=czas_od;
      if czas_nastepny>-1 then break;
      test_czas.Next;
    end;
  finally
    test_czas.Close;
  end;
  {UAKTUALNIAMY!}
  if czas_aktualny>-1 then
  begin
    indeks_czas:=czas_aktualny_indeks;
    DBGrid2.Refresh;
    wygeneruj_plik(czas_aktualny_nazwa);
  end else begin
    indeks_czas:=-1;
    DBGrid2.Refresh;
    reset_oo;
    wygeneruj_plik(film_tytul);
  end;
end;

end.

