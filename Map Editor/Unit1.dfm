object Editor: TEditor
  Left = 120
  Top = 335
  BorderStyle = bsToolWindow
  Caption = 'Robot Studio: Maps Editor'
  ClientHeight = 668
  ClientWidth = 874
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    874
    668)
  PixelsPerInch = 96
  TextHeight = 13
  object Map: TImage
    Left = 7
    Top = 9
    Width = 617
    Height = 618
    Anchors = []
    OnClick = MapClick
  end
  object ro: TShape
    Left = 272
    Top = 104
    Width = 17
    Height = 17
    Brush.Color = clYellow
  end
  object Label1: TLabel
    Left = 632
    Top = 8
    Width = 58
    Height = 13
    Caption = #1062#1074#1077#1090' '#1083#1080#1085#1080#1081
  end
  object Label2: TLabel
    Left = 752
    Top = 8
    Width = 43
    Height = 13
    Caption = #1047#1072#1083#1080#1074#1082#1072
  end
  object Label3: TLabel
    Left = 632
    Top = 64
    Width = 130
    Height = 20
    Caption = #1058#1077#1082#1089#1090' '#1079#1072#1076#1072#1085#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object fname_lbl: TLabel
    Left = 8
    Top = 640
    Width = 55
    Height = 13
    Caption = 'fname_lbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 624
    Top = 312
    Width = 104
    Height = 20
    Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 712
    Top = 648
    Width = 150
    Height = 13
    Caption = 'Copyright (c) 2011. Lyamkin Ilya'
  end
  object PenColor: TColorBox
    Left = 632
    Top = 24
    Width = 105
    Height = 22
    DefaultColorColor = clBlue
    Selected = clBackground
    ItemHeight = 16
    TabOrder = 0
    OnChange = PenColorChange
  end
  object BrushColor: TColorBox
    Left = 752
    Top = 24
    Width = 97
    Height = 22
    DefaultColorColor = clBtnFace
    Selected = clBtnFace
    ItemHeight = 16
    TabOrder = 1
    OnChange = BrushColorChange
  end
  object Save_btn: TButton
    Left = 624
    Top = 496
    Width = 113
    Height = 65
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
    TabOrder = 2
    TabStop = False
    OnClick = Save_btnClick
  end
  object Open_btn: TButton
    Left = 752
    Top = 496
    Width = 113
    Height = 65
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
    TabOrder = 3
    TabStop = False
    OnClick = Open_btnClick
  end
  object Clear_btn: TButton
    Left = 624
    Top = 432
    Width = 241
    Height = 41
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077
    TabOrder = 4
    TabStop = False
    OnClick = Clear_btnClick
  end
  object TaskText: TMemo
    Left = 624
    Top = 96
    Width = 217
    Height = 201
    Lines.Strings = (
      'TaskText')
    TabOrder = 5
    OnEnter = TaskTextEnter
    OnExit = TaskTextExit
  end
  object Memo1: TMemo
    Left = 624
    Top = 344
    Width = 249
    Height = 73
    Lines.Strings = (
      '"'#1055#1088#1086#1073#1077#1083'" - '#1079#1072#1082#1088#1072#1089#1080#1090#1100' '#1103#1095#1077#1081#1082#1091
      '"'#1050#1083#1072#1074#1080#1096#1080' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103'" - '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
      '"END" - '#1079#1072#1076#1072#1090#1100' '#1082#1086#1085#1077#1095#1085#1091#1102' '#1087#1086#1079#1080#1094#1080#1102'.'
      #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1087#1086#1094#1080#1094#1080#1103' '#1079#1072#1076#1072#1077#1090#1089#1103' '#1086#1073#1098#1077#1082#1090#1086#1084'.'
      '"Ctrl + '#1082#1083#1072#1074#1080#1096#1072' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103'" - '#1087#1086#1089#1090#1088#1086#1080#1090#1100' '#1089#1090#1077#1085#1091)
    TabOrder = 6
  end
  object Button1: TButton
    Left = 752
    Top = 584
    Width = 115
    Height = 49
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 7
    OnClick = Button1Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'rsm'
    Filter = 'Robot Studio Map|*.rsm'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 352
    Top = 24
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'rsm'
    Filter = 'Robot Studio Map|*.rsm'
    Left = 384
    Top = 24
  end
  object XPManifest1: TXPManifest
    Left = 416
    Top = 24
  end
end
