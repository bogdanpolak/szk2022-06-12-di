unit FormArrangerC;

interface

uses
  System.Math,
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
  maxLineHeight: Integer;
begin
  Result := TRectangle.Create;
  Result.Left := MarginHorizontal;
  Result.Top := MarginVertical;
  maxLineHeight := 0;
  for rectangle in rectangles do
  begin
    Result.Left := Result.Left + MarginHorizontal + FormWidth;
    maxLineHeight := Max(maxLineHeight, rectangle.Height);
    if Result.Left + FormWidth >= ScreenWidth then
    begin
      Result.Top := Result.Top + maxLineHeight + MarginVertical;
      maxLineHeight := 0;
      Result.Left := MarginHorizontal;
    end;
  end;
end;

end.
