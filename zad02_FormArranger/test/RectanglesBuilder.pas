unit RectanglesBuilder;

interface

uses
  Spring.Collections,
  {}
  FormArrangerC;

type
  TRectangleBuilder = class
  private
    fRectagles: IList<TRectangle>;
  public
    constructor Create();
    function WithLineOfRectangles(
      const aTop: Integer;
      const aRectnagleHeights: TArray<Integer>): TRectangleBuilder;
    function Build: IList<TRectangle>;
  end;

function GivenLineOfRectagles(const aRectnagleHeights: TArray<Integer>)
  : IList<TRectangle>;

implementation

function GivenLineOfRectagles(const aRectnagleHeights: TArray<Integer>)
  : IList<TRectangle>;
var
  builder: TRectangleBuilder;
begin
  builder := TRectangleBuilder.Create()
    .WithLineOfRectangles(MarginVertical, aRectnagleHeights);
  Result := builder.Build();
  builder.Free;
end;

{ TRectangleBuilder }

constructor TRectangleBuilder.Create();
begin
  fRectagles := TCollections.CreateList<TRectangle>();
end;

function TRectangleBuilder.Build: IList<TRectangle>;
begin
  Result := TCollections.CreateObjectList<TRectangle>(fRectagles);
end;

function TRectangleBuilder.WithLineOfRectangles(
  const aTop: Integer;
  const aRectnagleHeights: TArray<Integer>): TRectangleBuilder;
var
  height: Integer;
  left: Integer;
  top: Integer;
begin
  Result := self;
  left := MarginHorizontal;
  top := aTop;
  for height in aRectnagleHeights do
  begin
    if height > 0 then
    begin
      fRectagles.Add(TRectangle.Create(left, top, height));
    end;
    left := left + MarginHorizontal + FormWidth;
  end;
end;

end.
