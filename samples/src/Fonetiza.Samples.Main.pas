unit Fonetiza.Samples.Main;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtConteudo: TEdit;
    btnFonetizar: TButton;
    mmResultadoFonetico: TMemo;
    btnCodigoFonetico: TButton;
    btnListaCodigoFonetico: TButton;
    procedure btnFonetizarClick(Sender: TObject);
    procedure btnCodigoFoneticoClick(Sender: TObject);
    procedure btnListaCodigoFoneticoClick(Sender: TObject);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses Fonetiza;

procedure TFrmMain.btnCodigoFoneticoClick(Sender: TObject);
begin
  mmResultadoFonetico.Lines.Add(TFonetiza.New.GerarCodigoFonetico(edtConteudo.Text));
end;

procedure TFrmMain.btnFonetizarClick(Sender: TObject);
begin
  mmResultadoFonetico.Lines.Add(edtConteudo.Text + ' > ' + TFonetiza.New.Fonetizar(edtConteudo.Text));
end;

procedure TFrmMain.btnListaCodigoFoneticoClick(Sender: TObject);
var
  LCodigo: string;
  LCodigos: TArray<string>;
begin
  LCodigos := TFonetiza.New.GerarListaCodigosFoneticos(edtConteudo.Text);
  for LCodigo in LCodigos do
    mmResultadoFonetico.Lines.Add(LCodigo);
end;

end.
