object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 242
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 136
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 8
    Top = 168
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object A: TEdit
    Left = 8
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'A'
  end
  object B: TEdit
    Left = 8
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'B'
  end
  object C: TEdit
    Left = 8
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'C'
  end
  object Button1: TButton
    Left = 152
    Top = 14
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
end