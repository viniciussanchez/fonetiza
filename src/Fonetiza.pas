unit Fonetiza;

interface

uses Fonetiza.Intf, Fonetiza.Core, Fonetiza.Utils, Fonetiza.CodigoFonetico.Core;

type
  TFonetiza = class(TInterfacedObject, IFonetiza)
  private
    FFonetizaCore: TFonetizaCore;
    FCodigoFonetico: TCodigoFoneticoCore;
    FFonetizaUtils: TFonetizaUtils;
    { IFonetiza }
    function Fonetizar(const AValue: string): string;
    function GerarCodigoFonetico(const AValue: string): string;
    function GerarListaCodigosFoneticos(const AValue: string): TArray<string>;
  public
    constructor Create;
    class function New: IFonetiza;
    destructor Destroy; override;
  end;

implementation

{ TFonetiza }

uses System.SysUtils, Fonetiza.Consts;

constructor TFonetiza.Create;
begin
  FFonetizaCore := TFonetizaCore.Create;
  FCodigoFonetico := TCodigoFoneticoCore.Create;
  FFonetizaUtils := TFonetizaUtils.Create;
end;

destructor TFonetiza.Destroy;
begin
  if Assigned(FFonetizaCore) then
    FFonetizaCore.Free;
  if Assigned(FCodigoFonetico) then
    FCodigoFonetico.Free;
  if Assigned(FFonetizaUtils) then
    FFonetizaUtils.Free;
  inherited;
end;

function TFonetiza.Fonetizar(const AValue: string): string;
begin
  Result := AValue.Trim.ToUpper;
  Result := FFonetizaUtils.RemoverAcentuacoes(Result);
  Result := FFonetizaUtils.RemoverCaracteresEspeciais(Result);
  Result := FFonetizaUtils.RemoverConteudos(Result, PREPOSICOES);
  Result := FFonetizaUtils.RemoverConteudos(Result, TITULOS);
  Result := FFonetizaUtils.SubstituirConteudos(Result, LETRAS);
  Result := FFonetizaUtils.SubstituirConteudos(Result, NUMEROS);
  Result := FFonetizaUtils.SomarCaracteres(Result);
  Result := FFonetizaUtils.RemoverCaracteresDuplicados(Result);
  Result := FFonetizaCore.GerarConteudoFonetico(Result);
  Result := FFonetizaUtils.RemoverCaracteresDuplicados(Result);
  Result := FFonetizaUtils.SubstituirConteudos(Result, NOMES);
  Result := FFonetizaUtils.SubstituirConteudos(Result, SINONIMOS);
end;

function TFonetiza.GerarCodigoFonetico(const AValue: string): string;
begin
  Result := Self.Fonetizar(AValue);
  Result := FCodigoFonetico.randomize(Result);
end;

function TFonetiza.GerarListaCodigosFoneticos(const AValue: string): TArray<string>;
var
  LConteudoFonetico: string;
begin
  LConteudoFonetico := Self.Fonetizar(AValue);
  Result := FCodigoFonetico.generateCodes(LConteudoFonetico);
end;

class function TFonetiza.New: IFonetiza;
begin
  Result := Self.Create;
end;

end.
