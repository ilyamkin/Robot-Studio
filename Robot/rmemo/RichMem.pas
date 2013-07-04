unit RichMemo;

interface


uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, WordsParamsEditor,
  Contnrs, Clipbrd, Menus;

type
  TRichMemo = class;

  TColorWords = class(TPersistent)
  private
    FColor      : TColor;
    FWords      : String;
    FBSelString : Boolean;
    FSelectionR : Boolean;
    FLScob      : Boolean;
    FRScob      : Boolean;
    FTypeFont   : Byte;
  public
    function IsEqual(aColorWords : TColorWords) : Boolean;
    function GetCountWord : Integer;
    function GetItem(Index : Integer) : String;
    property Words      : String             read FWords      write FWords;
    property Color      : TColor             read FColor      write FColor;
    property BSelString : Boolean            read FBSelString write FBSelString;
    property SelectionR : Boolean            read FSelectionR write FSelectionR;
    property LScob      : Boolean            read FLScob      write FLScob;
    property RScob      : Boolean            read FRScob      write FRScob;
    property TypeFont   : Byte               read FTypeFont   write FTypeFont;
    property CountWord  : Integer            read GetCountWord;
    property Items[Index : Integer] : String read GetItem;
  end;

  TCollectionColorWords = class(TPersistent)
  private
    FOwner              : TRichMemo;
    function GetColorWords(Index : Integer) : TColorWords;
    procedure SetColorWords(Index : Integer; Value : TColorWords);
    function GetCount : Integer;
    procedure ReadData(Stream : TStream);
    procedure ReadDataItem(Stream : TStream);
    procedure WriteData(Stream : TStream);
    procedure WriteDataItem(Stream : TStream; i : Integer);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    FList : TObjectList;
    procedure Clear;
    procedure Add(mColorWords : TColorWords);
    constructor Create(AOwner : TRichMemo);
    destructor Destroy; override;
    property OWner : TRichMemo read FOwner;
    property ColorWords[Index : Integer] : TColorWords read GetColorWords write SetColorWords;
    property CountColorWords : Integer read GetCount;
  end;

  TRichMemoStrings = class(TStrings)
  private
    RichMemo: TRichMemo;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    function GetTextStr: string; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetTextStr(const Value: string); override;
  public
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
  end;

  TRichMemo = class(TCustomControl)
  private
    FLines: TStrings;
    FBitmap:TBitmap;
    FColor : TColor;
    FDown : Boolean;
    FNotPaint     : Boolean;
    FAutoScroll   : Boolean;
    FBegSelection : Boolean;
    FHClick       : Boolean;
    FInsertMode   : Boolean;
    FRestrictCountCharInStr : Boolean;
    FOffset: TPoint;
    FPos          : TPoint;
    FPosBeforUndo : TPoint;
    FSelStart: TPoint;
    FSelEnd: TPoint;
    FTempPos: TPoint;
    FCharHeight: Integer;
    FCharWidth: Integer;
    FText: TStringList;
    FTextBeforUndo: TStringList;
    FMaxLength: Integer;
    FReadOnly: Boolean;
    FBusy: Boolean;
    FIsMonoType: Boolean;
    FVScroll: TScrollBar;
    FHScroll: TScrollBar;
    FScrollBars: TScrollStyle;
    FOldOffsetX: Integer;
    FCollectionColorWords : TCollectionColorWords;
    FOnChange  : TNotifyEvent;
    FOnExit    : TNotifyEvent;
    FPopupMenu : TPopupMenu;
    function GetSelText: String;
    function GetIndexPos(Pos: TPoint): Integer;
    function GetPosIndex(Pos: Integer): TPoint;
    function NumberCharInStr(X, Y : Integer) : Integer;
    function StrInSelection(j : Integer) : Boolean;
    function GetCountStringInWindow : Integer;
    function GetCountCharInString(j : Integer) : Integer;
    function FirstWordInStr(aStr : String) : String;
    function LastWordInStr(aStr : String) : String;
    function WordNeedSel(aWord : String; var aColor : TColor; var  aFontStyles : TFontStyles) : Boolean;
    function GetWidthBWord(ai, aj : Integer; aStr : String) : Integer;
    function GetWidthBWordInword(ai : Integer; aStr : String) : Integer;
    function WidthAllText(j : Integer) : Integer;
    function WidthText(j, ai : Integer) : Integer;
    function SubStrInSelArea(aSubStr : String; aPosSubStr : Integer; aStr : String; var aColor : TColor; var  aFontStyles : TFontStyles{; var ai : Integer}) : Boolean;
    function GetWidthText(aStr: String; aColor : TColor; aFontStyles : TFontStyles) : Integer;
    function FPosInSel : Boolean;
    procedure PasteFromClipboard;
    procedure PaintSelection;
    procedure ShowCaretPos;
    procedure AddSel;
    procedure SetSelText(Value: String);
    procedure DoChar(aChar: Char);
    procedure CalcSreenParams;
    procedure mTextOut(x, y, j : Integer);
    procedure DoInsert;
    procedure DoReturn;
    procedure DoLeft;
    procedure DoLeftWord;
    procedure DoRight;
    procedure DoRightWord;
    procedure DoUp;
    procedure DoDown;
    procedure DoHome(Ctrl: Boolean);
    procedure DoEnd(Ctrl: Boolean);
    procedure DoDel;
    procedure DoPgUp;
    procedure DoPgDn;
    procedure DoBackspace;
    procedure DoUndo;
    procedure SaveUndo;
    procedure ScrollEnter(Sender: TObject);
    procedure VScrollClick(Sender: TObject);
    procedure HScrollClick(Sender: TObject);
    procedure UpdateScrollBarS;
    procedure SetScrollBars(Value: TScrollStyle);
    procedure UpdateVScrollBar(ACountString : Integer);
    procedure SetLines(Value: TStrings);
    procedure SetCollectionColorWords(Value : TCollectionColorWords);
    procedure SetRestrictCountCharInStr(Value : Boolean);
    procedure SelWord(aStr : String; x, y, j : Integer);
    procedure SetColor(Value : TColor);
    procedure OprCancel(Sender: TObject);
    procedure OprCut(Sender: TObject);
    procedure OprCopy(Sender: TObject);
    procedure OprPaste(Sender: TObject);
    procedure OprDelete(Sender: TObject);
    procedure OprSelectAll(Sender: TObject);
    procedure RefreshPopupMenu;
    function RestrictCountChar(jb, je : Integer) : Boolean;
  protected
    // для того, чтобы компонент не терял фокус при нажатии управляющих клавиш
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSIZE(var Message : TMessage); message WM_SIZE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLBUTTONDBLCLK(var Message : TMessage); message WM_LBUTTONDBLCLK;
//WM_MBUTTONDBLCLK
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMMouseWheel(var Message: TMessage); message WM_MouseWheel;
//    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded;override;
    procedure Paint;override;
  public
    procedure ClearSelection;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure SelectAll;
    procedure Clear;
    procedure SetPos(x, y : Integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelText : String read GetSelText write SetSelText;
  published
    property Anchors;
    property Align;
    property AutoScroll : Boolean read FAutoScroll write FAutoScroll;
    property Lines : TStrings read FLines write SetLines;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssNone;
    property CollectionColorWords : TCollectionColorWords read FCollectionColorWords write SetCollectionColorWords;
    property RestrictCountCharInStr : Boolean read FRestrictCountCharInStr write SetRestrictCountCharInStr;
    property ColorWindow : TColor read FColor write SetColor;
    property Font;
    property TabStop default True;
    property OnKeyDown;
    property OnKeyPress;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property ReadOnly : Boolean read FReadOnly write FReadOnly;
    property TabOrder;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
    property OnExit : TNotifyEvent read FOnExit write FOnExit;
  end;

implementation

{$R RichMemo.res}

uses
   Math;

type
  THackScrollBar = class(TScrollBar)
  end;

var
   FMouseLock : Boolean;

function TColorWords.GetCountWord : Integer;
var
   i, j : Integer;
begin
   i := 0;
   j := 0;
   if (Length(Words) > 0) then
      repeat
         Inc(i);
         if (i = Length(FWords)) or (FWords[i] = ',') then Inc(j);
      until (i >= Length(FWords));
   Result := j;
end;

function TColorWords.GetItem(Index : Integer) : String;
var
   s    : String;
   i, j : Integer;
begin
   i := 0;
   j := 0;
   repeat
      Inc(i);
      if (FWords[i] = ',') or (i = Length(FWords)) then Inc(j);
   until (j = Index) or (i = Length(FWords));
   s := '';
   if Index <> 0 then Inc(i);
   repeat
      s := s + FWords[i];
      Inc(i);
   until (FWords[i] = ',') or (i - 1 = Length(FWords));
   Result := s;
end;

function TColorWords.IsEqual(aColorWords : TColorWords) : Boolean;
begin
   Result := (Color = aColorWords.Color) and (Words = aColorWords.Words) and (BSelString = aColorWords.FBSelString);
end;

procedure TRichMemo.SetColor(Value : TColor);
begin
   if Value <> FColor then begin
      FColor := Value;
      Color  := FColor;
      InValidate;
   end;
end;

procedure TRichMemo.SelectAll;
var
   i : Integer;
begin
   ClearSelection;
   FBegSelection := True;
   FTempPos.X    := 0;
   FTempPos.Y    := 0;
   i := 0;
   if FText.Count > 0 then i := FText.Count - 1;
   FPos.Y := i;
   if i > 0 then i := Length(FText[i]);
   FPos.X := i;
   AddSel;
   ShowCaretPos;
   if (FPos.X > 0) or (FPos.Y > 0) then begin
      FPopupMenu.Items[2].Enabled := True;
      FPopupMenu.Items[3].Enabled := True;
      FPopupMenu.Items[5].Enabled := True;
   end;
   FPopupMenu.Items[7].Enabled := False;
end;

procedure TRichMemo.Clear;
var
   i : Integer;
begin
   for i := FText.Count - 1 downto 0 do
      FText.Delete(i);
   FPos.X := 0;
   FPos.Y := 0;
   ShowCaretPos;
   FPopupMenu.Items[7].Enabled := True;
end;

procedure TRichMemo.SetCollectionColorWords(Value : TCollectionColorWords);
begin
   CollectionColorWords.Assign(Value);
end;

constructor TCollectionColorWords.Create(AOwner : TRichMemo);
var
   mObject : TColorWords;
begin
   inherited Create;
   FOwner  := AOwner;
   FList   := TObjectList.Create;
   mObject := TColorWords.Create;
   with mObject do begin
      Color      := clBlue;
      Words      := 'select,from,where,insert,into,update,and,union,values,decode,order,by,asc,desc,union,all,null,is';
      BSelString := False;
      SelectionR := False;
      LScob      := False;
      RScob      := False;
      TypeFont   := 1;
   end;
   FList.Add(mObject);
end;

procedure TCollectionColorWords.Add(mColorWords : TColorWords);
var
   mObject : TColorWords;
begin
   mObject := TColorWords.Create;
   with mObject do begin
      Color      := mColorWords.Color;
      Words      := AnsiUpperCase(mColorWords.Words);
      BSelString := mColorWords.BSelString;
      SelectionR := mColorWords.SelectionR;
      LScob      := mColorWords.LScob;
      RScob      := mColorWords.RScob;
      TypeFont   := mColorWords.TypeFont;
   end;
   FList.Add(mObject);
end;

function TCollectionColorWords.GetCount : Integer;
begin
   Result := FList.Count;
end;

destructor TCollectionColorWords.Destroy;
var
   i : Integer;
begin
   if FList.Count > 0 then
      for i := FList.Count - 1 downto 0 do
         FList.Remove(FList.Items[i]);
   FList.Free;
   inherited;
end;

function TCollectionColorWords.GetColorWords(Index : Integer) : TColorWords;
begin
   Result := TColorWords(FList[Index]);
end;

procedure TCollectionColorWords.Clear;
var
   i : Integer;
begin
   for i := FList.Count - 1 downto 0 do
      FList.Remove(FList.Items[i]);
end;

procedure TCollectionColorWords.SetColorWords(Index : Integer; Value : TColorWords);
var
   flFound : Boolean;
   mObject : TColorWords;
begin
   flFound := (Index <= FList.Count - 1);
   if flFound then begin
      TColorWords(FList.Items[Index]).Color      := Value.Color;
      TColorWords(FList.Items[Index]).Words      := AnsiUpperCase(Value.Words);
      TColorWords(FList.Items[Index]).BSelString := Value.BSelString;
      TColorWords(FList.Items[Index]).SelectionR := Value.SelectionR;
      TColorWords(FList.Items[Index]).LScob      := Value.LScob;
      TColorWords(FList.Items[Index]).RScob      := Value.RScob;
      TColorWords(FList.Items[Index]).TypeFont   := Value.TypeFont;
   end
   else begin
      mObject := TColorWords.Create;
      with mObject do begin
         Color      := Value.Color;
         Words      := AnsiUpperCase(Value.Words);
         BSelString := Value.BSelString;
         SelectionR := Value.SelectionR;
         LScob      := Value.LScob;
         RScob      := Value.RScob;
         TypeFont   := Value.TypeFont;
      end;
      FList.Add(mObject);
   end;
end;

procedure TCollectionColorWords.ReadData(Stream : TStream);
var
   Count, i : Integer;
begin
   for i := FList.Count - 1 downto 0 do FList.Delete(i);
   Stream.Position := 0;
   Stream.ReadBuffer(Count, SizeOf(Integer));
   for i := 0 to Count - 1 do
      ReadDataItem(Stream);
end;

procedure TCollectionColorWords.ReadDataItem(Stream : TStream);
var
   pColorWords : Pointer;
   mObject     : TColorWords;
begin
   GetMem(pColorWords, SizeOf(TRecColorWords));
   Stream.ReadBuffer(pColorWords^, SizeOf(TRecColorWords));
   mObject := TColorWords.Create;
   with mObject do begin
      Color      := TRecColorWords(pColorWords^).Color;
      Words      := AnsiUpperCase(TRecColorWords(pColorWords^).Words);
      BSelString := TRecColorWords(pColorWords^).BSelString;
      SelectionR := TRecColorWords(pColorWords^).SelectionR;
      TypeFont   := TRecColorWords(pColorWords^).TypeFont;
      LScob      := TRecColorWords(pColorWords^).LScob;
      RScob      := TRecColorWords(pColorWords^).RScob;
   end;
   FList.Add(mObject);
   FreeMem(pColorWords);
end;

procedure TCollectionColorWords.WriteDataItem(Stream : TStream; i : Integer);
var
   pColorWords : Pointer;
begin
   GetMem(pColorWords, SizeOf(TRecColorWords));
   TRecColorWords(pColorWords^).Color      := TColorWords(FList.Items[i]).Color;
   TRecColorWords(pColorWords^).Words      := AnsiUpperCase(TColorWords(FList.Items[i]).Words);
   TRecColorWords(pColorWords^).BSelString := TColorWords(FList.Items[i]).BSelString;
   TRecColorWords(pColorWords^).SelectionR := TColorWords(FList.Items[i]).SelectionR;
   TRecColorWords(pColorWords^).LScob      := TColorWords(FList.Items[i]).LScob;
   TRecColorWords(pColorWords^).RScob      := TColorWords(FList.Items[i]).RScob;
   TRecColorWords(pColorWords^).TypeFont   := TColorWords(FList.Items[i]).TypeFont;
   Stream.WriteBuffer(pColorWords^, SizeOf(TRecColorWords));
   FreeMem(pColorWords);
end;

procedure TCollectionColorWords.WriteData(Stream : TStream);
var
   i : Integer;
begin
   i := CountColorWords;
   Stream.WriteBuffer(i, SizeOf(Integer));
   for i := 0 to CountColorWords - 1 do
      WriteDataItem(Stream, i);
end;

procedure TCollectionColorWords.DefineProperties(Filer: TFiler);

   function WriteSetColorWords : Boolean;
   var
     CollectionColorWords : TCollectionColorWords;
     i                    : Integer;
   begin
      Result := False;
      CollectionColorWords := TCollectionColorWords(Filer.Ancestor);
      if (CollectionColorWords <> nil) and (CollectionColorWords.CountColorWords = CountColorWords) then
         for I := 0 to CountColorWords - 1 do  begin
            Result := not ColorWords[I].IsEqual(CollectionColorWords.ColorWords[I]);
            if Result then Break;
         end
     else Result := CountColorWords > 0;
   end;

begin
   inherited DefineProperties(Filer);
   Filer.DefineBinaryProperty('Data', ReadData, WriteData, WriteSetColorWords);
end;

procedure TRichMemo.SetRestrictCountCharInStr(Value : Boolean);
begin
   if (Value <> FRestrictCountCharInStr) then begin
      FRestrictCountCharInStr := Value;
      if Value then begin
         if (FScrollBars in [ssHorizontal]) then
            FScrollBars := ssNone
         else
            if (FScrollBars in [ssBoth]) then FScrollBars := ssVertical;
      end;
   end;
end;

procedure TRichMemo.SetLines(Value: TStrings);
begin
   FLines.Assign(Value);
   Paint;
end;

{procedure TRichMemo.CMEnter(var Message: TCMEnter);
begin
    inherited;
end;}

function TRichMemo.GetCountStringInWindow : Integer;
var
   i : Integer;
begin
   i := 0;
   if (not (csDesigning in ComponentState)) and FHScroll.Visible then i := FHScroll.Height;
   Result := (ClientHeight - i) div FCharHeight;
end;

procedure TRichMemo.SetScrollBars(Value: TScrollStyle);
begin
   if FScrollBars <> Value then begin
      FScrollBars := Value;
      RecreateWnd;
      if (FScrollBars in [ssBoth, ssHorizontal]) then FRestrictCountCharInStr := False;
   end;
end;

procedure TRichMemo.WMSIZE(var Message : TMessage);
begin
   FOffSet.X := 0;
   Invalidate;
   CalcSreenParams;
   if not (csDesigning in ComponentState) then UpdateScrollBars;
end;

procedure TRichMemo.WMLBUTTONDBLCLK(var Message : TMessage);
var
   PosX, PosY, i, l : Integer;
   fl : Boolean;
begin
   inherited;
   ClearSelection;
   Invalidate;
   with Message do begin
      PosX := LOWORD(lParam);
      PosY := HIWORD(lParam);
   end;
   i := NumberCharInStr(PosX, PosY);
   PosY := PosY div FCharHeight + FOffset.Y;
   // позиция символа, которая измеряется в целых номерах количествах символов (по вертикали и горизонтали)
   if PosY <= FText.Count - 1 then begin
      l           := Length(FText[PosY]);
      FSelStart.Y := PosY;
      FSelEnd.Y   := PosY;
      if i >= l then begin
         PosX        := l;
         FSelEnd.X   := PosX;
         // помечаем конец выделения PosX
         if PosX > 1 then begin
            fl := Ord(FText[PosY][PosX]) <> 32;
            repeat
               fl := fl or (Ord(FText[PosY][PosX]) <> 32);
               Dec(PosX);
            until (PosX < 1) or (fl and (Ord(FText[PosY][PosX]) = 32));
         end;
         FSelStart.X := PosX;
      end
      else begin
         if (Ord(FText[PosY][i]) = 32) then begin
            PosX      := i;
            FSelEnd.X := PosX;
            if PosX > 1 then begin
               fl := Ord(FText[PosY][PosX]) <> 32;
               repeat
                  fl := fl or (Ord(FText[PosY][PosX]) <> 32);
                  Dec(PosX);
               until (PosX < 1) or (fl and (Ord(FText[PosY][PosX]) = 32));
            end;
            FSelStart.X := PosX;
         end
         else begin
            PosX := i;
            while (i <= l)   and (Ord(FText[PosY][i]) <> 32)    do Inc(i);
            while (PosX > 0) and (Ord(FText[PosY][PosX]) <> 32) do Dec(PosX);
            FSelStart.X := PosX;
            FSelEnd.X   := i - 1;
         end;
      end;
   end;
   if FPosInSel then HideCaret(Handle);
   Paint;
end;

procedure TRichMemo.Loaded;
begin
   inherited;
   FBitmap.Width              := ClientWidth;
   FBitmap.Height             := ClientHeight;
   FBitmap.Canvas.Brush.Color := FColor;
   FBitmap.Canvas.Font        := Font;
   FBitmap.Canvas.Pen.Color   := Font.Color;
   FBitmap.Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
   FInsertMode                := False;
   Invalidate;
   if not (csDesigning in ComponentState) then UpdateScrollBarS;
end;

{вспомогательная функция}
function GetFontMetrics(Font : TFont) : TTextMetric;
var
   DC       : HDC;
   SaveFont : HFont;
begin
   DC       := GetDC(0);
   SaveFont := SelectObject(DC, Font.Handle);
   GetTextMetrics(DC, Result);
   SelectObject(DC, SaveFont);
   ReleaseDC(0, DC);
end;

{определение высоты Font на текущем экране}
function GetFontWidth(Font : TFont) : Integer;
begin
   Result := GetFontMetrics(Font).tmAveCharWidth;
end;

procedure TRichMemo.CalcSreenParams;
begin
   with Canvas do
   begin
      Font.Assign(Self.Font);
      Font.Style  := [];
      Font.Pitch  := fpFixed;
      FCharHeight := TextHeight('Wr');
      FCharWidth  := GetFontWidth(Font);
      FIsMonoType := Pos('COURIER NEW', AnsiUppercase(Canvas.Font.Name)) <> 0;
   end;
   if not (csDesigning in ComponentState) then begin
      FVScroll.Ctl3D := False;
      FHScroll.Ctl3D := False;
      FVScroll.SetBounds(Width - FVScroll.Width - 4, 0, FVScroll.Width, Height - 4);
   end;
end;

// для того, чтобы компонент не терял фокус при нажатии управляющих клавиш
procedure TRichMemo.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
   Message.Result := DLGC_WANTARROWS {что бы при нажатии стрелок фокус не терялся} or
                     DLGC_WANTALLKEYS {что бы реакция на Enter оставалась}{ or DLGC_WANTTAB};
end;

procedure TRichMemo.DoReturn;
var
   s, sp, sn : String;
begin
   SaveUndo;
   if FReadOnly then Exit;
   s  := FText[FPos.Y];
   sp := Copy(s, 1, FPos.X);
   sn := Copy(s, FPos.X + 1, Length(s) - FPos.X);
   FText[FPos.Y] := sp;
   FText.Insert(FPos.Y + 1, sn);
   if (FPos.Y >= GetCountStringInWindow - 1 + FOffset.Y) then Inc(FOffset.Y);
   SetPos(0, FPos.Y + 1);
end;

procedure TRichMemo.DoLeft;
begin
   Dec(FPos.X);
   if FPos.X < 0 then
      if FPos.Y > 0 then begin
         Dec(FPos.Y);
         FPos.X := Length(FText[FPos.Y]);
      end
      else
         FPos.X := 0;
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoLeftWord;
begin
   // здесь будут изменения
   Dec(FPos.X);
   if FPos.X < 0 then begin
      if FPos.Y > 0 then begin
         Dec(FPos.Y);
         FPos.X := Length(FText[FPos.Y]);
      end
      else
         FPos.X := 0;
   end
      else
         while (FPos.X > 0) and (FText[FPos.Y][FPos.X] <> ' ') do Dec(FPos.X);
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoRight;
begin
   Inc(FPos.X);
   if FPos.X > Length(FText[FPos.Y]) then begin
      if (FPos.Y = FText.Count - 1) and (Length(FText[FPos.Y]) > 0) then FText.Add('');
      if (FPos.Y < FText.Count - 1) then Inc(FPos.Y);
      FPos.X := 0;
   end;
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoRightWord;
var
   l : Integer;
begin
   Inc(FPos.X);
   l := Length(FText[FPos.Y]);
   if FPos.X > l then begin
      if (FPos.Y = FText.Count - 1) and (l > 0) then FText.Add('');
      if (FPos.Y < FText.Count - 1) then Inc(FPos.Y);
      FPos.X := 0;
   end
   else
      while (FPos.X < l) and (FText[FPos.Y][FPos.X + 1] <> ' ') do Inc(FPos.X);
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoUp;
begin
   Dec(FPos.Y);
   if FPos.Y < 0 then FPos.Y := 0;
   if FOffset.Y > FPos.Y then Dec(FOffset.Y);
   if (FPos.Y > GetCountStringInWindow - 1 + FOffset.Y) then FPos.y := GetCountStringInWindow - 1 + FOffset.Y;
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoDown;
begin
   Inc(FPos.Y);
   if FPos.Y > FText.Count - 1 then FPos.Y := FText.Count - 1;
   if (FPos.Y > GetCountStringInWindow - 1 + FOffset.Y) then Inc(FOffset.Y);
   if FPos.Y < FOffset.Y then FPos.Y := FOffSet.Y;
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoHome(Ctrl : Boolean);
begin
   if Ctrl then begin
      FOffSet.Y := 0;
      SetPos(0, 0);
   end
   else
      SetPos(0, FPos.Y);
end;

procedure TRichMemo.DoPgUp;
var
   i, j, k : Integer;
begin
   k := GetCountStringInWindow;
   j := FOffset.Y;

   if FPos.Y - k >= 0 then begin
      i := k;
      if FOffset.Y - k >= 0 then j := i;
   end
   else
      i := FPos.Y;
   Dec(FPos.Y, i);
   Dec(FOffSet.Y, j);
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoPgDn;
var
   i, j : Integer;
begin
   if FPos.Y + GetCountStringInWindow <= FText.Count then begin
      i := GetCountStringInWindow;
      j := i;
   end
   else begin
      i := FText.Count - FPos.Y;
      j := 0;
   end;
   Inc(FPos.Y, i);
   Inc(FOffSet.Y, j);
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.DoEnd(Ctrl : Boolean);
begin
   if Ctrl then begin
      FOffSet.Y := FText.Count - 1;
      if FOffSet.Y > 1 then Dec(FOffSet.Y);
      SetPos(Length(FText[FText.Count - 1]), FText.Count - 1);
   end
   else
      SetPos(Length(FText[FPos.Y]), FPos.Y);
end;

procedure TRichMemo.SaveUndo;
begin
   FTextBeforUndo.Text := FText.Text;
   FPosBeforUndo       := FPos;
end;

procedure TRichMemo.DoDel;
var
   s             : String;
   i             : Integer;
   pLeft, pRight : TPoint;
begin
   SaveUndo;
   if (FSelStart.X = FSelEnd.X) and (FSelStart.Y = FSelEnd.Y) then begin
   s := FText[FPos.Y];
   if (FPos.X < Length(s)) then begin
      Delete(s, FPos.X + 1, 1);
      FText[FPos.Y] := s;
   end
   else
      if (FPos.Y + 1 < FText.Count) then begin
         FText[FPos.Y] := s + FText[FPos.Y + 1];
         FText.Delete(FPos.Y + 1);
      end;
   end
   else begin
      if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
         pLeft  := FSelStart;
         pRight := FSelEnd;
      end
      else begin
         pLeft  := FSelEnd;
         pRight := FSelStart;
      end;
      i := GetIndexPos(pLeft); // начинается с первого символа
      s := FText.Text;
      Delete(s, i, GetIndexPos(pRight) - i);
      FText.Text  := s;
      FPos        := pLeft;
      FSelStart.X := 0;
   end;
   ClearSelection;
   if FRestrictCountCharInStr then RestrictCountChar(FPos.Y, FPos.Y);
   SetPos(FPos.X, FPos.Y);
   RefreshPopupMenu;
end;

procedure TRichMemo.DoBackspace;
var
   s, st         : String;
   i             : Integer;
   pLeft, pRight : TPoint;
begin
   SaveUndo;
   if (FSelStart.X = FSelEnd.X) and (FSelStart.Y = FSelEnd.Y) then begin
      s := FText[FPos.Y];
      if FPos.X = 0 then begin
         if FPos.Y > 0 then begin
            Dec(FPos.Y);
            FPos.X := Length(FText[FPos.Y]);
            st := FText[FPos.Y];
            FText[FPos.Y] := FText[FPos.Y] + s;
            FText.Delete(FPos.Y + 1);
         end;

      end
      else begin
         Delete(s, FPos.X, 1);
         FText[FPos.Y] := s;
         st := Copy(FText[FPos.Y], 1, FPos.X - 1);
         Dec(FPos.X);
      end;
   end
   else begin
      if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
         pLeft  := FSelStart;
         pRight := FSelEnd;
      end
      else begin
         pLeft  := FSelEnd;
         pRight := FSelStart;
      end;
      i := GetIndexPos(pLeft); // начинается с первого символа
      s := FText.Text;
      Delete(s, i, GetIndexPos(pRight) - i);
      FText.Text  := s;
      FPos        := pLeft;
      FSelStart.X := 0;
   end;
   ClearSelection;
   SetPos(FPos.X, FPos.Y);
   RefreshPopupMenu;
end;

procedure TRichMemo.DoInsert;
begin
   SaveUndo;
   FInsertMode := not FInsertMode;
   RefreshPopupMenu;
end;

procedure TRichMemo.DoUndo;
var
   s : String;
   t : TPoint;
begin
   s                   := FText.Text;
   t                   := FPos;
   FText.Text          := FTextBeforUndo.Text;
   FTextBeforUndo.Text := s;
   FPos                := FPosBeforUndo;
   FPosBeforUndo       := t;
   SetPos(FPos.X, FPos.Y);
   RefreshPopupMenu;
end;

procedure TRichMemo.CopyToClipboard;
begin
   Clipboard.AsText := SelText;
end;

procedure TRichMemo.CutToClipboard;
begin
   Clipboard.AsText := SelText;
   SelText := '';
   RefreshPopupMenu;
end;

procedure TRichMemo.PasteFromClipboard;
begin
   SelText := Clipboard.AsText;
   RefreshPopupMenu;
end;

procedure TRichMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
   inherited;
   FTempPos := FPos;
   FPopupMenu.Items[0].Enabled := True;
   case Key of
      vk_Insert:
         if (ssCtrl in Shift) then
            CopyToClipboard
         else
            if ssShift in Shift then begin
               if not FReadOnly then PasteFromClipboard;
               Paint;
            end
            else
               if not FReadOnly then DoInsert;

      vk_Left:
         if (ssCtrl in Shift) then
            DoLeftWord
         else
            DoLeft;

      vk_Right:
         if (ssCtrl in Shift) then
            DoRightWord
         else
            DoRight;

      vk_Up:
         DoUp;

      vk_Down:
         DoDown;

      vk_Home:
         DoHome(ssCtrl in Shift);

      vk_End:
         DoEnd(ssCtrl in Shift);

      vk_Delete:
        if not FReadOnly then begin
           if ssShift in Shift then
              CutToClipboard
           else
              DoDel;
        end;

      vk_Back:
         if not FReadOnly then DoBackspace;

      vk_Prior:
         DoPgUp;

      vk_Next:
         DoPgDn;

      vk_Return:
         if (Shift = []) and (not FReadOnly) then DoReturn;

   end;

   if Key in [vk_Left, vk_Right, vk_Up, vk_Down, vk_Home, vk_End, vk_Prior, vk_Next] then begin
      if (FSelStart.X = FSelEnd.X) and (FSelStart.Y = FSelEnd.Y) then FBegSelection := True;
      if ssShift in Shift then
         AddSel
      else
         ClearSelection;
   end;
//  if (ssCtrl in Shift) then begin
//     if (Key = vk_Left)  then DoLeftWord;
//     if (Key = vk_Right) then DoRightWord;
//  end;

   if (ssCtrl in Shift) and (Key = 90) and (not FReadOnly) then DoUndo;
   FPopupMenu.Items[2].Enabled := False;
   FPopupMenu.Items[3].Enabled := False;
   FPopupMenu.Items[5].Enabled := False;
   FPopupMenu.Items[7].Enabled := True;
end;

procedure TRichMemo.RefreshPopupMenu;
begin
   FpopupMenu.Items[7].Enabled := (FText.Count > 1) or ((FText.Count = 1) and (Length(FText[0]) > 0));
end;


procedure TRichMemo.KeyPress(var Key: Char);
begin
   inherited;
//   if Assigned(FOnKeyPress) then FOnKeyPress(Self);
   case Key of
      #32..#255 : begin
         DoChar(Key);
         RefreshPopupMenu;
      end;
   end;
end;

function TRichMemo.GetSelText : String;
var
   s             : String;
   i, j, l       : Integer;
   pLeft, pRight : TPoint;
begin
   s := '';
   if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
      pLeft  := FSelStart;
      pRight := FSelEnd;
   end
   else begin
      pLeft  := FSelEnd;
      pRight := FSelStart;
   end;

   for i := pLeft.Y to pRight.Y do begin
      j := 0;

      if i = pLeft.Y  then j := pLeft.X;
      l := Length(FText[i]);
      if i = pRight.Y then l := pRight.X;

      s := s + Copy(FText[i], j + 1, l - j) + #13#10;
   end;
   if Length(s) > 1 then system.Delete(s, Length(s) - 1, 2);
   Result := s;
end;

function TRichMemo.GetIndexPos(Pos: TPoint): Integer;
var
   i: Integer;
begin
   Result := 0;
   for i := 0 to Pos.Y - 1 do
      if FText.Count - 1 >= i then Result := Result + Length(FText[i]) + 2;
   Result := Result + Pos.X + 1;
end;

function TRichMemo.GetPosIndex(Pos: Integer): TPoint;
// нумерация Result обязательно начинается с нуля, а Pos (глобальный перебор с 1)
var
   i, l : Integer;
   s    : String;
begin
   Result := Point(0, 0);
   s := FText.Text;
   l := Length(s);
   i := 1;
   while (i < Pos) and (i <=l) do
      if s[i] = #13 then begin
         Inc(i, 2);
         if i < Pos then begin
            Inc(Result.Y);
            Result.X := 0;
         end
         else
            Inc(Result.X);
      end
      else begin
         Inc(i);
         Inc(Result.X);
      end;
end;

// определение количества символов, которое умещается в видимую часть
function TRichMemo.GetCountCharInString(j : Integer) : Integer;
var
   i, w, kw, l  : Integer;
   flWidthB     : Boolean;
   s, sv, sl    : String;
   mColor,
   aColor       : TColor;
   mFontStyles,
   aFontStyles  : TFontStyles;
begin
   i  := 0;
   w  := 0;
   kw := ClientWidth;
   s  := '';
   flWidthB := False;
   if j <= -1 then begin
      Result := 0;
      Exit;
   end;

   if j > Ftext.Count - 1 then begin
      Result := 0;
      Exit;
   end;

   if (FOffSet.X > 0) and (Length(FText[j]) > 0) then
      sl := LastWordInStr(Copy(FText[j], 1, FOffSet.X));

   if Assigned(FVScroll) and FVScroll.Visible then kw := kw - FVScroll.Width;
   if (j > -1) and (j <= FText.Count - 1) and (Length(FText[j]) > 0) and (i + FOffset.X <= Length(FText[j]) - 1) then
      repeat
         Inc(i);

         s  := s + FText[j][FOffset.X + i];
         sv := Copy(s, 1, Length(s) - 1);
         if (i + FOffset.X = Length(FText[j])) and (Ord(FText[j][FOffset.X + i]) <> 32) then sv := s;

         if (Ord(FText[j][FOffset.X + i]) = 32) or (i + FOffset.X = Length(FText[j])) then begin
            if (Length(sv) > 0) then begin
               if (WordNeedSel(sv, aColor, aFontStyles)) or
                  ((i = Length(sv) + 1) and WordNeedSel(sl + sv, aColor, aFontStyles)) then begin
                  l := Length(sv);
                  while (l > 0) and (sv[1] = '(') do begin
                     system.Delete(sv, 1, 1);
                     Dec(l);
                     w := w + FBitMap.Canvas.TextWidth('(');
                  end;
                  while (l > 0) and (s[l] = ')') do begin
                     system.Delete(sv, l, 1);
                     Dec(l);
                     w := w + FBitMap.Canvas.TextWidth(')');
                  end;

                  mColor      := FBitMap.Canvas.Font.Color;
                  mFontStyles := FBitMap.Canvas.Font.Style;
                  FBitMap.Canvas.Font.Color := aColor;
                  FBitMap.Canvas.Font.Style := aFontStyles;
                  w := w + FBitmap.Canvas.TextWidth(sv);
                  FBitMap.Canvas.Font.Color := mColor;
                  FBitMap.Canvas.Font.Style := mFontStyles;
               end
               else
                  w := w + FBitmap.Canvas.TextWidth(sv);
            end;
            s := '';
            if (Ord(FText[j][FOffset.X + i]) = 32) then w := w + FBitMap.Canvas.TextWidth(' ');
         end;
         flWidthB := (w + 4 >= kw);

      until flWidthB or (i + FOffset.X > Length(FText[j]) - 1);
      while flWidthB do begin
         mColor      := FBitMap.Canvas.Font.Color;
         mFontStyles := FBitMap.Canvas.Font.Style;
         FBitMap.Canvas.Font.Color := aColor;
         FBitMap.Canvas.Font.Style := aFontStyles;
         w := w - FBitmap.Canvas.TextWidth(FText[j][i]);
         FBitMap.Canvas.Font.Color := mColor;
         FBitMap.Canvas.Font.Style := mFontStyles;
         flWidthB := (w + 4 >= kw);
         Dec(i)
      end;
   Result := i;
end;

function TRichMemo.FirstWordInStr(aStr : String) : String;
var
   i, l : Integer;
   s    : String;
begin
   Result := '';
   l := Length(aStr);
   if l = 0 then Exit;
   s := '';
   i := 1;
   repeat
      s := s + aStr[i];
      Inc(i);
   until (i > l) or (Ord(aStr[i]) = 32);
   Result := Trim(s);
end;

function TRichMemo.LastWordInStr(aStr : String) : String;
var
   i : Integer;
   s : String;
begin
   Result := '';
   if Length(aStr) = 0 then Exit;
   s := '';
   i := Length(aStr);
   repeat
      s := aStr[i] + s;
      Dec(i);
   until (i = 0) or (Ord(aStr[i]) = 32);
   Result := Trim(s);
end;

function TRichMemo.WordNeedSel(aWord : String; var aColor : TColor; var aFontStyles : TFontStyles) : Boolean;
var
   i, l      : Integer;
   sWord, st : String;
   fr, fl    : Boolean;
begin
   Result := False;
   st     := AnsiUpperCase(aWord);
   sWord  := ',' + st + ',';
   l      := Length(st);
   if l > 1 then begin
      fl := (st[1] = '(');
      fr := (st[l] = ')');
      while (l > 0) and (st[1] = '(') do begin
         system.Delete(st, 1, 1);
         Dec(l);
      end;
      while (l > 0) and (st[l] = ')') do begin
         system.Delete(st, l, 1);
         Dec(l);
      end;
   end;
   for i := 0 to CollectionColorWords.CountColorWords - 1 do begin
      if (Length(CollectionColorWords.ColorWords[i].Words) > 0) and
         ((Pos(sWord, ',' + CollectionColorWords.ColorWords[i].Words + ',') > 0) or
         (CollectionColorWords.ColorWords[i].LScob and fl and (Pos(',' + st + ',', ',' + CollectionColorWords.ColorWords[i].Words + ',') > 0)) or
         (CollectionColorWords.ColorWords[i].RScob and fr and (Pos(',' + st + ',', ',' + CollectionColorWords.ColorWords[i].Words + ',') > 0))) then begin
         aFontStyles := [];
         if CollectionColorWords.ColorWords[i].TypeFont = 1 then aFontStyles := [fsBold];
         aColor := CollectionColorWords.ColorWords[i].Color;
         Result := True;
         Exit;
      end;
   end;
end;

function TRichMemo.GetWidthText(aStr : String; aColor : TColor; aFontStyles : TFontStyles) : Integer;
var
   mColor      : TColor;
   mFontStyles : TFontStyles;
   s           : String;
   w, l        : Integer;
begin
   s := aStr;
   w := 0;
   l := Length(aStr);
   while (l > 0) and (s[1] = '(') do begin
      system.Delete(s, 1, 1);
      Dec(l);
      w := w + FBitMap.Canvas.TextWidth('(');
   end;
   while (l > 0) and (s[l] = ')') do begin
      system.Delete(s, l, 1);
      Dec(l);
      w := w + FBitMap.Canvas.TextWidth(')');
   end;
   if (l > 0) then begin
      mColor                    := FBitMap.Canvas.Font.Color;
      mFontStyles               := FBitMap.Canvas.Font.Style;
      FBitMap.Canvas.Font.Color := aColor;
      FBitMap.Canvas.Font.Style := aFontStyles;
      w                         := w + FBitMap.Canvas.TextWidth(s);
      FBitMap.Canvas.Font.Color := mColor;
      FBitMap.Canvas.Font.Style := mFontStyles;
   end;
   Result := w;
end;

// возвращает значение, которое соответствует началу слова (в пикселах на канве) aSubStr в слове aStr
function TRichMemo.GetWidthBWord(ai, aj : Integer; aStr : String) : Integer;
// ai - конец слова aSubStr в строке aStr
var
   i, w, k, l, m, lv        : Integer;
   s, sv, sl, mSubStr       : String;
   mColor, aColor           : TColor;
   mFontStyles, aFontStyles : TFontStyles;
begin
   i       := ai;
   w       := 0;
   s       := '';
   mSubStr := '';
   while ((i > 0) and (aStr[i] <> ' ')) do begin
      mSubStr := aStr[i] + mSubStr;
      Dec(i);
   end;
   i := 0;
   l := Length(aStr);
   k := Length(mSubStr) - 1;
   m := 0;
   while i < ai - k do begin
      Inc(i);
      s := s + aStr[i];
      sv := Copy(s, 1, Length(s) - 1);
      if (Ord(aStr[i]) = 32) or (i > ai - k) then begin
         lv := Length(sv);
         if (lv > 0) then begin
            mColor      := FBitMap.Canvas.Font.Color;
            mFontStyles := FBitMap.Canvas.Font.Style;
            sl := '';
            if (FOffSet.X <> 0) and (m = 0) and (Ord(sv[1]) <> 32) then
               while (m < FOffSet.X) and (Ord(FText[aj][FOffSet.X - m]) <> 32) do begin
                  sl := FText[aj][FOffSet.X - m] + sl;
                  Inc(m);
               end;

            if WordNeedSel(sl + sv, aColor, aFontStyles) then begin
               while (Pos('(', sv) = 1) do begin
                  system.Delete(sv, Pos('(', sv), 1);
                  w := w + FBitMap.Canvas.TextWidth('(');
                  Dec(lv);
               end;
               while (lv > 0) and (sv[lv] =')') do begin
                  system.Delete(sv, Pos(')', sv), 1);
                  w := w + FBitMap.Canvas.TextWidth(')');
                  Dec(lv);
               end;

               FBitMap.Canvas.Font.Color := aColor;
               FBitMap.Canvas.Font.Style := aFontStyles;
            end;
            w := w + FBitMap.Canvas.TextWidth(sv);
            FBitMap.Canvas.Font.Color := mColor;
            FBitMap.Canvas.Font.Style := mFontStyles;
         end;

         if (l > 1) and (aStr[i] <> '(') and (aStr[i] <> ')') then w := w + FBitMap.Canvas.TextWidth(' ');
         s := '';
      end;
   end;
   Result := w;
end;

// нумерация с нуля (первый символ)
function TRichMemo.SubStrInSelArea(aSubStr : string; aPosSubStr : Integer; aStr : String; var aColor : TColor; var  aFontStyles : TFontStyles{; var ai : Integer}) : Boolean;
var
   i      : Integer;
   sl, sr : String;
begin
   sl := '';
   sr := '';
   i := aPosSubStr;
   while (i > 0) and (Ord(aStr[i]) <> 32) do begin
      sl := aStr[i] + sl;
      Dec(i);
   end;

   i := aPosSubStr + Length(aSubStr);
   while (i < Length(aStr)) and (Ord(aStr[i + 1]) <> 32) do begin
      Inc(i);
      sr := sr + aStr[i];
   end;

   Result := WordNeedSel(sl + aSubStr + sr, aColor, aFontStyles);
end;

// возвращает значение, которое соответствует началу символа в пикселах (на Канве)
// aStr - строка, ai - равен номер символа до которого включительно подсчитывается ширина(c нуля)
function TRichMemo.GetWidthBWordInword(ai : Integer; aStr : String) : Integer;
var
   i, w, k : Integer;
   s, sv   : String;
   mColor, aColor           : TColor;
   mFontStyles, aFontStyles : TFontStyles;
begin
   i := FOffSet.X;
   w := 0;
   s := '';
   if ai <= Length(aStr) then
      while (i < ai) do begin
         Inc(i);
         s := s + aStr[i];
         sv := Copy(s, 1, Length(s) - 1);
         k  := i - 1;
         if (i = ai) and (Ord(aStr[i]) <> 32) then begin
            sv := s;
            k := i;
         end;

         if (Ord(aStr[i]) = 32) or (i = ai) then begin
            if (Length(sv) > 0) then begin
               mColor      := FBitMap.Canvas.Font.Color;
               mFontStyles := FBitMap.Canvas.Font.Style;
               if SubStrInSelArea(sv, k - Length(sv), aStr, aColor, aFontStyles) then begin
                  while (Pos('(', sv) = 1) do begin
                     system.Delete(sv, Pos('(', sv), 1);
                     w := w + FBitMap.Canvas.TextWidth('(');
                  end;
                  while (Length(sv) > 0) and (Pos(')', sv) = Length(sv)) do begin
                     system.Delete(sv, Pos(')', sv), 1);
                     w := w + FBitMap.Canvas.TextWidth(')');
                  end;

                  FBitMap.Canvas.Font.Color := aColor;
                  FBitMap.Canvas.Font.Style := aFontStyles;
               end;
               w := w + FBitMap.Canvas.TextWidth(sv);
               FBitMap.Canvas.Font.Color := mColor;
               FBitMap.Canvas.Font.Style := mFontStyles;
            end;
            if (Ord(aStr[i])= 32) then w := w + FBitMap.Canvas.TextWidth(' ');
            s := '';
         end;
      end;
   Result := w;
end;

procedure TRichMemo.SelWord(aStr : String; x, y, j : Integer);
var
   i, k, w, l    : Integer;
   s, sv, sl, sr : String;
   mColor,
   aColor        : TColor;
   mFontStyles,
   aFontStyles   : TFontStyles;
begin
   sl := '';
   sr := '';
   if (FOffSet.X > 0) and (Length(aStr) > 0) then
      sl := LastWordInStr(Copy(FText[j], 1, FOffSet.X));
   if (FOffSet.X + GetCountCharInString(j) < Length(FText[j])) then
      sr := FirstWordInStr(Copy(FText[j], FOffSet.X + GetCountCharInString(j) + 1, Length(FText[j]) - (FOffSet.X + GetCountCharInString(j))));
   i := 0;
   s := '';
   while i < Length(aStr) do begin
      Inc(i);
      s  := s + aStr[i];
      sv := Copy(s, 1, Length(s) - 1);
      k  := i - 1;
      if (i = Length(aStr)) and (Ord(aStr[i]) <> 32) then begin
         sv := s;
         k  := i;
      end;
      if (Ord(aStr[i]) = 32) or (i = Length(aStr)) then begin
         if Length(sv) > 0 then begin
            if (WordNeedSel(sv, aColor, aFontStyles)) or
               ((i = Length(sv) + 1) and WordNeedSel(sl + sv, aColor, aFontStyles)) or
               ((i = Length(aStr)) and WordNeedSel(sv + sr, aColor, aFontStyles)) then begin

               l := 0;
               w := GetWidthBWord(k, j, aStr);

               while Pos('(', sv) = 1 do begin
                  system.Delete(sv, 1, 1);
                  FBitmap.Canvas.TextOut(x + w + l, y, '(');
                  l := l + FBitMap.Canvas.TextWidth('(');
               end;
               while (Length(sv) > 0) and (sv[Length(sv)] = ')') do begin
                  system.Delete(sv, Length(sv), 1);
                  FBitmap.Canvas.TextOut(x + w + l + GetWidthText(sv, aColor, aFontStyles), y, ')');
               end;

               mColor      := FBitMap.Canvas.Font.Color;
               mFontStyles := FBitMap.Canvas.Font.Style;
               FBitMap.Canvas.Font.Color := aColor;
               FBitMap.Canvas.Font.Style := aFontStyles;
               FBitmap.Canvas.TextOut(x + w + l, y, sv);
               FBitMap.Canvas.Font.Color := mColor;
               FBitMap.Canvas.Font.Style := mFontStyles;

            end
            else
               FBitmap.Canvas.TextOut(x + GetWidthBWord(k, j, aStr), y, sv);
         end;
         s := '';
      end;
   end;
end;

procedure TRichMemo.mTextOut(x, y, j : Integer);
var
   p      : Integer;
   s, so  : String;
   pLeft,
   pRight : TPoint;
   pRect  : TRect;
begin
   p  := GetCountCharInString(j);
   s  := Copy(TrimRight(FText[j]), 1 + FOffset.X, p);
   so := s;
   if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
      pLeft  := FSelStart;
      pRight := FSelEnd;
   end
   else begin
      pLeft  := FSelEnd;
      pRight := FSelStart;
   end;

   if not StrInSelection(j) then begin
      with pRect do begin
         Left   := x;
         Top    := y;
         Right  := Width;
         Bottom := y + FCharHeight;
      end;
      FBitmap.Canvas.FillRect(pRect);
   end
   else // для выделения
      if (j = pLeft.Y) and (j = pRight.Y) then begin
         s := Copy(s, 1, pLeft.X);
         s := TrimRight(FText[j]);
         // здесь требуется определить сколько символов на экран влазиет
         s := Copy(s, pRight.X + 1, p - (pRight.X - FOffset.X));
      end
      else
         if (j = pLeft.Y) and ((pLeft.X <> pRight.X) or (pLeft.Y <> pRight.Y)) then begin // если строка j равна первой строке выделения
            p := pLeft.X;
            s := Copy(s, 1, p);
         end
         else
            if (j = pRight.Y) and ((pLeft.X <> pRight.X) or (pLeft.Y <> pRight.Y)) then begin
               p := pRight.X + 1;
               s := Copy(s, p, Length(FText[j]) - p + 1);
            end;
   SelWord(so, x, y, j);
end;

// отображение при выделении
procedure TRichMemo.PaintSelection;
var
   p1, TSelStart, pLeft, pRight   : TPoint;
   i, j, k, w, l, n, ls,
               NumStrSel, SelEndX : Integer;
   sl ,sr, sv, s, ss              : String;
   mColor, mBColor, aColor        : TColor;
   mFontStyles,
   aFontStyles                    : TFontStyles;
   ffw, flw                       : Boolean;
begin
   if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
      pLeft  := FSelStart;
      pRight := FSelEnd;
   end
   else begin
      pLeft  := FSelEnd;
      pRight := FSelStart;
   end;

// VColor    := Font.Color;
   NumStrSel := (pRight.Y - pLeft.Y);
   if (FText.Count > max(pLeft.Y, pRight.Y)) and ((pRight.X <> pLeft.X) or (pRight.Y <> pLeft.Y)) then
      for i := 0 to NumStrSel do
         with FBitmap.Canvas do begin
            // определяем номера выделений для каждой строки
            TSelStart.X := FOffset.X;
            TSelStart.Y := pLeft.Y + i;
            SelEndX     := Length(FText[TSelStart.Y]); // номер последней выделенной буквы в строке
            if i = 0         then TSelStart.X := pLeft.X;
            if i = NumStrSel then SelEndX     := pRight.X;
            // теперь в пикселах
            p1.Y := FCharHeight * (TSelStart.Y - FOffset.Y);

            // обозначаем левое слово с лева от начала выделения и правое с права от конца выделения
            sl := '';
            sr := '';
            if (Length(FText[TSelStart.Y]) > 0) and
               (Length(FText[TSelStart.Y]) >= TSelStart.X) then
               sl := LastWordInStr(Copy(FText[TSelStart.Y], 1, TSelStart.X));
            if (SelEndX + 1 <= Length(FText[TSelStart.Y])) then
               sr := FirstWordInStr(Copy(FText[TSelStart.Y], SelEndX + 1, Length(FText[TSelStart.Y]) - SelEndX));

            j   := TSelStart.X;
            s   := '';
            ffw := True; // признак того, что слово является первым (рассматривается только выделенная часть)
            while j < SelEndX do begin // перебор символов в строке
               Inc(j);
               flw := (j = SelEndX); // признак того, что слово является последним из выделяемой строки (рассматривается только выделенная часть)
               s   := s + FText[TSelStart.Y][j];
               sv  := Copy(s, 1, Length(s) - 1);
               k   := j - 1;
               if (j = SelEndX) and (Ord(FText[TSelStart.Y][j]) <> 32) then begin
                  sv := s;
                  k  := j;
               end;
               if (Ord(FText[TSelStart.Y][j]) = 32) or (j = SelEndX) then begin
                  mColor      := Font.Color;
                  mBColor     := Brush.Color;
                  Font.Color  := clWhite;
                  Brush.Color := clActiveCaption;
                  ss          := FText[TSelStart.Y];
                  if Length(sv) > 0 then begin // работаем с каждым словом
                     if (flw and ffw and WordNeedSel(sl + sv + sr, aColor, aFontStyles)) or
                        (ffw and WordNeedSel(sl + sv, aColor, aFontStyles)) or
                        (flw and WordNeedSel(sv + sr, aColor, aFontStyles)) or
                        WordNeedSel(sv, aColor, aFontStyles) then begin
                        l  := Length(sv);
                        n  := 0;
                        w  := GetWidthBWordInWord(k - l, ss);
                        while (Pos('(', sv)) = 1 do begin
                           FBitmap.Canvas.TextOut(2 + w + n, p1.Y, '(');
                           n := n + FBitMap.Canvas.TextWidth('(');
                           system.Delete(sv, 1, 1);
                        end;
                        ls := Length(sv);
                        while ( ls > 0) and (sv[ls] = ')') do begin
                           system.Delete(sv, ls, 1);
                           Dec(ls);
                           FBitmap.Canvas.TextOut(2 + w + n + GetWidthText(sv, aColor, aFontStyles), p1.y, ')');
                        end;
                        if Length(sv) > 0 then begin
                           mFontStyles := Font.Style;
                           Font.Style  := aFontStyles;
                           TextOut(2 + w + n, p1.Y, sv);
                           Font.Style  := mFontStyles;
                        end;
                     end
                     else
                        FBitmap.Canvas.TextOut(2 + GetWidthBWordInword(k - Length(sv), ss), p1.y, sv);
                  end;
                  s := '';
                  if (Ord(FText[TSelStart.Y][j]) = 32) then FBitmap.Canvas.TextOut(2 + GetWidthBWordInword(j - 1, ss), p1.y, ' ');
                  Brush.Color := mBColor;
                  Font.Color  := mColor;
                  ffw         := False;
               end;
            end;
         end;
end;

function TRichMemo.StrInSelection(j : Integer) : Boolean;
begin
   if (FSelStart.Y = FSelEnd.Y) and (FSelStart.X = FSelEnd.X)  then
      Result := False
   else
      Result := (j >= min(FSelStart.Y, FSelEnd.Y)) and (j <= max(FSelEnd.Y, FSelStart.Y));
end;

procedure TRichMemo.Paint;
var
   i, j   : Integer;
   VColor : TColor;
begin
   // возможно inherited нужно убрать
   inherited;
   FBitMap.Canvas.Font.Color  := Font.Color;
   FBitMap.Canvas.Font.Size   := Font.Size;
   FBitMap.Canvas.Brush.Color := FColor;
   Color                      := FColor;
   i := 0;
   j := 0;
   if (not (csDesigning in ComponentState)) then begin
      if FVScroll.Visible then  i := FVScroll.Width;
      if FHScroll.Visible then  j := FHScroll.Height;
   end;
   FBitmap.Width  := ClientWidth  - i;
   FBitmap.Height := ClientHeight - j;
   FBitmap.Canvas.FillRect(FBitmap.Canvas.ClipRect);
   i := -1;
   if not (csDesigning in ComponentState) then begin
      if (i + FOffSet.Y <= FText.Count - 1) then
         repeat
            Inc(i);
            if (i + FOffSet.Y <= FText.Count - 1) then
               mTextOut(2, FCharHeight * i, i + FOffSet.Y);
         until (i = GetCountStringInWindow) or (i + FOffSet.Y = FText.Count - 1);
      PaintSelection;
      Canvas.CopyRect(FBitmap.Canvas.ClipRect, FBitmap.Canvas,Rect(0, 0, FBitmap.Width, FBitmap.Height));
      if FVScroll.Visible and FHScroll.Visible then begin
         VColor             := Canvas.Brush.Color;
         Canvas.Brush.Color := (Parent as TForm).Color;
         with Canvas do begin
            FillRect(Rect(Width - FVScroll.Width - 4, Height - FHScroll.Height - 4, Width, Height));
            Brush.Color := VColor;
         end;
      end;
   end;
end;

function TRichMemo.RestrictCountChar(jb, je : Integer) : Boolean;
   function ConstrChar(j : Integer) : Boolean;
   var
      i, k, kl, c : Integer;
      s, sm       : String;
   begin
      s := '';
      c := GetCountCharInString(j);
      if c < Length(FText[j]) then begin
         k  := -1;
         kl := -1;
         repeat
            Inc(k);
            s := s + FText[j][k];
            if (Ord(FText[j][k]) = 32) then begin
               kl := k;
               s  := '';
            end;
         until (k + 1 >= c);
         sm := FText[j];
         if kl >= 0 then k := kl;
         s := Copy(FText[j], k + 1, Length(FText[j]) - k);
         Delete(sm, k + 1, Length(sm) - k);
         FText[j] := sm;
         if j < FText.Count - 1 then
            FText.Insert(j + 1, s)
         else
            FText.Add(s);
      end;
      i := j + 1;
      if i > FText.Count - 1 then Dec(i);
      Result := Length(FText[i]) > GetCountCharInString(i);
   end;

var
   i      : Integer;
   flExit : Boolean;
begin
   i := jb;
   Result := False;
   repeat
      if not ((i >= FText.Count - 1) and (FText.Count - 1 >= 0)) then Break;
      if (Length(FText[i]) > GetCountCharInString(i)) then Result := True;
      flExit := ConstrChar(i);
      Inc(i);
      flExit := (not flExit) and (i > je);
   until (flExit);
end;

procedure TRichMemo.SetSelText(Value: String);
var
   s             : String;
   pLeft, pRight : TPoint;
   i             : Integer;
begin
   if Assigned(FOnChange) then FOnChange(Self);
   SaveUndo;
   if FReadOnly then Exit;
   if (FSelStart.X = 0) then begin
      pLeft  := FPos;
      pRight := pLeft;
   end
   else
      if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
         pLeft  := FSelStart;
         pRight := FSelEnd;
      end
      else begin
         pLeft  := FSelEnd;
         pRight := FSelStart;
      end;

   i := GetIndexPos(pLeft); // начинается с первого символа
   s := FText.Text;
   Delete(s, i, GetIndexPos(pRight) - i);
   if FInsertMode then Delete(s, i, 1);
   Insert(Value, s, i);
   FText.Text  := s;
   pRight      := GetPosIndex(i + Length(Value));
   FSelStart.X := 0;
   ClearSelection;
   if FRestrictCountCharInStr then RestrictCountChar(pLeft.Y, pRight.Y);

   if (FPos.Y > GetCountStringInWindow - 1 + FOffset.Y) then Inc(FOffset.Y);
   if (FText.Count - 1 >= 0) and (pRight.X > Length(FText[pRight.Y])) then begin
      Inc(pRight.Y);
      pRight.X := Length(FirstWordInStr(FText[pRight.Y]));
   end;
   SetPos(pRight.X, pRight.Y);
end;

procedure TRichMemo.DoChar(aChar: Char);
begin
   SelText := aChar;
end;

procedure TRichMemo.CMFontChanged(var Message: TMessage);
begin
   inherited;
   Font.Pitch := fpFixed;
   FBitmap.Canvas.Font.Size := Font.Size;
   with Canvas do begin
      Font.Assign(Self.Font);
      Font.Style  := [fsBold];
      Font.Pitch  := fpFixed;
      FCharHeight := TextHeight('Wg');
      FCharWidth  := TextWidth('W');
      FIsMonoType := Pos('COURIER NEW', AnsiUppercase(Font.Name)) <> 0;
   end;
end;

procedure TRichMemo.UpdateVScrollBar(ACountString : Integer);
var
   fVisible : Boolean;
begin
   if (FScrollBars in [ssVertical, ssBoth]) then
      with FVScroll do begin
         fVisible    := Visible;
         if FText.Count < ACountString then
            Max  := FText.Count
         else
            Max  := FText.Count - ACountString;
         if FAutoScroll then
            Visible := (ACountString < FText.Count)
         else begin
            Visible := True;
            Enabled := (ACountString < FText.Count);
         end;
         SmallChange := 1;
         LargeChange := ACountString;
         Position    := FOffset.Y;
      end;
   if (not fVisible) and FVScroll.Visible and FAutoScroll and (FPos.Y <> 0)  then fOffSet.y := 1;
end;

procedure TRichMemo.UpdateScrollBarS;
var
   i, j, m, k, l : Integer;
   flWasHVisible : Boolean;
   s             : String;
begin
   FBusy         := True;
   flWasHVisible := FHScroll.Visible;
   UpdateVScrollBar(FBitmap.Height div FCharHeight);
   if (FScrollBars in [ssHorizontal, ssBoth]) then
      with FHScroll do begin
         m            := -1;
         j            := 0;
         l            := 0;
         if FVScroll.Visible then j := FVScroll.Width;
         for i := 0 to FText.Count - 1 do
            if l < Length(FText[i]) then begin
               m := i;
               l := Length(FText[i]);
            end;
         s := '';
         if m > -1 then s := FText[m];
         if FAutoScroll then
            Visible := (m > -1) and ((FBitmap.Width - 6 - j < WidthText(m, Length(s))) or (FOffSet.X > 0))
         else begin
            Visible := True;
            Enabled := (m > -1) and ((FBitmap.Width - 6 - j < WidthText(m, Length(s))) or (FOffSet.X > 0));
         end;
         Max         := Length(s) - GetCountCharInString(m);
         SmallChange := 1;
         LargeChange := Max;
         Position    := FOffset.X;
      end;
   k := 0;
   j := 0;
   if FHScroll.Visible then begin
      k              := FHScroll.Height;
      FBitmap.Height := ClientHeight - k;
      UpdateVScrollBar(FBitmap.Height div FCharHeight);
      if FVScroll.Visible then j := FVScroll.Width;
      if (not flWasHVisible) and FVScroll.Visible then begin
         FHScroll.Max := Length(s) - GetCountCharInString(m);
         FOffset.X    := FHScroll.Max;
         if FPos.Y >= FOffSet.Y + GetCountStringInWindow then Inc(FOffSet.Y);
      end;
   end
   else
      if flWasHVisible then begin
         UpdateVScrollBar(ClientHeight div FCharHeight);
         THackScrollBar(FVScroll).RecreateWnd;
      end;
   FVScroll.SetBounds(Width - FVScroll.Width - 4, 0, FVScroll.Width, Height - 4 - k);
   FHScroll.SetBounds(0, Height - FHScroll.Height - 4, Width - 4 - j, FHScroll.Height);
   FBusy := False;
end;

// измеряется в целых номерах символов (x - по горизонтали y - по вертикали первый символ 0 )
procedure TRichMemo.SetPos(x, y : Integer);
var
   i : Integer;
begin
   if x > FMaxLength then x := FMaxLength - 1;
   if (y <= FText.Count - 1) and (y > -1) and (x > Length(FText[y])) then x := Length(FText[y]);
   if (y > FText.Count - 1) and (FText.Count > 0) then
      if Length(FText[FText.Count - 1]) > 0 then
         y := FText.Count
      else
         y := FText.Count - 1;
   if y < 0 then y := 0;

   if not FRestrictCountCharInStr then begin
      i := GetCountCharInString(y);
      if x > FOffset.X + i then
         if (not FHClick) and (not FMouseLock) and (not FDown) then begin
            Inc(FOffset.X, x - (FOffset.X + i));
            i := GetCountCharInString(y);
         end
         else
            Dec(x, x - (FOffset.X + i));
      if x > FOffset.X + i then begin
         if (not FHClick) and (not FMouseLock) and (not FDown) then
            Inc(FOffset.X, x - (FOffset.X + i))
         else
            Dec(x, x - (FOffset.X + i));
      end
      else
         if x <= FOffset.X then begin
            if not FHClick then
               Dec(FOffset.X, FOffset.X - x)
            else
               Dec(x, FOffset.X - x);
         end;
   end;
   if x < 0 then x := 0;

   FPos := Point(x, y);

   if not (csDesigning in ComponentState) then UpdateScrollBarS;
   ShowCaretPos;
end;

procedure TRichMemo.CreateParams(var Params: TCreateParams);
begin
   inherited;
   with Params do ExStyle := ExStyle or WS_EX_CLIENTEDGE; // 3d рамка окна
end;

procedure TRichMemo.WMMouseWheel(var Message: TMessage);
begin
   inherited;
   if Short(HIWORD(Message.wParam)) >= 0 then begin
      if FVScroll.Position > 0 then
         FVScroll.Position := FVScroll.Position - 1
      else
        if FPos.Y > 0 then begin
           FPos.Y := FPos.Y - 1;
           SetPos(FPos.X, FPos.Y);
        end;
      end
   else begin
      if FVScroll.Position < FVScroll.Max then
         FVScroll.Position := FVScroll.Position + 1
      else
        if (FPos.Y < FText.Count - 1) then begin
           FPos.Y := FPos.Y + 1;
           SetPos(FPos.X, FPos.Y);
        end;
   end;
   FVScroll.Refresh;
end;

procedure TRichMemo.WMKillFocus(var Msg: TWMKillFocus);
begin
   inherited;
   if TMessage(Msg).wParam <> FHScroll.Handle then begin            // если компонент теряет фокус но не на раскрывающееся окно FListWindow
      HideCaret(Handle);
      DestroyCaret;
      ClearSelection;
      Paint;
   end;
   if Assigned(FOnExit) then FOnExit(Self);
end;

procedure TRichMemo.WMSetFocus(var Msg: TWMSetFocus);
begin
   inherited;
   CreateCaret(Handle, 0, 1, FCharHeight);
   ShowCaretPos;
end;

function TRichMemo.FPosInSel : Boolean;
var
   pLeft, pRight : TPoint;
begin
   if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then begin
      pLeft  := FSelStart;
      pRight := FSelEnd;
   end
   else begin
      pLeft  := FSelEnd;
      pRight := FSelStart;
   end;
   Result := ((FPos.Y >= FSelStart.Y) and (FPos.Y <= FSelEnd.Y)) and ((FPos.X > FSelStart.X) and (FPos.X < FSelEnd.X));
end;

procedure TRichMemo.ShowCaretPos;
begin
   if (FPos.Y = FText.Count) and (FText.Count > 0) and (Length(FText[FText.Count - 1]) > 0) then
      FText.Add('');
   if (FCharHeight * (FPos.Y - FOffset.Y) < FBitmap.Height - FCharHeight) then begin
      HideCaret(Handle);
      DestroyCaret;
      if not FNotPaint then Paint;
      CreateCaret(Handle, 0, 1, FCharHeight);
      with Canvas do SetCaretPos(WidthText(FPos.Y, FPos.X) + 2, FCharHeight * (FPos.Y - FOffset.Y));
      ShowCaret(Handle);
   end
   else
      if not FNotPaint then Paint;
end;

procedure TRichMemo.VScrollClick(Sender: TObject);
begin
   if FBusy then Exit;
   FOffset.Y := FVScroll.Position;
   if FPos.Y < FOffset.Y then FPos.Y := FOffSet.Y;
   if (FPos.Y > GetCountStringInWindow - 1 + FOffset.Y) then FPos.Y := GetCountStringInWindow - 1 + FOffset.Y;
   SetPos(FPos.X, FPos.Y);
end;

procedure TRichMemo.HScrollClick(Sender: TObject);
begin
   if FBusy then Exit;
   FHClick     := True;
   FOldOffsetX := FOffset.X;
   FOffset.X   := FHScroll.Position;
   SetPos(FPos.X, FPos.Y);
   FHClick     := False;
end;

procedure TRichMemo.ScrollEnter(Sender: TObject);
begin
   SetFocus;
end;

procedure TRichMemo.OprCancel(Sender: TObject);
begin
   DoUndo;
end;

procedure TRichMemo.OprCut(Sender: TObject);
begin
   CopyToClipboard;
   if not FReadOnly then DoDel;
   FPopupMenu.Items[0].Enabled := True;
   FPopupMenu.Items[2].Enabled := False;
   FPopupMenu.Items[3].Enabled := False;
   FPopupMenu.Items[5].Enabled := False;
end;

procedure TRichMemo.OprCopy(Sender: TObject);
begin
   CopyToClipboard;
end;

procedure TRichMemo.OprPaste(Sender: TObject);
begin
   if not FReadOnly then PasteFromClipboard;
   Paint;
   FPopupMenu.Items[0].Enabled := True;
   FPopupMenu.Items[2].Enabled := False;
   FPopupMenu.Items[3].Enabled := False;
   FPopupMenu.Items[5].Enabled := False;
end;

procedure TRichMemo.OprDelete(Sender: TObject);
begin
   if not FReadOnly then DoDel;
   FPopupMenu.Items[0].Enabled := True;
   FPopupMenu.Items[2].Enabled := False;
   FPopupMenu.Items[3].Enabled := False;
   FPopupMenu.Items[5].Enabled := False;
end;

procedure TRichMemo.OprSelectAll(Sender: TObject);
begin
   SelectAll;
end;

constructor TRichMemo.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FCollectionColorWords := TCollectionColorWords.Create(Self);
   FText          := TStringList.Create;
   FTextBeforUndo := TStringList.Create;
   FPos.X         := 0;
   FPos.Y         := 0;
   Width          := 185;
   Height         := 89;
   FCharWidth     := 10;
   FCharHeight    := 10;
   FOffset.X      := 0;
   FOffset.Y      := 0;
   FMaxLength     := 1024;
   FBitmap        := TBitmap.Create;
   Color          := clWindow;
   FNotPaint      := False;
   if (csDesigning in ComponentState) then begin
      ColorWindow := clWindow;
      FAutoScroll := False;
   end
   else begin
      FPopupMenu := TPopupMenu.Create(Self);
      FPopupMenu.Items.Add(NewItem('Отменить', TextToShortCut(''), False, False, OprCancel, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('-', TextToShortCut(''), False, False, nil, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('Вырезать', TextToShortCut(''), False, False, OprCut, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('Копировать', TextToShortCut(''), False, False, OprCopy, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('Вставить', TextToShortCut(''), False, True, OprPaste, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('Удалить', TextToShortCut(''), False, False, OprDelete, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('-', TextToShortCut(''), False, True, nil, 0, 'Ch_all'));
      FPopupMenu.Items.Add(NewItem('Выделить все', TextToShortCut(''), False, True, OprSelectAll, 0, 'Ch_all'));
      PopupMenu        := FPopupMenu;
      FVScroll         := TScrollBar.Create(Self);
      FVScroll.Parent  := Self;
      FVScroll.Visible := False;
      FHScroll         := TScrollBar.Create(Self);
      FHScroll.Parent  := Self;
      FHScroll.Visible := False;
      with FVScroll do begin
         Kind     := sbVertical;
         OnChange := VScrollClick;
         OnEnter  := ScrollEnter;
      end;
      with FHScroll do begin
         Kind     := sbHorizontal;
         OnChange := HScrollClick;
         OnEnter  := ScrollEnter;
      end;
   end;
   FLines := TRichMemoStrings.Create;
   TRichMemoStrings(FLines).RichMemo := Self;
   AutoScroll := True;
   TabStop    := True;
end;

procedure TRichMemo.ClearSelection;
begin
   ShowCaret(Handle);
   if (FSelStart.X <> FSelEnd.X) or (FSelStart.Y <> FSelEnd.Y) then begin
      FSelStart := Point(0, 0);
      FSelEnd   := Point(0, 0);
      Paint;
   end;
   FPopupMenu.Items[7].Enabled := True;   
end;

function TRichMemo.WidthText(j, ai : Integer) : Integer;
// ai - номер символа (первый символ нуль) до которого включительно подсчитывается width
var
   i, w, l, k  : Integer;
   s, sv, sr   : String;
   mColor,
   aColor      : TColor;
   mFontStyles,
   aFontStyles : TFontStyles;
begin
   i  := FOffSet.X;
   s  := '';
   sr := '';
   sv := '';
   k  := ai + 1;
   l  := 0;
   w  := 0;
   if (j <= FText.Count - 1) and (FText.Count - 1 >= 0) then
   l  := Length(FText[j]);
   if j <= -1 then begin
      Result := 0;
      Exit;
   end;

   if (l > 0) and (ai > 0) then
      repeat
         Inc(i);
         s  := s + FText[j][i];
         sv := Copy(s, 1, Length(s) - 1);
         if (i = ai) and (Ord(FText[j][i]) <> 32) then sv := s;
         if (Ord(FText[j][i]) = 32) or (i = ai) then begin
            if (i = ai) and (sv = s) then
               while (k <= l) and (Ord(FText[j][k]) <> 32) do begin
                  sr := sr + FText[j][k];
                  Inc(k);
               end;
            if (sv <> '') then
                 if (WordNeedSel(sv + sr, aColor, aFontStyles)) then begin
                  while Pos('(', sv) = 1 do begin
                     system.Delete(sv, Pos('(', sv), 1);
                     w := w + FBitmap.Canvas.TextWidth('(');
                  end;
                  while (Length(sv) > 0)  and (sv[Length(sv)] = ')') do begin
                     system.Delete(sv, Pos(')', sv), 1);
                     w := w + FBitmap.Canvas.TextWidth(')');
                  end;

                  mColor      := FBitMap.Canvas.Font.Color;
                  mFontStyles := FBitMap.Canvas.Font.Style;
                  FBitMap.Canvas.Font.Color := aColor;
                  FBitMap.Canvas.Font.Style := aFontStyles{[fsBold]};
                  w := w + FBitmap.Canvas.TextWidth(sv);
                  FBitMap.Canvas.Font.Color := mColor;
                  FBitMap.Canvas.Font.Style := mFontStyles;
               end
               else
                  w := w + FBitmap.Canvas.TextWidth(sv);

            s := '';
            if (Ord(FText[j][i]) = 32) then w := w + FBitMap.Canvas.TextWidth(' ');
         end;
      until (i >= ai);
   Result := w;
end;

function TRichMemo.WidthAllText(j : Integer) : Integer;
var
   i, w, l      : Integer;
   s, sv        : String;
   mColor,
   aColor       : TColor;
   mFontStyles,
   aFontStyles  : TFontStyles;
begin
   i := 0;
   s := '';
   l := Length(FText[j]);
   w := 0;
   if l > 0 then
      repeat
         Inc(i);
         s  := s + FText[j][i];
         sv := Copy(s, 1, Length(s) - 1);
         if (i = l) and (Ord(FText[j][i]) <> 32) then sv := s;
         if (Ord(FText[j][i]) = 32) or (i = l) then begin

            if (sv <> '') then begin
               if (WordNeedSel(sv, aColor, aFontStyles)) then begin
                  mColor      := FBitMap.Canvas.Font.Color;
                  mFontStyles := FBitMap.Canvas.Font.Style;
                  FBitMap.Canvas.Font.Color := aColor;
                  FBitMap.Canvas.Font.Style := aFontStyles;
                  w := w + FBitmap.Canvas.TextWidth(sv);
                  FBitMap.Canvas.Font.Color := mColor;
                  FBitMap.Canvas.Font.Style := mFontStyles;
               end
               else
                  w := w + FBitmap.Canvas.TextWidth(sv);
            end;
            s := '';
            if (Ord(FText[j][i]) = 32) then w := w + FBitMap.Canvas.TextWidth(' ');
         end;
      until (i = l);
   Result := w;
end;

// возврашает целый номер символа в строке (без учета смещения) куда нужно установить корретку после счелчка мыши по
// точке (в пикселах) с координатой X, Y начиная с 0,0
function TRichMemo.NumberCharInStr(X, Y : Integer) : Integer;
var
   i, j, l : Integer;
   s       : String;
begin
   s := '';
   i := 0;
   j := Y div FCharHeight + FOffset.Y; // номер строки
   if j < 0 then j := 0;
   if (j <= FText.Count - 1) then begin
      l := Length(FText[j]);
      if (X >= WidthAllText(j)) then
         i := l
      else
         for i := 0 to l - 1 do
            if (WidthText(j, i) >= (X + WidthText(j, FOffset.X))) then Break;
   end;
   Result := i;
end;

procedure TRichMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   j : Integer;
begin
   if Button in [mbLeft] then begin
      FBegSelection := True;
      FMouseLock    := True;
      if not Focused then SetFocus;
      FDown := True;
      j := Y div FCharHeight + FOffset.Y;
      // измеряется в целых номерах количествах символов (по вертикали и горизонтали)
      FPos.X := NumberCharInStr(X, Y);
      if j > FText.Count - 1 then begin
         j := FText.Count - 1;
         FPos.X := Length(FText[j]);
      end;
      FPos.Y := j;
      SetPos(FPos.X, FPos.Y);
      ClearSelection;
      FTempPos := FPos;
      ShowCaretPos;
      FMouseLock := False;
      FPopupMenu.Items[2].Enabled := False;
      FPopupMenu.Items[3].Enabled := False;
      FPopupMenu.Items[5].Enabled := False;
   end;
end;

procedure TRichMemo.AddSel;
begin
   if FBegSelection then begin
      FSelStart     := FTempPos;
      FBegSelection := False;
   end;
   FSelEnd := FPos;
   Paint;
   FPopupMenu.Items[2].Enabled := True;
   FPopupMenu.Items[3].Enabled := True;
   FPopupMenu.Items[5].Enabled := True;
end;

procedure TRichMemo.MouseMove(Shift: TShiftState; X, Y: Integer);
var
   i, j : Integer;
begin
   if FDown then begin
      // происходят изменения только если сменилась позиция ()
      i := NumberCharInStr(X, Y);
      j := Y div FCharHeight + FOffset.Y;
      if j > FText.Count - 1 then begin
         j := FText.Count - 1;
         i := Length(FText[j]);
      end;
      if (i <> FPos.X) or (j <> FPos.Y) then begin
         FNotPaint := True;
         SetPos(i, j);
         FNotPaint := False;
         AddSel;
         FTempPos := FPos;
      end;
   end;
end;

procedure TRichMemo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   inherited;
   FDown := False;
   if (FSelStart.X = FSelEnd.X) and (FSelStart.Y = FSelEnd.Y) then ShowCaret(Handle);
end;

destructor TRichMemo.Destroy;
begin
   if Assigned(FVScroll)   then FVScroll.Destroy;
   if Assigned(FHScroll)   then FHScroll.Destroy;
   if Assigned(FPopupMenu) then FPopupMenu.Destroy;
   FBitmap.Destroy;
   FPopupMenu := nil;
   FText.Free;
   FTextBeforUndo.Free;
   FLines.Free;
   inherited;
end;

function TRichMemoStrings.GetCount: Integer;
begin
   Result := RichMemo.FText.Count;
end;

function TRichMemoStrings.Get(Index: Integer): string;
begin
   Result := RichMemo.FText[Index];
end;

procedure TRichMemoStrings.Put(Index: Integer; const S: string);
begin
   RichMemo.FText[Index] := s;
   if RichMemo.RestrictCountCharInStr then RichMemo.RestrictCountChar(Index, RichMemo.FText.Count - 1);
   RichMemo.Paint;
   if not (csDesigning in RIchMemo.ComponentState) then RichMemo.UpdateScrollBars;
end;

procedure TRichMemoStrings.Insert(Index: Integer; const S: string);
var
   i  : Integer;
   st : String;
begin
   i  := 0;
   st := S;
   if Pos(#13#10, st) > 0 then begin
      while Pos(#13#10, st) > 0 do begin
         RichMemo.FText.Insert(Index + i, Copy(st, 1, Pos(#13#10, st) - 1));
         system.Delete(st, 1 , Pos(#13#10, st) + 1);
         Inc(i);
      end;
      RichMemo.FText.Insert(Index + i, st);
      if RichMemo.RestrictCountCharInStr then RichMemo.RestrictCountChar(Index, RichMemo.FText.Count - 1);
   end
   else
      RichMemo.FText.Insert(Index + i, st);
      if RichMemo.RestrictCountCharInStr then RichMemo.RestrictCountChar(Index, RichMemo.FText.Count - 1);
   with RichMemo do begin
      FOffset.Y := 0;
      FOffset.X := 0;
      FPos.X    := 0;
      FPos.Y    := 0;
      if not (csDesigning in ComponentState) then UpdateScrollBars;
      SetPos(FPos.X, FPos.Y);
      Paint;
   end;
end;

procedure TRichMemoStrings.Delete(Index: Integer);
const
   Empty : PChar = '';
begin
   RichMemo.FText.Delete(Index);
   if RichMemo.RestrictCountCharInStr then RichMemo.RestrictCountChar(Index, RichMemo.FText.Count - 1);
   RichMemo.Paint;
   if not (csDesigning in RIchMemo.ComponentState) then RichMemo.UpdateScrollBars;
end;

procedure TRichMemoStrings.Clear;
begin
   RichMemo.FText.Clear;
end;

function TRichMemoStrings.GetTextStr: string;
begin
   Result := RichMemo.FText.Text;
end;

procedure TRichMemoStrings.SetTextStr(const Value: string);
begin
   RichMemo.FText.Text := Value;
   if RichMemo.RestrictCountCharInStr then RichMemo.RestrictCountChar(0, RichMemo.FText.Count - 1);
   RichMemo.Paint;
   if not (csDesigning in RIchMemo.ComponentState) then RichMemo.UpdateScrollBars;
end;

end.
