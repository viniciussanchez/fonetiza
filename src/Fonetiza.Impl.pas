unit Fonetiza.Impl;

interface

uses Fonetiza.Intf;

type
  TFonetiza = class(TInterfacedObject, IFonetiza)
  private
    function RemoverCaracteresEspeciais(const AValue: string): string;
    function RemoverConteudos(const AValue: string; const AConteudo: TArray<string>): string;
    function RemoverAcentuacoes(const AValue: string): string;
    { IFonetiza }
    function Fonetizar(const AValue: string): string;
    function GerarCodigoFonetico(const AValue: string): string;
    function GerarListaCodigosFoneticos(const AValue: string): TArray<string>;
  end;

implementation

{ TFonetiza }

uses System.SysUtils, System.StrUtils, Fonetiza.Consts;

function TFonetiza.Fonetizar(const AValue: string): string;
begin
  Result := AValue.ToUpper;
  Result := Self.RemoverAcentuacoes(Result);
  Result := Self.RemoverCaracteresEspeciais(Result);
  Result := Self.RemoverConteudos(Result, PREPOSICOES);
  Result := Self.RemoverConteudos(Result, TITULOS);
//  Result := StringReplacer.replaceStrings(Result, LETRAS);
//  Result := StringReplacer.replaceStrings(Result, numberReplacements);
//  Result := NumberReplacer.replaceNumbers(Result);
//  Result := PhonetizerBR.phonetize(Result);
//  Result := StringReplacer.replaceStrings(Result, nameReplacements);
//  Result := StringReplacer.replaceStrings(Result, synonimReplacements);
end;

function TFonetiza.GerarCodigoFonetico(const AValue: string): string;
begin
  Result := Self.Fonetizar(AValue);
//  Result := CodeGenerator.randomize(Result);
end;

function TFonetiza.GerarListaCodigosFoneticos(const AValue: string): TArray<string>;
var
  LConteudoFonetico: string;
begin
  LConteudoFonetico := Self.Fonetizar(AValue);
//  Result := MultipleCodeGenerator.generateCodes(LConteudoFonetico);
end;

function TFonetiza.RemoverAcentuacoes(const AValue: string): string;
type
  USAscii20127 = type AnsiString(20127);
begin
  Result := string(USAscii20127(AValue));
end;

function TFonetiza.RemoverCaracteresEspeciais(const AValue: string): string;
var
  LCaracter: Char;
begin
  for LCaracter in AValue do
    if CharInSet(LCaracter, ['A' .. 'Z', '0' .. '9']) or (LCaracter = ' ') then
      Result := Result + LCaracter;
end;

function TFonetiza.RemoverConteudos(const AValue: string; const AConteudo: TArray<string>): string;
var
  LPalavra: string;
  LPalavras: TArray<string>;
begin
  LPalavras := AValue.Trim.Split([' ']);
  for LPalavra in LPalavras do
  begin
    if not MatchStr(LPalavra, AConteudo) then
    begin
      if not Result.Trim.IsEmpty then
        Result := Result + ' ';
      Result := Result + LPalavra;
    end;
  end;
end;

end.
