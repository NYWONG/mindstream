unit msDrawness;

interface

uses
 FMX.Graphics,
 Generics.Collections,
 System.SysUtils,
 System.Types,
 System.UITypes,
 msShape,
 msRegisteredPrimitives;

type
 TShapeList = TObjectList<TmsShape>;

 TmsDrawness = class
 private
  FShapeList : TShapeList;
  FCurrentClass : RmsShape;
  FCurrentAddedShape : TmsShape;
  FCanvas : TCanvas;
 private
  procedure DrawTo(const aCanvas : TCanvas; const aOrigin : TPointF);
  function CurrentAddedShape: TmsShape;
 public
  constructor Create(aCanvas: TCanvas);
  destructor Destroy; override;
  procedure AddPrimitive(const aStart: TPointF; const aFinish: TPointF);
  procedure Clear(const aCanvas : TCanvas);
  property CurrentClass : RmsShape read FCurrentClass write FCurrentClass;
  procedure FinalizeCurrentShape(const aFinish: TPointF);
  procedure Invalidate;
  function ShapeFinalized: Boolean;
 end;

implementation

{ TDrawness }

procedure TmsDrawness.AddPrimitive(const aStart: TPointF; const aFinish: TPointF);
begin
 Assert(CurrentClass <> nil);
 FCurrentAddedShape := CurrentClass.Create(aStart, aFinish);
 FShapeList.Add(FCurrentAddedShape);
 if not FCurrentAddedShape.IsNeedsSecondClick then
 // - ���� �� ���� SecondClick, �� ��� �������� - ��������
  FCurrentAddedShape := nil;
  Invalidate;
end;

procedure TmsDrawness.Clear(const aCanvas: TCanvas);
begin
  aCanvas.BeginScene;
  aCanvas.Clear(TAlphaColorRec.Null);
  aCanvas.EndScene;
end;

constructor TmsDrawness.Create(aCanvas: TCanvas);
begin
 FShapeList := TShapeList.Create;
 FCurrentAddedShape := nil;
 FCanvas := aCanvas;
end;

function TmsDrawness.CurrentAddedShape: TmsShape;
begin
 Result := FCurrentAddedShape;
end;

destructor TmsDrawness.Destroy;
begin
 FreeAndNil(FShapeList);
 inherited;
end;

procedure TmsDrawness.DrawTo(const aCanvas: TCanvas; const aOrigin : TPointF);
var
 i : Integer;
begin
 Clear(aCanvas);
 for i:= 0 to FShapeList.Count-1
  do FShapeList[i].DrawTo(aCanvas, aOrigin);
end;

procedure TmsDrawness.FinalizeCurrentShape(const aFinish: TPointF);
begin
  Assert(CurrentAddedShape <> nil);
  CurrentAddedShape.FinalPoint := aFinish;
  FCurrentAddedShape := nil;
  Invalidate;
end;

procedure TmsDrawness.Invalidate;
begin
 DrawTo(FCanvas, TPointF.Create(0,0));
end;

function TmsDrawness.ShapeFinalized: Boolean;
begin
 Result := (CurrentAddedShape = nil);
end;

end.
