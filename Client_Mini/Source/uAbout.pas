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
    Image1: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Bevel1: TBevel;
    Panel11: TPanel;
    Image3: TImage;
    lbFormCaption: TLabel;
    Bevel2: TBevel;
    Label19: TLabel;
    sbClose: TSpeedButton;
    Image2: TImage;
    Label1: TLabel;
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
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

procedure Tfoabout.SpeedButton3Click(Sender: TObject);
begin
  close;
end;

procedure Tfoabout.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image3.OnMouseMove:=Image3MouseMove;
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
  ShellExecute (0,'open', pchar('http://sapr.tstu.ru'), pchar(''),nil, SW_show);
end;

procedure Tfoabout.FormCreate(Sender: TObject);
var i:integer;
begin

  Label2.Caption:='ver. '+version;
  self.AlphaBlend:=true;

end;

procedure Tfoabout.sbCloseClick(Sender: TObject);
begin
  close;
end;

procedure Tfoabout.FormShow(Sender: TObject);
var i:integer;
begin


end;

end.
