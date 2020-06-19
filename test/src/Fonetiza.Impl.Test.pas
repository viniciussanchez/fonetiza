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
    procedure TestRemoverAcentuacoes;
    procedure TestRemoverCaracteresEspeciais;
    procedure TestRemoverConteudos;
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

procedure TTestFonetiza.TestRemoverCaracteresEspeciais;
const
  CARACTERES_ESPERADOS = ' VINICIUS SANCHEZ 1995 ';
  CARACTERES_ESPECIAIS = '<>!@#$%®&*()_+={}[]?;:,|*"~^¥`®Ê∆¯£ÿÉ™∫øÆΩºﬂµ˛˝›';
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

initialization
  RegisterTest(TTestFonetiza.Suite);

end.
