unit uWait;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, Buttons, Animate, GIFCtrl;

type
  TfoWait = class(TForm)
    RxGIFAnimator1: TRxGIFAnimator;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foWait: TfoWait;

implementation

uses Main;


{$R *.DFM}

procedure TfoWait.FormCreate(Sender: TObject);
begin
 height:=RxGIFAnimator1.Height;
 width:=RxGIFAnimator1.width;

end;

procedure TfoWait.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    begin

    end;
end;

end.
