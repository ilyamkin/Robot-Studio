unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzPrgres, jpeg, ExtCtrls, RzForms, StdCtrls;

type
  TForm7 = class(TForm)
    RzFormShape1: TRzFormShape;
    Label1: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;
  i:integer;

implementation

uses Unit1, Unit5;

{$R *.dfm}

procedure TForm7.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
Form7.Close;
RfD.Show;
Form5.Visible:=true;
end;

procedure TForm7.Timer2Timer(Sender: TObject);
begin
inc(i);
label1.Caption:=IntToStr(i)+'%';
if i > 99 then Timer2.Enabled:=false;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
i:=1;
end;

end.
