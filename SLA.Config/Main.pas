unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, activex, WinSock, ImgList, XPMenu,
  Menus, DB, ADODB, Buttons, jpeg, Tlhelp32,   IdSocketHandle,
  ShellAPI, ShlObj, comobj ,Variants,  inifiles,  Mask, CheckLst, DBCtrlsEh;

type formstates = (fsMaximized, fsNormal);

const NormalSizeWidth=750;
      NormalSizeHeight=500;
      Version = '2.0';
      Progname = 'SysLogAnalizer.Config';

type
  TfoMain = class(TForm)
    lbIPs: TCheckListBox;
    SpeedButton3: TSpeedButton;
    edDBPath: TDBEditEh;
    edTime1: TDBNumberEditEh;
    edTime2: TDBNumberEditEh;
    Label4: TLabel;
    Label3: TLabel;
    edPort: TDBNumberEditEh;
    edTCPPOrt: TDBNumberEditEh;
    Label5: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    Image3: TImage;
    Label6: TLabel;
    edWebPath: TDBEditEh;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
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



  foMain.DoubleBuffered:=true;


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

procedure TfoMain.SpeedButton3Click(Sender: TObject);
 var
   dir: string;
 begin
   AdvSelectDirectory('DB location', '', dir, False, False, True);

   if dir<>'' then
     begin

      edDBPath.text := dir;
     end;

end;



procedure TfoMain.SpeedButton2Click(Sender: TObject);
begin
  close;
end;

procedure TfoMain.SpeedButton1Click(Sender: TObject);
begin
  Ini := TIniFile.Create(apl_path + '\sla.server.ini');
  ini.writeString('system', 'udpport', edPort.Text);
  ini.writeString('system', 'tcpport', edtcpPort.Text);
  ini.writeString('system', 'sl_load_interval', edTime1.Text);
  ini.writeString('system', 'sl_calc_stat_interval', edTime2.Text);
  ini.writeString('system', 'DB', edDBPath.Text);
  ini.writeString('system', 'webpath', edWebPath.Text);
  ini.Free;
  close;

end;

procedure TfoMain.SpeedButton4Click(Sender: TObject);
 var
   dir: string;
 begin
   AdvSelectDirectory('Path to web site for clients', '', dir, False, False, True);

   if dir<>'' then
     begin

      edWebPath.text := dir;

     end;
end;

end.




