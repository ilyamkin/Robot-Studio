object Form4: TForm4
  Left = 313
  Top = 408
  BorderStyle = bsToolWindow
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 172
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 308
    Height = 13
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1088#1086#1073#1086#1090#1072'('#1095#1077#1084' '#1084#1077#1085#1100#1096#1077' '#1095#1080#1089#1083#1086', '#1090#1077#1084' '#1073#1099#1089#1090#1088#1077#1077'):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TrackBar1: TTrackBar
    Left = 8
    Top = 40
    Width = 150
    Height = 41
    Max = 10000
    Frequency = 1000
    Position = 1000
    TabOrder = 0
    TickMarks = tmBoth
    OnChange = TrackBar1Change
  end
  object Edit1: TEdit
    Left = 160
    Top = 48
    Width = 57
    Height = 21
    MaxLength = 5
    TabOrder = 1
    Text = '1000'
    OnChange = Edit1Change
  end
  object Button1: TButton
    Left = 232
    Top = 136
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
end
