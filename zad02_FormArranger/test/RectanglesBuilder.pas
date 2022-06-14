unit RectanglesBuilder;

interface

uses
  Spring.Collections,
  {}
  FormArrangerC;

function GivenLineOfRectagles(const aRectnagleHeights: TArray<Integer>)
  : IList<TRectangle>;

implementation

function GivenLineOfRectagles(const aRectnagleHeights: TArray<Integer>)
  : IList<TRectangle>;
var
  height: Integer;
  left: Integer;
  top: Integer;
begin
  Result := TCollections.CreateObjectList<TRectangle>();
  left := MarginHorizontal;
  top := MarginVertical;
  for height in aRectnagleHeights do
  begin
    Result.Add(TRectangle.Create(left, top, height));
    left := left + MarginHorizontal+FormWidth;
  end;
end;

end.
