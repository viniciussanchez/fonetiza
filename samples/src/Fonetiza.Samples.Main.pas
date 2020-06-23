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
    procedure btnFonetizarClick(Sender: TObject);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses Fonetiza;

procedure TFrmMain.btnFonetizarClick(Sender: TObject);
begin
  mmResultadoFonetico.Lines.Add(TFonetiza.New.Fonetizar(edtConteudo.Text));
end;

end.
