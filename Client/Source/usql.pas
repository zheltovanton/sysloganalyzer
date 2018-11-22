unit usql;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGridEh, ExtCtrls, Buttons,umain, DB, ADODB;

type
  TfoSQL = class(TForm)
    Panel1: TPanel;
    SpeedButton3: TSpeedButton;
    Label4: TLabel;
    Panel4: TPanel;
    SpeedButton1k: TSpeedButton;
    Panel2: TPanel;
    Splitter1: TSplitter;
    DBGridEh1: TDBGridEh;
    Memo1: TMemo;
    aqsql: TADOQuery;
    DataSource1: TDataSource;
    procedure SpeedButton1kClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foSQL: TfoSQL;

implementation

{$R *.dfm}

procedure TfoSQL.SpeedButton1kClick(Sender: TObject);
begin
 close;
end;

procedure TfoSQL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  memo1.Lines.SaveToFile('2.sql');
  action:=cafree;
end;

procedure TfoSQL.SpeedButton3Click(Sender: TObject);
begin
  if aqsql.Active then aqsql.Active:=false;
  aqsql.SQL:=memo1.Lines;
  aqsql.Active:=true;
  fomain.StatusBar1.Panels[1].Text:='Записей ' + inttostr(aqsql.recordcount);
  application.ProcessMessages;

end;

procedure TfoSQL.FormCreate(Sender: TObject);
begin
  memo1.Lines.LoadfromFile('2.sql');
end;

end.
