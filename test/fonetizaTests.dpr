program fonetizaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Fonetiza.Impl.Test in 'src\Fonetiza.Impl.Test.pas',
  Fonetiza.Consts in '..\src\Fonetiza.Consts.pas',
  Fonetiza.Impl in '..\src\Fonetiza.Impl.pas',
  Fonetiza.Intf in '..\src\Fonetiza.Intf.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

