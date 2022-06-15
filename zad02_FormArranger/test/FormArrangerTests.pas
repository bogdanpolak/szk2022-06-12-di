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
    arrangerConfiguration: TArrangerConfiguration;
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
    procedure ArrangeGivenFirstSlotEmpty;
    [Test]
    procedure ArrangeGivenSecondSlotEmpty;
  end;

implementation

{ Configuration Builder }

function GivenDefaultConfiguration(): TArrangerConfiguration; overload;
begin
  Result := TArrangerConfiguration.Create;
  with Result do
  begin
    MarginHorizontal := 10;
    MarginVertical := 20;
    FormWidth := 200;
    ScreenWidth := 600;
  end;
end;

{ Unit Tests }

procedure TMyTestObject.ArrangeOnEmptyScreen;
begin
  // Arrange
  rectangles := GivenLineOfRectagles([], GivenDefaultConfiguration());

  // Act
  position := sut.Arrange(rectangles, 20);

  // Assert
  position.ShouldBe(10, 20);
end;

procedure TMyTestObject.ArrangeOnScreenWithOneRectangle;
begin
  rectangles := GivenLineOfRectagles([50], GivenDefaultConfiguration());

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(2 * 10 + 200, 20);
end;

procedure TMyTestObject.ArrangeOnScreenWithFullLineOfRectangles;
begin
  rectangles := GivenLineOfRectagles([50, 50], GivenDefaultConfiguration());

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(10, 2 * 20 + 50);
end;

procedure TMyTestObject.ArrangeGivenDifferentHeightRectangles;
begin
  rectangles := GivenLineOfRectagles([20, 50], GivenDefaultConfiguration());

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(10, 2 * 20 + 50);
end;

procedure TMyTestObject.ArrangeGivenTwoFilledLinesOfRectangles;
begin
  rectangles := rectangleBuilder { }
    .WithLineOfRectangles(20, [20, 50]) { }
    .WithLineOfRectangles(90, [40, 30]) { }
    .WithLineOfRectangles(150, [35]).Build();

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(220, 150);
end;

const
  Empty = 0;

procedure TMyTestObject.ArrangeGivenFirstSlotEmpty;
begin
  rectangles := GivenLineOfRectagles([Empty, 50], GivenDefaultConfiguration());

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(10, 20);
end;

procedure TMyTestObject.ArrangeGivenSecondSlotEmpty;
begin
  arrangerConfiguration.ScreenWidth := 1000;
  rectangles := GivenLineOfRectagles([40, Empty, 50], arrangerConfiguration);

  position := sut.Arrange(rectangles, 20);

  position.ShouldBe(220, 20);
end;

procedure TMyTestObject.Setup;
begin
  arrangerConfiguration := GivenDefaultConfiguration();
  sut := TFormArranger.Create(arrangerConfiguration);
  rectangleBuilder := TRectangleBuilder.Create(arrangerConfiguration);
end;

procedure TMyTestObject.TearDown;
begin
  sut.Free;
  rectangleBuilder.Free;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestObject);

end.
