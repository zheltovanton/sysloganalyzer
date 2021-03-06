unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, activex, WinSock, ImgList, XPMenu,
  Menus, DB, ADODB, Buttons, jpeg, Tlhelp32,   IdSocketHandle,
  ShellAPI, ShlObj, comobj ,Variants,  inifiles, uabout, AppEvnts, Grids,
  DBGridEh, Mask, DBCtrlsEh, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdEcho, DBSumLst, RXShell, IdUDPBase, IdUDPServer,
   IdTCPServer, CheckLst, IdBlockCipherIntercept,
  IdIntercept, IdException, IdStackConsts, IdGlobal,IdStack;

type formstates = (fsMaximized, fsNormal);

const NormalSizeWidth=750;
      NormalSizeHeight=500;
      Version = '2.0';
      Progname = 'SysLogAnalizer.Server';

type
  TfoMain = class(TForm)
    gbxShares: TGroupBox;
    lbxShares: TListBox;
    gbxSessions: TGroupBox;
    gbxFiles: TGroupBox;
    btnGetShares: TButton;
    btnCloseShares: TButton;
    btnAddShares: TButton;
    btnCloseSession: TButton;
    btnGetSessions: TButton;
    plButtonFiles: TPanel;
    btnGetFiles: TButton;
    btnCloseFile: TButton;
    plFiles: TPanel;
    gbxTraffic: TGroupBox;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    lvfiles_compare: TListView;
    ADOConnect: TADOConnection;
    Panel1: tpanel;
    ppMainmenu: TPopupMenu;
    N2: TMenuItem;
    ImageList1: TImageList;
    CPanel1: TPanel;
    N10: TMenuItem;
    About1: TMenuItem;
    Image5: TImage;
    Panel9: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    aqSQL: TADOQuery;
    aqMain: TADOQuery;
    DataSource1: TDataSource;
    Panel3: TPanel;
    aqTodayStat: TADOQuery;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    DataSource2: TDataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    DBSumList1: TDBSumList;
    RxTrayIcon1: TRxTrayIcon;
    Timer2: TTimer;
    aqMonthStat: TADOQuery;
    aqHosts: TADOQuery;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    IdUDPServer1: TIdUDPServer;
    Timer1: TTimer;
    aqSQL2: TADOQuery;
    Panel5: TPanel;
    Panel4: TPanel;
    sbabout: TSpeedButton;
    edDBPath: TDBEditEh;
    SpeedButton3: TSpeedButton;
    Label2: TLabel;
    lbIPs: TCheckListBox;
    IdTCPServer: TIdTCPServer;
    edPort: TDBNumberEditEh;
    edTime1: TDBNumberEditEh;
    Label3: TLabel;
    edTime2: TDBNumberEditEh;
    Label4: TLabel;
    edTCPPOrt: TDBNumberEditEh;
    Label5: TLabel;
    Memo1: TMemo;
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
    procedure SpeedButton4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedB3utton4Click(Sender: TObject);
    procedure dtTodayChange(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure Button1Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure edDBPathChange(Sender: TObject);
    function StartServer: Boolean;
    procedure Memo1Change(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure PopulateIPAddresses;
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
    function StopServer: Boolean;
    procedure IdTCPServerDisconnect(AThread: TIdPeerThread);
    procedure IdTCPServerConnect(AThread: TIdPeerThread);
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
  Clients         : TThreadList;     // Holds the data of all clients

type

  TGetDataThread = class(TThread)
  private

  protected
    procedure Execute; override;
  public
    constructor Create;
  end;



implementation


 var
  fs:formstates;




type
  PClient   = ^TClient;
  TClient   = record  // Object holding data of client (see events)
                DNS         : String[20];            { Hostname }
                Connected,                           { Time of connect }
                LastAction  : TDateTime;             { Time of last transaction }
                Thread      : Pointer;               { Pointer to thread }
              end;

{$R *.dfm}

{ TMainForm }

// ---------------------------------------------------------------------------------------------------------

constructor TGetDataThread.Create;
begin
  FreeOnTerminate := True;
  inherited Create(False);
end;


// ---------------------------------------------------------------------------------------------------------

procedure TGetDataThread.Execute;
begin
with fomain do
  begin
timer1.Enabled:=false;
timer2.Enabled:=false;

  aqTodayStat.Close;
  aqmain.Close;
  ADOConnect.BeginTrans;
  aqMonthStat.Close;
  aqMonthStat.SQL.Clear;
  aqMonthStat.SQL.Add(' select * from daylog ');
  aqMonthStat.Open;

  aqHosts.Close;
  aqHosts.SQL.Clear;
  aqHosts.SQL.Add(' select * from hosts ');
  aqHosts.Open;

  if aqSQL2.Active then aqsql2.Close;
  aqSQL2.SQL.Clear;
  aqSQL2.SQL.Add(' select sum(origsent) as origsent,sum(termsent) as termsent,connsrcip,dtime,conndestport from today ');
  aqSQL2.SQL.Add(' group by dtime,connsrcip,conndestport ');
  aqSQL2.Open;
  aqSQL2.First;

  //��������� ���������� �� ip
  while not aqSQL2.Eof do
    begin
      if aqMonthStat.Locate('dtime;connsrcip;connsrcport',
           VarArrayOf([ aqSQL2.FieldByName('dtime').AsVariant,
                        aqSQL2.FieldByName('connsrcip').AsVariant,
                        aqSQL2.FieldByName('conndestport').AsVariant]),[] )
        then
          begin
           aqMonthStat.Edit;
           aqMonthStat.FieldByName('origsent').AsFloat:=aqMonthStat.FieldByName('origsent').AsFloat+aqSQL2.FieldByName('origsent').AsFloat;
           aqMonthStat.FieldByName('termsent').AsFloat:=aqMonthStat.FieldByName('termsent').AsFloat+aqSQL2.FieldByName('termsent').AsFloat;
           aqMonthStat.post;
          end else
          begin
           aqMonthStat.Insert;
           aqMonthStat.Edit;
           aqMonthStat.FieldByName('dtime').AsVariant:=aqSQL2.FieldByName('dtime').AsVariant;
           aqMonthStat.FieldByName('dyear').AsString:=formatdatetime('YYYY',aqSQL2.FieldByName('dtime').AsDateTime);
           aqMonthStat.FieldByName('dmonth').AsString:=formatdatetime('MM',aqSQL2.FieldByName('dtime').AsDateTime);
           aqMonthStat.FieldByName('dday').AsString:=formatdatetime('DD',aqSQL2.FieldByName('dtime').AsDateTime);
           aqMonthStat.FieldByName('connsrcip').AsVariant:=aqSQL2.FieldByName('connsrcip').AsVariant;
           aqMonthStat.FieldByName('connsrcport').AsVariant:=aqSQL2.FieldByName('conndestport').AsVariant;
           aqMonthStat.FieldByName('origsent').AsVariant:=aqSQL2.FieldByName('origsent').AsVariant;
           aqMonthStat.FieldByName('termsent').AsVariant:=aqSQL2.FieldByName('termsent').AsVariant;
           aqMonthStat.Post;
          end;

      aqSQL2.Next;
    end;

  //��������� ���������� �� ������ � ip
  aqSQL2.Close;
  aqSQL2.SQL.Clear;
  aqSQL2.SQL.Add(' select sum(origsent) as origsent,sum(termsent) as termsent,connsrcip,dtime,conndestport,conndestip from today ');
  aqSQL2.SQL.Add(' group by dtime,connsrcip,conndestport,conndestip ');
  aqSQL2.Open;
  aqSQL2.First;

  while not aqSQL2.Eof do
    begin
      if aqHosts.Locate('dtime;srcip;port;destip',
           VarArrayOf([ aqSQL2.FieldByName('dtime').AsVariant,
                        aqSQL2.FieldByName('connsrcip').AsVariant,
                        aqSQL2.FieldByName('conndestport').AsVariant,
                        aqSQL2.FieldByName('conndestip').AsVariant]),[] )
        then
          begin
           aqHosts.Edit;
           aqHosts.FieldByName('origsent').AsFloat:=aqHosts.FieldByName('origsent').AsFloat+aqSQL2.FieldByName('origsent').AsFloat;
           aqHosts.FieldByName('termsent').AsFloat:=aqHosts.FieldByName('termsent').AsFloat+aqSQL2.FieldByName('termsent').AsFloat;
           aqHosts.post;
          end else
          begin
           aqHosts.Insert;
           aqHosts.Edit;
           aqHosts.FieldByName('dtime').AsVariant:=aqSQL2.FieldByName('dtime').AsVariant;
           aqHosts.FieldByName('dyear').AsString:=formatdatetime('YYYY',aqSQL2.FieldByName('dtime').AsDateTime);
           aqHosts.FieldByName('dmonth').AsString:=formatdatetime('MM',aqSQL2.FieldByName('dtime').AsDateTime);
           aqHosts.FieldByName('dday').AsString:=formatdatetime('DD',aqSQL2.FieldByName('dtime').AsDateTime);
           aqHosts.FieldByName('srcip').AsVariant:=aqSQL2.FieldByName('connsrcip').AsVariant;
           aqHosts.FieldByName('host').AsVariant:=aqSQL2.FieldByName('conndestip').AsVariant;//GetHostByIP(aqSQL.FieldByName('conndestip').AsVariant);
           aqHosts.FieldByName('destip').AsVariant:=aqSQL2.FieldByName('conndestip').AsVariant;
           aqHosts.FieldByName('port').AsVariant:=aqSQL2.FieldByName('conndestport').AsVariant;
           aqHosts.FieldByName('origsent').AsVariant:=aqSQL2.FieldByName('origsent').AsVariant;
           aqHosts.FieldByName('termsent').AsVariant:=aqSQL2.FieldByName('termsent').AsVariant;
           aqHosts.Post;
          end;
      //aqHosts.Refresh;
      //Application.ProcessMessages;
      aqSQL2.Next;
    end;

  aqSQL2.Close;
  aqSQL2.SQL.Clear;
  aqSQL2.SQL.Add('delete from  today');
  aqSQL2.ExecSQL;

  ADOConnect.CommitTrans;

  aqMain.Active:=true;
  aqTodayStat.Active:=true;
  timer1.Enabled:=true;
  timer2.Enabled:=true;
 end;
end;

//----------------------------------------------------------------------------------------------------------------------


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


//----------------------------------------------------------------------------------------------------------------------

function GetHostByIP(IPAddr: String): String; // ���y����� ����� �� IP
var
  Error: DWORD;
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  Data: TWSAData;
begin
  Result:='-';
  Error:=WSAStartup($101, Data);
  if Error = 0 then begin
   SockAddrIn.sin_addr.s_addr:= inet_addr(PChar(IPAddr));
   HostEnt:= gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
   if HostEnt<>nil then Result:=StrPas(Hostent^.h_name);
  end; // Error=0
  WSACleanup();
end;

//----------------------------------------------------------------------------------------------------------------------

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  tnid:NOTIFYICONDATA;
  nt: TNotifyIconData;

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


  with nt do
  begin
    cbSize := SizeOf(nt);
    Wnd    := FindWindow('#32770', nil);
    uid    := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallbackMessage := WM_USER + 17;
    hIcon  := 0;
    szTip  := '';
  end;
  Shell_NotifyIcon(NIM_DELETE, @nt);
  TerminateProcess(FSnapshotHandle,4);
  //CloseHandle(FSnapshotHandle);
 // SendMessage(FindWindow('#32770', nil), WM_close, 0, 0);
  SendMessage( 0, WM_PAINT, 0, 0);


end;

//----------------------------------------------------------------------------------------------------------------------


 function AdvSelectDirectory(const Caption: string; const Root: WideString;
   var Directory: string; EditBox: Boolean = False; ShowFiles: Boolean = False;
   AllowCreateDirs: Boolean = True): Boolean;
   // callback function that is called when the dialog has been initialized
  //or a new directory has been selected

  // Callback-Funktion, die aufgerufen wird, wenn der Dialog initialisiert oder
  //ein neues Verzeichnis selektiert wurde
  function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam): Integer;
     stdcall;
   var
     PathName: array[0..MAX_PATH] of Char;
   begin
     case uMsg of
       BFFM_INITIALIZED: SendMessage(Wnd, BFFM_SETSELECTION, Ord(True), Integer(lpData));
       // include the following comment into your code if you want to react on the
      //event that is called when a new directory has been selected
      // binde den folgenden Kommentar in deinen Code ein, wenn du auf das Ereignis
      //reagieren willst, das aufgerufen wird, wenn ein neues Verzeichnis selektiert wurde
      {BFFM_SELCHANGED: 
      begin
        SHGetPathFromIDList(PItemIDList(lParam), @PathName); 
        // the directory "PathName" has been selected 
        // das Verzeichnis "PathName" wurde selektiert
      end;}
     end;
     Result := 0;
   end;
 var
   WindowList: Pointer;
   BrowseInfo: TBrowseInfo;
   Buffer: PChar;
   RootItemIDList, ItemIDList: PItemIDList;
   ShellMalloc: IMalloc;
   IDesktopFolder: IShellFolder;
   Eaten, Flags: LongWord;
 const
   // necessary for some of the additional expansions
  // notwendig fur einige der zusatzlichen Erweiterungen 
  BIF_USENEWUI = $0040;
   BIF_NOCREATEDIRS = $0200;
 begin
   Result := False;
   if not DirectoryExists(Directory) then
     Directory := '';
   FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
   if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
   begin
     Buffer := ShellMalloc.Alloc(MAX_PATH);
     try
       RootItemIDList := nil;
       if Root <> '' then
       begin
         SHGetDesktopFolder(IDesktopFolder);
         IDesktopFolder.ParseDisplayName(Application.Handle, nil,
           POleStr(Root), Eaten, RootItemIDList, Flags);
       end;
       OleInitialize(nil);
       with BrowseInfo do
       begin
         hwndOwner := Application.Handle;
         pidlRoot := RootItemIDList;
         pszDisplayName := Buffer;
         lpszTitle := PChar(Caption);
         // defines how the dialog will appear:
        // legt fest, wie der Dialog erscheint:
        ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI or
           BIF_EDITBOX * Ord(EditBox) or BIF_BROWSEINCLUDEFILES * Ord(ShowFiles) or
           BIF_NOCREATEDIRS * Ord(not AllowCreateDirs);
         lpfn    := @SelectDirCB;
         if Directory <> '' then
           lParam := Integer(PChar(Directory));
       end;
       WindowList := DisableTaskWindows(0);
       try
         ItemIDList := ShBrowseForFolder(BrowseInfo);
       finally
         EnableTaskWindows(WindowList);
       end;
       Result := ItemIDList <> nil;
       if Result then
       begin
         ShGetPathFromIDList(ItemIDList, Buffer);
         ShellMalloc.Free(ItemIDList);
         Directory := Buffer;
       end;
     finally
       ShellMalloc.Free(Buffer);
     end;
   end;
 end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.PopulateIPAddresses;
var
    i : integer;
begin
with lbIPs do
    begin
    Clear;
    Items := GStack.LocalAddresses;
    Items.Insert(0, '127.0.0.1');
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TfoMain.StopServer: Boolean;
begin
IdTCPServer.Active := false;
IdTCPServer.Bindings.Clear;
Result := not IdTCPServer.Active;
end;


//----------------------------------------------------------------------------------------------------------------------

function TfoMain.StartServer: Boolean;
var
    Binding : TIdSocketHandle;
    i : integer;
    SL : TStringList;
begin
  SL := TStringList.Create;

  if not StopServer then
    begin
     Result := false;
     exit;
    end;

  IdTCPServer.Bindings.Clear; // bindings cannot be cleared until TidTCPServer is inactive
  try
  try

  {for i := 0 to lbIPs.Count-1 do
        begin
        Binding := IdTCPServer.Bindings.Add;
        Binding.IP := lbIPs.Items.Strings[i];
        Binding.Port := integer(edPort.Value);//StrToInt(edtPort.Text);
        SL.append('Server bound to IP ' + Binding.IP + ' on port ' + string(edPort.Value));
        end; }

  IdTCPServer.DefaultPort:=integer(edPort.Value);
  IdTCPServer.Active := true;
  result := IdTCPServer.Active;

  except
  on E : Exception do
    begin
      Result := false;
      showmessage(e.Message);
    end;
  end;
  finally
  FreeAndNil(SL);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.FormCreate(Sender: TObject);
var s,s1,s2,name,email:string;
    x:integer;
  OS:boolean;
  db:string;
  str:tstrings;
  i:integer;
  tableexist:boolean;
  fp:textFile;
  WinDir: PChar;
begin

//  apl_path:= ExtractShortPathName(ExtractFileDir(application.ExeName));
   foMain.Caption:=Progname+' '+ Version;

  apl_path:= ExtractFileDir(application.ExeName);

  foMain.DoubleBuffered:=true;

  apl_path:= ExtractFileDir(application.ExeName);

  Ini := TIniFile.Create(apl_path + '\sla.server.ini');

  db:=ini.readString('system', 'db', 'false')+'\sysloganalizer.mdb';
  edDBPath.Text:=ini.readString('system', 'db', 'false');

  edTime1.Text:=ini.readString('system', 'sl_load_interval', '5');
  edTime2.Text:=ini.readString('system', 'sl_calc_stat_interval', '20');
  edPort.Text:=ini.readString('system', 'udpport', '514');
  edtcpPort.Text:=ini.readString('system', 'tcpport', '1470');

  timer1.Interval:= 1000*strtoint(ini.readString('system', 'sl_load_interval', '5'));
  timer2.Interval:= 1000*strtoint(ini.readString('system', 'sl_calc_stat_interval', '20'));

  timer2.Enabled:=true;
  timer1.Enabled:=true;
  ini.Free;

  if findfirst(db,0,sr)<>0 then
     CreateMSAccessDatabase(db);

  foMain.DoubleBuffered:=true;

     self.ADOConnect.Connected:=false;
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

     tableexist:=false;
     if str.Count>0 then
     for i:=0 to str.Count-1 do if str[i]='hosts' then tableexist:=true;

     if not tableexist then
     try
       aqSQL.SQL.Clear;
       aqSQL.SQL.Add('create table hosts (        ');
       aqSQL.SQL.Add('  id AUTOINCREMENT primary key, ');
       aqSQL.SQL.Add('  dtime date,               ');
       aqSQL.SQL.Add('  port  text(5),            ');
       aqSQL.SQL.Add('  srcip  text(15),             ');
       aqSQL.SQL.Add('  destip  text(15),             ');
       aqSQL.SQL.Add('  dday  text(2),   ');
       aqSQL.SQL.Add('  dmonth  text(2),   ');
       aqSQL.SQL.Add('  dyear  text(4),   ');
       aqSQL.SQL.Add('  host  text(255),          ');
       aqSQL.SQL.Add('  origsent  text(10),       ');
       aqSQL.SQL.Add('  termsent  text(10))       ');

      aqSQL.ExecSQL;
     except
       on EOleException do
     end;

   aqTodayStat.Active:=true;
  fs:=fsnormal;
  sbMaxClick(self);
  progressbar1.Parent:=StatusBar1;
  Clients := TThreadList.Create;
  progressbar1.Left:=0;
  progressbar1.Top:=0;
  deletefile(apl_path+'\syslog.txt');

  Panel5Click(self);
  PopulateIPAddresses;

  IdTCPServer.DefaultPort:=edtcpPort.Value;
  IdTCPServer.Active:=true;

  if not StartServer then ShowMessage('Error starting TCP server ');
  IdUDPServer1.DefaultPort:=edPort.Value;
  IdUDPServer1.Active:=true;


  edDBPath.OnChange:=edDBPathChange;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.N2Click(Sender: TObject);
begin
 StopServer;
 IdUDPServer1.Active:=false;
 IdTCPServer.Active:=false;
 IdUDPServer1.OnUDPRead:=nil;
 Clients.Free;

  Ini := TIniFile.Create(apl_path + '\sla.server.ini');
  ini.writeString('system', 'udpport', edPort.Text);
  ini.writeString('system', 'tcpport', edtcpPort.Text);
  ini.writeString('system', 'sl_load_interval', edTime1.Text);
  ini.writeString('system', 'sl_calc_stat_interval', edTime2.Text);
  ini.writeString('system', 'DB', edDBPath.Text);
  ini.Free;

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
  if not _exit then action:=canone;
  Application.Minimize;
  self.AppMinimize(self);
end;

//----------------------------------------------------------------------------------------------------------------------
procedure TfoMain.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
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

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.lbFormCaptionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
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
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbCloseClick(Sender: TObject);
begin
//  DBGridEh3.DataSource.DataSet.DisableControls;

  close;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbMaxClick(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbShareviewClick(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------------------------------------------------


procedure TfoMain.RxTrayIcon1DblClick(Sender: TObject);
begin
//  DBGridEh3.DataSource.DataSet.EnableControls;
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

//----------------------------------------------------------------------------------------------------------------------

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

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var buf:array [0..511] of byte;
    s:string;
    i:integer;
    sdate:string;
    data,dtime:tdatetime;
    x:integer;
  ip,prio,rule,connsrcport,connsrcip,conndestif,
  conndestip,conndestport,origsent,termsent:string;
begin
//  setlength(buf,AData.Size);
  if AData.Read(buf, AData.Size) <> AData.Size then exit;
  s:='';
  for i:=1 to SizeOf(buf)-1 do
   begin
     if buf[i]=0 then break;
     s:=s+chr(buf[i]);
   end;
  memo1.lines.add(s);


end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton4Click(Sender: TObject);
var s,sdate:string;
    data,dtime:tdatetime;
    i,x:integer;
  ip,prio,rule,connsrcport,connsrcip,conndestif,
  bytes, conndestip,conndestport,origsent,termsent:string;
  t:textfile;
begin
//  aqsql.DisableControls;


  //Wed Jul 06 11:55:50 2005: 172.18.48.22: <142>EFW: CONN: prio=1 rule=low_speed conn=close connipproto=TCP connrecvif=LAN connsrcip=172.18.48.156 connsrcport=1157 conndestif=WAN conndestip=217.16.31.80 conndestport=80 origsent=998 termsent=1232
  for  x:=1 to memo1.Lines.Count do
  begin
  s:=memo1.Lines[x];

  //   --------- Analize CISCO syslog -----------------

  if (pos('Teardown TCP connection',s)>0) and (pos('bytes',s)>0) then
  begin

     assignfile(t,apl_path+'\log.txt');
     append(t);
     writeln(t,s);
     closefile(t);


     //date parse
     dtime:=now;

     // Example
     // Teardown TCP connection 130743 for outside:172.17.48.11/8080
     //   to inside:172.20.55.12/1381 duration 0:00:30 bytes 0 SYN Timeout

     //connsrcip & port laddr
     if (pos('inside:',s)>1) then
       begin
         //connsrcip & port laddr
         connsrcip:=s;
         i:=pos('inside:',connsrcip);
         delete(connsrcip,1,i+length('inside:')-1);
         i:=pos(' ',connsrcip);
         delete(connsrcip,i,250);
         i:=pos('/',connsrcip);
         delete(connsrcip,i,250);
         connsrcport:=s;

         i:=pos('inside:',connsrcport);
         delete(connsrcport,1,i+length('inside:')-1);
         i:=pos(' ',connsrcport);
         delete(connsrcport,i,250);
         i:=pos('/',connsrcport);
         delete(connsrcport,1,i+length('/')-1);

       end;

     if (pos('dmz:',s)>1) then
       begin
         //connsrcip & port laddr
         connsrcip:=s;
         i:=pos('dmz:',connsrcip);
         delete(connsrcip,1,i+length('dmz:')-1);
         i:=pos(' ',connsrcip);
         delete(connsrcip,i,250);
         i:=pos('/',connsrcip);
         delete(connsrcip,i,250);
         connsrcport:='0';
       end;

     //conndestip & port  faddr
{     conndestip:=s;
     i:=pos('outside:',conndestip);
     delete(conndestip,1,i+length('outside:')-1);
     i:=pos(' ',conndestip);
     delete(conndestip,i,250);
     i:=pos('/',conndestip);
     delete(conndestip,i,250);}
     conndestport:=connsrcport;


     //bytes

     bytes:=s;

     i:=pos('bytes ',bytes);
     delete(bytes,1,i+length('bytes ')-1);
     i:=pos(' ',bytes);
     delete(bytes,i,250);

     origsent:='0';
     termsent:='0';

     //origsent
     if pos('to outside:',s)>1 then origsent:=bytes;

     //termsent
     if pos('to inside:',s)>1 then termsent:=bytes;

     if (termsent<>'')and(origsent<>'') then
       begin
         aqSQL.Close;
         aqSQL.SQL.Clear;
         aqSQL.SQL.Add('insert into Today (dtime,connsrcport,connsrcip,   ');
         aqSQL.SQL.Add('  conndestip, conndestport,origsent, termsent ) ');
         aqSQL.SQL.Add('  values ('+#39+datetostr(dtime)+#39+', ');
         aqSQL.SQL.Add(   #39+connsrcport+#39+', ');
         aqSQL.SQL.Add(   #39+connsrcip+#39+', ');
         aqSQL.SQL.Add(   #39+conndestip+#39+', ');
         aqSQL.SQL.Add(   #39+conndestport+#39+', ');
         aqSQL.SQL.Add(   #39+origsent+#39+', ');
         aqSQL.SQL.Add(   #39+termsent+#39+') ');

         try
           aqSQL.ExecSQL;
           except
             on e:exception do
               showmessage(aqSQL.SQL.Strings[0]+#10+#13+aqSQL.SQL.Strings[1]
               +#10+#13+aqSQL.SQL.Strings[2]
               +#10+#13+aqSQL.SQL.Strings[3]
               +#10+#13+aqSQL.SQL.Strings[4]
               +#10+#13+aqSQL.SQL.Strings[5]
               +#10+#13+aqSQL.SQL.Strings[6]
               +#10+#13+aqSQL.SQL.Strings[7]);
           end;
       end;
       if x mod 10 = 0 then
          begin
            ProgressBar1.Position:=round(x/memo1.Lines.Count*100);
            Application.ProcessMessages;
          end;
  end;

  //   --------- Analize standart syslog -----------------

  if pos('CONN:',s)>0 then
    begin

     //date parse
     sdate:=s;
     delete(sdate,25,300);
     dtime:=now;//SysLogDate2datetime(sdate);

     //connsrcip
     connsrcip:=s;
     i:=pos('connsrcip=',connsrcip);
     delete(connsrcip,1,i+length('connsrcip=')-1);
     i:=pos(' ',connsrcip);
     delete(connsrcip,i,250);

     //prio
     prio:=s;
     i:=pos('prio=',prio);
     delete(prio,1,i+length('prio=')-1);
     i:=pos(' ',prio);
     delete(prio,i,250);

     //rule
     rule:=s;
     i:=pos('rule=',rule);
     delete(rule,1,i+length('rule=')-1);
     i:=pos(' ',rule);
     delete(rule,i,250);

     //connsrcport
     connsrcport:=s;
     i:=pos('connsrcport=',connsrcport);
     delete(connsrcport,1,i+length('connsrcport=')-1);
     i:=pos(' ',connsrcport);
     delete(connsrcport,i,250);
     if length(connsrcport)>5 then connsrcport:='';

     //conndestif
     conndestif:=s;
     i:=pos('conndestif=',conndestif);
     delete(conndestif,1,i+length('conndestif=')-1);
     i:=pos(' ',conndestif);
     delete(conndestif,i,250);

     //conndestip
     conndestip:=s;
     i:=pos('conndestip=',conndestip);
     delete(conndestip,1,i+length('conndestip=')-1);
     i:=pos(' ',conndestip);
     delete(conndestip,i,250);

     //conndestport
     conndestport:=s;
     i:=pos('conndestport=',conndestport);
     delete(conndestport,1,i+length('conndestport=')-1);
     i:=pos(' ',conndestport);
     delete(conndestport,i,250);
     if length(conndestport)>5 then conndestport:='';

     //origsent
     origsent:=s;
     if pos('origsent',s)<1 then origsent:='';
     i:=pos('origsent=',origsent);
     delete(origsent,1,i+length('origsent=')-1);
     i:=pos(' ',origsent);
     delete(origsent,i,250);


     //termsent
     termsent:=s;
     if pos('termsent',s)<1 then termsent:='';
     i:=pos('termsent=',termsent);
     delete(termsent,1,i+length('termsent=')-1);
     i:=pos(' ',termsent);
     delete(termsent,i,250);

     if (termsent<>'')and(origsent<>'') then
       begin
         aqSQL.Close;
         aqSQL.SQL.Clear;
         aqSQL.SQL.Add('insert into Today (dtime,prio,rule,connsrcport,connsrcip, conndestif,   ');
         aqSQL.SQL.Add('  conndestip, conndestport,origsent, termsent ) ');
         aqSQL.SQL.Add('  values ('+#39+datetostr(dtime)+#39+', ');
         aqSQL.SQL.Add(   #39+prio+#39+', ');
         aqSQL.SQL.Add(   #39+rule+#39+', ');
         aqSQL.SQL.Add(   #39+connsrcport+#39+', ');
         aqSQL.SQL.Add(   #39+connsrcip+#39+', ');
         aqSQL.SQL.Add(   #39+conndestif+#39+', ');
         aqSQL.SQL.Add(   #39+conndestip+#39+', ');
         aqSQL.SQL.Add(   #39+conndestport+#39+', ');
         aqSQL.SQL.Add(   #39+origsent+#39+', ');
         aqSQL.SQL.Add(   #39+termsent+#39+') ');

         try
           aqSQL.ExecSQL;
           except
             on e:exception do
               showmessage(aqSQL.SQL.Strings[0]+#10+#13+aqSQL.SQL.Strings[1]
               +#10+#13+aqSQL.SQL.Strings[2]
               +#10+#13+aqSQL.SQL.Strings[3]
               +#10+#13+aqSQL.SQL.Strings[4]
               +#10+#13+aqSQL.SQL.Strings[5]
               +#10+#13+aqSQL.SQL.Strings[6]
               +#10+#13+aqSQL.SQL.Strings[7]
               +#10+#13+aqSQL.SQL.Strings[8]
               +#10+#13+aqSQL.SQL.Strings[9]
               +#10+#13+aqSQL.SQL.Strings[10]+#10+#13+aqSQL.SQL.Strings[11]);
           end;
       end;
       if x mod 10 = 0 then
          begin
            ProgressBar1.Position:=round(x/memo1.Lines.Count*100);
            Application.ProcessMessages;
          end;
      end;
     end;

  if aqTodayStat.active then
  s:=aqTodayStat.fieldbyname('connsrcip').AsString;
  aqTodayStat.Close;
  aqTodayStat.open;
  aqTodayStat.Locate('connsrcip',s,[]);
  timer2.Enabled:=true;
  memo1.lines.clear;
  StatusBar1.Panels[1].Text:='0';
  timer1.Enabled:=true;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Timer1Timer(Sender: TObject);
var x:integer;
   Inp: TInput;
   _x,_y:integer;
   p:tpoint;
begin
{  sleep(250);
  GetCursorPos(p);
  try
    memo1.Lines.LoadFromFile(apl_path+'\syslog.txt');
    deletefile(apl_path+'\syslog.txt');
  except
   on e:exception do
  end;}
  timer1.Enabled:=false;
  SpeedButton4Click(self);
  timer1.Enabled:=true;
  timer2.Enabled:=true;



end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton1Click(Sender: TObject);
begin
  timer1.Enabled:=true;
  timer2.Enabled:=true;

  IdUDPServer1.DefaultPort:=edPort.value;
  IdUDPServer1.Active:=true;
  StartServer;
SpeedButton1.Enabled:=false;
SpeedButton2.enabled:=true;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton2Click(Sender: TObject);
begin
  timer1.Enabled:=false;
  timer2.Enabled:=false;
  IdUDPServer1.Active:=false;
  IdTCPServer.Active:=false;
SpeedButton2.Enabled:=false;
SpeedButton1.enabled:=true;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedB3utton4Click(Sender: TObject);
var x:integer;
   Inp: TInput;
   _x,_y:integer;
   p:tpoint;
begin
//  KillTask('tftpd32.exe');
  sleep(250);
  GetCursorPos(p);

  memo1.Lines.LoadFromFile(apl_path+'\syslog.txt');
  deletefile(apl_path+'\syslog.txt');
//  ShellExecute (0,'open', pchar(apl_path + '\tftpd32.exe'), pchar(''),nil, SW_MINIMIZE);
  timer1.Enabled:=false;
  SpeedButton4Click(self);
  timer1.Enabled:=true;
  Timer2.Enabled:=true;

  for x:=3 to 40 do
    begin
      Inp.Itype := INPUT_MOUSE;
      Inp.mi.dx := Screen.Width-(x*5);
      Inp.mi.dy := Screen.Height-10;
      inp.mi.dwExtraInfo := 0;
      Inp.mi.mouseData := 1;
      inp.mi.dwFlags:=MOUSEEVENTF_LEFTDOWN;
      inp.mi.time := GetTickCount();
      sleep(15);
      SetCursorPos(Screen.Width-(x*5),Screen.Height-10);

      sendInput(1, Inp, SizeOf(Inp));
    end;

      Inp.Itype := INPUT_MOUSE;
      Inp.mi.dx := p.x;
      Inp.mi.dy := p.y;
      inp.mi.dwExtraInfo := 0;
      Inp.mi.mouseData := 1;
      inp.mi.dwFlags:=MOUSEEVENTF_LEFTDOWN;
      inp.mi.time := GetTickCount();
      SetCursorPos(p.x,p.y);
      sendInput(1, Inp, SizeOf(Inp));

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.dtTodayChange(Sender: TObject);
begin
  aqTodayStat.Close;
  aqTodayStat.SQL.Clear;
  aqTodayStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent,connsrcip,dtime from Today');
  aqTodayStat.SQL.Add(' where dtime=:dtime group by connsrcip,dtime');
  aqTodayStat.Parameters.ParameterCollection.Refresh;
  aqTodayStat.Parameters.Refresh;
  aqTodayStat.Parameters[0].Value:=datetimetostr(now);
  aqTodayStat.Open;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Timer2Timer(Sender: TObject);
var x:TGetDataThread;
begin
   Timer2.Enabled:=false;
   x:=TGetDataThread.Create;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Button1Click(Sender: TObject);
begin
   ShowMessage(ADOConnect.ConnectionString);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Panel5Click(Sender: TObject);
var x:integer;
begin
  if fomain.Panel8.Visible then
   begin
     for x:=1 to 4 do
       begin
         fomain.Panel8.Height:=round(fomain.Panel8.Height/2);
         panel5.Caption:='Config (click to open)';
         sleep(5);
         fomain.refresh;
       end;
     fomain.Panel8.Visible:=not fomain.Panel8.Visible;
//     fomain.Splitter1.Visible:=not fomain.Splitter1.Visible;
   end else
   begin
//     fomain.Splitter1.Visible:=not fomain.Splitter1.Visible;
     fomain.Panel8.Visible:=not fomain.Panel8.Visible;
     for x:=1 to 4 do
       begin
         fomain.Panel8.Height:=round(fomain.Panel8.Height*2);
         panel5.Caption:='Config (click to close)';
         sleep(5);
         fomain.refresh;
       end;
   end;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton3Click(Sender: TObject);
 var
   dir: string;
 begin
   AdvSelectDirectory('DB location', '', dir, False, False, True);

   if dir<>'' then
     begin

      edDBPath.text := dir;

      Ini := TIniFile.Create(apl_path + '\sla.server.ini');
      ini.writeString('system', 'db', edDBPath.Text);
      ini.Free;
     end;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.edDBPathChange(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Memo1Change(Sender: TObject);
begin
  StatusBar1.Panels[1].Text:=inttostr(memo1.Lines.Count);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.IdTCPServer1Connect(AThread: TIdPeerThread);
begin
StatusBar1.Panels[0].Text:='TCP Connect';
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.IdTCPServerExecute(AThread: TIdPeerThread);
var
    Command : wideString;
begin
  Command := AThread.Connection.ReadLn;
//  Command := uppercase(Command);
  memo1.lines.add(command)

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.IdTCPServerDisconnect(AThread: TIdPeerThread);
var  ActClient: PClient;

begin
StatusBar1.Panels[0].Text:='TCP Disconnect';
  ActClient := PClient(AThread.Data);
  try
    Clients.LockList.Remove(ActClient);
  finally
    Clients.UnlockList;
  end;
  FreeMem(ActClient);
  AThread.Data := nil;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.IdTCPServerConnect(AThread: TIdPeerThread);
var
  NewClient: PClient;

begin
  StatusBar1.Panels[0].Text:='TCP Connect';
  GetMem(NewClient, SizeOf(TClient));

  NewClient.DNS         := AThread.Connection.LocalName;
  NewClient.Connected   := Now;
  NewClient.LastAction  := NewClient.Connected;
  NewClient.Thread      :=AThread;

  AThread.Data:=TObject(NewClient);

  try
    Clients.LockList.Add(NewClient);
  finally
    Clients.UnlockList;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------


end.




