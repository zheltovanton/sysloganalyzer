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
  //≈сли уже есть копи€ этого приложени€, то выходим
  Application.Title := 'SLA.Client';
  Application.CreateForm(TfoMain, foMain);
  Application.Run;
end.

//----------------------------------------------------------------------------------------------------------------------


