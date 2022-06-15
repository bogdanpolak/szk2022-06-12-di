unit PositionHelper;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  FormArrangerC;

type
  TPositionHelper = record helper for TPosition
    procedure ShouldBe(const aLeft, aTop: Integer);
  end;

implementation

{ TPositionHelper }

procedure TPositionHelper.ShouldBe(const aLeft, aTop: Integer);
begin
  if (aLeft <> self.Left) or (aTop <> self.Top) then
  begin
    Assert.Fail(Format('Expected position (%d,%d), but found (%d,%d)',
      [aLeft, aTop, self.Left, self.Top]));
  end;
  Assert.Pass();
end;

end.
