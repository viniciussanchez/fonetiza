unit Fonetiza.Intf;

interface

type
  IFonetiza = interface
    ['{B906D0E0-1BD1-4D90-BB17-39FE665DBD7C}']
    /// <summary>
    ///   Gerar conteúdo fonético
    /// </summary>
    /// <param name="AValue">
    ///   Conteúdo que será processado para geração fonética
    /// </param>
    /// <returns>
    ///   Retorna o conteúdo fonético
    /// </returns>
    function Fonetizar(const AValue: string): string;
    /// <summary>
    ///   Gerar código fonético
    /// </summary>
    /// <para>
    ///   Conteúdo que será processado para geração do código fonético
    /// </para>
    /// <returns>
    ///   Retorna um código fonético
    /// </returns>
    function GerarCodigoFonetico(const AValue: string): string;
    /// <summary>
    ///   Gerar lista de códigos fonéticos
    /// </summary>
    /// <param name="AValue">
    ///   Conteúdo que será processado para geração dos códigos fonéticos
    /// </param>
    /// <returns>
    ///   Retorna uma lista dos códigos fonéticos
    /// </returns>
    function GerarListaCodigosFoneticos(const AValue: string): TArray<string>;
  end;

implementation

end.
