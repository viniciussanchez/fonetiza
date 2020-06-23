program fonetizaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Fonetiza.Utils.Test in 'src\Fonetiza.Utils.Test.pas',
  Fonetiza.Utils in '..\src\Fonetiza.Utils.pas',
  Fonetiza.Core in '..\src\Fonetiza.Core.pas',
  Fonetiza.Core.Test in 'src\Fonetiza.Core.Test.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

