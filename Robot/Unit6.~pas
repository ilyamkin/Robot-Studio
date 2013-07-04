unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, robot;

type
  TForm6 = class(TForm)
    R: TRobot;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses Unit5,Unit1;

{$R *.dfm}


procedure TForm6.FormShow(Sender: TObject);
begin
// Form 6//
Top:=Rfd.Height+10;
Left:=5;
Height:=Screen.Height - Top-35;
////

///Form 5//
Form5.Top:=Rfd.Height+10;
Form5.Left:=Width+15;
Form5.Width:=Screen.Width- Form6.Width-20;
Form5.Height:=Screen.Height - Top-35;
//
end;

procedure TForm6.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=false;
Hide;
Rfd.N1.Checked:=false;
end;

end.
