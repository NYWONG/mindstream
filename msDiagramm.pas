unit msDiagramm;

interface

uses
 FMX.Graphics,
 Generics.Collections,
 System.SysUtils,
 System.Types,
 System.UITypes,
 msShape,
 msRegisteredPrimitives,
 msPointCircle;

type
 TShapeList = TObjectList<TmsShape>;

 TmsDiagramm = class
 private
  FShapeList : TShapeList;
  FCurrentClass : RmsShape;
  FCurrentAddedShape : TmsShape;
  FCanvas : TCanvas;
  FOrigin : TPointF;
 private
  procedure DrawTo(const aCanvas : TCanvas; const aOrigin : TPointF);
  function CurrentAddedShape: TmsShape;
 public
  constructor Create(aCanvas: TCanvas);
  procedure CanvasChanged(aCanvas: TCanvas);
  destructor Destroy; override;
  procedure BeginShape(const aStart: TPointF);
  procedure Clear;
  property CurrentClass : RmsShape read FCurrentClass write FCurrentClass;
  procedure EndShape(const aFinish: TPointF);
  procedure Invalidate;
  function ShapeIsEnded: Boolean;
 end;

implementation

{ TDrawness }

procedure TmsDiagramm.BeginShape(const aStart: TPointF);
begin
 Assert(CurrentClass <> nil);
 FCurrentAddedShape := CurrentClass.Create(aStart, aStart);
 FShapeList.Add(FCurrentAddedShape);
 if not FCurrentAddedShape.IsNeedsSecondClick then
 // - ���� �� ���� SecondClick, �� ��� �������� - ��������
  FCurrentAddedShape := nil;
 Invalidate;
end;

procedure TmsDiagramm.Clear;
begin
 FCanvas.BeginScene;
 try
  FCanvas.Clear(TAlphaColorRec.Null);
 finally
  FCanvas.EndScene;
 end;//try..finally
end;

constructor TmsDiagramm.Create(aCanvas: TCanvas);
begin
 FShapeList := TShapeList.Create;
 FCurrentAddedShape := nil;
 FCanvas := aCanvas;
 FOrigin := TPointF.Create(0, 0)
end;

procedure TmsDiagramm.CanvasChanged(aCanvas: TCanvas);
begin
 FCanvas := aCanvas;
 Invalidate;
end;

function TmsDiagramm.CurrentAddedShape: TmsShape;
begin
 Result := FCurrentAddedShape;
end;

destructor TmsDiagramm.Destroy;
begin
 FreeAndNil(FShapeList);
 inherited;
end;

procedure TmsDiagramm.DrawTo(const aCanvas: TCanvas; const aOrigin : TPointF);
var
 l_Shape : TmsShape;
begin
 aCanvas.BeginScene;
 try
  for l_Shape in FShapeList do
   l_Shape.DrawTo(aCanvas, aOrigin);
 finally
  aCanvas.EndScene;
 end;//try..finally
end;

procedure TmsDiagramm.EndShape(const aFinish: TPointF);
begin
 Assert(CurrentAddedShape <> nil);
 CurrentAddedShape.EndTo(aFinish);
 FCurrentAddedShape := nil;
 Invalidate;
end;

procedure TmsDiagramm.Invalidate;
begin
 Clear;
 DrawTo(FCanvas, FOrigin);
end;

function TmsDiagramm.ShapeIsEnded: Boolean;
begin
 Result := (CurrentAddedShape = nil);
end;

end.
