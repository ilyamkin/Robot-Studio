unit RegisterAB;

interface

{$I DFS.inc}

uses

  {$IFDEF DFS_DELPHI_5}
  DsgnIntf,
  {$ELSE}
  DesignIntf, DesignEditors,
  {$ENDIF}
  Windows, RichMemo, WordsParamsEditor,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Contnrs;

type
  TRichMemoProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

procedure Register;

function EditColorWords(ACollectionColorWords : TCollectionColorWords) : Boolean;

implementation

procedure TRichMemoProperty.Edit;
begin
   if EditColorWords(TCollectionColorWords(GetOrdValue)) then Modified;
end;

function TRichMemoProperty.GetAttributes : TPropertyAttributes;
begin
   Result := [paDialog, paReadOnly];
end;

function EditColorWords(ACollectionColorWords : TCollectionColorWords) : Boolean;
var
   Editor  : TWordsParamsEditor;
   i       : Integer;
   mObject : TColorWords;
begin
   Application.CreateForm(TWordsParamsEditor, Editor);
   try
      if Assigned(Editor.FList) and (Editor.FList.Count > 0) then
         for i := Editor.FList.Count - 1 downto 0 do
            Editor.FList.Delete(i);
         Editor.memMain.Lines.Clear;
         for i := 0 to ACollectionColorWords.FList.Count - 1 do begin
            mObject := TColorWords.Create;
            with mObject do begin
               Color      := TColorWords(ACollectionColorWords.FList.Items[i]).Color;
               Words      := TColorWords(ACollectionColorWords.FList.Items[i]).Words;
               BSelString := TColorWords(ACollectionColorWords.FList.Items[i]).BSelString;
               SelectionR := TColorWords(ACollectionColorWords.FList.Items[i]).SelectionR;
               LScob      := TColorWords(ACollectionColorWords.FList.Items[i]).LScob;
               RScob      := TColorWords(ACollectionColorWords.FList.Items[i]).RScob;
               TypeFont   := TColorWords(ACollectionColorWords.FList.Items[i]).TypeFont;
            end;
            Editor.FList.Add(mObject);
         end;
      Editor.LoadData;

      if Editor.ShowModal = mrOK then
         begin
        // заполнение структуры ACollectionColorWords
         if Assigned(ACollectionColorWords.FList) and (ACollectionColorWords.FList.Count > 0) then
            for i := ACollectionColorWords.FList.Count - 1 downto 0 do
               ACollectionColorWords.FList.Delete(i);
         for i := 0 to Editor.FList.Count - 1 do begin
            mObject := TColorWords.Create;
            with mObject do begin
               Color      := TColorWords(Editor.FList.Items[i]).Color;
               Words      := TColorWords(Editor.FList.Items[i]).Words;
               BSelString := TColorWords(Editor.FList.Items[i]).BSelString;
               SelectionR := TColorWords(Editor.FList.Items[i]).SelectionR;
               LScob      := TColorWords(Editor.FList.Items[i]).LScob;
               RScob      := TColorWords(Editor.FList.Items[i]).RScob;
               TypeFont   := TColorWords(Editor.FList.Items[i]).TypeFont;
            end;
            ACollectionColorWords.FList.Add(mObject);
         end;
         Result:=True;
         end
      else Result:=False;
   finally
      Editor.Free;
   end;
end;

procedure Register;
begin
   RegisterComponents('Abilan', [TRichMemo]);
   RegisterPropertyEditor(TypeInfo(TCollectionColorWords), TRichMemo, 'CollectionColorWords', TRichMemoProperty);
end;


end.
