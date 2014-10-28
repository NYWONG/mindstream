unit TestMsPointCircle;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, System.UITypes, msPointCircle, msShape, msCircle, FMX.Graphics,
  System.Types;

type
  // Test methods for class TmsPointCircle

  TestTmsPointCircle = class(TTestCase)
  strict private
    FmsPointCircle: TmsPointCircle;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  end;

implementation

procedure TestTmsPointCircle.SetUp;
begin
  FmsPointCircle := TmsPointCircle.Create;
end;

procedure TestTmsPointCircle.TearDown;
begin
  FmsPointCircle.Free;
  FmsPointCircle := nil;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTmsPointCircle.Suite);
end.

