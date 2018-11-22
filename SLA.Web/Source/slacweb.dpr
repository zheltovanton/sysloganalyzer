{ Compile this DLL and place it into your web server
  scripts directory.  You can then access this application
  from a web browser using http://<your web server>/scripts/iserver.dll
}
library slacweb;

{%TogetherDiagram 'ModelSupport_slacweb\default.txaPackage'}

uses
  WebBroker,
  HTTPApp,
  ISAPIApp,
  main in 'main.pas' {InfoModule: TDataModule};

{$R *.RES}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  Application.Initialize;
  Application.CreateForm(TInfoModule, InfoModule);
  Application.Run;
end.
