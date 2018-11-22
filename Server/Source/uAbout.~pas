unit uAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, shellapi, jpeg,
  Buttons;

type
  Tfoabout = class(TForm)
    CPanel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Bevel1: TBevel;
    Panel11: TPanel;
    Image3: TImage;
    lbFormCaption: TLabel;
    Bevel2: TBevel;
    sbClose: TSpeedButton;
    Image2: TImage;
    Label1: TLabel;
    Label18: TLabel;
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
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
    procedure Label19Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foabout: Tfoabout;

implementation

uses Main;

{$R *.dfm}

procedure Tfoabout.Label3MouseEnter(Sender: TObject);
begin
  (sender as tlabel).Font.Style:=[fsunderline];
end;

procedure Tfoabout.Label3MouseLeave(Sender: TObject);
begin
  (sender as tlabel).Font.Style:=[];

end;

procedure Tfoabout.Label3Click(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('http://www.miridixsoft.com/'), pchar(''),nil, SW_show);
end;

procedure Tfoabout.Label4Click(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('http://www.miridixsoft.com/files/slas_setup.exe'), pchar(''),nil, SW_show);
end;

procedure Tfoabout.Label5Click(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('mailto:developer@miridix.com?subject=SLA&body=Hello'), pchar(''),nil, SW_show);

end;

procedure Tfoabout.Label6Click(Sender: TObject);
begin
  ShellExecute(0, nil,'mailto:support@miridix.com?subject=BugReport(SLA)',nil,nil,1);

end;

procedure Tfoabout.Label16Click(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('http://www.miridixsoft.com/page-3.htm'), pchar(''),nil, SW_show);

end;

procedure Tfoabout.Label14Click(Sender: TObject);
begin
  ShellExecute (0,'open', pchar('mailto:sales@miridix.com?subject=SLA_buy'), pchar(''),nil, SW_show);
end;

procedure Tfoabout.SpeedButton3Click(Sender: TObject);
begin
  close;
end;

procedure Tfoabout.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.OnMouseMove:=Image3MouseMove;
  self.AlphaBlendValue:=trunc(255/100*50);
  _x:=x;
  _y:=y;
end;

procedure Tfoabout.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    left:=x-_x+left;
    top:=y-_y+top;
end;

procedure Tfoabout.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.OnMouseMove:=nil;
  self.AlphaBlendValue:=255;

end;

procedure Tfoabout.lbFormCaptionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lbFormCaption.OnMouseMove:=lbFormCaptionMouseMove;
  self.AlphaBlendValue:=trunc(255/100*50);
  _x:=x;
  _y:=y;
end;

procedure Tfoabout.lbFormCaptionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    left:=x-_x+left;
    top:=y-_y+top;
end;

procedure Tfoabout.lbFormCaptionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   lbFormCaption.OnMouseMove:=nil;
  self.AlphaBlendValue:=255;
end;

procedure Tfoabout.Label19Click(Sender: TObject);
begin
//  ShellExecute (0,'open', pchar(apl_path + '\help.pdf'), pchar(''),nil, SW_show);
end;

procedure Tfoabout.FormCreate(Sender: TObject);
begin

  Label2.Caption:='ver. '+version;
  self.AlphaBlend:=true;

end;

procedure Tfoabout.sbCloseClick(Sender: TObject);
begin
  close;
end;

end.
