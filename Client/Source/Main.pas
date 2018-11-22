unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, activex, WinSock,
  Menus, DB, ADODB, jpeg,Tlhelp32,
  ShellAPI, ShlObj, comobj ,Variants,  inifiles, uabout, AppEvnts,
  IdTCPClient, IdEcho,  OleCtrls, SHDocVw,
  IdBaseComponent, IdComponent, IdTCPConnection, ImgList, Buttons,
  TntStdCtrls;

type formstates = (fsMaximized, fsNormal);

const NormalSizeWidth=750;
      NormalSizeHeight=500;
      Version = '2.0';
      Progname = 'SysLogAnalizer.Client';

type
  TfoMain = class(TForm)
    ADOConnect: TADOConnection;
    ppMainmenu: TPopupMenu;
    N2: TMenuItem;
    ImageList1: TImageList;
    N10: TMenuItem;
    About1: TMenuItem;
    aqSQL: TADOQuery;
    aqMain: TADOQuery;
    DataSource1: TDataSource;
    aqTodayStat: TADOQuery;
    DataSource2: TDataSource;
    IdEcho1: TIdEcho;
    aqMonthStat: TADOQuery;
    DataSource3: TDataSource;
    Timer1: TTimer;
    aqMonthStat_perday: TADOQuery;
    DataSource4: TDataSource;
    aqHosts: TADOQuery;
    DataSource5: TDataSource;
    WebBrowser1: TWebBrowser;
    mmTemp: TTntMemo;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel2: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    pnHost: TPanel;
    Label1: TLabel;
    lbHostState: TLabel;
    lbHostname: TLabel;
    Label3: TLabel;
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
    procedure BuildHTMLResultIP(ip:string);
    procedure BuildHTMLResultMain(dt:tdatetime);
    procedure SpeedButton1Click(Sender: TObject);
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    dtm:tdatetime;
    { Public declarations }
  end;

var
  Ini: TIniFile;
  foMain           : TfoMain;
  apl_path           : string;
  sr                 : TSearchRec;
  _exit:boolean=false;
  _x,_y:integer;
  recnum:integer;

type

    ip_option_information = packed record  // Информация заголовка IP (Наполнение
    // этой структуры и формат полей описан в RFC791.
        Ttl : byte;// Время жизни (используется traceroute-ом)
        Tos : byte;// Тип обслуживания, обычно 0
        Flags : byte;// Флаги заголовка IP, обычно 0
        OptionsSize : byte;// Размер данных в заголовке, обычно 0, максимум 40
        OptionsData : Pointer;// Указатель на данные
    end;

   icmp_echo_reply = packed record
        Address : u_long;      // Адрес отвечающего
        Status : u_long;     // IP_STATUS (см. ниже)
        RTTime : u_long;     // Время между эхо-запросом и эхо-ответом
         // в миллисекундах
        DataSize : u_short;      // Размер возвращенных данных
        Reserved : u_short;      // Зарезервировано
        Data : Pointer;  // Указатель на возвращенные данные
        Options : ip_option_information; // Информация из заголовка IP

    end;

    PIPINFO = ^ip_option_information;
    PVOID = Pointer;

    function IcmpCreateFile() : THandle; stdcall; external 'ICMP.DLL' name 'IcmpCreateFile';
    function IcmpCloseHandle(IcmpHandle : THandle) : BOOL; stdcall; external 'ICMP.DLL'  name 'IcmpCloseHandle';
    function IcmpSendEcho(
          IcmpHandle : THandle;    // handle, возвращенный IcmpCreateFile()
          DestAddress : u_long;    // Адрес получателя (в сетевом порядке)
          RequestData : PVOID;     // Указатель на посылаемые данные
          RequestSize : Word;      // Размер посылаемых данных
          RequestOptns : PIPINFO;  // Указатель на посылаемую структуру
                           // ip_option_information (может быть nil)
          ReplyBuffer : PVOID;     // Указатель на буфер, содержащий ответы.
          ReplySize : DWORD;       // Размер буфера ответов
          Timeout : DWORD          // Время ожидания ответа в миллисекундах
          ) : DWORD; stdcall; external 'ICMP.DLL' name 'IcmpSendEcho';

type

  TPingThread = class(TThread)
  private
    FHost: String;
    FResult: integer;
    FError: integer;
    fIndex : integer;

  protected
    procedure Execute; override;
    function GetHostByIP(IPAddr: String): String;
  public
    constructor Create(Host: string);
  end;


implementation

uses uWait;


 var
  fs:formstates;

//----------------------------------------------------------------------------------------------------------------------




{$R *.dfm}

{ TMainForm }
//-----------------------------------------------------------------------------------------------

function TPingThread.GetHostByIP(IPAddr: String): String;
var
  Error: DWORD;
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  Data: TWSAData;
begin
  Result:='Can`t do this';
  Error:=WSAStartup($101, Data);
  if Error = 0 then begin
   SockAddrIn.sin_addr.s_addr:= inet_addr(PChar(IPAddr));
   HostEnt:= gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
   if HostEnt<>nil then Result:=StrPas(Hostent^.h_name);
  end; // Error=0
  WSACleanup();
end;



// ---------------------------------------------------------------------------------------------------------

constructor TPingThread.Create(Host: string);
begin
   FHost := Host;
  FreeOnTerminate := True;
  inherited Create(False);
end;


// ---------------------------------------------------------------------------------------------------------

procedure TPingThread.Execute;
label beg,ext;

var x:integer;
    hostname:string;
 hIP : THandle;
    pingBuffer : array [0..31] of Char;
    pIpe : ^icmp_echo_reply;
    pHostEn : PHostEnt;
    wVersionRequested : WORD;
    lwsaData : WSAData;
    error : DWORD;
    destAddress : In_Addr;
begin

  fomain.lbHostState.Caption:='';
  fomain.lbHostname.Caption:='Wait....';
  fomain.lbHostState.Font.Color:=clGray;

 // Blocksize:=edPingSize.Value;
  hostname:=fhost;
    // Tючфрхь handle
       hIP := IcmpCreateFile();
       GetMem( pIpe, sizeof(icmp_echo_reply) + sizeof(pingBuffer));
       pIpe.Data := @pingBuffer;
       pIpe.DataSize := sizeof(pingBuffer);
       wVersionRequested := MakeWord(1,1);
       error := WSAStartup(wVersionRequested,lwsaData);
       if (error <> 0) then
       begin
            fresult:=0;
            ferror:=error;
            goto Ext;
       end;
       pHostEn := gethostbyname(pansichar(hostname));
       error := GetLastError();
       if (error <> 0) then
       begin
            fresult:=0;
            ferror:=error;
            goto Ext;
       end;

    destAddress := PInAddr(pHostEn^.h_addr_list^)^;

      // ¦юёvырхь ping-яръхЄ

    IcmpSendEcho(hIP,
                    destAddress.S_addr,
                    @pingBuffer,
                    sizeof(pingBuffer),
                    Nil,
                    pIpe,
                    sizeof(icmp_echo_reply) + sizeof(pingBuffer),
                    5000);


    error := GetLastError();

       if (error <> 0) then
       begin
            fresult:=0;
            ferror:=error;
            goto Ext;
       end;

     // TьюЄЁшь эхъюЄюЁvх шч тхЁэєт°шїё  фрээvї
    fresult:=pIpe.RTTime;

    IcmpCloseHandle(hIP);
       WSACleanup();
       FreeMem(pIpe);

    ext:
    if ferror>0 then
      begin
        fomain.lbHostState.Caption:='Not response';
        fomain.lbHostState.Font.Color:=clRed;
      end
    else
      begin
        fomain.lbHostState.Caption:='Active';
        fomain.lbHostState.Font.Color:=clGreen;
        fomain.lbHostname.Caption:=GetHostByIP(fhost);

      end;
   // fomain.mmPing.lines.add('host = ' + fhost+'  result = '+inttostr(fresult)+' error = '+inttostr(ferror));

end;

//----------------------------------------------------------------------------------------------------------------------

procedure showwait;
begin
  if not assigned(fowait) then
   begin
      Application.CreateForm ( Tfowait, fowait );
   end;
  fowait.Show;
  fowait.repaint;
  fowait.DoubleBuffered:=true;
  screen.Cursor:=crhourglass;
end;

//-----------------------------------------------------------------------------------------------

procedure closewait;
begin
  screen.Cursor:=crdefault;
  fowait.close;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Bmp2Jpeg(bmp,jpeg:string);

var
  jp: TJPEGImage;  //Requires the "jpeg" unit added to "uses" clause.
  im:timage;
begin
  jp := TJPEGImage.Create;
  im := TImage.Create(fomain);
  try
    with jp do
    begin
      im.Picture.LoadFromFile(bmp);
      Assign(Im.Picture.Bitmap);
      SaveToFile(jpeg)
    end;
  finally
    jp.Free;
    im.Free;
  end;
end;


//----------------------------------------------------------------------------------------------------------------------

function GetHostByIP(IPAddr: String): String; // Полyчение имени по IP
var
  Error: DWORD;
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  Data: TWSAData;
begin
  Result:='Unknown';
  Error:=WSAStartup($101, Data);
  if Error = 0 then begin
   SockAddrIn.sin_addr.s_addr:= inet_addr(PChar(IPAddr));
   HostEnt:= gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
   if HostEnt<>nil then Result:=StrPas(Hostent^.h_name);
  end; // Error=0
  WSACleanup();
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

//----------------------------------------------------------------------------------------------------------------------

function Win2NetPath(s:string):string;
var i:integer;
begin
  s:='file://localhost/'+s;
  for i:=1 to length(s) do if s[i]='\' then s[i]:='/';
  result:=s;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.BuildHTMLResultIP(ip:string);
var dt:tdatetime;
    x,n:integer;
    hostname:TPingThread;
begin
   pnHost.Visible:=true;
   mmTemp.Lines.Clear;
   dt:=dtm;
   mmTemp.lines.add('<HTML><HEAD> ');
   mmTemp.lines.add('<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=WINDOWS-1251">');
   mmTemp.lines.add('<TITLE>Title</TITLE></HEAD>');

   mmTemp.lines.add('<body bgcolor="#FFFFFF"> <FONT face="Arial" size=3> Syslog analize main report.  Date '+datetimetostr(dt)+'</font><BR><BR>');
   mmTemp.lines.add('<FONT face="Arial" size=3>Report for '+IP+' </font><BR><BR>');
  // mmTemp.lines.add('<FONT face="Arial" size=3> IP '+IP+' ');//, Hostname '+GetHostByIP(ip)+'<br><br>');

   //Print one day download table, by one ip

  aqHosts.Close;
  aqHosts.SQL.Clear;
  aqHosts.SQL.Add('select int(termsent) as itermsent, int(origsent) as iorigsent, * from hosts');
  aqHosts.SQL.Add(' where dtime=:dtime and ');
  aqHosts.SQL.Add(' srcip='+#39+ip+#39+' order by  int(termsent) desc ');
  aqHosts.Parameters.ParameterCollection.Refresh;
  aqHosts.Parameters.Refresh;
  aqHosts.Parameters[0].Value:=dt;
  aqHosts.Open;

  aqSQL.Close;
  aqSQL.SQL.Clear;
  aqSQL.SQL.Add('select sum(termsent) as itermsent, sum(origsent) as iorigsent from hosts');
  aqSQL.SQL.Add(' where dtime=:dtime and ');
  aqSQL.SQL.Add(' srcip='+#39+ip+#39);
  aqSQL.Parameters.ParameterCollection.Refresh;
  aqSQL.Parameters.Refresh;
  aqSQL.Parameters[0].Value:=dt;
  aqSQL.Open;


   mmTemp.lines.add('<table width="800" border="0" cellpadding="0" cellspacing="1"> ');
   mmTemp.lines.add('<tr width="800">');

   mmTemp.lines.add('<td valign=top width="430">');
   mmTemp.lines.add('<FONT face="Arial" size=2> Date '+datetimetostr(dt)+'. Top '+inttostr(recnum)+' rows </font><BR>');
   mmTemp.lines.add('<table width="430" border="0" cellpadding="0" cellspacing="1"> ');
   mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;font-weight: bold;" width="430">');
   mmTemp.lines.add('  <td width="120"> IP </td>' );
   mmTemp.lines.add('  <td width="115">Receive</td>' );
   mmTemp.lines.add('  <td width="115">Send</td>' );
   mmTemp.lines.add('  <td width="80">Port</td>' );
    mmTemp.lines.add('</tr>');

   aqHosts.First;
   x:=0;
   while not aqHosts.Eof do
     begin
       mmTemp.lines.add('<tr style="font:11px Arial;background-color=#eeeeee;"width="430">');
       mmTemp.lines.add('  <td  width="120"> <a href="ip_ext:'  + aqHosts.fieldbyname('destip').AsString +  '"> '+aqHosts.fieldbyname('destip').AsString+' </td>' );
       mmTemp.lines.add('  <td  width="115">'  + FormatFloat('#,##',aqHosts.fieldbyname('termsent').AsVariant) + '</td>' );
       mmTemp.lines.add('  <td  width="115"> ' + FormatFloat('#,##',aqHosts.fieldbyname('origsent').AsVariant) + '</td>' );
       mmTemp.lines.add('  <td  width="80"> '  + aqHosts.fieldbyname('port').AsString + '</td></tr>' );
       mmTemp.lines.add('</tr>');
       inc(x);
       if x>recnum then aqHosts.Last;
       aqHosts.Next;
     end;

   mmTemp.lines.add('<tr style="font:11px Arial;background-color=#eeeeee;"width="430">');
   mmTemp.lines.add('  <td  width="120"> Total </td>' );
   mmTemp.lines.add('  <td  width="115">'  + FormatFloat('#,##',aqsql.fieldbyname('itermsent').AsVariant) + '</td>' );
   mmTemp.lines.add('  <td  width="115"> ' + FormatFloat('#,##',aqsql.fieldbyname('iorigsent').AsVariant) + '</td>' );
   mmTemp.lines.add('  <td  width="80"> </td></tr>' );
   mmTemp.lines.add('</tr>');

   mmTemp.lines.add('</table><br>');
   mmTemp.lines.add('</td>');
   mmTemp.lines.add('</tr>');
   mmTemp.lines.add('<tr width="800">');
   mmTemp.lines.add('<td width="550">');


   //Print one month download table, by one ip

  aqHosts.Close;
  aqHosts.SQL.Clear;
  aqHosts.SQL.Add('select int(termsent) as itermsent, int(origsent) as iorigsent, * from hosts');
  aqHosts.SQL.Add(' where dmonth=:month and dyear = :year and ');
  aqHosts.SQL.Add(' srcip='+#39+ip+#39+' order by  int(termsent) desc ');
  aqHosts.Parameters.ParameterCollection.Refresh;
  aqHosts.Parameters.Refresh;
  aqHosts.Parameters[0].Value:=formatdatetime('MM',dt);//dt.month;
  aqHosts.Parameters[1].Value:=formatdatetime('YYYY',dt);//dt.year;
  aqHosts.Open;


  aqSQL.Close;
  aqSQL.SQL.Clear;
  aqSQL.SQL.Add('select sum(termsent) as itermsent, sum(origsent) as iorigsent from hosts');
  aqSQL.SQL.Add(' where dmonth=:month and dyear = :year and ');
  aqSQL.SQL.Add(' srcip='+#39+ip+#39);
  aqSQL.Parameters.ParameterCollection.Refresh;
  aqSQL.Parameters.Refresh;
  aqSQL.Parameters[0].Value:=formatdatetime('MM',dt);//dt.month;
  aqSQL.Parameters[1].Value:=formatdatetime('YYYY',dt);//dt.year;
  aqSQL.Open;


   mmTemp.lines.add('  Report for '+IP+'. Month '+formatdatetime('MM/YYYY',dt)+' download . Top '+inttostr(recnum)+' rows</font><BR>');
   mmTemp.lines.add('<table width="430" border="0" cellpadding="0" cellspacing="1"> ');
   mmTemp.lines.add('<tr style="font:9px Arial; background-color=#FFFFFF;" width="350">');
   mmTemp.lines.add('</tr>');

   mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;font-weight: bold;" width="430">');
   mmTemp.lines.add('  <td width="120"> IP </td>' );
   mmTemp.lines.add('  <td width="115">Receive</td>' );
   mmTemp.lines.add('  <td width="115">Send</td>' );
   mmTemp.lines.add('  <td width="80">Port</td>' );
   mmTemp.lines.add('</tr>');

   aqHosts.First;

   x:=0;
   while not aqHosts.Eof do
     begin
       mmTemp.lines.add('<tr style="font:11px Arial;background-color=#eeeeee;"width="430">');
       mmTemp.lines.add('  <td  width="120"> <a href="ip_ext:'  + aqHosts.fieldbyname('destip').AsString +  '"> '+aqHosts.fieldbyname('destip').AsString+' </td>' );
       mmTemp.lines.add('  <td  width="150">'  + FormatFloat('#,##',aqHosts.fieldbyname('termsent').AsVariant) + '</td>' );
       mmTemp.lines.add('  <td  width="150"> ' + FormatFloat('#,##',aqHosts.fieldbyname('origsent').AsVariant) + '</td>' );
       mmTemp.lines.add('  <td  width="80"> '  + aqHosts.fieldbyname('port').AsString + '</td>' );
       mmTemp.lines.add('</tr>');
       inc(x);
       if x>recnum then aqHosts.Last;
       aqHosts.Next;

     end;

   mmTemp.lines.add('<tr style="font:11px Arial;background-color=#eeeeee;"width="430">');
   mmTemp.lines.add('  <td  width="120"> Total </td>' );
   mmTemp.lines.add('  <td  width="115">'  + FormatFloat('#,##',aqsql.fieldbyname('itermsent').AsVariant) + '</td>' );
   mmTemp.lines.add('  <td  width="115"> ' + FormatFloat('#,##',aqsql.fieldbyname('iorigsent').AsVariant) + '</td>' );
   mmTemp.lines.add('  <td  width="80"> </td></tr>' );
   mmTemp.lines.add('</tr>');


   mmTemp.lines.add('</table><br>');

   mmTemp.lines.add('</td>');
   mmTemp.lines.add('<td width="550">');

 {  mmTemp.lines.add('<table width="350" border="0" cellpadding="0" cellspacing="1"> ');
   mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;font-weight: bold;" width="350">');
   mmTemp.lines.add('  <td width="120"> IP </td>' );
   mmTemp.lines.add('  <td width="115">Receive</td>' );
   mmTemp.lines.add('  <td width="115">Send</td>' );
   mmTemp.lines.add('</tr>');

   aqHosts.First;
   while not aqHosts.Eof do
     begin
       mmTemp.lines.add('<tr style="font:11px Arial;background-color=#eeeeee;"width="350">');
       mmTemp.lines.add('  <td  width="120"> <a href="ip_ext:'  + aqHosts.fieldbyname('destip').AsString +  '"> '+aqHosts.fieldbyname('destip').AsString+' </td>' );
       mmTemp.lines.add('  <td  width="150">'  + FormatFloat('#,##',aqHosts.fieldbyname('termsent').asinteger) + '</td>' );
       mmTemp.lines.add('  <td  width="150"> ' + FormatFloat('#,##',aqHosts.fieldbyname('origsent').AsInteger) + '</td></tr>' );
       mmTemp.lines.add('</tr>');
       aqHosts.Next;
     end;  }

   mmTemp.lines.add('</td>');
   mmTemp.lines.add('</table><br>');

   mmTemp.lines.add('</font></body></html>');
   mmTemp.Lines.SaveToFile(apl_path + '\page\ip'+ip+'.htm');

   fomain.WebBrowser1.Navigate(apl_path + '\page\ip'+ip+'.htm');

   hostname:=TPingThread.Create(ip);

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.BuildHTMLResultMain(dt:tdatetime);
var  F: TextFile;
  i,x,y,z,n:integer;
  ip1,ip2,ip3,ip4:string;
begin

   pnHost.Visible:=false;
   dtm:=dt;
   mmTemp.Lines.Clear;

   mmTemp.lines.add('<HTML><HEAD> ');
   mmTemp.lines.add('<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=WINDOWS-1251">');
   mmTemp.lines.add('<TITLE>Title</TITLE></HEAD>');

   //Print day download table, every ip

   aqTodayStat.Close;
   aqTodayStat.SQL.Clear;
   aqTodayStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent, connsrcip, dtime from daylog');
   aqTodayStat.SQL.Add(' where dtime=:dtime  group by connsrcip,dtime order by  sum(termsent) desc ');
   aqTodayStat.Parameters.ParameterCollection.Refresh;
   aqTodayStat.Parameters.Refresh;
   aqTodayStat.Parameters[0].Value:=dt;//dtToday.Text;
   aqTodayStat.Open;

   mmTemp.lines.add('<body bgcolor="#FFFFFF"> <FONT face="Arial" size=4> Syslog main report.  Date '+datetimetostr(dt)+'</font><BR><BR>');
   mmTemp.lines.add('<table width="800" border="0" cellpadding="0" cellspacing="1"> ');
   mmTemp.lines.add('<tr width="750">');
   mmTemp.lines.add('<td valign=top width="350">');
   mmTemp.lines.add('<FONT face="Arial" size=3>Today full report </font><BR><BR>');
   mmTemp.lines.add('<table width="350" border="0" cellpadding="0" cellspacing="1"> ');
   aqTodayStat.First;
   mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;font-weight: bold;" width="350">');
   mmTemp.lines.add('  <td width="120"> IP </td>' );
   mmTemp.lines.add('  <td width="115">Receive</td>' );
   mmTemp.lines.add('  <td width="115">Send</td>' );
   mmTemp.lines.add('</tr>');

   while not aqTodayStat.Eof do
     begin
       mmTemp.lines.add('<tr style="font:11px Arial;background-color=#eeeeee;"width="350">');
       mmTemp.lines.add('  <td  width="120"> <a href="ip_full:' + aqTodayStat.fieldbyname('connsrcip').AsString + '"> ' + aqTodayStat.fieldbyname('connsrcip').AsString + '</a> </td>' );
       mmTemp.lines.add('  <td  width="150">'  + FormatFloat('#,##',aqTodayStat.fieldbyname('termsent').asinteger) + '</td>' );
       mmTemp.lines.add('  <td  width="150"> ' + FormatFloat('#,##',aqTodayStat.fieldbyname('origsent').AsInteger) + '</td></tr>' );
       mmTemp.lines.add('</tr>');
       aqTodayStat.Next;
     end;

   mmTemp.lines.add('</table><br>');

   mmTemp.lines.add('</td>');
   mmTemp.lines.add('<td width="50">');
   mmTemp.lines.add('</td>');

   mmTemp.lines.add('<td valign=top width="350">');
{   foMain.DBChart1.SaveToBitmapFile(apl_path + '\page\1.bmp');
   Bmp2Jpeg(apl_path + '\page\1.bmp',apl_path + '\page\1.jpg');
   DeleteFile(apl_path + '\page\1.bmp');
   mmTemp.lines.add('<img border=0 src="'+Win2NetPath(apl_path + '\page\1.jpg')+'">');}

   //Print day download table, sum of day. only current month;

   aqMonthStat_perday.Close;
   aqMonthStat_perday.Parameters.ParamByName('month').Value:=formatdatetime('MM',dt);//dt.month;
   aqMonthStat_perday.Parameters.ParamByName('year').Value:=formatdatetime('YYYY',dt);//dt.year;
   aqMonthStat_perday.Open;

   mmTemp.lines.add('<FONT face="Arial" size=3>Days summary </font><BR><BR>');
   mmTemp.lines.add('<table width="350" border="0" cellpadding="0" cellspacing="1"> ');
   aqTodayStat.First;
   mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;font-weight: bold;" width="350">');
   mmTemp.lines.add('  <td width="120">Date <td>' );
   mmTemp.lines.add('  <td width="115">Receive<td>' );
   mmTemp.lines.add('  <td width="115">Send</td></tr>' );
   mmTemp.lines.add('</tr>');

   while not aqMonthStat_perday.Eof do
     begin
       mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;" width="350">');
       mmTemp.lines.add('  <td  width="120"> <a href="data:' + aqMonthStat_perday.fieldbyname('dday').AsString+'.');
       mmTemp.lines.add(  aqMonthStat_perday.fieldbyname('dmonth').AsString+'.');
       mmTemp.lines.add(  aqMonthStat_perday.fieldbyname('dyear').AsString + '">');
       mmTemp.lines.add(  aqMonthStat_perday.fieldbyname('dday').AsString+'.');
       mmTemp.lines.add(  aqMonthStat_perday.fieldbyname('dmonth').AsString+'.');
       mmTemp.lines.add(  aqMonthStat_perday.fieldbyname('dyear').AsString+' </a><td>' );
       mmTemp.lines.add('  <td  width="150">'  + FormatFloat('#,##',aqMonthStat_perday.fieldbyname('termsent').asinteger) + '<td>' );
       mmTemp.lines.add('  <td  width="150"> ' + FormatFloat('#,##',aqMonthStat_perday.fieldbyname('origsent').AsInteger) + '</td>' );
       mmTemp.lines.add('</tr>');
       aqMonthStat_perday.Next;
     end;
   mmTemp.lines.add('</table><br>');

   //Print month download table, sum of Month. all current month;

   aqMonthStat.Close;
   aqMonthStat.Open;

   mmTemp.lines.add('<FONT face="Arial" size=3>Month summary </font><BR><BR>');
   mmTemp.lines.add('<table width="350" border="0" cellpadding="0" cellspacing="1"> ');
   aqTodayStat.First;
   mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;font-weight: bold;" width="350">');
   mmTemp.lines.add('  <td width="60">Month </td>' );
   mmTemp.lines.add('  <td width="60">Year </td>' );
   mmTemp.lines.add('  <td width="115">Receive</td>' );
   mmTemp.lines.add('  <td width="115">Send</td>' );
   mmTemp.lines.add('</tr>');

   while not aqMonthStat.Eof do
     begin
       mmTemp.lines.add('<tr style="font:11px Arial; background-color=#eeeeee;" width="350">');
       mmTemp.lines.add('  <td  width="60"> ' + aqMonthStat.fieldbyname('dmonth').AsString+' </td>' );
       mmTemp.lines.add('  <td  width="60"> ' + aqMonthStat.fieldbyname('dyear').AsString+' </td>' );
       mmTemp.lines.add('  <td  width="150">'  + FormatFloat('#,##',aqMonthStat.fieldbyname('termsent').AsVariant) + '</td>' );
       mmTemp.lines.add('  <td  width="150"> ' + FormatFloat('#,##',aqMonthStat.fieldbyname('origsent').AsVariant) + '</td>' );
       mmTemp.lines.add('</tr>');
       aqMonthStat.Next;
     end;
   mmTemp.lines.add('</table><br>');
   mmTemp.lines.add('</td>');
   mmTemp.lines.add('</table><br>');

   mmTemp.lines.add('</font></body></html>');
   mmTemp.Lines.SaveToFile(apl_path + '\page\ping.htm');

   fomain.WebBrowser1.Navigate(apl_path + '\page\ping.htm');

end;

//----------------------------------------------------------------------------------------------------------

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
   recnum:=50;

   foMain.Caption:=Progname+' '+ Version;

//  apl_path:= ExtractShortPathName(ExtractFileDir(application.ExeName));
  apl_path:= ExtractFileDir(application.ExeName);

  Ini := TIniFile.Create(apl_path + '\sla.server.ini');

  db:=ini.readString('system', 'db', 'false')+'\SysLogAnalizer.mdb';


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
     if str.Count=0 then begin Showmessage('Unable to connect DB');close;end;



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
//  aqMonthStat.Active:=true;
//aqMonthStat_perday.Active:=true;

  aqHosts.Close;
  aqHosts.SQL.Clear;
  aqHosts.SQL.Add(' select * from hosts ');
  aqHosts.Open;

  BuildHTMLResultMain(strtodate(formatDateTime('DD.MM.YYYY', now)));

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
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
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
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.lbFormCaptionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbCloseClick(Sender: TObject);
begin
close;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.sbMaxClick(Sender: TObject);
begin

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

{procedure TfoMain.DBGridEh2CellClick(Column: TColumnEh);
begin
{  aqMain.Close;
  aqMain.SQL.Clear;
  aqMain.SQL.Add('select origsent as origsent,termsent as termsent, connsrcport,connsrcip from daylog');
  aqMain.SQL.Add(' where dtime=:dtime and ');
  aqMain.SQL.Add(' connsrcip='+#39+aqTodayStat.fieldbyname('connsrcip').AsVariant+#39+' ');
  aqMain.Parameters.ParameterCollection.Refresh;
  aqMain.Parameters.Refresh;
  aqMain.Parameters[0].Value:=dtToday.Text;
  aqMain.Open;

  lbHostname.Caption:=GetHostByIP(aqTodayStat.fieldbyname('connsrcip').AsVariant);

  aqHosts.Close;
  aqHosts.SQL.Clear;
  aqHosts.SQL.Add('select int(termsent) as itermsent, int(origsent) as iorigsent, * from hosts');
  aqHosts.SQL.Add(' where dtime=:dtime and ');
  aqHosts.SQL.Add(' srcip='+#39+aqTodayStat.fieldbyname('connsrcip').AsVariant+#39+' order by  int(termsent) desc ');
  aqHosts.Parameters.ParameterCollection.Refresh;
  aqHosts.Parameters.Refresh;
  aqHosts.Parameters[0].Value:=dtToday.Text;
  aqHosts.Open;
end;}

//----------------------------------------------------------------------------------------------------------------------

{procedure TfoMain.dtTodayChange(Sender: TObject);
begin
{  aqTodayStat.Close;
  aqTodayStat.SQL.Clear;
  aqTodayStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent, connsrcip, dtime from daylog');
  aqTodayStat.SQL.Add(' where dtime=:dtime  group by connsrcip,dtime order by  sum(termsent) desc ');
  aqTodayStat.Parameters.ParameterCollection.Refresh;
  aqTodayStat.Parameters.Refresh;
  aqTodayStat.Parameters[0].Value:=dtToday.Text;
  aqTodayStat.Open;
end;}



//----------------------------------------------------------------------------------------------------------------------

{procedure TfoMain.DBGridEh3CellClick(Column: TColumnEh);
begin
{  aqTodayStat.Close;
  aqTodayStat.SQL.Clear;
  aqTodayStat.SQL.Add('select sum(origsent) as origsent,sum(termsent) as termsent, connsrcip, dtime from daylog');
  aqTodayStat.SQL.Add(' where dtime=:dtime group by connsrcip,dtime order by  sum(termsent) desc ');
  aqTodayStat.Parameters.ParameterCollection.Refresh;
  aqTodayStat.Parameters.Refresh;
  aqTodayStat.Parameters[0].Value:=aqMonthStat_perday.fieldbyname('dday').asstring+DateSeparator+
                                   aqMonthStat_perday.fieldbyname('dmonth').asstring+DateSeparator+
                                   aqMonthStat_perday.fieldbyname('dyear').asstring;
  aqTodayStat.Open;

  dtToday.Text:=aqMonthStat_perday.fieldbyname('dday').asstring+DateSeparator+
                                   aqMonthStat_perday.fieldbyname('dmonth').asstring+DateSeparator+
                                   aqMonthStat_perday.fieldbyname('dyear').asstring;

end;}

//----------------------------------------------------------------------------------------------------------------------

{procedure TfoMain.DBGridEh2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var s:string;
begin
{   if (column.fieldname='connsrcip') then
     begin
       s:='';
       if strpos(pchar(column.Field.DisplayText),pchar('172.'))<> nil then
         begin
           s:=GetHostByIP(column.Field.DisplayText);
           delete(s,pos('.',s),255);
         end;
       with DBGridEh2.Canvas do begin
 //         brush.color:=rgb(255,250,255);
//          column.Field.DisplayText
//          font.Style:=font.Style+[fsbold];
          textout(rect.left+2,rect.Top+2,column.Field.DisplayText+' '+s);
       end;
     end;

end;}

//----------------------------------------------------------------------------------------------------------------------

{procedure TfoMain.DBGridEh1DblClick(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('http://'+aqHosts.FieldByName('host').AsString), pchar(''),nil, SW_show);
end;
 }

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton1Click(Sender: TObject);
begin
  showwait;
  BuildHTMLResultMain(strtodate(formatDateTime('DD.MM.YYYY', now)));
  closewait;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.WebBrowser1BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var S:string;
begin
    if pos('data:',url)>0 then
      begin
        cancel:=true;
        s:=url;
        delete(s,1, pos('data:',s)+4);
        showwait;
        BuildHTMLResultMain(strtodate(s));
        closewait;
      end;
    if pos('ip_full:',url)>0 then
      begin
        cancel:=true;
        s:=url;
        delete(s,1, pos('ip_full:',s)+7);
        showwait;
        BuildHTMLResultIP(s);
        closewait;
      end;

    if pos('ip_ext:',url)>0 then
      begin
        cancel:=true;
        s:=url;
        delete(s,1, pos('ip_ext:',s)+6);
        ShowMessage('http://'+s+'/');
        WebBrowser1.Navigate('http://'+s+'/');
      end;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton2Click(Sender: TObject);
begin
 try
   WebBrowser1.GoBack;
   pnHost.Visible:=false;
 except on e:Eoleexception do

 end;

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton3Click(Sender: TObject);
begin
 try
   WebBrowser1.GoForward;
except on e:Eoleexception do
 end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TfoMain.SpeedButton4Click(Sender: TObject);
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

end.




