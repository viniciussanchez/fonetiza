program fonetiza;

uses
  Vcl.Forms,
  Fonetiza.Impl in '..\src\Fonetiza.Impl.pas',
  Fonetiza.Intf in '..\src\Fonetiza.Intf.pas',
  Fonetiza.Consts in '..\src\Fonetiza.Consts.pas',
  Fonetiza.Samples.Main in 'src\Fonetiza.Samples.Main.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
