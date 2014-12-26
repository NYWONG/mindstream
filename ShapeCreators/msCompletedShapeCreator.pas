unit msCompletedShapeCreator;

interface

uses
 msShapeCreator,
 msInterfaces
 ;

type
 TmsCompletedShapeCreator = class(TmsShapeCreator)
 // ��������� TmsShape. ��! ����������� ����������
 protected
  function CreateShape(const aContext: TmsMakeShapeContext): ImsShape; override;
 end;//TmsCompletedShapeCreator

implementation

// TmsCompletedShapeCreator

function TmsCompletedShapeCreator.CreateShape(const aContext: TmsMakeShapeContext): ImsShape;
begin
 Result := inherited CreateShape(aContext);
end;

end.
