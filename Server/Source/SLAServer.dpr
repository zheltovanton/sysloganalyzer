program SLAServer;

uses
  Forms,
  windows,
  sysutils,
  dialogs,
  Main in 'Main.pas' {foMain},
  uAbout in 'uAbout.pas' {foabout};

{$R *.res}

//----------------------------------------------------------------------------------------------------------------------

var
 hwndPrev: integer;

//----------------------------------------------------------------------------------------------------------------------


begin
  Application.Initialize;
  //���� ��� ���� ����� ����� ����������, �� �������
  Application.Title := 'SLA.Server';
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.

//----------------------------------------------------------------------------------------------------------------------


