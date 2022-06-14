unit FormArrangerTests;

interface

uses
  DUnitX.TestFramework,
  System.Math,
  Spring.Collections;

type
  // IFormArranger
  TRectangle = class
    Top: Integer;
    Left: Integer;
    Height: Integer;
  end;

  TFormArranger = class
    function Arrange(
      const rectangles: IList<TRectangle>;
      const aNewRectangleHeight: Integer): TRectangle;
  end;

const
  MarginHorizontal = 10;
  MarginVertical = 20;
  FormWidth = 200;
  ScreenWidth = 600;

type

  [TestFixture]
  TMyTestObject = class
  private
    rectangles: IList<TRectangle>;
    newRectangle: TRectangle;
    sut: TFormArranger;
  public

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure ArrangeOnEmptyScreen;
    [Test]
    procedure ArrangeOnScreenWithOneRectangle;
    [Test]
    procedure ArrangeOnScreenWithFullLineOfRectangles;
  end;

implementation

function CreateRectangle(
  aLeft: Integer;
  aTop: Integer;
  aHeight: Integer): TRectangle;
begin
  Result := TRectangle.Create;
  Result.Left := aLeft;
  Result.Top := aTop;
  Result.Height := aHeight;
end;

procedure TMyTestObject.ArrangeOnEmptyScreen;
begin
  // Arrange
  rectangles := TCollections.CreateObjectList<TRectangle>();

  // Act
  newRectangle := sut.Arrange(rectangles, 20);

  // Assert
  Assert.AreEqual(MarginHorizontal, newRectangle.Left);
  Assert.AreEqual(MarginVertical, newRectangle.Top);
end;

procedure TMyTestObject.ArrangeOnScreenWithOneRectangle;
begin
  rectangles := TCollections.CreateObjectList<TRectangle>
    ([CreateRectangle(MarginHorizontal, MarginVertical, 50)]);

  newRectangle := sut.Arrange(rectangles, 20);

  Assert.AreEqual(2 * MarginHorizontal + FormWidth, newRectangle.Left);
  Assert.AreEqual(MarginVertical, newRectangle.Top);
end;

procedure TMyTestObject.ArrangeOnScreenWithFullLineOfRectangles;
begin
  rectangles := TCollections.CreateObjectList<TRectangle>
    ([CreateRectangle(MarginHorizontal, MarginVertical, 50),
      CreateRectangle(2*MarginHorizontal+FormWidth, MarginVertical, 50)]);

  newRectangle := sut.Arrange(rectangles, 20);

  Assert.AreEqual(MarginHorizontal, newRectangle.Left);
  Assert.AreEqual(2*MarginVertical+50, newRectangle.Top);
end;

procedure TMyTestObject.Setup;
begin
  sut := TFormArranger.Create;
end;

procedure TMyTestObject.TearDown;
begin
  sut.Free;
end;

{ TFormArranger }

function TFormArranger.Arrange(
  const rectangles: IList<TRectangle>;
  const aNewRectangleHeight: Integer): TRectangle;
var
  rectangle: TRectangle;
begin
  Result := TRectangle.Create;
  Result.Left := MarginHorizontal;
  Result.Top := MarginVertical;
  for rectangle in rectangles do
  begin
    Result.Left := Result.Left + MarginHorizontal + FormWidth;
    if Result.Left + FormWidth >= ScreenWidth then
    begin
      Result.Top := Result.Top + rectangles.First.Height + MarginVertical;
      Result.Left := MarginHorizontal;
    end;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestObject);

end.
