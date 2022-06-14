unit FormArrangerC;

interface

uses
  Spring.Collections;

const
  MarginHorizontal = 10;
  MarginVertical = 20;
  FormWidth = 200;
  ScreenWidth = 600;

type
  TRectangle = class
    Top: Integer;
    Left: Integer;
    Height: Integer;
  end;

  // IFormArranger
  TFormArranger = class
    function Arrange(
      const rectangles: IList<TRectangle>;
      const aNewRectangleHeight: Integer): TRectangle;
  end;

implementation

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

end.
