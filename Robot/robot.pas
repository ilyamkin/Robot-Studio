// Описание классов TRobot(исполнитель), TData(карта) и некоторые стандартные функции для них.

unit robot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;
const
  xmax = 20;
  ymax = 20;

type
  TWalls = Array[1..4,1..xmax,1..ymax] of Boolean;
  TPaints = Array [1..xmax,1..ymax] of Boolean;
  TPoints = Array [1..xmax,1..ymax] of Boolean;
  TNumbers = Array [1..xmax,1..ymax] of Byte;
  TDirection = (u,d,l,r);

  Tdata = record
    Walls: TWalls;   {массив стен. по 4 для каждой клетки}
    Paints: TPaints; {закрашено или нет}
    Points: TPoints; //точка для задания по закрашиванию
    Temp,Rad : TNumbers;
    endX,endY,startX,startY: Integer; {начальная позиция в клетках}
    TaskText: array[0..499] of Char;
  end;


  TRobot = class (TWinControl)
  private
    Map: TImage;
    Ro: TImage;
    TaskText: TLabel;
    Walls: TWalls;
    Paints: TPaints;
    Points: TPoints;
    OpenDlg : TOpenDialog;
    Temp : TNumbers;
    Rad : TNumbers;

    procedure MapInit(const  step: Integer);
    procedure MapMake;
    procedure RobotInit(x,y : Integer);
    procedure RobotStep(direct: TDirection);
    function GetRobotPos : TPoint;

  public
    endX: Integer;
    endY: Integer;
    FFName : string;
    FSleepTime: integer;

    procedure Load (fname : String);
    procedure ToLeft;
    procedure ToRight;
    procedure ToDown;
    procedure ToUp;
    procedure Mark;
    procedure unMark;

    function WallOnDown : Boolean;
    function WallOnLeft: Boolean;
    function WallOnRight: Boolean;
    function WallOnUp: Boolean;
    function IsMark: Boolean;

    function FreeOnDown : Boolean;
    function FreeOnLeft: Boolean;
    function FreeOnRight: Boolean;
    function FreeOnUp: Boolean;

    function GetTemp: Integer;
    function GetRad: Integer;
    constructor Create (AOwner : TComponent);override;

  published
    property FName : String read FFName write Load stored true;
    property SleepTime: integer read FSleepTime write FSleepTime stored true;
  end;


var

  Robo: TRobot;
  Walls: TWalls;
  Paints: TPaints;
  Points: TPoints;
  Temp,Rad : TNumbers;
  endX,endY : Integer;
  step: Integer;



procedure Register;

implementation

{$R bitmap.res}

procedure Register;
begin
  RegisterComponents('Robot!', [TRobot]);
end;


procedure TRobot.MapMake;
var i,j,di,dj : Integer;
    wpen1, wpen2: Byte;
begin
   wpen1 := 3;
   wpen2 := 1;
   di := 1;
   dj := 1;

   Map.Canvas.Brush.Color := clBtnFace;
   Map.Canvas.Pen.Color := clBlue;
   Map.Canvas.FillRect(Map.ClientRect);
   Map.Canvas.Font.Size := 8;


   {перенести все похожие действия в процедуру "поставить"-"убрать"}
   for i := 1 to xmax do
   begin
        for j :=  1 to ymax do
        begin

           if Paints[i,j] then
             begin
               Map.Canvas.Brush.Style := bsSolid;
               Map.Canvas.Brush.Color := clOlive;
             end
           else
             begin
               Map.Canvas.Brush.Style := bsSolid;
               Map.Canvas.Brush.Color := clBtnFace;
             end;

           Map.Canvas.Pen.Style := psClear;
           Map.Canvas.Rectangle((i-di)*step,(j-dj)*step,(i-di+1)*step,(j-dj+1)*step);
           Map.Canvas.Pen.Style := psSolid;

           if Points[i,j] then
             begin
               Map.Canvas.Pen.Color := clYellow;
               Map.Canvas.Pen.Width := wpen2;
               Map.Canvas.Rectangle((i-di)*step+Trunc(step/3),(j-dj)*step+Trunc(step/3),(i-di+1)*step-Trunc(step/3),(j-dj+1)*step-Trunc(step/3));
               Map.Canvas.Pen.Color := clBlue;
             end;

           if (i = endX)  and (j = endY) then
             begin
               Map.Canvas.Pen.Color := clRed;
               Map.Canvas.Pen.Width := wpen2;
               Map.Canvas.Rectangle((i-di)*step+4,(j-dj)*step+4,(i-di+1)*step-4,(j-dj+1)*step-4);
               Map.Canvas.Pen.Color := clBlue;
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

           if temp[i,j] <> 0 then Map.Canvas.TextOut((i-di)*step+3,(j-dj)*step+4,IntToStr(temp[i,j]));
           if rad[i,j] <> 0 then Map.Canvas.TextOut((i-di)*step+3,(j-dj)*step+4,IntToStr(rad[i,j]));

        end;
   end;
   //Map.Repaint;
   Map.Canvas.Brush.Style := bsSolid;
   Map.Canvas.Brush.Color := clBtnFace;
   Map.Canvas.Pen.Style := psSolid;
   Map.Canvas.Pen.Color := clBlue;

end;

procedure TRobot.RobotInit(x,y : Integer);
var i: Integer;
begin
   ro.Visible := true;
   if step > 15 then
   begin
       ro.width := step - 1;
       ro.Height := step - 1;
       ro.top := map.top + 2;
       ro.left := map.left + 2;
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

procedure TRobot.RobotStep (direct: TDirection);
begin
   CASE direct OF
     l:  ro.left := ro.left - step;
     r:  ro.left := step + ro.left;
     d:  ro.top := step + ro.top;
     u:  ro.top := ro.top - step;
   END;
   self.Repaint;
   sleep(self.SleepTime);
   if ro.left < map.left then ro.left := ro.left + step;
   if ro.left > ( map.left + map.width) then ro.left := ro.left - step;
   if ro.top < map.top then ro.top := ro.top + step;
   if ro.top > ( map.top + map.height) then ro.top := ro.top - step;
end;


procedure TRobot.MapInit(const step: Integer);
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
   for i := 1  to xmax do
     for j := 1 to ymax do
       begin
         Paints[i,j] := false;
         Points[i,j] := false;
         Temp[i,j] := 0;
         Rad[i,j] := 0;
       end;

   for k := 1 to 4 do
     for i :=  1 to xmax do
       for j := 1 to ymax do
         Walls[k,i,j] := false;

   for i := 1 to xmax do
     begin
       Walls[1,i,1] := true;
       Walls[3,i,ymax] := true;
     end;
   for j := 1 to ymax do
     begin
       Walls[4,1,j] := true;
       Walls[2,xmax,j] := true;
     end;
   MapMake;

end;

procedure TRobot.Load (fname : string);
  var
    data: Tdata;
    task : file of Tdata;
    i : Integer;

begin

    self.FFName := fname;
    if Length(fname) > 0 then
      begin
        // если имя файла пустое,  то пропусить
        if not FileExists(fname) then
          if OpenDlg.Execute then fname := OpenDlg.FileName;

        if FileExists(fname) then
          // если имя есть, а файла нет - вызвать диалог
        // если всё есть, то подключить файл
        try
          AssignFile(task,fname);
          Reset(task);
          Read(task,data);
          CloseFile(task);
          TaskText.Caption:= fname;
          while pos('\',TaskText.Caption) > 0 do
            TaskText.Caption:= copy(TaskText.Caption,1+pos('\',TaskText.Caption),length(TaskText.Caption));
          TaskText.Caption:= TaskText.Caption + #13#10;


          for i := 0 to 499 do
            TaskText.Caption := TaskText.Caption + data.TaskText[i];
          paints := data.paints;
          points := data.points;
          walls := data.walls;
          temp := data.Temp;
          rad := data.Rad;
          endX := data.endX;
          endY := data.endY;
          robotInit(data.startX, data.startY);
          self.FFName := fname;
        except
          ShowMessage('ошибка при открытии или чтении файла. Возможно несоответсвие формата #13 Загрузка не выполнена. Для выбора файла измените свойство FName');
        end;
      end;
    mapMake;
end;



function TRobot.WallOnDown: boolean;
begin
   result := Walls[3,GetRobotPos.X,GetRobotPos.Y];
end;

function TRobot.WallOnUp: boolean;
begin
   result := Walls[1,GetRobotPos.X,GetRobotPos.Y];
end;

function TRobot.WallOnLeft: boolean;
begin
   result := Walls[4,GetRobotPos.X,GetRobotPos.Y];
end;

function TRobot.WallOnRight: boolean;
begin
   result := Walls[2,GetRobotPos.X,GetRobotPos.Y];
end;

procedure TRobot.ToDown;
begin
RobotStep(d);
end;

procedure TRobot.ToLeft;
begin
RobotStep(l);
end;

procedure TRobot.ToRight;
begin
RobotStep(r);
end;

procedure TRobot.ToUp;
begin
RobotStep(u);
end;


function TRobot.IsMark: Boolean;
begin
   result := Paints[GetRobotPos.X,GetRobotPos.Y];
end;

procedure TRobot.Mark;
begin
   Paints[GetRobotPos.X,GetRobotPos.Y] := true;
   MapMake;
end;

procedure TRobot.unMark;
begin
   Paints[GetRobotPos.X,GetRobotPos.Y] := false;
   MapMake;
end;


function TRobot.GetRad: Integer;
begin
   result := rad[GetRobotPos.X,GetRobotPos.Y];
end;

function TRobot.GetTemp: Integer;
begin
   result := temp[GetRobotPos.X,GetRobotPos.Y];
end;

constructor TRobot.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );
  self.SleepTime := 65;
  self.Left := 1;
  self.Top := 1;
  step := 30;
  self.Width := step*xmax+1;
  self.Height := step*ymax+1;
  self.Visible := true;

  Map := TImage.Create(self);
  Map.Parent := Self;
  Map.Left := 1;
  Map.Top := 31;
  Map.Width := self.Width ;
  Map.Height := self.Height ;
  Map.Visible := true;

  Ro:= TImage.Create(self);
  Ro.Picture.Bitmap.LoadFromResourceName(hInstance, 'robot');
  Ro.Parent := Self;

  TaskText := TLabel.Create(self);
  TaskText.AutoSize := false;
  TaskText.WordWrap := true;


  TaskText.Parent := self;
  TaskText.Top := 640;
  TaskText.Left := 1;
  TaskText.Width := 401;
  TaskText.Height := 100;
  TaskText.Visible := true;
  TaskText.Caption := 'Задание:...';

  OpenDlg := TOpenDialog.Create(self);
  OpenDlg.Filter := 'Robot Studio Map|*.rsm';

  MapInit(step);
  MapMake;
end;



function TRobot.FreeOnDown: Boolean;
begin
   Result := not WallOnDown;
end;

function TRobot.FreeOnLeft: Boolean;
begin
   Result := not WallonLeft;
end;

function TRobot.FreeOnRight: Boolean;
begin
  Result := not WallOnRight;
end;

function TRobot.FreeOnUp: Boolean;
begin
  Result := not WallOnUp;
end;


function TRobot.GetRobotPos : TPoint;
begin
   Result.X := (ro.left - map.Left) div step + 1;
   Result.Y  := (ro.top - map.Top) div step + 1;
end;

{procedure TRobot.ChangeMaxX(x:integer);
begin
xmax:=x;
self.Repaint;
end;

procedure TRobot.ChangeMaxY(y:integer);
begin
ymax:=y;
self.Repaint;
end;}

END.
