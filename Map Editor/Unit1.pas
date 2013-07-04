// Создание и редактирование карт

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XPMan;

type
  TDirection = (u,d,l,r);
  TWalls = Array[1..4,1..20,1..20] of Boolean;
  TPaints = Array [1..20,1..20] of Boolean;
  TPoints = Array [1..20,1..20] of Boolean;
  TNumbers = Array [1..20,1..20] of Byte;
  TTaskText = Array [0..499] of Char;

  TEditor = class(TForm)
    Map: TImage;
    ro: TShape;
    PenColor: TColorBox;
    Label1: TLabel;
    Label2: TLabel;
    BrushColor: TColorBox;
    Save_btn: TButton;
    SaveDialog1: TSaveDialog;
    Open_btn: TButton;
    OpenDialog1: TOpenDialog;
    Clear_btn: TButton;
    Label3: TLabel;
    TaskText: TMemo;
    fname_lbl: TLabel;
    Memo1: TMemo;
    Label4: TLabel;
    Button1: TButton;
    Label5: TLabel;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure PenColorChange(Sender: TObject);
    procedure BrushColorChange(Sender: TObject);
    procedure Save_btnClick(Sender: TObject);
    procedure Open_btnClick(Sender: TObject);
    procedure Clear_btnClick(Sender: TObject);
    procedure FieldDetalClick(Sender: TObject);
    procedure TaskTextEnter(Sender: TObject);
    procedure TaskTextExit(Sender: TObject);
    procedure MapClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure MapInit(const  step: Integer);
    procedure MapMakeField(const direct: Integer);
    procedure MapMake;
    procedure RobotInit(x,y : Integer);
    procedure RobotStep(direct: TDirection);
    function getText(text : TCaption): TTaskText;

    procedure HandleMessages(var Msg: tMsg; var Handled: Boolean);

    { Private declarations }
  public
    { Public declarations }
  end;

  Tdata = record
    Walls: TWalls;   {массив стен. по 4 для каждой клетки}
    Paints: TPaints; {закрашено или нет}
    Points: TPoints; //точка для задания закрашивания
    Temp,Rad : TNumbers;
    endX,endY,startX,startY: Integer; {начальная позиция в клетках}
    TaskText: TTaskText;

  end;


var
  Editor: TEditor;
  Walls: TWalls;
  Paints: TPaints;
  Points: TPoints;
  Temp,Rad : TNumbers;
  endX,endY : Integer;


  step: Integer;

implementation


{$R *.dfm}



procedure TEditor.MapMake;
var i,j,di,dj : Integer;
    wpen1, wpen2: Byte;
begin
   wpen1 := 3;
   wpen2 := 1;
   di := 1;
   dj := 1;
   Map.Canvas.Brush.Color := BrushColor.Selected;
   Map.Canvas.Pen.Color := PenColor.Selected;
   Map.Canvas.FillRect(Map.ClientRect);
   Map.Canvas.Font.Height := 5;

   {перенести все похожие действия в процедуру "поставить"-"убрать"}
   for i := 1 to 20 do
   begin
        for j :=  1 to 20 do
        begin

           if Paints[i,j] then
             begin
               Map.Canvas.Brush.Style := bsDiagCross;
               Map.Canvas.Brush.Color := clOlive;
             end
           else
             begin
               Map.Canvas.Brush.Style := bsSolid;
               Map.Canvas.Brush.Color := BrushColor.Selected;
             end;

             Map.Canvas.Pen.Style := psClear;
             Map.Canvas.Rectangle((i-di)*step,(j-dj)*step,(i-di+1)*step,(j-dj+1)*step);
             Map.Canvas.Pen.Style := psSolid;

           if (i = endX)  and (j = endY) then
             begin
               Map.Canvas.Pen.Width := wpen2;
               Map.Canvas.Pen.Color := clRed;
               Map.Canvas.Rectangle((i-di)*step+4,(j-dj)*step+4,(i-di+1)*step-4,(j-dj+1)*step-4);
               Map.Canvas.Pen.Color := PenColor.Selected;
             end;

           if Points[i,j] then
             begin
               Map.Canvas.Pen.Color := clYellow;
               Map.Canvas.Pen.Width := wpen2;
               Map.Canvas.Rectangle((i-di)*step+Trunc(step/4),(j-dj)*step++Trunc(step/4),(i-di+1)*step-Trunc(step/4),(j-dj+1)*step-Trunc(step/4));
               Map.Canvas.Pen.Color := PenColor.Selected;
             end;

           if Walls[1,i,j] then  Map.Canvas.Pen.Width := wpen1
             else Map.Canvas.Pen.Width := wpen2;
           Map.Canvas.MoveTo((i-di)*step,(j-dj)*step);
           Map.Canvas.LineTo((i+1-di)*step,(j-dj)*step);

           if Walls[2,i,j] then Map.Canvas.Pen.Width := wpen1
             else Map.Canvas.Pen.Width := wpen2;
           Map.Canvas.MoveTo((i+1-di)*step,(j-dj)*step-1);
           Map.Canvas.LineTo((i+1-di)*step,1+(j+1-dj)*step);

           if Walls[3,i,j] then Map.Canvas.Pen.Width := wpen1
             else Map.Canvas.Pen.Width := wpen2;
           Map.Canvas.MoveTo((i+1-di)*step,(j+1-dj)*step);
           Map.Canvas.LineTo((i-di)*step,(j+1-dj)*step);

           if Walls[4,i,j] then Map.Canvas.Pen.Width := wpen1
             else Map.Canvas.Pen.Width := wpen2;
           Map.Canvas.MoveTo((i-di)*step,(j-dj)*step-1);
           Map.Canvas.LineTo((i-di)*step,1+(j+1-dj)*step);

        end;
   end;
   Map.Canvas.Brush.Style := bsSolid;
   Map.Canvas.Brush.Color := BrushColor.Selected;
   Map.Canvas.Pen.Style := psSolid;
   Map.Canvas.Pen.Color := PenColor.Selected;

end;

procedure TEditor.MapMakeField(const direct: Integer);
  var i,j: Integer;
begin

   i := ro.left div step + 1;
   j := ro.top div step + 1;
   CASE direct OF
     1: begin {up}
          Walls[1,i,j] := not Walls[1,i,j];
          Walls[3,i,j-1] :=  Walls[1,i,j];
        end;
     2: begin {right}
          Walls[2,i,j] := not Walls[2,i,j];
          Walls[4,i+1,j] :=  Walls[2,i,j];
        end;
     3: begin {up}
          Walls[3,i,j] := not Walls[3,i,j];
          Walls[1,i,j+1] :=  Walls[3,i,j];
        end;
     4: begin {up}
          Walls[4,i,j] := not Walls[4,i,j];
          Walls[2,i-1,j] :=  Walls[4,i,j];
        end;
     5:   Paints[i,j] := not Paints[i,j];
     8:   Points[i,j] := not Points[i,j];
      7: begin {установить конечную позицию}
           endX := i;
           endY := j
         end;

   END;
   MapMake;

end;


procedure TEditor.RobotInit(x,y : Integer);
var i: Integer;
begin
   if step > 15 then
   begin
       ro.width := step - (step div 3);
       ro.Height := step - (step div 3);
       ro.top := map.top + ( (step div 3) div 2);
       ro.left := map.left + ( (step div 3) div 2);
   end;
   for i:=2 to x do
     begin
       RobotStep(r);
     end;
   for i:=2 to y do
     begin
       RobotStep(d);
     end;
end;

procedure TEditor.RobotStep (direct: TDirection);
begin
   CASE direct OF
     l:  ro.left := ro.left - step;
     r:  ro.left := step + ro.left;
     d:  ro.top := step + ro.top;
     u:  ro.top := ro.top - step;
   END;
   if ro.left < map.left then ro.left := ro.left + step;
   if ro.left > map.left + map.width then ro.left := ro.left - step;
   if ro.top < map.top then ro.top := ro.top + step;
   if ro.top > map.top + map.height then ro.top := ro.top - step;
end;


procedure TEditor.MapInit(const step: Integer);
  var k, i,j: Integer;
begin
   Map.Canvas.Pen.Color := clGray;
   Map.Canvas.Brush.Color := clBtnFace;
   Map.Canvas.FillRect(Map.ClientRect);
   robotInit(1,1);

   endX := 0;
   endY := 0;
          
   for i := 0 to Map.Width do
    begin
      Map.Canvas.MoveTo(i*step,0);
      Map.Canvas.LineTo(i*step,Map.Height);
    end;
   for i := 0 to Map.Height do
    begin
      Map.Canvas.MoveTo(0,i*step);
      Map.Canvas.LineTo(Map.Width,i*step);
    end;
   Map.Canvas.Pen.Color := clBlue;
   for i := 1  to 20 do
     for j := 1 to 20 do
       begin
         Paints[i,j] := false;
         Points[i,j] := false;
         Temp[i,j] := 0;
         Rad[i,j] := 0;
       end;

   for k := 1 to 4 do
     for i :=  1 to 20 do
       for j := 1 to 20 do
         Walls[k,i,j] := false;

   for i := 1 to 20 do
     begin
       Walls[1,i,1] := true;
       Walls[3,i,20] := true;
     end;
   for j := 1 to 20 do
     begin
       Walls[4,1,j] := true;
       Walls[2,20,j] := true;
     end;
   MapMake;

end;


procedure TEditor.FormCreate(Sender: TObject);
begin
   Application.OnMessage := HandleMessages;
   step := 30;
   MapInit(step);

end;


procedure TEditor.PenColorChange(Sender: TObject);
begin
  MapMake;
end;

procedure TEditor.BrushColorChange(Sender: TObject);
begin
  MapMake;
end;


procedure TEditor.Save_btnClick(Sender: TObject);
  var
    data: Tdata;
    task : file of Tdata;
    fname: String;

begin
  data.Walls := Walls;
  data.Paints := Paints;
  data.Points := Points;
  data.Temp := temp;
  data.Rad := rad;
  data.startX := ro.left div step + 1;
  data.startY := ro.top div step + 1;
  data.endX := endX;
  data.endY := endY;
  data.TaskText := gettext(tasktext.Text+' ');

  if length(fname_lbl.Caption) > 2 then
      savedialog1.FileName := fname_lbl.Caption;

  if SaveDialog1.Execute then
    begin
      fname := savedialog1.FileName;
      AssignFile(task,fname);
      Rewrite(task);
      Write(task,data);
      CloseFile(task);
      fname_lbl.Caption := fname;
    end;
 end;

procedure TEditor.Open_btnClick(Sender: TObject);
  var
    data: Tdata;
    task : file of Tdata;
    fname: String;
    i : Integer;
begin
  if openDialog1.Execute then
    begin
      fname := opendialog1.FileName;
      AssignFile(task,fname);
      reset(task);
      Read(task,data);
      fname_lbl.Caption := fname;
      tasktext.Text := '';
      for i := 0 to 499 do
         tasktext.Text := tasktext.Text +  data.TaskText[i];
      paints := data.paints;
      points := data.Points;
      walls := data.walls;
      temp := data.Temp;
      rad := data.Rad;
      endX := data.endX;
      endY := data.endY;
      robotInit(data.startX, data.startY);
      mapMake;

    end;
end;

procedure TEditor.Clear_btnClick(Sender: TObject);
begin
   MapInit(step);
   tasktext.Text := '';
end;

Procedure TEditor.HandleMessages ( Var Msg : tMsg; Var Handled : Boolean );
  var
  s:TKeyboardState;
Begin

    If ( Msg.Message = WM_KeyDown ) And
    ( Msg.wParam In [VK_END, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_SPACE, VK_CONTROL, VK_INSERT] ) Then
    Begin
       Case Msg.wParam of
         VK_SPACE : MapMakeField(8);
         VK_END : MapMakeField(7);
       end;
       GetKeyboardState(s);
       if ((s[vk_Control] And 128) = 0 ) then
          Case Msg.wParam Of
            VK_UP    : robotStep(u);
            VK_DOWN  : robotStep(d);
            VK_LEFT  : robotStep(l);
            VK_RIGHT : robotStep(r);
          End
       else
          Case Msg.wParam Of
            VK_UP    : MapMakeField(1);
            VK_RIGHT : MapMakeField(2);
            VK_DOWN  : MapMakeField(3);
            VK_LEFT  : MapMakeField(4);
          End;
      Handled := True;
    End;
End;


procedure TEditor.FieldDetalClick(Sender: TObject);
begin
  MapMake;
end;

function TEditor.getText(text: TCaption): TTaskText;
  var i,imax : Integer;

begin
  imax := Length(text);
  if imax > 499 then imax := 499;
  for i := 0 to imax do result[i] := text[i];
  for i := imax  to 499 do result[i] := #0;
    
end;


procedure TEditor.TaskTextEnter(Sender: TObject);
begin
   Application.OnMessage := nil;
end;

procedure TEditor.TaskTextExit(Sender: TObject);
begin
   Application.OnMessage := HandleMessages;
end;

procedure TEditor.MapClick(Sender: TObject);
begin
   Application.OnMessage := HandleMessages;
end;


procedure TEditor.Button1Click(Sender: TObject);
begin
close;
end;

END.
