unit msTriangle;

interface

uses
 System.Types,
 FMX.Graphics,
 FMX.Types,
 System.UITypes,
 System.Math.Vectors,
 msInterfaces,
 msPolygonShape
 ;

type
 TmsTriangle = class(TmsPolygonShape)
 protected
  class function InitialHeight: Single; override;
  function GetPolygon: TPolygon; override;
  procedure TransformDrawOptionsContext(var theCtx: TmsDrawOptionsContext); override;
 public
  class function IsForToolbar: Boolean; override;
 end;//TmsTriangle

implementation

uses
 System.Math;

class function TmsTriangle.InitialHeight: Single;
begin
 Result := 100;
end;

class function TmsTriangle.IsForToolbar: Boolean;
begin
 Result := True;
end;

function TmsTriangle.GetPolygon: TPolygon;
begin
 SetLength(Result, 4);
 Result[0] := TPointF.Create(StartPoint.X - InitialHeight / 2,
                             StartPoint.Y + InitialHeight / 2);
 Result[1] := TPointF.Create(StartPoint.X + InitialHeight / 2,
                             StartPoint.Y + InitialHeight / 2);
 Result[2] := TPointF.Create(StartPoint.X,
                             StartPoint.Y - InitialHeight / 2);
 Result[3] := Result[0];
end;

procedure TmsTriangle.TransformDrawOptionsContext(var theCtx: TmsDrawOptionsContext);
begin
 inherited;
 theCtx.rFillColor := TAlphaColorRec.Green;
end;

end.
