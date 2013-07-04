object WordsParamsEditor: TWordsParamsEditor
  Left = 301
  Top = 356
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'WordsParamsEditor'
  ClientHeight = 246
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 6
    Top = 6
    Width = 543
    Height = 234
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 14
      Top = 8
      Width = 209
      Height = 13
      Caption = 'Набор слов (, - разделитель слов):'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object bvlMain: TBevel
      Left = 239
      Top = 193
      Width = 274
      Height = 6
      Shape = bsTopLine
    end
    object Label2: TLabel
      Left = 240
      Top = 15
      Width = 190
      Height = 13
      Caption = 'Цвет слов из указанной строки:'
    end
    object Bevel1: TBevel
      Left = 240
      Top = 40
      Width = 273
      Height = 9
      Shape = bsTopLine
    end
    object Label3: TLabel
      Left = 249
      Top = 33
      Width = 39
      Height = 13
      Caption = 'Шрифт'
    end
    object Bevel2: TBevel
      Left = 241
      Top = 72
      Width = 272
      Height = 9
      Shape = bsTopLine
    end
    object Label4: TLabel
      Left = 249
      Top = 163
      Width = 235
      Height = 26
      Caption = 'Место для дополнительных параметров'#13#10'(в следующей версии)'
    end
    object btnYes: TButton
      Left = 352
      Top = 201
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 3
    end
    object btnCancel: TButton
      Left = 440
      Top = 201
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Отмена'
      ModalResult = 2
      TabOrder = 4
    end
    object memMain: TMemo
      Left = 11
      Top = 27
      Width = 220
      Height = 197
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      HideSelection = False
      ParentFont = False
      ScrollBars = ssHorizontal
      TabOrder = 0
      OnChange = memMainChange
      OnClick = memMainChange
      OnKeyUp = memMainKeyUp
    end
    object chkBoxB: TCheckBox
      Left = 243
      Top = 142
      Width = 277
      Height = 17
      Caption = 'Начиная с этого слова выделять блок слов'
      TabOrder = 2
      Visible = False
      OnClick = chkBoxBClick
    end
    object edtColor: TEdit
      Left = 432
      Top = 13
      Width = 19
      Height = 21
      TabStop = False
      Color = clBlack
      ReadOnly = True
      TabOrder = 5
    end
    object btnChangeColor: TButton
      Left = 454
      Top = 10
      Width = 59
      Height = 25
      Caption = 'Изменить'
      TabOrder = 1
      OnClick = btnChangeColorClick
    end
    object rbtnGeneral: TRadioButton
      Left = 248
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Обычный'
      Checked = True
      TabOrder = 6
      TabStop = True
      OnClick = rbtnGeneralClick
    end
    object rbtnGirn: TRadioButton
      Left = 360
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Жирный'
      TabOrder = 7
      OnClick = rbtnGirnClick
    end
    object chkLScob: TCheckBox
      Left = 243
      Top = 78
      Width = 294
      Height = 17
      Caption = 'Выделение при встрече символа "(" в начале'
      TabOrder = 8
      OnClick = chkLScobClick
    end
    object chkRScob: TCheckBox
      Left = 243
      Top = 99
      Width = 294
      Height = 17
      Caption = 'Выделение при встрече символа ")" в конце'
      TabOrder = 9
      OnClick = chkRScobClick
    end
  end
  object chkRazdel: TCheckBox
    Left = 249
    Top = 126
    Width = 272
    Height = 17
    Caption = 'Выделение в строке после встречи слова'
    TabOrder = 1
    Visible = False
    OnClick = chkRazdelClick
  end
  object cdlMain: TColorDialog
    Ctl3D = True
    Left = 206
    Top = 166
  end
end
