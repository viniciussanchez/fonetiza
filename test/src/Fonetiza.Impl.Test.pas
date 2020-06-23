unit Fonetiza.Impl.Test;

interface

uses TestFramework, Fonetiza.Intf, Fonetiza.Impl;

type
  TTestFonetiza = class(TTestCase)
  strict private
    FFonetiza: TFonetiza;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGerarConteudoFonetico;
    procedure TestRemoverAcentuacoes;
    procedure TestRemoverCaracteresEspeciais;
    procedure TestRemoverConteudos;
    procedure TestSubstituirConteudos;
    procedure TestRemoverCaracteresDuplicados;
    procedure TestSomarCaracteres;
  end;

implementation

procedure TTestFonetiza.SetUp;
begin
  FFonetiza := TFonetiza.Create;
end;

procedure TTestFonetiza.TearDown;
begin
  FFonetiza.Free;
end;

procedure TTestFonetiza.TestGerarConteudoFonetico;
begin
  CheckEquals('GIUZI', FFonetiza.GerarConteudoFonetico('JOSE'));
  CheckEquals('KARLU', FFonetiza.GerarConteudoFonetico('CARLOS'));
end;

procedure TTestFonetiza.TestRemoverAcentuacoes;
const
  CARACTERES_COM_ACENTO = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸Ò˝¿¬ ‘€√’¡…Õ”⁄«‹—›';
  CARACTERES_SEM_ACENTO = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  LReturn: string;
begin
  LReturn := FFonetiza.RemoverAcentuacoes(CARACTERES_COM_ACENTO);
  CheckEquals(CARACTERES_SEM_ACENTO, LReturn);
end;

procedure TTestFonetiza.TestRemoverCaracteresDuplicados;
const
  CONTEUDO = 'AA RUA DA NOSSA CASA POSSSUI  11    ANOS E 3333 DIAS';
  CONTEUDO_VALIDO = 'A RUA DA NOSSA CASA POSSUI  11    ANOS E 3333 DIAS';
var
  LReturn: string;
begin
  LReturn := FFonetiza.RemoverCaracteresDuplicados(CONTEUDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

procedure TTestFonetiza.TestRemoverCaracteresEspeciais;
const
  CARACTERES_ESPERADOS = ' VINICIUS_SANCHEZ&1995 ';
  CARACTERES_ESPECIAIS = '<>!@#$%®*()+={}[]?;:,|*"~^¥`®Ê∆¯£ÿÉ™∫øÆΩºﬂµ˛˝›';
var
  LReturn: string;
begin
  LReturn := FFonetiza.RemoverCaracteresEspeciais(CARACTERES_ESPECIAIS + CARACTERES_ESPERADOS);
  CheckEquals(CARACTERES_ESPERADOS, LReturn);
end;

procedure TTestFonetiza.TestRemoverConteudos;
const
  CONTEUDO = 'DR VINICIUS DE SANCHEZ';
  CONTEUDO_INVALIDO: TArray<string> = ['DR', 'DE'];
  CONTEUDO_VALIDO = 'VINICIUS SANCHEZ';
var
  LReturn: string;
begin
  LReturn := FFonetiza.RemoverConteudos(CONTEUDO, CONTEUDO_INVALIDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

procedure TTestFonetiza.TestSomarCaracteres;
const
  CONTEUDO = '3 MIL E 100 CABE«AS DE GADO, MIL NOVILHAS E MIL';
  CONTEUDO_VALIDO = '3100 CABE«AS DE GADO, 1000 NOVILHAS 1000';
var
  LReturn: string;
begin
  LReturn := FFonetiza.SomarCaracteres(CONTEUDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

procedure TTestFonetiza.TestSubstituirConteudos;
const
  CONTEUDO = 'RUA TREZE DE MAIO';
  CONTEUDO_INVALIDO: TArray<TArray<string>> = [['RUA', 'R'], ['TREZE', '13']];
  CONTEUDO_VALIDO = 'R 13 DE MAIO';
var
  LReturn: string;
begin
  LReturn := FFonetiza.SubstituirConteudos(CONTEUDO, CONTEUDO_INVALIDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

initialization
  RegisterTest(TTestFonetiza.Suite);

end.
