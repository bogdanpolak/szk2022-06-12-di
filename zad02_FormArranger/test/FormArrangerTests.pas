unit FormArrangerTests;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Math,
  Spring.Collections,
  {}
  FormArranger,
  FormArrangerC,
  RectanglesBuilder,
  PositionHelper;

type

  [TestFixture]
  TMyTestObject = class
  private
    rectangles: IList<TRectangle>;
    position: TPosition;
    rectangleBuilder: TRectangleBuilder;
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
    [Test]
    procedure ArrangeGivenDifferentHeightRectangles;
    [Test]
    procedure ArrangeGivenTwoFilledLinesOfRectangles;
    [Test]
    procedure ArrangeGivenEmptySpace;
  end;

implementation

procedure TMyTestObject.ArrangeOnEmptyScreen;
begin
  // Arrange
  rectangles := GivenLineOfRectagles([]);

  // Act
  position := sut.Arrange(rectangles, 20);

  // Assert
  position.ShouldBe(MarginHorizontal, MarginVertical);
end;

procedure TMyTestObject.ArrangeOnScreenWithOneRectangle;
begin
  rectangles := GivenLineOfRectagles([50]);

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(2 * MarginHorizontal + FormWidth, MarginVertical);
end;

procedure TMyTestObject.ArrangeOnScreenWithFullLineOfRectangles;
begin
  rectangles := GivenLineOfRectagles([50, 50]);

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(MarginHorizontal, 2 * MarginVertical + 50);
end;

procedure TMyTestObject.ArrangeGivenDifferentHeightRectangles;
begin
  rectangles := GivenLineOfRectagles([20, 50]);

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(MarginHorizontal, 2 * MarginVertical + 50);
end;

procedure TMyTestObject.ArrangeGivenTwoFilledLinesOfRectangles;
begin
  rectangles := rectangleBuilder { }
    .WithLineOfRectangles(MarginVertical, [20, 50]) { }
    .WithLineOfRectangles(2 * MarginVertical + 50, [40, 30])
    .WithLineOfRectangles(3 * MarginVertical + 50 + 40, [35]).Build();

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(2 * MarginHorizontal + FormWidth,
    3 * MarginVertical + 50 + 40);
end;

const
  Empty = 0;

procedure TMyTestObject.ArrangeGivenEmptySpace;
begin
  rectangles := GivenLineOfRectagles([Empty, 50]);

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(MarginHorizontal, MarginVertical);
end;

procedure TMyTestObject.Setup;
begin
  sut := TFormArranger.Create;
  rectangleBuilder := TRectangleBuilder.Create();
end;

procedure TMyTestObject.TearDown;
begin
  sut.Free;
  rectangleBuilder.Free;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestObject);

end.
