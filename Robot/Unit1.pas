/// �������� ����� �����������.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, StdCtrls, ExtCtrls, XPMan,
  Menus,ShellApi, AdvMemo, AdvmPS, RzPanel, AdvCodeList, ImgList,
  RzButton;

type
  TRfD = class(TForm)
    XPManifest1: TXPManifest;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    RzToolbar1: TRzToolbar;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    RzToolButton3: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzToolButton4: TRzToolButton;
    RzSpacer2: TRzSpacer;
    RzToolButton5: TRzToolButton;
    RzSpacer3: TRzSpacer;
    RzToolButton6: TRzToolButton;
    RzSpacer4: TRzSpacer;
    RzToolButton7: TRzToolButton;
    RzToolButton8: TRzToolButton;
    RzMenuToolbarButton1: TRzMenuToolbarButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure robotclick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure MainCommand(w:integer);
    procedure Process;
    procedure CheckEdit;
    procedure N10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
   // function pusto(var a:string): boolean;
  private
  public

  end;

var
  RfD: TRfD;
  i,count,backcount,pustoStr:integer;
  str:string;
  code: array of string;
  error,err:boolean;

implementation

uses Unit3, Unit4, Unit5, Unit6;

{$R *.dfm}


/// �������� ����� �� ���������.
procedure TRfD.Checkedit;
var
  stroka:string;
  j,beginK,endK,m,f:integer;
  mas: array [1..22] of string;
begin
beginK:=0; endK:=0; pustoStr:=0;
mas[1]:='�����';
mas[2]:='����';mas[3]:='�����';mas[4]:='������';mas[5]:='���������';
mas[6]:='�����';
mas[7]:='������������������������'; mas[8]:='��������������������������';
mas[9]:='�����������������������'; mas[10]:='�������������������������';
mas[11]:='������������������������'; mas[12]:='��������������������������';
mas[13]:='�����������������������'; mas[14]:='�������������������������';
mas[16]:='������������������������'; mas[15]:='��������������������������';
mas[17]:='�����������������������'; mas[18]:='�������������������������';
mas[19]:='�����������������������'; mas[20]:='�������������������������';
mas[21]:='������������������������'; mas[22]:='��������������������������';
for i:=0 to Form5.AdvMemo1.Lines.Count-1-pustoStr do
begin
stroka:=code[i];
m:=0;
f:=length(stroka);
for j:=1 to f-m do
  if stroka[j-m]=' ' then
  begin
    Delete(stroka,j-m,1);
    inc(m);
  end;
if stroka <> '' then code[i-pustoStr]:=stroka else inc(pustoStr);
end;
SetLength(code,Form5.AdvMemo1.Lines.Count-pustoStr);
error:=false;

for i:= 0 to Form5.AdvMemo1.Lines.Count-1-pustoStr do
begin
  stroka:=code[i];
  for j:=1 to 22 do
  begin
   if mas[j] <> stroka then error:=true;
   if mas[j] = stroka then
     begin
       if j > 6 then inc(beginK);
       if j = 6 then inc(endK);
       error:=false;
       break;
     end;
  end;
  if error then
  begin
    Form5.AdvMemo1.BreakPoint[i]:=true;
    Form5.RzStatusBar1.SimpleCaption:='������('+IntToStr(i+1)+'): ����������� �������.';
    break;
  end;
end;


if not error then
if beginK <> endK then
begin
error:=true;
Form5.AdvMemo1.BreakPoint[i-1]:=true;
Form5.RzStatusBar1.SimpleCaption:='������('+IntToStr(i)+'):�������� "�����".';
end;

if not error then
begin
Form5.AdvMemo1.ClearBreakpoints;
Form5.RzStatusBar1.SimpleCaption:='�������!';
end;
end;



//// ���������� �������� ������
procedure TRfD.MainCommand(w:integer);
begin
str:=code[w];
if str = '�����' then
begin
  if Form6.R.WallOnUp then
  begin
    ShowMessage('����� �������� � ��������');
    err:=true;
  end else Form6.r.ToUp;
end;

if str = '����' then
begin
  if Form6.R.WallOnDown then
  begin
    ShowMessage('����� �������� � ��������');
    err:=true;
  end
  else Form6.R.ToDown;
end;

if str = '�����' then
begin
  if form6.R.WallOnLeft then
  begin
    ShowMessage('����� �������� � ��������');
    err:=true;
  end else Form6.R.ToLeft;
end;

if str = '������' then
begin
  if Form6.R.WallOnRight then
  begin
    ShowMessage('����� �������� � ��������');
    err:=true;
  end else Form6.R.ToRight;
end;

if str='���������' then
begin
  Form6.R.Mark;
end;
end;
/////////////////////


procedure TRfD.Process;
var
  j:integer;
begin
err:=false;
while (i <= Form5.AdvMemo1.Lines.Count-1) and (err = false) do
begin
str:=code[i];
if str = '�����' then
begin
  if Form6.R.WallOnUp then
  begin
    ShowMessage('����� �������� � ��������');
    break;
  end else Form6.R.ToUp;
end;

if str = '����' then
begin
  if Form6.R.WallOnDown then
  begin
    ShowMessage('����� �������� � ��������');
    break;
  end
  else Form6.R.ToDown;
end;

if str = '�����' then
begin
  if Form6.R.WallOnLeft then
  begin
    ShowMessage('����� �������� � ��������');
    break;
  end else Form6.R.ToLeft;
end;

if str = '������' then
begin
  if Form6.R.WallOnRight then
  begin
    ShowMessage('����� �������� � ��������');
    break;
  end else Form6.R.ToRight;
end;

if str='���������' then
begin
  Form6.R.Mark;
end;

if str = '������������������������' then
begin
   inc(i);
   if Form6.R.FreeOnRight then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '��������������������������' then
begin
   inc(i);
   if not Form6.R.FreeOnRight then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '�����������������������' then
begin
   inc(i);
   if Form6.R.FreeOnLeft then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '�������������������������' then
begin
   inc(i);
   if not Form6.R.FreeOnLeft then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '������������������������' then
begin
   inc(i);
   if Form6.R.FreeOnUp then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '��������������������������' then
begin
   inc(i);
   if not Form6.R.FreeOnUp then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '�����������������������' then
begin
     inc(i);
   if Form6.R.FreeOnDown then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '�������������������������' then
begin
   inc(i);
   if  not Form6.R.FreeOnDown then
   begin
     while (code[i] <> '�����') and (err = false) do
     begin
       MainCommand(i);
       inc(i);
     end;
   end;
end;

if str = '�����������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.FreeOnDown = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '�������������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.WallOnDown = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '������������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.FreeOnRight = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '��������������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.WallOnRight = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '�����������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.FreeOnLeft = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '�������������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.WallOnLeft = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '������������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.FreeOnUp = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;

if str = '��������������������������' then
begin
  inc(i); j:=i;
   while (Form6.R.WallOnUp = true) and (err = false) do
   begin
     j:=i;
     while (code[j] <> '�����') and (err = false) do
     begin
       MainCommand(j);
       inc(j);
     end;
   end;
end;
inc(i);
end;

end;



procedure TRfD.N2Click(Sender: TObject);
begin
  Form6.R.Load('d');
end;


procedure TRfD.N5Click(Sender: TObject);
var
  k:integer;
begin
Setlength(code,Form5.AdvMemo1.Lines.Count);
for i:=0 to Form5.AdvMemo1.Lines.Count-1 do
  code[i]:=Form5.AdvMemo1.Lines[i];
CheckEdit;
i:=0;
if (not error) and (pustoStr <> Form5.AdvMemo1.Lines.Count)  then
begin
Process;
end;


end;

procedure TRfD.N7Click(Sender: TObject);
begin
Form3.Show;
end;


procedure TRfD.N4Click(Sender: TObject);
begin
close;
end;

procedure TRfD.N3Click(Sender: TObject);
begin
if SaveDialog1.Execute then
  Form5.AdvMemo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TRfD.N8Click(Sender: TObject);
begin
if OpenDialog1.Execute then
  Form5.AdvMemo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TRfD.N9Click(Sender: TObject);
begin
ShellExecute(handle,'open','rsme.exe',nil,nil,SW_SHOWNORMAL);
end;

procedure TRfD.N10Click(Sender: TObject);
begin
Form4.Show;
end;



procedure TRfD.FormCreate(Sender: TObject);
begin
count:=1;
backcount:=1;
end;


procedure TRfD.FormShow(Sender: TObject);
begin
Form5.Show;
Form6.Show;
end;

procedure TRfD.N1Click(Sender: TObject);
begin

if N1.Checked then
begin
  Form6.Show;
  N1.Checked:=true;
end;
if not N1.Checked then
begin
  Form6.Hide;
  N1.Checked:=false;
end;

end;

procedure TRfD.robotclick(Sender: TObject);
begin
if N2.Checked then
begin
  Form5.Show;
  N2.Checked:=true;
end;
if not N2.Checked then
begin
  Form5.Hide;
  N2.Checked:=false;
end;
end;

end.