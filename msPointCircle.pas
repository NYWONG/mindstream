unit msPointCircle;

interface

uses
 FMX.Graphics,
 System.Types,
 msShape;

type
 TmsPointCircle = class(TmsShape)
 protected
  procedure DrawShape(const aCanvas : TCanvas; const aOrigin : TPointF); override;
  procedure DoLogic; override;
 public
  constructor Create(const aStartPoint, aFinishPoint: TPointF); override;
  class function IsNeedsSecondClick : Boolean; override;
 end;

implementation

{ TmsPointCircle }

const
 c_CircleRadius = 10;

constructor TmsPointCircle.Create(const aStartPoint, aFinishPoint: TPointF);
begin
  inherited;

end;

procedure TmsPointCircle.DoLogic;
begin
 inherited;

end;

procedure TmsPointCircle.DrawShape(const aCanvas: TCanvas;
                                   const aOrigin : TPointF);
var
 l_StartPoint, l_FinalPoint: TPointF;
begin
 l_StartPoint.X := FStartPoint.X - c_CircleRadius;
 l_StartPoint.Y := FStartPoint.Y - c_CircleRadius;

 l_FinalPoint.X := FStartPoint.X + c_CircleRadius;
 l_FinalPoint.Y := FStartPoint.Y + c_CircleRadius;

 aCanvas.DrawEllipse(TRectF.Create(l_StartPoint.Add(aOrigin),
                                   l_FinalPoint.Add(aOrigin)), 1);
end;

class function TmsPointCircle.IsNeedsSecondClick: Boolean;
begin
  Result := False;
end;

end.
