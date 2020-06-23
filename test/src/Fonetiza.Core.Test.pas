unit Fonetiza.Core.Test;

interface

uses TestFramework, System.SysUtils, Fonetiza.Core;

type
  TTestFonetizaCore = class(TTestCase)
  strict private
    FFonetizaCore: TFonetizaCore;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGerarConteudoFonetico;
  end;

implementation

procedure TTestFonetizaCore.SetUp;
begin
  FFonetizaCore := TFonetizaCore.Create;
end;

procedure TTestFonetizaCore.TearDown;
begin
  FFonetizaCore.Free;
  FFonetizaCore := nil;
end;

procedure TTestFonetizaCore.TestGerarConteudoFonetico;
begin
  CheckEquals('GIUZI', FFonetizaCore.GerarConteudoFonetico('JOSE'));
  CheckEquals('KARLU', FFonetizaCore.GerarConteudoFonetico('CARLOS'));
end;

initialization
  RegisterTest(TTestFonetizaCore.Suite);

end.
