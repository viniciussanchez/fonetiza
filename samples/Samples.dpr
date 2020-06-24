program Samples;

uses
  Vcl.Forms,
  Fonetiza.Utils in '..\src\Fonetiza.Utils.pas',
  Fonetiza.Intf in '..\src\Fonetiza.Intf.pas',
  Fonetiza.Consts in '..\src\Fonetiza.Consts.pas',
  Fonetiza.Samples.Main in 'src\Fonetiza.Samples.Main.pas' {FrmMain},
  Fonetiza in '..\src\Fonetiza.pas',
  Fonetiza.Core in '..\src\Fonetiza.Core.pas',
  Fonetiza.CodigoFonetico.Core in '..\src\Fonetiza.CodigoFonetico.Core.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
