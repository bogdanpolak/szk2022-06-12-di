unit FormArrangerTests;

interface

uses
  DUnitX.TestFramework,
  System.Math,
  Spring.Collections,
  {}
  FormArrangerC,
  RectanglesBuilder;

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

procedure TMyTestObject.ArrangeOnEmptyScreen;
begin
  // Arrange
  rectangles := GivenLineOfRectagles([]);

  // Act
  newRectangle := sut.Arrange(rectangles, 20);

  // Assert
  Assert.AreEqual(MarginHorizontal, newRectangle.Left);
  Assert.AreEqual(MarginVertical, newRectangle.Top);
end;

procedure TMyTestObject.ArrangeOnScreenWithOneRectangle;
begin
  rectangles := GivenLineOfRectagles([50]);

  newRectangle := sut.Arrange(rectangles, 20);

  Assert.AreEqual(2 * MarginHorizontal + FormWidth, newRectangle.Left);
  Assert.AreEqual(MarginVertical, newRectangle.Top);
end;

procedure TMyTestObject.ArrangeOnScreenWithFullLineOfRectangles;
begin
  rectangles := GivenLineOfRectagles([50, 50]);

  newRectangle := sut.Arrange(rectangles, 20);

  Assert.AreEqual(MarginHorizontal, newRectangle.Left);
  Assert.AreEqual(2 * MarginVertical + 50, newRectangle.Top);
end;

procedure TMyTestObject.Setup;
begin
  sut := TFormArranger.Create;
end;

procedure TMyTestObject.TearDown;
begin
  sut.Free;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestObject);

end.
