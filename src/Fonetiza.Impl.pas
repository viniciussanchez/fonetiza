unit Fonetiza.Impl;

interface

uses Fonetiza.Intf;

type
  TFonetiza = class(TInterfacedObject, IFonetiza)
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

uses System.SysUtils, System.StrUtils, Fonetiza.Consts, System.Generics.Collections;

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

  // fonetiza (a mágica fica aqui!)
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

function TFonetiza.GerarConteudoFonetico(const AValue: string): string;
var
  // vetores de caracteres utilizadas para manipular o texto
  foncmp: TCharArray;
  fonaux: TCharArray;
  fonwrk: TCharArray;
  fonfon: TCharArray;

  // contadores
  I, J, X, K: Integer;

  // posicao atual no vetor
  desloc: Integer;

  // indica se eh ultimo fonema
  endfon: Integer;

  // indica se o fonema deve ser copiado
  copfon: Integer;

  // indica se o fonema eh mudo
  copmud, newmud: Integer;

  // Vetor utilizado para armazenar o texto: cada palavra do texto e armazenada em uma posicao do vetor
  component: TArray<string>;

  LCaracter: Char;
  LPalavra: string;
begin
  // zera os contadores
  I := 0;
  J := 0;

  // define o tamanho dos vetores
  SetLength(foncmp, 256);
  SetLength(fonaux, 256);
  SetLength(fonwrk, 256);
  SetLength(fonfon, 256);

  // o texto eh armazenado no vetor: cada palavra ocupa uma posicao do vetor
  component := AValue.Split([' ']);

  // percorre o vetor, palavra a palavra
  for desloc := 0 to Pred(Length(component)) do
  begin
    // branqueia os vetores
    for I := 0 to 255 do
    begin
      fonwrk[I] := ' ';
      fonfon[I] := ' ';
    end;

    // vetores recebem os caracteres da palavra atual
    foncmp := component[desloc].ToCharArray;
    fonaux := foncmp;

    J := 0;

    // se a palavra possuir apenas 1 caracter, nao altera a palavra
    if component[desloc].Length = 1 then
    begin
      fonwrk[0] := foncmp[0];

      // se o caracter for "_", troca por espaco em branco
      if foncmp[0] = '_' then
        fonwrk[0] := ' '
      else if ((foncmp[0] = 'E') or (foncmp[0] = '&') or (foncmp[0] = 'I')) then // se for "E", "&" ou "I", troca por "i"
        fonwrk[0] := 'i';
    end
    else
    begin
      // caracter nao eh modificado
      for I := 0 to Pred(component[desloc].Length) do
      begin
        if foncmp[I] = '_' then // _ -> Y
          fonfon[I] := 'Y'
        else if foncmp[i] = '&' then // & -> i
          fonfon[I] := 'i'
        else if ((foncmp[I] = 'E') or (foncmp[I] = 'Y') or (foncmp[I] = 'I')) then // E, Y, I -> i
          fonfon[I] := 'i'
        else if ((foncmp[I] = 'O') or (foncmp[I] = 'U')) then // O, U -> u
          fonfon[I] := 'o'
        else if foncmp[I] = 'A' then // A -> a
          fonfon[I] := 'a'
        else if foncmp[I] = 'S' then // S -> s
          fonfon[I] := 's'
        else
          fonfon[I] := foncmp[I];
      end;

      endfon := 0;
      fonaux := fonfon;

      // palavras formadas por apenas 3 consoantes sao dispensadas do processo de fonetizacao
      if fonaux[3] = ' ' then
      begin
        if ((fonaux[0] = 'a') or (fonaux[0] = 'i') or (fonaux[0] = 'o')) then
          endfon := 0
        else if ((fonaux[1] = 'a') or (fonaux[1] = 'i') or (fonaux[1] = 'o')) then
          endfon := 0
        else if ((fonaux[2] = 'a') or (fonaux[2] = 'i') or (fonaux[2] = 'o')) then
          endfon := 0
        else
        begin
          endfon := 1;
          fonwrk[0] := fonaux[0];
          fonwrk[1] := fonaux[1];
          fonwrk[2] := fonaux[2];
        end;
      end;

      // se a palavra nao for formada por apenas 3 consoantes...
      if endfon <> 1 then
      begin
        // percorre a palavra corrente, letra a letra
        I := 0;
        while I < component[desloc].Length do
        begin
          // zera variaveis de controle
          copfon := 0;
          copmud := 0;
          newmud := 0;

          case fonaux[I] of
            'a': // se o caracter for a
              begin
                // se a palavra termina com As, AZ, AM, ou AN, elimina a consoante do final da palavra
                if ((fonaux[I + 1] = 's') or (fonaux[I + 1] = 'Z') or (fonaux[I + 1] = 'M') or (fonaux[I + 1] = 'N')) then
                begin
                  if fonaux[I + 2] <> ' ' then
                    copfon := 1
                  else
                  begin
                    fonwrk[J] := 'a';
                    fonwrk[J + 1] := ' ';
                    Inc(J);
                    Inc(I);
                  end;
                end
                else
                  copfon := 1;
                Break;
              end;
            'B': // se o caracter for B
              begin
                // B nao eh modificado
                copmud := 1;
                Break;
              end;
            'C': // se o caracter for C
              begin
                X := 0;

                // ci vira si
                if fonaux[I + 1] = 'i' then
                begin
                  fonwrk[J] := 's';
                  Inc(J);
                  Break;
                end;

                // coes final vira cao
                if ((fonaux[I + 1] = 'o') and (fonaux[I + 2] = 'i') and (fonaux[I + 3] = 's') and (fonaux[I + 4] = ' ')) then
                begin
                  fonwrk[J] := 'K';
                  fonwrk[J + 1] := 'a';
                  fonwrk[J + 2] := 'o';
                  I := I + 4;
                  Break;
                end;

                // ct vira t
                if fonaux[I + 1] = 'T' then
                  Break;

                // c vira k
                if fonaux[I + 1] <> 'H' then
                begin
                  fonwrk[J] := 'K';
                  newmud := 1;

                  // ck vira k
                  if fonaux[I + 1] = 'K' then
                  begin
                    Inc(I);
                    Break;
                  end
                  else
                    Break;
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
                  fonwrk[J] := 'K';
                  Inc(J);
                  Inc(I);
                  Break;
                end;

                // chi, nao chi final, chi vogal, chini final ou chiti final ch nao seguido de i se anterior nao e s, ch = x
                if J > 0 then
                begin
                  if fonwrk[J - 1] = 's' then
                    Dec(J);
                end;

                fonwrk[J] := 'X';
                newmud := 1;
                Inc(I);
                Break;
              end;
            'D': // se o caracter for D
              begin
                X := 0;

                // procura por dor
                if fonaux[I + 1] <> 'o' then
                begin
                  copmud := 1;
                  Break;
                end
                else if fonaux[I + 2] = 'R' then
                begin
                  if I <> 0 then
                    X := 1 // dor nao inicial
                  else
                    copfon := 1; // dor inicial
                end
                else
                  copfon := 1; // nao e dor

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
                  fonwrk[J] := 'D';
                  fonwrk[J + 1] := 'o';
                  fonwrk[J + 2] := 'R';
                  I := I + 5;
                end
                else
                  copfon := 1;

                Break;
              end;
            'F': // se o caracter for F
              begin
                // F nao eh modificado
                copmud := 1;
                Break;
              end;
            'G': // se o caracter for G
              begin
                // gui -> gi
                if fonaux[I + 1] = 'o' then
                begin
                  if fonaux[I + 2] = 'i' then
                  begin
                    fonwrk[J] := 'G';
                    fonwrk[J + 1] := 'i';
                    J := J + 2;
                    I := I + 2;
                  end
                  else
                    copmud := 1;
                end
                else
                if fonaux[I + 1] = 'L' then // gl
                begin
                  if fonaux[I + 2] = 'i' then
                  begin
                    if ((fonaux[I + 3] = 'a') or (fonaux[I + 3] = 'i') or (fonaux[I + 3] = 'o')) then
                    begin
                      fonwrk[J] := fonaux[I + 1];
                      fonwrk[J + 1] := fonaux[I + 2];
                      J := J + 2;
                      I := I + 2;
                    end
                    else if fonaux[I + 3] = 'N' then // glin -> lin
                    begin
                      fonwrk[J] := fonaux[I + 1];
                      fonwrk[J + 1] := fonaux[I + 2];
                      J := J + 2;
                      I := I + 2;
                    end
                    else
                      copmud := 1;
                  end
                  else
                    copmud := 1;
                end
                else if fonaux[I + 1] = 'N' then // gn + vogal -> ni + vogal
                begin
                  if ((fonaux[I + 2] <> 'a') and (fonaux[I + 2] <> 'i') and (fonaux[I + 2] <> 'o')) then
                    copmud := 1
                  else
                  begin
                    fonwrk[J] := 'N';
                    fonwrk[J + 1] := 'i';
                    J := J + 2;
                    Inc(I);
                  end;
                end
                else if fonaux[I + 1] = 'H' then // ghi -> gi
                begin
                  if fonaux[I + 2] = 'i' then
                  begin
                    fonwrk[J] := 'G';
                    fonwrk[J + 1] := 'i';
                    J := J + 2;
                    I := I + 2;
                  end
                  else
                    copmud := 1;
                end
                else
                  copmud := 1;

                Break;
              end;
            'H': // se o caracter for H
              begin
                // H eh desconsiderado
                Break;
              end;
            'i': // se o caracter for i
              begin
                if fonaux[I + 2] = ' ' then
                begin
                  if fonaux[I + 1] = 's' then
                  begin
                    fonwrk[J] := 'i';
                    Break;
                  end
                  else if fonaux[I + 1] = 'Z' then
                  begin
                    fonwrk[J] := 'i';
                    Break;
                  end;
                end;

                // ix
                if fonaux[I + 1] <> 'X' then
                  copfon := 1
                else if I <> 0 then
                  copfon := 1
                else if ((fonaux[I + 2] = 'a') or (fonaux[I + 2] = 'i') or (fonaux[I + 2] = 'o')) then
                begin
                  // ix vogal no inicio torna-se iz
                  fonwrk[J] := 'i';
                  fonwrk[J + 1] := 'Z';
                  J := J + 2;
                  Inc(I);
                  Break;
                end
                else if ((fonaux[I + 2] = 'C') or (fonaux[I + 2] = 's')) then
                begin
                  // ix consoante no inicio torna-se is
                  fonwrk[J] := 'i';
                  Inc(J);
                  Inc(I);
                  Break;
                end
                else
                begin
                  fonwrk[J] := 'i';
                  fonwrk[J + 1] := 's';
                  J := J + 2;
                  Inc(I);
                  Break;
                end;
                Break;
              end;
            'J': // se o caracter for J
              begin
                // J -> Gi
                fonwrk[J] := 'G';
                fonwrk[J + 1] := 'i';
                J := J + 2;
                Break;
              end;
            'K': // se o caracter for K
              begin
                // KT -> T
                if fonaux[I + 1] <> 'T' then
                  copmud := 1;
                Break;
              end;
            'L': // se o caracter for L
              begin
                // L + vogal nao eh modificado
                if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
                  copfon := 1
                else if fonaux[I + 1] <> 'H' then // L + consoante -> U + consoante
                begin
                  fonwrk[J] := 'o';
                  Inc(J);
                  Break;
                end
                // LH + consoante nao eh modificado
                else if ((fonaux[I + 2] <> 'a') and (fonaux[I + 2] <> 'i') and (fonaux[I + 2] <> 'o')) then
                  copfon := 1
                else
                begin
                  // LH + vogal -> LI + vogal
                  fonwrk[J] := 'L';
                  fonwrk[J + 1] := 'i';
                  J := J + 2;
                  Inc(I);
                  Break;
                end;
                Break;
              end;
            'M': // se o caracter for M
              begin
                // M + consoante -> N + consoante; M final -> N
                if (((fonaux[I + 1] <> 'a') and (fonaux[I + 1] <> 'i') and (fonaux[I + 1] <> 'o')) or (fonaux[I + 1] = ' ')) then
                begin
                  fonwrk[J] := 'N';
                  Inc(J);
                end
                else
                  copfon := 1;
                Break;
              end;
            'N': // se o caracter for N
              begin
                // NGT -> NT
                if ((fonaux[I + 1] = 'G') and (fonaux[I + 2] = 'T')) then
                begin
                  fonaux[I + 1] := 'N';
                  copfon := 1;
                end
                else if fonaux[I + 1] = 'H' then // NH + consoante nao eh modificado
                begin
                  if ((fonaux[I + 2] <> 'a') and (fonaux[I + 2] <> 'i') and (fonaux[I + 2] <> 'o')) then
                    copfon := 1
                  else
                  begin
                    fonwrk[J] := 'N';
                    fonwrk[J + 1] := 'i';
                    J := J + 2;
                    Inc(I);
                  end;
                end
                else
                  copfon := 1;
                Break;
              end;
            'o': // se o caracter for o
              begin
                // oS final -> o; oZ final -> o
                if ((fonaux[I + 1] = 's') or (fonaux[I + 1] = 'Z')) then
                begin
                  if fonaux[I + 2] = ' ' then
                  begin
                    fonwrk[J] := 'o';
                    Break;
                  end
                  else
                    copfon := 1;
                end
                else
                  copfon := 1;
                Break;
              end;
            'P': // se o caracter for P
              begin
                // PH -> F
                if fonaux[I + 1] = 'H' then
                begin
                  fonwrk[J] := 'F';
                  Inc(I);
                  newmud := 1;
                end
                else
                  copmud := 1;
                Break;
              end;
            'Q': // se o caracter for Q
              begin
                // Koi -> Ki (QUE, QUI -> KE, KI)
                if fonaux[I + 1] = 'o' then
                begin
                  if fonaux[I + 2] = 'i' then
                  begin
                    fonwrk[J] := 'K';
                    Inc(J);
                    Inc(I);
                    Break;
                  end;
                end;
                // QoA -> KoA (QUA -> KUA)
                fonwrk[J] := 'K';
                Inc(J);
                Break;
              end;
            'R': // se o caracter for R
              begin
                // R nao eh modificado
                copfon := 1;
                Break;
              end;
            's': // se o caracter for s
              begin
                // s final eh ignorado
                if fonaux[I + 1] = ' ' then
                  Break;

                // s inicial + vogal nao eh modificado
                if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
                begin
                  if I = 0 then
                  begin
                    copfon := 1;
                    Break;
                  end
                  // s entre duas vogais -> z
                  else if ((fonaux[I - 1] <> 'a') and (fonaux[I - 1] <> 'i') and (fonaux[I - 1] <> 'o')) then
                  begin
                    copfon := 1;
                    Break;
                  end
                  // SoL nao eh modificado
                  else if ((fonaux[I + 1] = 'o') and (fonaux[I + 2] = 'L') and (fonaux[I + 3] = ' ')) then
                  begin
                    copfon := 1;
                    Break;
                  end
                  else
                  begin
                    fonwrk[J] := 'Z';
                    Inc(J);
                    Break;
                  end;
                end;

                // ss -> s
                if fonaux[I + 1] = 's' then
                begin
                  if fonaux[I + 2] <> ' ' then
                  begin
                    copfon := 1;
                    Inc(I);
                    Break;
                  end
                  else
                  begin
                    fonaux[I + 1] := ' ';
                    Break;
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
                        fonwrk[J] := 'i';
                        Inc(J);
                        copfon := 1;
                        Break;
                      end;
                    end;
                  end;
                end;

                // sH -> X;
                if fonaux[I + 1] = 'H' then
                begin
                  fonwrk[J] := 'X';
                  Inc(I);
                  newmud := 1;
                  Break;
                end;

                if fonaux[I + 1] <> 'C' then
                begin
                  copfon := 1;
                  Break;
                end;

                // sCh nao seguido de i torna-se X
                if fonaux[I + 2] = 'H' then
                begin
                  fonwrk[J] := 'X';
                  I := I + 2;
                  newmud := 1;
                  Break;
                end;

                if fonaux[I + 2] <> 'i' then
                begin
                  copfon := 1;
                  Break;
                end;

                // sCi final -> Xi
                if fonaux[I + 3] = ' ' then
                begin
                  fonwrk[J] := 'X';
                  fonwrk[J + 1] := 'i';
                  I := I + 3;
                  Break;
                end;

                // sCi vogal -> X
                if ((fonaux[I + 3] = 'a') or (fonaux[I + 3] = 'i') or (fonaux[I + 3] = 'o')) then
                begin
                  fonwrk[J] := 'X';
                  Inc(J);
                  I := I + 2;
                  Break;
                end;

                // sCi consoante -> si
                fonwrk[J] := 's';
                fonwrk[J + 1] := 'i';
                J := J + 2;
                I := I + 2;
                Break;
              end;
            'T': // se o caracter for T
              begin
                // TS -> S
                if (fonaux[I + 1] = 's') then
                  Break
                else if (fonaux[I + 1] = 'Z') then
                  Break
                else
                  copmud := 1;
                Break;
              end;
            'V': // se o caracter for V
              begin
                // V eh desconsiderado
                Break;
              end;
            'W': // ou se o caracter for W
              begin
                // V,W inicial + vogal -> o + vogal (U + vogal)
                if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
                begin
                  if I = 0 then
                  begin
                    fonwrk[J] := 'o';
                    Inc(J);
                  end
                  else
                  begin
                    // V,W NAO inicial + vogal -> V + vogal
                    fonwrk[J] := 'V';
                    newmud := 1;
                  end;
                end
                else
                begin
                  fonwrk[J] := 'V';
                  newmud := 1;
                end;
                Break;
              end;
            'X': // se o caracter for X
              begin
                // caracter nao eh modificado
                copmud := 1;
                Break;
              end;
            'Y': // se o caracter for Y
              begin
                // Y jah foi tratado acima
                Break;
              end;
            'Z': // se o caracter for Z
              begin
                // Z final eh eliminado
                if fonaux[I + 1] = ' ' then
                  Break
                else if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
                  copfon := 1
                else
                begin
                  fonwrk[J] := 's';
                  Inc(J);
                end;
                Break;
              end;
          else // se o caracter nao for um dos jah relacionados
            begin
              // o caracter nao eh modificado
              fonwrk[J] := fonaux[I];
              Inc(J);
              Break;
            end;
          end;

          // copia caracter corrente
          if copfon = 1 then
          begin
            fonwrk[J] := fonaux[I];
            Inc(J);
          end;

          // insercao de i apos consoante muda
          if copmud = 1 then
            fonwrk[J] := fonaux[I];

          if ((copmud = 1) or (newmud = 1)) then
          begin
            Inc(J);
            K := 0;

            while k = 0 do
            begin
              // e final mudo
              if fonaux[I + 1] = ' ' then
              begin
                fonwrk[J] := 'i';
                K := 1;
              end
              else if ((fonaux[I + 1] = 'a') or (fonaux[I + 1] = 'i') or (fonaux[I + 1] = 'o')) then
                K := 1
              else if fonwrk[J - 1] = 'X' then
              begin
                fonwrk[J] := 'i';
                Inc(J);
                K := 1;
              end
              else if fonaux[I + 1] = 'R' then
                K := 1
              else if fonaux[I + 1] = 'L' then
                K := 1
              else if fonaux[I + 1] <> 'H' then
              begin
                fonwrk[J] := 'i';
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

    for i := 0 to Pred(component[desloc].Length) + 3 do
    begin
      if fonwrk[I] = 'i' then
        fonwrk[I] := 'I'
      else if fonwrk[i] = 'a' then // a -> A
        fonwrk[I] := 'A'
      else if fonwrk[I] = 'o' then // o -> U
        fonwrk[I] := 'U'
      else if fonwrk[I] = 's' then // s -> S
        fonwrk[I] := 'S'
      else if fonwrk[I] = 'E' then // E -> b
        fonwrk[I] := ' '
      else if fonwrk[I] = 'Y' then // Y -> _
        fonwrk[I] := '_';
    end;

    // retorna a palavra, modificada, ao vetor que contem o texto
    component[desloc] := '';
    for LCaracter in fonwrk do
      component[desloc] := component[desloc] + LCaracter;

    // zera o contador
    j := 0;
  end;

  // remonta as palavras armazenadas no vetor em um unico string
  for LPalavra in component do
    Result := Result + LPalavra;

  // remove os caracteres duplicados
  Result := Self.RemoverCaracteresDuplicados(Result);

  Result := Result.ToUpper.Trim;
end;

end.
