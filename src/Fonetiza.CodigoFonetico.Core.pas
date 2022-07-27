unit Fonetiza.CodigoFonetico.Core;

interface

uses System.SysUtils;

type
  TCodigoFoneticoCore = class
  public
    function removeElement(var pArray: TArray<string>; const pIndex: integer): boolean;
    function fonreg(const i03: Int64): TCharArray;
    function tabNor(const str: string): string;
    function tabEbc(const str: string): string;
    function randomic(const str: string): Int64;
    function randomize(const str: string): string;
    function generateCodes(const str: string): TArray<String>;
    function permutations(const size: Integer): TArray<TArray<Boolean>>;
    function allPermutations: TArray<TArray<TArray<Boolean>>>;
  end;

implementation

uses System.Classes, System.Math;

{ TCodigoFoneticoCore }

const
  powersOfTwo: TArray<Integer> = [1, 2, 4, 8, 16, 32];

function TCodigoFoneticoCore.allPermutations: TArray<TArray<TArray<Boolean>>>;
begin
  Result := [permutations(1), permutations(2), permutations(3), permutations(4), permutations(5)];
end;

function TCodigoFoneticoCore.fonreg(const i03: Int64): TCharArray;
var
  i01, i02: Int64;
  fonaux: TCharArray;
begin
  SetLength(fonaux, 4);
	i02 := i03;
  fonaux[3] := char(i02 mod $0100);
  i01 := (i02 - Ord(fonaux[3])) div $0100;
  fonaux[2] := char(i01 mod $0100);
  i02 := (i01 - Ord(fonaux[2])) div $0100;
  fonaux[1] := char(i02 mod $0100);
  i01 := (i02 - Ord(fonaux[1])) div $0100;
  fonaux[0] := char(i01 mod $0100);
	Result := fonaux;
end;

function TCodigoFoneticoCore.permutations(const size: Integer): TArray<TArray<Boolean>>;
var
  i, j: integer;
begin
  if size > 5 then
    raise Exception.Create('Invalid argument. size must be <= 5');

  SetLength(Result, Pred(powersOfTwo[size]), size);

  for i := 0 to Pred(Length(Result)) do
    for j := 0 to Pred(size) do
      result[i][j] := ((i + 1) and powersOfTwo[j]) > 0;
end;

function TCodigoFoneticoCore.removeElement(var pArray: TArray<string>; const pIndex: integer): boolean;
var
  i :integer;
begin
  Result := (pIndex <= High(pArray)) and (pIndex >= Low(pArray));

  if not Result then
    raise EListError.Create(Format('List index is out of bounds (%s).', [pIndex]))
  else
  begin
    for i := pIndex to Pred(High(pArray)) do
      pArray[i] := pArray[i + 1];

    SetLength(pArray, Pred(Length(pArray)));
    Result := True;
  end;
end;

function TCodigoFoneticoCore.generateCodes(const str: string): TArray<String>;
var
  i, j, size, index: Integer;
  return: TStringList;
  palavras, subPalavras: TArray<string>;
  permutations: TArray<TArray<Boolean>>;
  palavra, subNome: string;
begin
  palavras := str.Split([' ']);
  return := TStringList.Create;
  try
    if Length(palavras) > 5 then
      return.add(Self.randomize(str)); // adiciona o nome completo, mesmo grandao

    while Length(palavras) > 5 do
    begin
      index := Length(palavras) div 2;
      palavra := palavras[index];
      removeElement(palavras, index); // remove um nome do meio
      return.add(Self.randomize(palavra)); // adiciona o codigo da palavra removida
    end;

    size := Length(palavras);
    permutations := allPermutations[IfThen(size = 0, 0, Pred(size))];

    for i := 0 to Pred(Length(permutations)) do
    begin
      SetLength(subPalavras, 0);

      for j := 0 to Pred(size) do
      begin
        if permutations[i][j] then
        begin
          SetLength(subPalavras, Succ(Length(subPalavras)));
          subPalavras[Pred(Length(subPalavras))] := palavras[j];
        end;
      end;

      subNome := EmptyStr;
      for palavra in subPalavras do
      begin
        if not subNome.Trim.IsEmpty then
          subNome := subNome + ' ';
        subNome := subNome + palavra;
      end;

      return.add(Self.randomize(subNome));
    end;

    SetLength(Result, return.Count);
    for I := 0 to Pred(return.Count) do
      Result[I] := return[I];
  finally
    return.Free;
  end;
end;

function TCodigoFoneticoCore.randomic(const str: string): Int64;
var
  i: integer;
  i01, i02: Int64;
  fonaux: TCharArray;
begin
  SetLength(fonaux, 256);

  if str.Length > 1 then
  begin
    fonaux := str.ToCharArray;
    i01 := (Ord(fonaux[0]) * $0100) + Ord(fonaux[1]);

    for i := 1 to 255 do
    begin
      if i = Pred(str.Length) then
        Break;

      i02 := (Ord(fonaux[i]) * $0100) + Ord(fonaux[i + 1]);
      i01 := i01 * i02;
      i01 := i01 shr 8;
    end;
  end
  else
  begin
    fonaux := str.ToCharArray;
    i01 := Ord(fonaux[0]) * $0100;
    i01 := i01 shr 8;
  end;

  Result := i01;
end;

function TCodigoFoneticoCore.randomize(const str: string): string;
var
  lchar: char;
  w0, w1: Integer; // inteiros utilizados para operacoes de shift
  i, j, k: Integer; // contadores
  fon09, fon11, fon12: Int64; // inteiros utilizados para manipular o codigo
  reg09, reg11, reg12: TCharArray; // matrizes de caracteres utilizadas para manipular o codigo
  fonrnd, finalRand: TCharArray; // estruturas que armazenam o codigo
  work: TCharArray; // variavel de manipulacao
  foncmp, fonaux: TCharArray; // matrizes de manipulacao
	priStr, auxStr, modStr, rand: string; // string de manipulacao
  component: TArray<string>; // texto eh armazenado no vetor
begin
  // gera um codigo identificador de 10 caracteres para um texto qualquer
  Result := EmptyStr;

	fon09 := 0;
	fon11 := 0;
	fon12 := 0;

  SetLength(reg09, 4);
  SetLength(reg11, 4);
  SetLength(reg12, 4);

  SetLength(fonrnd, 5);
  SetLength(finalRand, 10);

  SetLength(work, 2);

  SetLength(foncmp, 256);
  SetLength(fonaux, 256);

	component := str.Split([' ']);

  // percorre o texto, palavra a palavra
  for i := 0 to Pred(Length(component)) do
  begin
    auxStr := component[i];
    foncmp := auxStr.ToCharArray;

    // se a palavra nao for vazia
    if foncmp[0] <> ' ' then
    begin
      // branqueia matriz
      for j := 0 to 255 do
        fonaux[j] := ' ';

      // se a palavra iniciar por vogal, insere um "R" no inicio da palavra
      if ((foncmp[0] = 'I') or (foncmp[0] = 'A') or (foncmp[0] = 'U')) then
      begin
        fonaux[0] := 'R';
        for j := 0 to Pred(auxStr.Length) do
          fonaux[j + 1] := foncmp[j];
      end
      else
      begin
        // se a palavra iniciar com "GI", suprime o "G"
        if ((foncmp[0] = 'G') and (auxStr.Length > 1)) then
        begin
          if (foncmp[1] = 'I') then
          begin
            for j := 0 to auxStr.Length - 2 do
              fonaux[j] := foncmp[j + 1];
          end
          else
          begin
            // senao apenas copia a palavra original
            for j := 0 to Pred(auxStr.Length) do
              fonaux[j] := foncmp[j];
          end;
        end
        else
        begin
          // senao apenas copia a palavra original
          for j := 0 to Pred(auxStr.Length) do
            fonaux[j] := foncmp[j];
        end;
      end;

      auxStr := EmptyStr;
      for lchar in fonaux do
        auxStr := auxStr + lchar;
      auxStr := auxStr.Trim;

      foncmp := auxStr.ToCharArray;

      for j := 0 to 255 do
        fonaux[j] := ' ';

      j := 0;
      k := 0;

      // percorre a palavra, letra a letra
      while j < auxStr.Length do
      begin
        // se a palavra terminar com BI, DI, FI, GI, JI, PI, KI, TI ou VI suprime estas silabas da palavra
        if ((j + 2 = auxStr.Length) and (j <> 0) and ((foncmp[j] = 'B') or (foncmp[j] = 'D') or (foncmp[j] = 'F')
          or (foncmp[j] = 'G') or (foncmp[j] = 'J') or (foncmp[j] = 'P') or (foncmp[j] = 'K') or (foncmp[j] = 'T') or (foncmp[j] = 'V'))) then
        begin
          if foncmp[j + 1] = 'I' then
            j := j + 2
          else
          begin
            fonaux[k] := foncmp[j];
            Inc(j);
            Inc(k);
          end;
        end
        // NI+vogal ou LI+vogal = N+vogal ou L+vogal
        else if ((j + 3 <= auxStr.Length) and ((foncmp[j] = 'N') or (foncmp[j] = 'L'))) then
        begin
          if ((foncmp[j + 1] = 'I') and ((foncmp[j + 2] = 'A') or (foncmp[j + 2] = 'E') or (foncmp[j + 2] = 'O') or (foncmp[j + 2] = 'U'))) then
          begin
            fonaux[k] := foncmp[j];
            fonaux[k + 1] := foncmp[j + 2];
            j := j + 3;
            k := k + 2;
          end
          else
          begin
            fonaux[k] := foncmp[j];
            Inc(J);
            Inc(K);
          end;
        end
        // vogal+R final = vogal
        else if ((foncmp[j] = 'R') and (j > 0)) then
        begin
          if ((foncmp[j - 1] <> 'A') and (foncmp[j - 1] <> 'E') and (foncmp[j - 1] <> 'I') and (foncmp[j - 1] <> 'O') and (foncmp[j - 1] <> 'U')) then
            Inc(J)
          else
          begin
            fonaux[k] := foncmp[j];
            Inc(J);
            Inc(K);
          end;
        end
        else
        begin
          fonaux[k] := foncmp[j];
          Inc(J);
          Inc(K);
        end;
      end;

      auxStr := EmptyStr; // >>>>>>>> ADDED BY VINICIUS
      for lchar in fonaux do
        auxStr := auxStr + lchar;
      auxStr := auxStr.Trim;

      foncmp := auxStr.ToCharArray;

      for j := 0 to 255 do
        fonaux[j] := ' ';

      // percorre a palavra, letra a letra
      for j := 0 to Pred(auxStr.Length) do
      begin
        // se a letra for "V", substitui por "F"
        if foncmp[j] = 'V' then
          fonaux[j] := 'F'
        else if ((foncmp[j] = 'X') or (foncmp[j] = 'Z') or (foncmp[j] = 'K')) then // se a letra for "X","Z" ou "K", substitui por "S"
          fonaux[j] := 'S'
        else if foncmp[j] = 'G' then // G -> D
          fonaux[j] := 'D'
        else
          fonaux[j] := foncmp[j];
      end;
    end;

    auxStr := EmptyStr; // >>>>>>>> ADDED BY VINICIUS
    for lchar in fonaux do
      auxStr := auxStr + lchar;
    auxStr := auxStr.Trim;

    // a palavra eh recolocada, modificada, no vetor que contem o texto
    component[I] := auxStr;
	end;

  // percorre o texto, palavra a palavra
  for i := 0 to Pred(Length(component)) do
  begin
    auxStr := component[i];

    // considera somente as primeiras 7 letras da palavra
    if auxStr.Length > 7 then
    begin
      foncmp := auxStr.ToCharArray;
      for j := 7 to Pred(auxStr.Length) do
        foncmp[j] := ' ';

      for lchar in foncmp do
        auxStr := auxStr + lchar;
      auxStr := auxStr.Trim;

      component[I] := auxStr;
    end;

    // componentes do codigo sao calculados
    fon11 := fon11 + randomic(tabEbc(auxStr));
    fon12 := fon12 + randomic(tabNor(tabEbc(auxStr)));
  end;

  component := str.Split([' ']);

  // percorre o texto, palavra a palavra
  for i := 0 to Pred(Length(component)) do
    fon09 := fon09 + randomic(component[i]); // componente do codigo eh calculado

  // monta o codigo identificador do texto
  reg09 := fonreg(fon09);
  reg11 := fonreg(fon11);
  reg12 := fonreg(fon12);

  fonrnd[0] := reg12[2];
  fonrnd[1] := reg11[1];
  fonrnd[2] := reg11[2];

  if ((fonrnd[0] = '0') and (fonrnd[1] = '0') and (fonrnd[2] = '0')) then
  begin
    fonrnd[0] := reg12[1];
    fonrnd[1] := reg11[0];
    fonrnd[2] := reg11[3];
  end;

  fonrnd[3] := reg09[1];
  fonrnd[4] := reg09[2];

  if ((fonrnd[3] = '0') and (fonrnd[4] = '0')) then
  begin
    fonrnd[3] := reg09[0];
    fonrnd[4] := reg09[3];

    if ((fonrnd[3] = '0') and (fonrnd[4] = '0')) then
    begin
      fon09 := fon11 + fon12;
      reg09 := fonreg(fon09);

      fonrnd[3] := reg09[1];
      fonrnd[4] := reg09[2];
    end;
  end;

  j := 0;
  for i := 0 to 4 do
  begin
    auxStr := fonrnd[i];

    w0 := Ord(fonrnd[i]);
    w0 := w0 shr 4;
    work[0] := char(w0);

    if Ord(work[0]) <= $0009 then
      finalRand[j] := char(Ord(work[0]) + 48)
    else
      finalRand[j] := char(Ord(work[0]) - 10 + 97);

    w1 := Ord(fonrnd[i]);
    w1 := w1 shl 28;
    w0 := w1 shr 28;
    work[0] := char(w0);

    if Ord(work[0]) <= $0009 then
      finalRand[j + 1] := char(Ord(work[0]) + 48)
    else
      finalRand[j + 1] := char(Ord(work[0]) - 10 + 97);

    j := j + 2;
  end;

  for lchar in finalRand do
    Result := Result + lchar;
end;

function TCodigoFoneticoCore.tabEbc(const str: string): string;
var
  i: integer;
  fonaux: TCharArray;
  lchar: char;
begin
  Result := EmptyStr;
  SetLength(fonaux, 256);
  fonaux := str.ToCharArray;
  for i := 0 to Pred(str.Length) do
  begin
    case fonaux[i] of
      'A':
        fonaux[i] := Char($00c1);
      'B':
        fonaux[i] := Char($00c2);
      'C':
        fonaux[i] := Char($00c3);
      'D':
        fonaux[i] := Char($00c4);
      'E':
        fonaux[i] := Char($00c5);
      'F':
        fonaux[i] := Char($00c6);
      'G':
        fonaux[i] := Char($00c7);
      'H':
        fonaux[i] := Char($00c8);
      'I':
        fonaux[i] := Char($00c9);
      'J':
        fonaux[i] := Char($00d1);
      'K':
        fonaux[i] := Char($00d2);
      'L':
        fonaux[i] := Char($00d3);
      'M':
        fonaux[i] := Char($00d4);
      'N':
        fonaux[i] := Char($00d5);
      'O':
        fonaux[i] := Char($00d6);
      'P':
        fonaux[i] := Char($00d7);
      'Q':
        fonaux[i] := Char($00d8);
      'R':
        fonaux[i] := Char($00d9);
      'S':
        fonaux[i] := Char($00e2);
      'T':
        fonaux[i] := Char($00e3);
      'U':
        fonaux[i] := Char($00e4);
      'V':
        fonaux[i] := Char($00e5);
      'W':
        fonaux[i] := Char($00e6);
      'X':
        fonaux[i] := Char($00e7);
      'Y':
        fonaux[i] := Char($00e8);
      'Z':
        fonaux[i] := Char($00e9);
      '0':
        fonaux[i] := Char($00f0);
      '1':
        fonaux[i] := Char($00f1);
      '2':
        fonaux[i] := Char($00f2);
      '3':
        fonaux[i] := Char($00f3);
      '4':
        fonaux[i] := Char($00f4);
      '5':
        fonaux[i] := Char($00f5);
      '6':
        fonaux[i] := Char($00f6);
      '7':
        fonaux[i] := Char($00f7);
      '8':
        fonaux[i] := Char($00f8);
      '9':
        fonaux[i] := Char($00f9);
    else
      fonaux[i] := Char($0040);
    end;
  end;
  for lchar in fonaux do
    Result := Result + lchar;
end;

function TCodigoFoneticoCore.tabNor(const str: string): string;
var
  i: integer;
  fonaux: TCharArray;
  lchar: Char;
begin
  Result := EmptyStr;
  SetLength(fonaux, 256);
  fonaux := str.ToCharArray;
  for i := 0 to Pred(str.Length) do
  begin
    case fonaux[i] of
      Char($00c1):
        fonaux[i] := Char($0013);
      Char($00c2):
        fonaux[i] := Char($0016);
      Char($00c3):
        fonaux[i] := Char($0019);
      Char($00c4):
        fonaux[i] := Char($001c);
      Char($00c5):
        fonaux[i] := Char($0011);
      Char($00c6):
        fonaux[i] := Char($0014);
      Char($00c7):
        fonaux[i] := Char($0017);
      Char($00c8):
        fonaux[i] := Char($001a);
      Char($00c9):
        fonaux[i] := Char($001d);
      Char($00d1):
        fonaux[i] := Char($0033);
      Char($00d2):
        fonaux[i] := Char($0036);
      Char($00d3):
        fonaux[i] := Char($0039);
      Char($00d4):
        fonaux[i] := Char($003c);
      Char($00d5):
        fonaux[i] := Char($0031);
      Char($00d6):
        fonaux[i] := Char($0034);
      Char($00d7):
        fonaux[i] := Char($0037);
      Char($00d8):
        fonaux[i] := Char($003a);
      Char($00d9):
        fonaux[i] := Char($003d);
      Char($00e2):
        fonaux[i] := Char($0053);
      Char($00e3):
        fonaux[i] := Char($0056);
      Char($00e4):
        fonaux[i] := Char($0059);
      Char($00e5):
        fonaux[i] := Char($005c);
      Char($00e6):
        fonaux[i] := Char($0054);
      Char($00e7):
        fonaux[i] := Char($0057);
      Char($00e8):
        fonaux[i] := Char($005a);
      Char($00e9):
        fonaux[i] := Char($005d);
      Char($00f0):
        fonaux[i] := Char($0070);
      Char($00f1):
        fonaux[i] := Char($0071);
      Char($00f2):
        fonaux[i] := Char($0072);
      Char($00f3):
        fonaux[i] := Char($0073);
      Char($00f4):
        fonaux[i] := Char($0074);
      Char($00f5):
        fonaux[i] := Char($0075);
      Char($00f6):
        fonaux[i] := Char($0076);
      Char($00f7):
        fonaux[i] := Char($0077);
      Char($00f8):
        fonaux[i] := Char($0078);
      Char($00f9):
        fonaux[i] := Char($0079);
    else
      fonaux[i] := Char($0040);
    end;
  end;
  for lchar in fonaux do
    Result := Result + lchar;
end;

end.
