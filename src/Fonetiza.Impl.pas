unit Fonetiza.Impl;

interface

uses Fonetiza.Intf;

type
  TFonetiza = class(TInterfacedObject, IFonetiza)
  private
    function SomarCaracteres(const AValue: string): string;
    function SubstituirConteudos(const AValue: string; const AConteudo: TArray<TArray<string>>): string;
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
  Result := AValue.Trim.ToUpper;
  Result := Self.RemoverAcentuacoes(Result);
  Result := Self.RemoverCaracteresEspeciais(Result);
  Result := Self.RemoverConteudos(Result, PREPOSICOES);
  Result := Self.RemoverConteudos(Result, TITULOS);
  Result := Self.SubstituirConteudos(Result, LETRAS);
  Result := Self.SubstituirConteudos(Result, NUMEROS);
  Result := Self.SomarCaracteres(Result);
//  Result := PhonetizerBR.phonetize(Result);
  Result := Self.SubstituirConteudos(Result, NOMES);
  Result := Self.SubstituirConteudos(Result, SINONIMOS);
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
  LPalavras := AValue.Split([' ']);
  for LPalavra in LPalavras do
  begin
    if MatchStr(LPalavra, AConteudo) then
      Continue;
    if not Result.Trim.IsEmpty then
      Result := Result + ' ';
    Result := Result + LPalavra;
  end;
end;

function TFonetiza.SomarCaracteres(const AValue: string): string;
var
  LPalavra: string;
  LPalavras: TArray<string>;
  LSoma, LValor: Integer;
begin
  LSoma := 0;
	LPalavras := AValue.Split([' ']);
  for LPalavra in LPalavras do
  begin
    if LPalavra.Trim.Equals('E') then
      Continue;
    if LPalavra.Trim.Equals('MIL') then
    begin
      if LSoma = 0 then
        LSoma := 1000
      else
      begin
        LSoma := LSoma * 1000;
        Continue;
      end;
    end
    else
    begin
      LValor := StrToIntDef(LPalavra, 0);
      if LValor <> 0 then
      begin
        LSoma := LSoma + LValor;
        Continue;
      end
      else
      begin
        if LSoma <> 0 then
          Result := Result + LSoma.ToString;
        LSoma = 0;
        Continue;
      end;
    end;
    Result := Result + LPalavra;
  end;
	if LSoma <> 0 then
  	Result := Result + LSoma.ToString;
end;

function TFonetiza.SubstituirConteudos(const AValue: string; const AConteudo: TArray<TArray<string>>): string;
var
  LPalavra, LResultado: string;
  LConteudo, LPalavras: TArray<string>;
begin
  LPalavras := AValue.Split([' ']);
  for LPalavra in LPalavras do
  begin
    LResultado := LPalavra;
    for LConteudo in AConteudo do
    begin
      if LConteudo[0].Equals(LPalavra) then
      begin
        LResultado := LConteudo[1];
        Break;
      end;
    end;
    if not Result.Trim.IsEmpty then
      Result := Result + ' ';
    Result := Result + LResultado;
  end;
end;

end.
