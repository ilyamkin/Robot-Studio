program Project2;

{%ToDo 'Project2.todo'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Editor};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Robot Studio: Map Editor';
  Application.CreateForm(TEditor, Editor);
  Application.Run;
end.
