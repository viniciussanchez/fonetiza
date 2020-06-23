unit Fonetiza.Utils;

interface

type
  TFonetizaUtils = class
  public
    function SomarCaracteres(const AValue: string): string;
    function SubstituirConteudos(const AValue: string; const AConteudo: TArray<TArray<string>>): string;
    function RemoverCaracteresDuplicados(const AValue: string): string;
    function RemoverCaracteresEspeciais(const AValue: string): string;
    function RemoverConteudos(const AValue: string; const AConteudo: TArray<string>): string;
    function RemoverAcentuacoes(const AValue: string): string;
  end;

implementation

{ TFonetizaUtils }

uses System.StrUtils, System.SysUtils, System.Generics.Collections;

function TFonetizaUtils.RemoverAcentuacoes(const AValue: string): string;
type
  USAscii20127 = type AnsiString(20127);
begin
  Result := string(USAscii20127(AValue));
end;

function TFonetizaUtils.RemoverCaracteresDuplicados(const AValue: string): string;
var
  I: Integer;
  LChar: Char;
begin
  LChar := ' ';
  for I := 1 to AValue.Length do
  begin
    if ((AValue[I] <> LChar) or (AValue[I] = ' ') or ((AValue[I] >= '0') and (AValue[I] <= '9')) or ((AValue[I] = 'S') and (AValue[I - 1] = 'S') and ((I > 1) and (AValue[I - 2] <> 'S')))) then
      Result := Result + AValue[I];
    LChar := AValue[I];
  end;
  Result := Result.Trim;
end;

function TFonetizaUtils.RemoverCaracteresEspeciais(const AValue: string): string;
var
  LCaracter: Char;
begin
  for LCaracter in AValue do
    if CharInSet(LCaracter, ['A' .. 'Z', '0' .. '9']) or (LCaracter = ' ') or (LCaracter = '_') or (LCaracter = '&') then
      Result := Result + LCaracter;
end;

function TFonetizaUtils.RemoverConteudos(const AValue: string; const AConteudo: TArray<string>): string;
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

function TFonetizaUtils.SomarCaracteres(const AValue: string): string;
var
  LSoma, LValor: Integer;
  LPalavras: TList<string>;
  LPalavra: string;
  I: Integer;
begin
  I := 0;
  LSoma := 0;
  LPalavras := TList<string>.Create();
  try
    LPalavras.AddRange(AValue.Split([' ']));
    while I < LPalavras.Count do
    begin
      LPalavra := LPalavras.Items[I];
			if LPalavra.Equals('E') then
      begin
				LPalavras.Delete(I);
				Dec(I);
			end
      else
      begin
				if LPalavra.Equals('MIL') then
        begin
					if LSoma = 0 then
						LSoma := 1000
					else
          begin
						LSoma := LSoma * 1000;
						LPalavras.Delete(I);
						Dec(I);
					end;
				end
        else
        begin
					LValor := StrToIntDef(LPalavra, 0);
					if LValor <> 0 then
          begin
						if LSoma <> 0 then
            begin
							LPalavras.Delete(I - 1);
							Dec(I);
						end;
						LSoma := LSoma + LValor;
					end
					else
          begin
						if LSoma <> 0 then
							LPalavras.Items[I - 1] := LSoma.ToString;
						LSoma := 0;
					end;
        end;
      end;
      Inc(I);
    end;
		if LSoma <> 0 then
			LPalavras.Items[Pred(LPalavras.Count)] := LSoma.ToString;
    for LPalavra in LPalavras do
    begin
      if not Result.IsEmpty then
        Result := Result + ' ';
      Result := Result + LPalavra;
    end;
  finally
    LPalavras.Free;
  end;
end;

function TFonetizaUtils.SubstituirConteudos(const AValue: string; const AConteudo: TArray<TArray<string>>): string;
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
