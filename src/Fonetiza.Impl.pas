unit Fonetiza.Impl;

interface

uses Fonetiza.Intf, System.SysUtils;

type
  TFonetiza = class(TInterfacedObject, IFonetiza)
  private
    procedure TratarCaracterFonetico(var fonaux, APalavraFonetica: TCharArray; var I, J, newmud: Integer; var ACopiarFonema, ACaracterMudo: Boolean);
  public
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

uses System.StrUtils, Fonetiza.Consts, System.Generics.Collections;

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
  Result := Self.GerarConteudoFonetico(Result);
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
  for I := 1 to AValue.Length do
  begin
    if ((AValue[I] <> LChar) or (AValue[I] = ' ') or ((AValue[I] >= '0') and (AValue[I] <= '9')) or ((AValue[I] = 'S') and (AValue[I - 1] = 'S') and ((I > 1) and (AValue[I - 2] <> 'S')))) then
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
    if CharInSet(LCaracter, ['A' .. 'Z', '0' .. '9']) or (LCaracter = ' ') or (LCaracter = '_') or (LCaracter = '&') then
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

procedure TFonetiza.TratarCaracterFonetico(var fonaux, APalavraFonetica: TCharArray; var I, J, newmud: Integer; var ACopiarFonema, ACaracterMudo: Boolean);
var
  X: Integer;
begin
  case fonaux[I] of
    'a':
      begin
        // se a palavra termina com As, AZ, AM, ou AN, elimina a consoante do final da palavra
        if ((fonaux[I + 1] = 's') or (fonaux[I + 1] = 'Z') or (fonaux[I + 1] = 'M') or (fonaux[I + 1] = 'N')) then
        begin
          if fonaux[I + 2] <> ' ' then
            ACopiarFonema := True
          else
          begin
            APalavraFonetica[J] := 'a';
            APalavraFonetica[J + 1] := ' ';
            Inc(J);
            Inc(I);
          end;
        end
        else
          ACopiarFonema := True;
      end;
    'B':
      begin
        // B nao eh modificado
        ACaracterMudo := True;
      end;
    'C':
      begin
        X := 0;

        // ci vira si
        if fonaux[I + 1] = 'i' then
        begin
          APalavraFonetica[J] := 's';
          Inc(J);
          Exit;
        end;

        // coes final vira cao
        if ((fonaux[I + 1] = 'o') and (fonaux[I + 2] = 'i') and (fonaux[I + 3] = 's') and (fonaux[I + 4] = ' ')) then
        begin
          APalavraFonetica[J] := 'K';
          APalavraFonetica[J + 1] := 'a';
          APalavraFonetica[J + 2] := 'o';
          I := I + 4;
          Exit;
        end;

        // ct vira t
        if fonaux[I + 1] = 'T' then
          Exit;

        // c vira k
        if fonaux[I + 1] <> 'H' then
        begin
          APalavraFonetica[J] := 'K';
          newmud := 1;

          // ck vira k
          if fonaux[I + 1] = 'K' then
          begin
            Inc(I);
            Exit;
          end
          else
            Exit;
        end;

        // ch vira k para chi final, chi vogal, chini final e chiti final, chi final ou chi vogal
        if fonaux[I + 1] = 'H' then
        begin
          if fonaux[I + 2] = 'i' then
          begin
            if ((fonaux[I + 3] = 'a') or (fonaux[I + 3] = 'i') or (fonaux[I + 3] = 'o')) then
              X := 1
            else if fonaux[I + 3] = 'N' then
            begin
              if fonaux[I + 4] = 'i' then
              begin
                if fonaux[I + 5] = ' ' then
                  X := 1;
              end;
            end
            // chiti final
            else if fonaux[I + 3] = 'T' then
            begin
              if fonaux[I + 4] = 'i' then
              begin
                if fonaux[I + 5] = ' ' then
                  X := 1;
              end;
            end;
          end;
        end;

        if X = 1 then
        begin
          APalavraFonetica[J] := 'K';
          Inc(J);
          Inc(I);
          Exit;
        end;

        // chi, nao chi final, chi vogal, chini final ou chiti final ch nao seguido de i se anterior nao e s, ch = x
        if J > 0 then
        begin
          if APalavraFonetica[J - 1] = 's' then
            Dec(J);
        end;

        APalavraFonetica[J] := 'X';
        newmud := 1;
        Inc(I);
      end;
    'D':
      begin
        X := 0;

        // procura por dor
        if fonaux[I + 1] <> 'o' then
        begin
          ACaracterMudo := True;
          Exit;
        end
        else if fonaux[I + 2] = 'R' then
        begin
          if I <> 0 then
            X := 1 // dor nao inicial
          else
            ACopiarFonema := True; // dor inicial
        end
        else
          ACopiarFonema := True; // nao e dor

        if X = 1 then
        begin
          if fonaux[I + 3] = 'i' then
          begin
            if fonaux[I + 4] = 's' then
            begin
              if fonaux[I + 5] <> ' ' then
                X := 0; // nao e dores
            end
            else
              X := 0;
          end
          else if fonaux[I + 3] = 'a' then
          begin
            if fonaux[I + 4] <> ' ' then
            begin
              if fonaux[I + 4] <> 's' then
                X := 0
              else if fonaux[I + 5] <> ' ' then
                X := 0;
            end;
          end
          else
            x := 0;
        end
        else
          X := 0;

        if X = 1 then
        begin
          APalavraFonetica[J] := 'D';
          APalavraFonetica[J + 1] := 'o';
          APalavraFonetica[J + 2] := 'R';
          I := I + 5;
        end
        else
          ACopiarFonema := True;
      end;
    'F':
      begin
        // F nao eh modificado
        ACaracterMudo := True;
      end;
    'G':
      begin
        // gui -> gi
        if fonaux[I + 1] = 'o' then
        begin
          if fonaux[I + 2] = 'i' then
          begin
            APalavraFonetica[J] := 'G';
            APalavraFonetica[J + 1] := 'i';
            J := J + 2;
            I := I + 2;
          end
          else
            ACaracterMudo := True;
        end
        else
        if fonaux[I + 1] = 'L' then // gl
        begin
          if fonaux[I + 2] = 'i' then
          begin
            if ((fonaux[I + 3] = 'a') or (fonaux[I + 3] = 'i') or (fonaux[I + 3] = 'o')) then
            begin
              APalavraFonetica[J] := fonaux[I + 1];
              APalavraFonetica[J + 1] := fonaux[I + 2];
              J := J + 2;
              I := I + 2;
            end
            else if fonaux[I + 3] = 'N' then // glin -> lin
            begin
              APalavraFonetica[J] := fonaux[I + 1];
              APalavraFonetica[J + 1] := fonaux[I + 2];
              J := J + 2;
              I := I + 2;
            end
            else
              ACaracterMudo := True;
          end
          else
            ACaracterMudo := True;
        end
        else if fonaux[I + 1] = 'N' then // gn + vogal -> ni + vogal
        begin
          if ((fonaux[I + 2] <> 'a') and (fonaux[I + 2] <> 'i') and (fonaux[I + 2] <> 'o')) then
            ACaracterMudo := True
          else
          begin
            APalavraFonetica[J] := 'N';
            APalavraFonetica[J + 1] := 'i';
            J := J + 2;
            Inc(I);
          end;
        end
        else if fonaux[I + 1] = 'H' then // ghi -> gi
        begin
          if fonaux[I + 2] = 'i' then
          begin
            APalavraFonetica[J] := 'G';
            APalavraFonetica[J + 1] := 'i';
            J := J + 2;
            I := I + 2;
          end
          else
            ACaracterMudo := True;
        end
        else
          ACaracterMudo := True;
      end;
    'H':
      begin
        // H eh desconsiderado
        Exit;
      end;
    'i':
      begin
        if fonaux[I + 2] = ' ' then
        begin
          if fonaux[I + 1] = 's' then
          begin
            APalavraFonetica[J] := 'i';
            Exit;
          end
          else if fonaux[I + 1] = 'Z' then
          begin
            APalavraFonetica[J] := 'i';
            Exit;
          end;
        end;

        // ix
        if fonaux[I + 1] <> 'X' then
          ACopiarFonema := True
        else if I <> 0 then
          ACopiarFonema := True
        else if ((fonaux[I + 2] = 'a') or (fonaux[I + 2] = 'i') or (fonaux[I + 2] = 'o')) then
        begin
          // ix vogal no inicio torna-se iz
          APalavraFonetica[J] := 'i';
          APalavraFonetica[J + 1] := 'Z';
          J := J + 2;
          Inc(I);
          Exit;
        end
        else if ((fonaux[I + 2] = 'C') or (fonaux[I + 2] = 's')) then
        begin
          // ix consoante no inicio torna-se is
          APalavraFonetica[J] := 'i';
          Inc(J);
          Inc(I);
          Exit;
        end
        else
        begin
          APalavraFonetica[J] := 'i';
          APalavraFonetica[J + 1] := 's';
          J := J + 2;
          Inc(I);
          Exit;
        end;
      end;
    'J':
      begin
        // J -> Gi
        APalavraFonetica[J] := 'G';
        APalavraFonetica[J + 1] := 'i';
        J := J + 2;
      end;
    'K':
      begin
        // KT -> T
        if fonaux[I + 1] <> 'T' then
          ACaracterMudo := True;
      end;
    'L':
      begin
        // L + vogal nao eh modificado
        if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
          ACopiarFonema := True
        else if fonaux[I + 1] <> 'H' then // L + consoante -> U + consoante
        begin
          APalavraFonetica[J] := 'o';
          Inc(J);
          Exit;
        end
        // LH + consoante nao eh modificado
        else if ((fonaux[I + 2] <> 'a') and (fonaux[I + 2] <> 'i') and (fonaux[I + 2] <> 'o')) then
          ACopiarFonema := True
        else
        begin
          // LH + vogal -> LI + vogal
          APalavraFonetica[J] := 'L';
          APalavraFonetica[J + 1] := 'i';
          J := J + 2;
          Inc(I);
          Exit;
        end;
      end;
    'M':
      begin
        // M + consoante -> N + consoante; M final -> N
        if (((fonaux[I + 1] <> 'a') and (fonaux[I + 1] <> 'i') and (fonaux[I + 1] <> 'o')) or (fonaux[I + 1] = ' ')) then
        begin
          APalavraFonetica[J] := 'N';
          Inc(J);
        end
        else
          ACopiarFonema := True;
      end;
    'N':
      begin
        // NGT -> NT
        if ((fonaux[I + 1] = 'G') and (fonaux[I + 2] = 'T')) then
        begin
          fonaux[I + 1] := 'N';
          ACopiarFonema := True;
        end
        else if fonaux[I + 1] = 'H' then // NH + consoante nao eh modificado
        begin
          if ((fonaux[I + 2] <> 'a') and (fonaux[I + 2] <> 'i') and (fonaux[I + 2] <> 'o')) then
            ACopiarFonema := True
          else
          begin
            APalavraFonetica[J] := 'N';
            APalavraFonetica[J + 1] := 'i';
            J := J + 2;
            Inc(I);
          end;
        end
        else
          ACopiarFonema := True;
      end;
    'o':
      begin
        // oS final -> o; oZ final -> o
        if ((fonaux[I + 1] = 's') or (fonaux[I + 1] = 'Z')) then
        begin
          if fonaux[I + 2] = ' ' then
          begin
            APalavraFonetica[J] := 'o';
            Exit;
          end
          else
            ACopiarFonema := True;
        end
        else
          ACopiarFonema := True;
      end;
    'P':
      begin
        // PH -> F
        if fonaux[I + 1] = 'H' then
        begin
          APalavraFonetica[J] := 'F';
          Inc(I);
          newmud := 1;
        end
        else
          ACaracterMudo := True;
      end;
    'Q':
      begin
        // Koi -> Ki (QUE, QUI -> KE, KI)
        if fonaux[I + 1] = 'o' then
        begin
          if fonaux[I + 2] = 'i' then
          begin
            APalavraFonetica[J] := 'K';
            Inc(J);
            Inc(I);
            Exit;
          end;
        end;
        // QoA -> KoA (QUA -> KUA)
        APalavraFonetica[J] := 'K';
        Inc(J);
      end;
    'R':
      begin
        // R nao eh modificado
        ACopiarFonema := True;
      end;
    's':
      begin
        // s final eh ignorado
        if fonaux[I + 1] = ' ' then
          Exit;

        // s inicial + vogal nao eh modificado
        if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
        begin
          if I = 0 then
          begin
            ACopiarFonema := True;
            Exit;
          end
          // s entre duas vogais -> z
          else if ((fonaux[I - 1] <> 'a') and (fonaux[I - 1] <> 'i') and (fonaux[I - 1] <> 'o')) then
          begin
            ACopiarFonema := True;
            Exit;
          end
          // SoL nao eh modificado
          else if ((fonaux[I + 1] = 'o') and (fonaux[I + 2] = 'L') and (fonaux[I + 3] = ' ')) then
          begin
            ACopiarFonema := True;
            Exit;
          end
          else
          begin
            APalavraFonetica[J] := 'Z';
            Inc(J);
            Exit;
          end;
        end;

        // ss -> s
        if fonaux[I + 1] = 's' then
        begin
          if fonaux[I + 2] <> ' ' then
          begin
            ACopiarFonema := True;
            Inc(I);
            Exit;
          end
          else
          begin
            fonaux[I + 1] := ' ';
            Exit;
          end;
        end;

        // s inicial seguido de consoante fica precedido de i, se nao for sci, sh ou sch nao seguido de vogal
        if i = 0 then
        begin
          if (not ((fonaux[I + 1] = 'C') and (fonaux[I + 2] = 'i'))) then
          begin
            if fonaux[I + 1] <> 'H' then
            begin
              if (not ((fonaux[I + 1] = 'C') and (fonaux[I + 2] = 'H') and ((fonaux[I + 3] <> 'a') and (fonaux[I + 3] <> 'i') and (fonaux[I + 3] <> 'o')))) then
              begin
                APalavraFonetica[J] := 'i';
                Inc(J);
                ACopiarFonema := True;
                Exit;
              end;
            end;
          end;
        end;

        // sH -> X;
        if fonaux[I + 1] = 'H' then
        begin
          APalavraFonetica[J] := 'X';
          Inc(I);
          newmud := 1;
          Exit;
        end;

        if fonaux[I + 1] <> 'C' then
        begin
          ACopiarFonema := True;
          Exit;
        end;

        // sCh nao seguido de i torna-se X
        if fonaux[I + 2] = 'H' then
        begin
          APalavraFonetica[J] := 'X';
          I := I + 2;
          newmud := 1;
          Exit;
        end;

        if fonaux[I + 2] <> 'i' then
        begin
          ACopiarFonema := True;
          Exit;
        end;

        // sCi final -> Xi
        if fonaux[I + 3] = ' ' then
        begin
          APalavraFonetica[J] := 'X';
          APalavraFonetica[J + 1] := 'i';
          I := I + 3;
          Exit;
        end;

        // sCi vogal -> X
        if ((fonaux[I + 3] = 'a') or (fonaux[I + 3] = 'i') or (fonaux[I + 3] = 'o')) then
        begin
          APalavraFonetica[J] := 'X';
          Inc(J);
          I := I + 2;
          Exit;
        end;

        // sCi consoante -> si
        APalavraFonetica[J] := 's';
        APalavraFonetica[J + 1] := 'i';
        J := J + 2;
        I := I + 2;
      end;
    'T':
      begin
        // TS -> S
        if (fonaux[I + 1] = 's') then
          Exit
        else if (fonaux[I + 1] = 'Z') then
          Exit
        else
          ACaracterMudo := True;
      end;
    'V', 'W':
      begin
        // V,W inicial + vogal -> o + vogal (U + vogal)
        if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
        begin
          if I = 0 then
          begin
            APalavraFonetica[J] := 'o';
            Inc(J);
          end
          else
          begin
            // V,W NAO inicial + vogal -> V + vogal
            APalavraFonetica[J] := 'V';
            newmud := 1;
          end;
        end
        else
        begin
          APalavraFonetica[J] := 'V';
          newmud := 1;
        end;
      end;
    'X':
      begin
        // caracter nao eh modificado
        ACaracterMudo := True;
      end;
    'Y':
      begin
        // Y jah foi tratado acima
        Exit;
      end;
    'Z':
      begin
        // Z final eh eliminado
        if fonaux[I + 1] = ' ' then
          Exit
        else if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
          ACopiarFonema := True
        else
        begin
          APalavraFonetica[J] := 's';
          Inc(J);
        end;
      end;
  else // se o caracter nao for um dos jah relacionados
    begin
      // o caracter nao eh modificado
      APalavraFonetica[J] := fonaux[I];
      Inc(J);
    end;
  end;
end;

function TFonetiza.GerarConteudoFonetico(const AValue: string): string;
var
  // vetores de caracteres utilizadas para manipular o texto
  LPalavraAtual: TCharArray;
  fonaux: TCharArray;
  LPalavraFonetica: TCharArray;
  fonfon: TCharArray;

  // indica se o fonema eh mudo
  newmud: Integer;

  LCaracter: Char;
  I, J, K, LIndice: Integer;
  LCaracterMudo, LCopiarFonema, LUltimoFonema: Boolean;
  LPalavras: TArray<string>;
  LPalavra: string;
begin
  // define o tamanho dos vetores
  SetLength(LPalavraAtual, 256);
  SetLength(fonaux, 256);
  SetLength(LPalavraFonetica, 256);
  SetLength(fonfon, 256);

  // o texto eh armazenado no vetor: cada palavra ocupa uma posicao do vetor
  LPalavras := AValue.Split([' ']);

  // percorre o vetor, palavra a palavra
  for LIndice := 0 to Pred(Length(LPalavras)) do
  begin
    J := 0;

    // branqueia os vetores
    for I := 0 to 255 do
    begin
      LPalavraFonetica[I] := ' ';
      fonfon[I] := ' ';
    end;

    // vetores recebem os caracteres da palavra atual
    LPalavraAtual := LPalavras[LIndice].ToCharArray;
    fonaux := LPalavraAtual;

    // se a palavra possuir apenas 1 caracter, nao altera a palavra
    if LPalavras[LIndice].Length = 1 then
    begin
      LPalavraFonetica[0] := LPalavraAtual[0];

      // se o caracter for "_", troca por espaco em branco
      if LPalavraAtual[0] = '_' then
        LPalavraFonetica[0] := ' '
      else if ((LPalavraAtual[0] = 'E') or (LPalavraAtual[0] = '&') or (LPalavraAtual[0] = 'I')) then // se for "E", "&" ou "I", troca por "i"
        LPalavraFonetica[0] := 'i';
    end
    else
    begin
      // caracter nao eh modificado
      for I := 0 to Pred(LPalavras[LIndice].Length) do
      begin
        if LPalavraAtual[I] = '_' then // _ -> Y
          fonfon[I] := 'Y'
        else if LPalavraAtual[i] = '&' then // & -> i
          fonfon[I] := 'i'
        else if ((LPalavraAtual[I] = 'E') or (LPalavraAtual[I] = 'Y') or (LPalavraAtual[I] = 'I')) then // E, Y, I -> i
          fonfon[I] := 'i'
        else if ((LPalavraAtual[I] = 'O') or (LPalavraAtual[I] = 'U')) then // O, U -> u
          fonfon[I] := 'o'
        else if LPalavraAtual[I] = 'A' then // A -> a
          fonfon[I] := 'a'
        else if LPalavraAtual[I] = 'S' then // S -> s
          fonfon[I] := 's'
        else
          fonfon[I] := LPalavraAtual[I];
      end;

      LUltimoFonema := False;
      fonaux := fonfon;

      // palavras formadas por apenas 3 consoantes sao dispensadas do processo de fonetizacao
      if fonaux[3] = ' ' then
      begin
        if ((fonaux[0] = 'a') or (fonaux[0] = 'i') or (fonaux[0] = 'o')) then
          LUltimoFonema := False
        else if ((fonaux[1] = 'a') or (fonaux[1] = 'i') or (fonaux[1] = 'o')) then
          LUltimoFonema := False
        else if ((fonaux[2] = 'a') or (fonaux[2] = 'i') or (fonaux[2] = 'o')) then
          LUltimoFonema := False
        else
        begin
          LUltimoFonema := True;
          LPalavraFonetica[0] := fonaux[0];
          LPalavraFonetica[1] := fonaux[1];
          LPalavraFonetica[2] := fonaux[2];
        end;
      end;

      // se a palavra nao for formada por apenas 3 consoantes...
      if not LUltimoFonema then
      begin
        // percorre a palavra corrente, letra a letra
        I := 0;
        while I < LPalavras[LIndice].Length do
        begin
          // zera variaveis de controle
          LCopiarFonema := False;
          LCaracterMudo := False;
          newmud := 0;

          TratarCaracterFonetico(fonaux, LPalavraFonetica, I, J, newmud, LCopiarFonema, LCaracterMudo);

          // copia caracter corrente
          if LCopiarFonema then
          begin
            LPalavraFonetica[J] := fonaux[I];
            Inc(J);
          end;

          // insercao de i apos consoante muda
          if LCaracterMudo then
            LPalavraFonetica[J] := fonaux[I];

          if (LCaracterMudo or (newmud = 1)) then
          begin
            Inc(J);
            K := 0;

            while K = 0 do
            begin
              // e final mudo
              if fonaux[I + 1] = ' ' then
              begin
                LPalavraFonetica[J] := 'i';
                K := 1;
              end
              else if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
                K := 1
              else if LPalavraFonetica[J - 1] = 'X' then
              begin
                LPalavraFonetica[J] := 'i';
                Inc(J);
                K := 1;
              end
              else if fonaux[I + 1] = 'R' then
                K := 1
              else if fonaux[I + 1] = 'L' then
                K := 1
              else if fonaux[I + 1] <> 'H' then
              begin
                LPalavraFonetica[J] := 'i';
                Inc(J);
                K := 1;
              end
              else
                Inc(I);
            end;
          end;

          // incrementa o contador para ir para o próximo caracter
          Inc(I);
        end;
      end;
    end;

    for i := 0 to Pred(LPalavras[LIndice].Length) + 3 do
    begin
      if LPalavraFonetica[I] = 'i' then
        LPalavraFonetica[I] := 'I'
      else if LPalavraFonetica[i] = 'a' then // a -> A
        LPalavraFonetica[I] := 'A'
      else if LPalavraFonetica[I] = 'o' then // o -> U
        LPalavraFonetica[I] := 'U'
      else if LPalavraFonetica[I] = 's' then // s -> S
        LPalavraFonetica[I] := 'S'
      else if LPalavraFonetica[I] = 'E' then // E -> b
        LPalavraFonetica[I] := ' '
      else if LPalavraFonetica[I] = 'Y' then // Y -> _
        LPalavraFonetica[I] := '_';
    end;

    // retorna a palavra, modificada, ao vetor que contem o texto
    LPalavras[LIndice] := '';
    for LCaracter in LPalavraFonetica do
      LPalavras[LIndice] := LPalavras[LIndice] + LCaracter;
  end;

  // remonta as palavras armazenadas no vetor em um unico string
  for LPalavra in LPalavras do
  begin
    if LPalavra.Trim.IsEmpty then
      Continue;
    if not Result.Trim.IsEmpty then
      Result := Result + ' ';
    Result := Result + LPalavra.Trim;
  end;

  // remove os caracteres duplicados
  Result := Self.RemoverCaracteresDuplicados(Result);

  Result := Result.ToUpper.Trim;
end;

end.
