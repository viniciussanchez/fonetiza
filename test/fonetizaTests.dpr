program fonetizaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Fonetiza.Utils.Test in 'src\Fonetiza.Utils.Test.pas',
  Fonetiza.Utils in '..\src\Fonetiza.Utils.pas',
  Fonetiza.Core in '..\src\Fonetiza.Core.pas',
  Fonetiza.Core.Test in 'src\Fonetiza.Core.Test.pas',
  Fonetiza in '..\src\Fonetiza.pas',
  Fonetiza.Test in 'src\Fonetiza.Test.pas',
  Fonetiza.Intf in '..\src\Fonetiza.Intf.pas',
  Fonetiza.CodigoFonetico.Core in '..\src\Fonetiza.CodigoFonetico.Core.pas',
  Fonetiza.Consts in '..\src\Fonetiza.Consts.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

