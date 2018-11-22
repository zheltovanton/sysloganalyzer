unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, activex, WinSock, ImgList, XPMenu,
  Menus, DB, ADODB, Buttons, jpeg, Tlhelp32,
  ShellAPI, ShlObj, comobj ,Variants,  inifiles, uabout, AppEvnts, Grids,
  DBGridEh, Mask, DBCtrlsEh, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdEcho, DBSumLst;

type formstates = (fsMaximized, fsNormal);

const NormalSizeWidth=750;
      NormalSizeHeight=500;
      Version = '1.0';
      Progname = 'SysLogAnalizer';

type
  TfoMain = class(TForm)
    ADOConnect: TADOConnection;
    ppMainmenu: TPopupMenu;
    N2: TMenuItem;
    ImageList1: TImageList;
    CPanel1: TPanel;
    Panel11: TPanel;
    lbFormCaption: TLabel;
    sbClose: TSpeedButton;
    Image3: TImage;
    Image1: TImage;
    sbMax: TSpeedButton;
    sbabout: TSpeedButton;
    N10: TMenuItem;
    About1: TMenuItem;
    Image5: TImage;
    aqSQL: TADOQuery;
    aqMain: TADOQuery;
    DataSource1: TDataSource;
    aqTodayStat: TADOQuery;
    DataSource2: TDataSource;
    IdEcho1: TIdEcho;
    DBSumList1: TDBSumList;
    aqMonthStat: TADOQuery;
    DataSource3: TDataSource;
    Timer1: TTimer;
    Panel1: TPanel;
    Panel9: TPanel;
    Panel8: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Panel3: TPanel;
    ProgressBar1: TProgressBar;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    Image4: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    DBGridEh1: TDBGridEh;
    Splitter2: TSplitter;
    DBGridEh4: TDBGridEh;
    aqHosts: TADOQuery;
    DataSource5: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbFormCaptionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbFormCaptionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure lbFormCaptionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbCloseClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure sbShareviewClick(Sender: TObject);
    procedure RxTrayIcon1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AppRestore(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure sbaboutClick(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure dtTodayChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Ini: TIniFile;
  foMain           : TfoMain;
  apl_path           : string;
  sr                 : TSearchRec;
  _exit:boolean=false;
  _x,_y:integer;

implementation


 var
  fs:formstates;




{$R *.dfm}

{ TMainForm }

//----------------------------------------------------------------------------------------------------------------------


function GetLocalIP : string;
type TaPInAddr = array [0..10] of PInAddr;
     PaPInAddr = ^TaPInAddr;
var  phe  : PHostEnt;
     pptr : PaPInAddr;
     Buffer : array [0..63] of char;
     I    : Integer;
     GInitData      : TWSADATA;
begin
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    I := 0;
    while pptr^[I] <> nil do
    begin
      result:=StrPas(inet_ntoa(pptr^[I]^));
      Inc(I);
    end;
    WSACleanup;
end;

Procedure CreateMSAccessDatabase(filename : String);
var DAO: Variant;
    i:integer;
Const Engines:array[0..2] of string=('DAO.DBEngine.36', 'DAO.DBEngine.35', 'DAO.DBEngine');

    Function CheckClass(OLEClassName:string):boolean;
    var Res: HResult;
    begin
      Result:=CoCreateInstance(ProgIDToClassID(OLEClassName), nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IDispatch, Res)=S_OK;
    end;
begin
 For i:=0 to 2 do
   if CheckClass(Engines[i]) then
     begin
       DAO := CreateOleObject(Engines[i]);
       DAO.Workspaces[0].CreateDatabase(filename, ';LANGID=0x0409;CP=1252;COUNTRY=0', 32);
       exit;
     end;

 Raise Exception.Create('DAO engine could not be initialized');
end;



function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot
                     (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,
                                 FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
         UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) =
         UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(
                        PROCESS_TERMINATE, BOOL(0),
                        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle,
                                  FProcessEntry32);
  end;

//  CloseHandle(FSnapshotHandle);
  SendMessage(FSnapshotHandle, WM_QUIT, 0, 0);
end;


procedure TfoMain.FormCreate(Sender: TObject);
var s,s1,s2,name,email:string;
    x:integer;
  OS:boolean;

  str:tstrings;
  i:integer;
  tableexist:boolean;
  fp:textFile;
  WinDir: PChar;
  db:string;
begin


//  apl_path:= ExtractShortPathName(ExtractFileDir(application.ExeName));
  apl_path:= ExtractFileDir(application.ExeName);

  Ini := TIniFile.Create(apl_path + '\slac.ini');

  db:=ini.readString('system', 'db', 'false');


  foMain.DoubleBuffered:=true;

     self.ADOConnect.Connected:=false;;
     self.ADOConnect.ConnectionString:='';
     self.ADOConnect.ConnectionString:=self.ADOConnect.ConnectionString+
      ' Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source='+db+';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";';
     self.ADOConnect.ConnectionString:=self.ADOConnect.ConnectionString+
      ' Jet OLEDB:Engine Type=4;Jet OLEDB:Database Locking Mode=0;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;';
     self.ADOConnect.ConnectionString:=self.ADOConnect.ConnectionString+
      ' Jet OLEDB:Encrypt Database=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False';
     self.ADOConnect.Connected:=true;

     str:=TStringList.Create;
     self.ADOConnect.GetTableNames(str,false);

     tableexist:=false;
     if str.Count>0 then
     for i:=0 to str.Count-1 do if str[i]='Today' then tableexist:=true;
     if not tableexist then
     try
       aqSQL.SQL.Clear;
       aqSQL.SQL.Add('create table Today (           ');
       aqSQL.SQL.Add('  id AUTOINCREMENT primary key,           ');
       aqSQL.SQL.Add('  dtime date,           ');
       aqSQL.SQL.Add('  prio  integer,   ');
       aqSQL.SQL.Add('  rule  text(25),   ');
       aqSQL.SQL.Add('  connsrcport  text(5),   ');
       aqSQL.SQL.Add('  connsrcip  text(15),   ');
       aqSQL.SQL.Add('  conndestif  text(15),   ');
       aqSQL.SQL.Add('  conndestip  text(15),   ');
       aqSQL.SQL.Add('  conndestport  text(5),   ');
       aqSQL.SQL.Add('  origsent  text(10),   ');
       aqSQL.SQL.Add('  termsent  text(10),   ');
       aqSQL.SQL.Add('  prim text(200))               ');

      aqSQL.ExecSQL;
     except
       on EOleException do
     end;


     tableexist:=false;
     if str.Count>0 then
     for i:=0 to str.Count-1 do if str[i]='DayLog' then tableexist:=true;
     if not tableexist then
     try
       aqSQL.SQL.Clear;
       aqSQL.SQL.Add('create table DayLog (           ');
       aqSQL.SQL.Add('  id AUTOINCREMENT primary key,           ');
       aqSQL.SQL.Add('  dtime date,           ');
       aqSQL.SQL.Add('  connsrcport  text(5),   ');
       aqSQL.SQL.Add('  connsrcip  text(15),   ');
       aqSQL.SQL.Add('  dday  text(2),   ');
       aqSQL.SQL.Add('  dmonth  text(2),   ');
       aqSQL.SQL.Add('  dyear  text(4),   ');
       aqSQL.SQL.Add('  origsent  text(10),   ');
       aqSQL.SQL.Add('  termsent  text(10)) ');

      aqSQL.ExecSQL;
     except
       on EOleException do
     end;


     {       self.Width:=NormalSizeWidth;
       self.Height:=NormalSizeHeight;

       self.Left:=(screen.WorkAreaWidth-self.Width) div 2;
       self.Top:=(screen.WorkAreaHeight-self.Height) div 2;

   self.sbClose.Left:=self.Width-self.sbClose.Width;
   self.sbMax.Left:=self.Width-self.sbClose.Width*2;

   self.sbAbout.Left:=self.Width-self.sbAbout.Width;}

//   aqMonthStat.Active:=true;
//
  fs:=fsnormal;
  sbMaxClick(self);

  s:=GetLocalIP;
  aqTodayStat.Close;
  aqTodayStat.SQL.Clear;
  aqTodayStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent, connsrcip, dtime from daylog');
  aqTodayStat.SQL.Add(' where connsrcip='+#39+GetLocalIP+#39+' group by connsrcip,dtime ');
  aqTodayStat.Open;
  aqTodayStat.Last;

  aqMonthStat.Close;
  aqMonthStat.SQL.Clear;
  aqMonthStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent, connsrcip, dmonth, dyear from daylog');
  aqMonthStat.SQL.Add(' where connsrcip='+#39+GetLocalIP+#39+' group by connsrcip, dmonth, dyear order by  sum(termsent) desc ');
  aqMonthStat.Open;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.N2Click(Sender: TObject);
begin
 halt;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.N1Click(Sender: TObject);
begin
  Application.Restore;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

end;

//----------------------------------------------------------------------------------------------------------------------
procedure TfoMain.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.OnMouseMove:=Image3MouseMove;
  _x:=x;
  _y:=y;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    left:=x-_x+left;
    top:=y-_y+top;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.OnMouseMove:=nil;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.lbFormCaptionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lbFormCaption.OnMouseMove:=lbFormCaptionMouseMove;
  _x:=x;
  _y:=y;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.lbFormCaptionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    left:=x-_x+left;
    top:=y-_y+top;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.lbFormCaptionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lbFormCaption.OnMouseMove:=nil;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbCloseClick(Sender: TObject);
begin
close;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbMaxClick(Sender: TObject);
begin
  image3.OnMouseDown:=nil;
  image3.OnMouseMove:=nil;

   if fs=fsMaximized then fs:=fsNormal else fs:=fsMaximized;

   if fs=fsMaximized then
     begin
       self.Left:=screen.WorkAreaRect.Left;
       self.Top:=screen.WorkAreaRect.Top;
       self.Width:=screen.WorkAreaRect.Right+screen.WorkAreaRect.Left;
       self.Height:=screen.WorkAreaRect.Bottom+screen.WorkAreaRect.Top;
     end;

   if fs=fsNormal then
     begin
       self.Width:=NormalSizeWidth;
       self.Height:=NormalSizeHeight;
       self.Left:=(screen.WorkAreaWidth-self.Width) div 2;
       self.Top:=(screen.WorkAreaHeight-self.Height) div 2;
     end;

   self.sbClose.Left:=self.Width-self.sbClose.Width;
   self.sbMax.Left:=self.Width-self.sbClose.Width*2;

   self.sbAbout.Left:=self.Width-self.sbAbout.Width;
   image3.OnMouseDown:=Image3MouseDown;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbShareviewClick(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------------------------------------------------


procedure TfoMain.RxTrayIcon1DblClick(Sender: TObject);
begin
  Application.Restore;
  self.AppRestore(self);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.FormActivate(Sender: TObject);
begin
{$IFNDEF WIN32}
  if Screen.ActiveForm <> nil then Screen.ActiveForm.BringToFront;
{$ENDIF}

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.AppRestore(Sender: TObject);
begin
{$IFDEF WIN32}
  if NewStyleControls then ShowWindow(Application.Handle, SW_SHOW);
{$ENDIF}
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.AppMinimize(Sender: TObject);
begin
{$IFDEF WIN32}
  if NewStyleControls then ShowWindow(Application.Handle, SW_HIDE);
{$ENDIF}
end;

//----------------------------------------------------------------------------------------------------------------------


procedure TfoMain.sbaboutClick(Sender: TObject);
VAR I:INTEGER;
begin
  Application.CreateForm(TfoAbout, foAbout);
  foAbout.show;
  self.AlphaBlendValue:=0;
  for i:=0 to 12 do
    begin
      foAbout.AlphaBlendValue:=i*20;
       sleep(25);
      application.ProcessMessages;
      foabout.Refresh;
    end;
  foAbout.AlphaBlendValue:=255;

end;

function SysLogDate2datetime(sDate:string):tdatetime;
var sMM,sYYYY,sDD,sTIME:string;
begin
  sMM:=sdate;
  delete(sMM,1,4);
  delete(sMM,4,24);
  if sMM='Jan' then sMM:='01';
  if sMM='Feb' then sMM:='02';
  if sMM='Mar' then sMM:='03';
  if sMM='Apr' then sMM:='04';
  if sMM='May' then sMM:='05';
  if sMM='Jun' then sMM:='06';
  if sMM='Jul' then sMM:='07';
  if sMM='Aug' then sMM:='08';
  if sMM='Sep' then sMM:='09';
  if sMM='Oct' then sMM:='10';
  if sMM='Nov' then sMM:='11';
  if sMM='Dec' then sMM:='12';

  sYYYY:=sdate;
  delete(sYYYY,1,20);

  sDD:=sdate;
  delete(sDD,1,8);
  delete(sDD,3,24);

 { sTIME:=sdate;
  delete(sTIME,1,11);
  delete(sTIME,9,24); }

  sdate:=sDD+DateSeparator+sMM+DateSeparator+sYYYY;//+' '+sTIME;
  result:=strtodatetime(sdate);
end;

procedure TfoMain.SpeedButton6Click(Sender: TObject);
begin
    if MessageDlg('Удалить запись?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes  then
      begin
        aqMain.Delete;
      end
end;

procedure TfoMain.DBGridEh2CellClick(Column: TColumnEh);
begin
  aqMain.Close;
  aqMain.SQL.Clear;
  aqMain.SQL.Add('select origsent as origsent,termsent as termsent, connsrcport,connsrcip from daylog');
  aqMain.SQL.Add(' where dtime=:dtime and ');
  aqMain.SQL.Add(' connsrcip='+#39+aqTodayStat.fieldbyname('connsrcip').AsVariant+#39+' ');
  aqMain.Parameters.ParameterCollection.Refresh;
  aqMain.Parameters.Refresh;
  aqMain.Parameters[0].Value:=aqTodayStat.fieldbyname('dtime').Asstring;
  aqMain.Open;


  aqHosts.Close;
  aqHosts.SQL.Clear;
  aqHosts.SQL.Add('select int(termsent) as itermsent, int(origsent) as iorigsent, * from hosts');
  aqHosts.SQL.Add(' where dtime=:dtime and ');
  aqHosts.SQL.Add(' srcip='+#39+aqTodayStat.fieldbyname('connsrcip').AsVariant+#39+' order by  int(termsent) desc ');
  aqHosts.Parameters.ParameterCollection.Refresh;
  aqHosts.Parameters.Refresh;
  aqHosts.Parameters[0].Value:=aqTodayStat.fieldbyname('dtime').Asstring;
  aqHosts.Open;



end;

procedure TfoMain.dtTodayChange(Sender: TObject);
begin
  aqTodayStat.Close;
  aqTodayStat.SQL.Clear;
  aqTodayStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent, connsrcip, dtime from daylog');
  aqTodayStat.SQL.Add(' where connsrcip='+#39+GetLocalIP+#39+' group by connsrcip,dtime ');
  aqTodayStat.Open;
end;

end.




