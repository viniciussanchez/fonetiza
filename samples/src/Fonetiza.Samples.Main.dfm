object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Fonetiza'
  ClientHeight = 299
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 619
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  Exemplo'
    Color = 7048009
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 25
    Width = 619
    Height = 274
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 13
      Top = 10
      Width = 57
      Height = 15
      Caption = 'Conte'#250'do:'
      Color = 16157516
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5592405
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 13
      Top = 61
      Width = 108
      Height = 15
      Caption = 'Resultado fon'#233'tico:'
      Color = 16157516
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5592405
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object edtConteudo: TEdit
      Left = 13
      Top = 31
      Width = 289
      Height = 21
      TabOrder = 0
      TextHint = 'Informe o conte'#250'do para fonetizar'
    end
    object btnFonetizar: TButton
      Left = 308
      Top = 29
      Width = 75
      Height = 25
      Caption = 'Fonetizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnFonetizarClick
    end
    object mmResultadoFonetico: TMemo
      Left = 13
      Top = 82
      Width = 596
      Height = 183
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
end
