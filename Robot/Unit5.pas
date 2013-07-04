unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvCodeList, AdvMemo, ImgList, AdvmPS, ExtCtrls,
  RzPanel;

type
  TForm5 = class(TForm)
    AdvMemo1: TAdvMemo;
    AdvPascalMemoStyler1: TAdvPascalMemoStyler;
    ImageList1: TImageList;
    AdvMemoCapitalChecker1: TAdvMemoCapitalChecker;
    AdvCodeList1: TAdvCodeList;
    RzStatusBar1: TRzStatusBar;
    procedure AdvMemo1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AdvMemo1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AdvCodeList1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AdvCodeList1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit1;

{$R *.dfm}



procedure TForm5.AdvMemo1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (source is tadvcodelist) then
  begin
    AdvMemo1.DropText(x,y,advcodelist1.CodeBlocks.Items[advcodelist1.itemindex].Code.Text);
  end;
end;

procedure TForm5.AdvMemo1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := true;
end;

procedure TForm5.AdvCodeList1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
Advcodelist1.CodeBlocks.Add(advmemo1.Selection);
AdvCodeList1.CodeBlocks[AdvCodeList1.CodeBlocks.Count - 1].ImageIndex := 0;
end;

procedure TForm5.AdvCodeList1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
Accept := (source is TAdvMemo);
end;


procedure TForm5.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose:=false;
Hide;
Rfd.N2.Checked:=false;
end;

end.
