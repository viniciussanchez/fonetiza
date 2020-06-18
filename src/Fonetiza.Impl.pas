unit Fonetiza.Impl;

interface

uses Fonetiza.Intf;

type
  TFonetiza = class(TInterfacedObject, IFonetiza)
  private
    function GerarConteudoFonetico(const AValue: string): string;
    function SomarCaracteres(const AValue: string): string;
    function SubstituirConteudos(const AValue: string; const AConteudo: TArray<TArray<string>>): string;
    function RemoverCaracteresDuplicados(const AValue: string): string;
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
  Result := Self.RemoverCaracteresDuplicados(Result);
//  Result := Self.GerarConteudoFonetico(Result);
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

function TFonetiza.RemoverCaracteresDuplicados(const AValue: string): string;
var
  I: Integer;
  LChar: Char;
begin
  LChar := ' ';
  for I := 0 to Pred(AValue.Length) do
  begin
    if ((AValue[i] <> LChar) or (AValue[I] = ' ') or ((AValue[i] >= '0') and (AValue[I] <= '9')) or ((AValue[I] = 'S') and (AValue[I - 1] = 'S') and ((I > 1) and (AValue[I - 2] <> 'S')))) then
      Result := Result + AValue[I];
    LChar := AValue[I];
  end;
  Result := Result.Trim;
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
  LSoma, LValor: Integer;
  LPalavras: TArray<string>;
  I: Integer;
begin
  LPalavras := AValue.Split([' ']);
  for I := 0 to Pred(Length(LPalavras)) do
  begin
    if LPalavras[I].Equals('E') then
      Continue;
    if LPalavras[I].Equals('MIL') then
    begin
      if LSoma <> 0 then
      begin
        LSoma := LSoma * 1000;
        Continue;
      end;
      LSoma := 1000;
      Result := Result + LPalavras[I];
      Continue;
    end;
    LValor := StrToIntDef(LPalavras[I], 0);
    if LValor <> 0 then
    begin
      if LSoma = 0 then
        Result := Result + LPalavras[I];
      LSoma := LSoma + LValor;
      Continue;
    end;
    if LSoma <> 0 then
      Result := Result + LSoma.ToString;
    LSoma := 0;
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

function TFonetiza.GerarConteudoFonetico(const AValue: string): string;
begin

end;

end.
