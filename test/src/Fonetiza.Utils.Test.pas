unit Fonetiza.Utils.Test;

interface

uses TestFramework, Fonetiza.Utils;

type
  TTestFonetizaUtils = class(TTestCase)
  strict private
    FFonetizaUtils: TFonetizaUtils;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestRemoverAcentuacoes;
    procedure TestRemoverCaracteresEspeciais;
    procedure TestRemoverConteudos;
    procedure TestSubstituirConteudos;
    procedure TestRemoverCaracteresDuplicados;
    procedure TestSomarCaracteres;
  end;

implementation

procedure TTestFonetizaUtils.SetUp;
begin
  FFonetizaUtils := TFonetizaUtils.Create;
end;

procedure TTestFonetizaUtils.TearDown;
begin
  FFonetizaUtils.Free;
end;

procedure TTestFonetizaUtils.TestRemoverAcentuacoes;
const
  CARACTERES_COM_ACENTO = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸Ò˝¿¬ ‘€√’¡…Õ”⁄«‹—›';
  CARACTERES_SEM_ACENTO = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  LReturn: string;
begin
  LReturn := FFonetizaUtils.RemoverAcentuacoes(CARACTERES_COM_ACENTO);
  CheckEquals(CARACTERES_SEM_ACENTO, LReturn);
end;

procedure TTestFonetizaUtils.TestRemoverCaracteresDuplicados;
const
  CONTEUDO = 'AA RUA DA NOSSA CASA POSSSUI  11    ANOS E 3333 DIAS';
  CONTEUDO_VALIDO = 'A RUA DA NOSSA CASA POSSUI  11    ANOS E 3333 DIAS';
var
  LReturn: string;
begin
  LReturn := FFonetizaUtils.RemoverCaracteresDuplicados(CONTEUDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

procedure TTestFonetizaUtils.TestRemoverCaracteresEspeciais;
const
  CARACTERES_ESPERADOS = ' VINICIUS_SANCHEZ&1995 ';
  CARACTERES_ESPECIAIS = '<>!@#$%®*()+={}[]?;:,|*"~^¥`®Ê∆¯£ÿÉ™∫øÆΩºﬂµ˛˝›';
var
  LReturn: string;
begin
  LReturn := FFonetizaUtils.RemoverCaracteresEspeciais(CARACTERES_ESPECIAIS + CARACTERES_ESPERADOS);
  CheckEquals(CARACTERES_ESPERADOS, LReturn);
end;

procedure TTestFonetizaUtils.TestRemoverConteudos;
const
  CONTEUDO = 'DR VINICIUS DE SANCHEZ';
  CONTEUDO_INVALIDO: TArray<string> = ['DR', 'DE'];
  CONTEUDO_VALIDO = 'VINICIUS SANCHEZ';
var
  LReturn: string;
begin
  LReturn := FFonetizaUtils.RemoverConteudos(CONTEUDO, CONTEUDO_INVALIDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

procedure TTestFonetizaUtils.TestSomarCaracteres;
const
  CONTEUDO = '3 MIL E 100 CABE«AS DE GADO, MIL NOVILHAS E MIL';
  CONTEUDO_VALIDO = '3100 CABE«AS DE GADO, 1000 NOVILHAS 1000';
var
  LReturn: string;
begin
  LReturn := FFonetizaUtils.SomarCaracteres(CONTEUDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

procedure TTestFonetizaUtils.TestSubstituirConteudos;
const
  CONTEUDO = 'RUA TREZE DE MAIO';
  CONTEUDO_INVALIDO: TArray<TArray<string>> = [['RUA', 'R'], ['TREZE', '13']];
  CONTEUDO_VALIDO = 'R 13 DE MAIO';
var
  LReturn: string;
begin
  LReturn := FFonetizaUtils.SubstituirConteudos(CONTEUDO, CONTEUDO_INVALIDO);
  CheckEquals(CONTEUDO_VALIDO, LReturn);
end;

initialization
  RegisterTest(TTestFonetizaUtils.Suite);

end.
