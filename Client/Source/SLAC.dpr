program SLAC;

uses
  Forms,
  windows,
  sysutils,
  dialogs,
  Main in 'Main.pas' {foMain},
  uWait in 'uWait.pas' {foWait},
  uAbout in 'uAbout.pas' {foabout};

{$R *.res}

//----------------------------------------------------------------------------------------------------------------------

var
 hwndPrev: integer;

//----------------------------------------------------------------------------------------------------------------------


begin
  Application.Initialize;
  //���� ��� ���� ����� ����� ����������, �� �������
  Application.Title := 'SLA.Client';
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.

//----------------------------------------------------------------------------------------------------------------------


