unit WordsParamsEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ToolWin, ComCtrls, Contnrs{, FlexCoolBar, RxCombos};

type
//  PRecColorWords = ^TRecColorWords;

  TRecColorWords = Record
    Color      : TColor;
    TypeFont   : Byte;
    Words      : String[254];
    SelectionR : Boolean;
    BSelString : Boolean;
    LScob      : Boolean;
    RScob      : Boolean;
  end;

type
  TWordsParamsEditor = class(TForm)
    pnlMain: TPanel;
    btnYes: TButton;
    btnCancel: TButton;
    memMain: TMemo;
    Label1: TLabel;
    cdlMain: TColorDialog;
    bvlMain: TBevel;
    chkBoxB: TCheckBox;
    edtColor: TEdit;
    Label2: TLabel;
    btnChangeColor: TButton;
    chkRazdel: TCheckBox;
    rbtnGeneral: TRadioButton;
    rbtnGirn: TRadioButton;
    Bevel1: TBevel;
    Label3: TLabel;
    Bevel2: TBevel;
    chkLScob: TCheckBox;
    Label4: TLabel;
    chkRScob: TCheckBox;
    procedure memMainChange(Sender: TObject);
    procedure btnChangeColorClick(Sender: TObject);
    procedure chkBoxBClick(Sender: TObject);
    procedure memMainKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkRazdelClick(Sender: TObject);
    procedure rbtnGeneralClick(Sender: TObject);
    procedure rbtnGirnClick(Sender: TObject);
    procedure chkLScobClick(Sender: TObject);
    procedure chkRScobClick(Sender: TObject);
  private
    flLoaded : Boolean;
    procedure GlobalIndexToRowString(GlobalNum : Integer;var StrNum, RowNum : Integer);
  public
    FList : TObjectList;
    procedure LoadData;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy;override;
  end;

{var
  WordsParamsEditor: TWordsParamsEditor;}

implementation

uses
   RichMemo;

{$R *.DFM}

const
   mArray : array[Boolean] of Integer = (1, 0);

constructor TWordsParamsEditor.Create(AOwner : TComponent);
begin
   inherited Create(AOwner);
   FList    := TObjectList.Create;
   flLoaded := False;
end;

destructor TWordsParamsEditor.Destroy;
var
   i : Integer;
begin
   if FList.Count > 0 then
      for i := FList.Count - 1 downto 0 do
         FList.Delete(i);
   FList.Free;
   inherited;
end;

procedure TWordsParamsEditor.LoadData;
var
   i, j : Integer;
begin
   with memMain.Lines do begin
      BeginUpdate;
      Clear;
      for i := 0 to FList.Count - 1 do Add(TColorWords(FList.Items[i]).Words);
      EndUpdate;
   end;
   memMain.SelStart := 0;
   GlobalIndexToRowString(memMain.SelStart, i, j);
   chkBoxB.Checked     := TColorWords(FList.Items[i]).BSelString;
   chkRazdel.Checked   := TColorWords(FList.Items[i]).SelectionR;
   chkLScob.Checked    := TColorWords(FList.Items[i]).LScob;
   chkRScob.Checked    := TColorWords(FList.Items[i]).RScob;
   edtColor.Color      := TColorWords(FList.Items[i]).Color;
   rbtnGeneral.Checked := TColorWords(FList.Items[i]).TypeFont = 0;
   rbtnGirn.Checked    := not rbtnGeneral.Checked;
   flLoaded            := True;
end;

procedure TWordsParamsEditor.GlobalIndexToRowString(GlobalNum : Integer;var StrNum, RowNum : Integer);
var
   flExit           : Boolean;
   sLength,
   LengthPredString : Integer;
begin
   flExit           := False;
   StrNum           := -1;
   RowNum           := 0;
   LengthPredString := 0;
   sLength          := 0;
   repeat
      Inc(StrNum);
      sLength := sLength + Length(memMain.Lines[StrNum]) + 2;
      if StrNum > 0 then LengthPredString := LengthPredString + Length(memMain.Lines[StrNum - 1]) + 2;
      if GlobalNum < sLength then begin
         flExit := True;
         RowNum := (GlobalNum + 1) - LengthPredString;
      end;
   until flExit;
end;

procedure TWordsParamsEditor.memMainChange(Sender: TObject);
var
   i, j, k : Integer;
   flFound : Boolean;
   mObject : TColorWords;
begin
   if flLoaded then begin
      GlobalIndexToRowString(memMain.SelStart, i, j);
      flFound := False;
      if FList.Count > 0 then
         for k := 0 to FList.Count - 1 do
           if k = i then begin
              flFound := True;
              Break;
           end;
      if flFound then begin
         edtColor.Color                    := TColorWords(FList.Items[k]).Color;
         TColorWords(FList.Items[k]).Words := Copy(memMain.Lines[i], 1, 254);
         chkBoxB.Checked                   := TColorWords(FList.Items[k]).BSelString;
         chkRazdel.Checked                 := TColorWords(FList.Items[k]).SelectionR;
         chkLScob.Checked                  := TColorWords(FList.Items[k]).LScob;
         chkRScob.Checked                  := TColorWords(FList.Items[k]).RScob;
         rbtnGeneral.Checked               := (TColorWords(FList.Items[k]).TypeFont = 0);
         rbtnGirn.Checked                  := not rbtnGeneral.Checked;
      end
      else begin
         mObject :=TColorWords.Create;
         with mObject do begin
            Color      := edtColor.Color;
            Words      := Copy(memMain.Lines[i], 1, 254);
            BSelString := chkBoxB.Checked;
            SelectionR := chkRazdel.Checked;
            LScob      := chkLScob.Checked;
            RScob      := chkLScob.Checked;
            TypeFont   := mArray[rbtnGeneral.Checked];
         end;
         FList.Add(mObject);
      end;
   end;
end;

procedure TWordsParamsEditor.btnChangeColorClick(Sender: TObject);
var
   i, j : Integer;
begin
   if cdlMain.Execute then begin
      edtColor.Color := cdlMain.Color;
      GlobalIndexToRowString(memMain.SelStart, i, j);
      TColorWords(FList.Items[i]).Color := cdlMain.Color;
   end;
end;

procedure TWordsParamsEditor.chkBoxBClick(Sender: TObject);
var
   i, j : Integer;
begin
   GlobalIndexToRowString(memMain.SelStart, i, j);
   TColorWords(FList.Items[i]).BSelString := chkBoxB.Checked;
end;

procedure TWordsParamsEditor.memMainKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   i, j : Integer;
begin
   inherited;
   GlobalIndexToRowString(memMain.SelStart, i, j);
   chkBoxB.Checked := TColorWords(FList.Items[i]).BSelString;
   edtColor.Color  := TColorWords(FList.Items[i]).Color;
end;

procedure TWordsParamsEditor.chkRazdelClick(Sender: TObject);
var
   i, j : Integer;
begin
   GlobalIndexToRowString(memMain.SelStart, i, j);
   TColorWords(FList.Items[i]).SelectionR := chkRazdel.Checked;
end;

procedure TWordsParamsEditor.rbtnGeneralClick(Sender: TObject);
var
   i, j : Integer;
begin
   rbtnGirn.Checked := not rbtnGeneral.Checked;
   GlobalIndexToRowString(memMain.SelStart, i, j);
   TColorWords(FList.Items[i]).TypeFont := mArray[rbtnGeneral.Checked];
end;

procedure TWordsParamsEditor.rbtnGirnClick(Sender: TObject);
var
   i, j : Integer;
begin
   rbtnGeneral.Checked := not rbtnGirn.Checked;
   GlobalIndexToRowString(memMain.SelStart, i, j);
   TColorWords(FList.Items[i]).TypeFont := mArray[rbtnGeneral.Checked];
end;

procedure TWordsParamsEditor.chkLScobClick(Sender: TObject);
var
   i, j : Integer;
begin
   GlobalIndexToRowString(memMain.SelStart, i, j);
   TColorWords(FList.Items[i]).LScob := chkLScob.Checked;
end;

procedure TWordsParamsEditor.chkRScobClick(Sender: TObject);
var
   i, j : Integer;
begin
   GlobalIndexToRowString(memMain.SelStart, i, j);
   TColorWords(FList.Items[i]).RScob := chkRScob.Checked;
end;

end.
