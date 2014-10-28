unit TestMsRectangle;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, FMX.Types, msShape, System.UITypes, FMX.Graphics, System.Types,
  msRectangle;

type
  // Test methods for class TmsRectangle

  TestTmsRectangle = class(TTestCase)
  strict private
    FmsRectangle: TmsRectangle;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestContainsPt;
  end;

implementation

procedure TestTmsRectangle.SetUp;
begin
  FmsRectangle := TmsRectangle.Create;
end;

procedure TestTmsRectangle.TearDown;
begin
  FmsRectangle.Free;
  FmsRectangle := nil;
end;

procedure TestTmsRectangle.TestContainsPt;
var
  ReturnValue: Boolean;
  aPoint: TPointF;
begin
  // TODO: Setup method call parameters
  ReturnValue := FmsRectangle.ContainsPt(aPoint);
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTmsRectangle.Suite);
end.

