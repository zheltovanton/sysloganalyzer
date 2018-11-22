unit Unit1;

{
  CrtSocket for Delphi 32
  Copyright (C) 1999-2001  Paul Toth <tothpaul@free.fr>
  http://tothpaul.free.fr

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    edURL: TEdit;
    Label1: TLabel;
    GET: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edSMTP: TEdit;
    edFROM: TEdit;
    edTO: TEdit;
    edSUBJECT: TEdit;
    edBODY: TMemo;
    SendMail: TButton;
    Label6: TLabel;
    edHost: TEdit;
    Label7: TLabel;
    edFile: TEdit;
    Upload: TButton;
    Download: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label8: TLabel;
    edUser: TEdit;
    Label9: TLabel;
    edPass: TEdit;
    TabSheet4: TTabSheet;
    Label10: TLabel;
    Port: TEdit;
    Label11: TLabel;
    edBroadcast: TEdit;
    Label12: TLabel;
    Listen: TLabel;
    Broadcast: TButton;
    Active: TCheckBox;
    UDPTimer: TTimer;
    Label13: TLabel;
    edListen: TEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TabSheet5: TTabSheet;
    Label14: TLabel;
    popHOST: TEdit;
    Label15: TLabel;
    popUSER: TEdit;
    Label16: TLabel;
    popPASS: TEdit;
    ReadMail: TButton;
    mmMail: TMemo;
    Label17: TLabel;
    lbMailCount: TLabel;
    procedure GETClick(Sender: TObject);
    procedure SendMailClick(Sender: TObject);
    procedure UploadClick(Sender: TObject);
    procedure DownloadClick(Sender: TObject);
    procedure BroadcastClick(Sender: TObject);
    procedure ActiveClick(Sender: TObject);
    procedure UDPTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReadMailClick(Sender: TObject);
  private
    { Déclarations privées }
    function Server:string;
    function URL:string;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses CrtSock, HttpSock, SmtpSock, FtpSock, PopSock;

{$R *.DFM}

//--HTTP-------------------------------------------------------------------

procedure TForm1.GETClick(Sender: TObject);
var
 header:string;
 body:string;
begin
 screen.cursor:=crHourglass;
 try
  header:='';
  body:=HttpGet(Server,URL,header);
  memo1.Lines.Text:='[header]'#13#10+Header+'[body]'#13#13+body;
 finally
  screen.cursor:=crDefault;
 end;
end;

function TForm1.Server:string;
var
 i:integer;
begin
 result:=edURL.Text;
 i:=pos('//',Result);
 if i>0 then Delete(Result,1,i+1);
 i:=pos('/',Result);
 if i>0 then SetLength(Result,i-1);
end;

function TForm1.URL:string;
var
 i:integer;
begin
 result:=edURL.Text;
 i:=pos('//',Result);
 if i>0 then Delete(Result,1,i+2);
 i:=pos('/',Result);
 if i=0 then Result:='/' else Delete(Result,1,i-1);
end;

//--SMTP-------------------------------------------------------------------

procedure TForm1.SendMailClick(Sender: TObject);
begin
 screen.cursor:=crHourglass;
 try
  if SmtpOpen(edSMTP.Text)<0 then raise exception.create(smtpError);
  try
  // this can be different from smtpSend parameters !
   if not smtpFrom(edFrom.Text) then raise exception.create(smtpError);
   if not smtpTo(edTo.Text) then raise exception.create(smtpError);
  // this is part of the message, not the SMTP session
   if not smtpSend(edFrom.Text,edTo.Text,edSubject.Text,edBody.Lines) then raise exception.create(smtpError);
  finally
   smtpClose;
  end;
 finally
  screen.cursor:=crDefault;
 end;
end;

//---FTP------------------------------------------------------------------

procedure TForm1.UploadClick(Sender: TObject);
var
 h:integer;
 f:file;
 i:integer;
 p:pointer;
begin
 screen.cursor:=crHourglass;
 try
  if opendialog1.execute then begin
   assignfile(f,opendialog1.filename);
   reset(f,1);
   i:=filesize(f);
   getmem(p,i);
   blockread(f,p^,i);
   closefile(f);
   if FtpLogon(edHost.Text,edUser.Text,edPass.Text)<0 then raise exception.create(ftpError);
   try
    h:=ftpOpenWrite(edFile.Text);
    if h<0 then raise exception.create(ftperror);
    send(h,p,i,0);
    if not ftpclose(h) then raise exception.create(ftperror);
   finally
    ftpLogoff;
   end;
   freemem(p);
  end;
 finally
  screen.cursor:=crDefault;
 end;
end;

procedure TForm1.DownloadClick(Sender: TObject);
var
 i:integer;
 p:array[0..1023] of char;
 f:file;
 h:integer;
begin
 screen.cursor:=crHourglass;
 try
  savedialog1.filename:=edFile.Text;
  if savedialog1.execute then begin
   if FtpLogon(edHost.Text,edUser.Text,edPass.Text)<0 then raise exception.create(ftpError);
   try
    h:=ftpOpenRead(edFile.Text);
    if h<0 then raise exception.create(ftperror);
    assignfile(f,savedialog1.filename);
    rewrite(f,1);
    i:=SockAvail(h);
    while i>=0 do begin
     if i>0 then begin
      if i>1024 then i:=1024;
      recv(h,p,i,0);
      blockwrite(f,p,i);
     end;
     i:=SockAvail(h);
    end;
    closefile(f);
    if not ftpclose(h) then raise exception.create(ftperror);
   finally
    ftpLogoff;
   end;
  end;
 finally
  screen.cursor:=crDefault;
 end;
end;

// UDP
{
function StartBroadCast(Port:word):integer;
function SendBroadCast(Server:integer; Port:word; s:string):integer;
function SendBroadCastTo(Server:integer; Port:word; ip,s:string):integer;
function ReadBroadCast(Server:integer; Port:word):string;
function ReadBroadCastEx(Server:integer; Port:word; var ip:string):string;
}
procedure TForm1.BroadcastClick(Sender: TObject);
var
 p:integer;
begin
 p:=StrToInt(Port.Text);
 if (Port.Tag<>p) then begin
  if Broadcast.Tag>0 then begin
   CloseSocket(Broadcast.Tag);
   Broadcast.Tag:=0;
  end;
  Port.Tag:=p;
 end;
 if Broadcast.Tag<=0 then Broadcast.Tag:=StartBroadcast(p);
 if Broadcast.Tag<0 then
  ShowMessage('can''t open socket :(')
 else
  SendBroadCast(Broadcast.Tag,StrToInt(edListen.Text),edBroadcast.Text);
end;

procedure TForm1.ActiveClick(Sender: TObject);
begin
 if Active.Checked then begin
  Active.Tag:=StrToInt(edListen.Text);
  UDPTimer.Tag:=StartBroadcast(Active.Tag);
  if UDPTimer.Tag<0 then begin
   ShowMessage('Can''t open socket :(');
   Active.Checked:=False;
  end else begin
   UDPTimer.Enabled:=True;
   edListen.Enabled:=False;
  end;
 end else begin
  UDPTimer.Enabled:=False;
  CloseSocket(UDPTimer.Tag);
  edListen.Enabled:=True;
 end;
end;

procedure TForm1.UDPTimerTimer(Sender: TObject);
begin
 if SockAvail(UDPTimer.Tag)>0 then begin
  Listen.Caption:=ReadBroadcast(UDPTimer.Tag,Active.Tag);
 end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Broadcast.Tag>0 then CloseSocket(Broadcast.Tag);
end;

// POP3

procedure TForm1.ReadMailClick(Sender: TObject);
var
 i:integer;
begin
 Screen.Cursor:=crHourglass;
 try
  if OpenMailBox(popHost.Text,popUser.Text,popPAss.Text)<0 then raise Exception.Create(MailError);
  i:=MailCount; lbMailCount.Caption:=IntToStr(i)+' mail(s)';
  if i>0 then begin
   mmMail.Text:=GetMail(1); // 1..MailCount
  end;
  CloseMailBox;
 finally
  Screen.Cursor:=crDefault;
 end;
end;

end.
