unit RectanglesBuilder;

interface

uses
  Spring.Collections,
  {}
  FormArrangerC;

function GivenLineOfRectagles(const aRectnagleHeights: TArray<Integer>)
  : IList<TRectangle>;

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
    Result.Add(CreateRectangle(left, top, height));
    left := left + MarginHorizontal+FormWidth;
  end;
end;

end.
