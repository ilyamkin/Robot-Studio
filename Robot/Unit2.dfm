object Form2: TForm2
  Left = 310
  Top = 288
  BorderStyle = bsToolWindow
  Caption = #1057#1080#1085#1090#1072#1082#1089#1080#1089' '#1082#1086#1084#1072#1085#1076' '#1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1103
  ClientHeight = 299
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 126
    Height = 13
    Caption = #1054#1089#1085#1086#1074#1085#1099#1077'  '#1082#1086#1084#1072#1085#1076#1099':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 160
    Top = 8
    Width = 119
    Height = 13
    Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1094#1080#1103' '#1045#1057#1051#1048':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 136
    Width = 100
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1091#1089#1083#1086#1074#1080#1081':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 160
    Top = 136
    Width = 119
    Height = 13
    Caption = #1050#1086#1085#1089#1090#1088#1091#1082#1094#1080#1103' '#1055#1054#1050#1040':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 129
    Height = 81
    ItemHeight = 13
    Items.Strings = (
      #1074#1074#1077#1088#1093
      #1074#1085#1080#1079
      #1074#1087#1088#1072#1074#1086
      #1074#1083#1077#1074#1086
      #1079#1072#1082#1088#1072#1089#1080#1090#1100)
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 160
    Top = 32
    Width = 129
    Height = 81
    Lines.Strings = (
      #1077#1089#1083#1080' '#1059#1057#1051#1054#1042#1048#1045' '#1076#1077#1083#1072#1090#1100
      ''
      #1086#1089#1085#1086#1074#1085#1099#1077' '#1082#1086#1084#1072#1085#1076#1099
      ''
      #1082#1086#1085#1077#1094)
    ReadOnly = True
    TabOrder = 1
  end
  object ListBox2: TListBox
    Left = 8
    Top = 160
    Width = 129
    Height = 81
    ItemHeight = 13
    Items.Strings = (
      #1089#1087#1088#1072#1074#1072' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1089#1083#1077#1074#1072' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1089#1085#1080#1079#1091' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1089#1074#1077#1088#1093#1091' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1085#1077' '#1089#1087#1088#1072#1074#1072' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1085#1077' '#1089#1083#1077#1074#1072' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1085#1077' '#1089#1085#1080#1079#1091' '#1089#1074#1086#1073#1086#1076#1085#1086
      #1085#1077' '#1089#1074#1077#1088#1093#1091' '#1089#1074#1086#1073#1086#1076#1085#1086)
    TabOrder = 2
  end
  object Button1: TButton
    Left = 112
    Top = 264
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1050
    TabOrder = 3
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 160
    Top = 160
    Width = 129
    Height = 81
    Lines.Strings = (
      #1087#1086#1082#1072' '#1059#1057#1051#1054#1042#1048#1045' '#1076#1077#1083#1072#1090#1100
      ''
      #1086#1089#1085#1086#1074#1085#1099#1077' '#1082#1086#1084#1072#1085#1076#1099
      ''
      #1082#1086#1085#1077#1094)
    ReadOnly = True
    TabOrder = 4
  end
end
