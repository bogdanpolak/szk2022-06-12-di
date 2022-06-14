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
  public
    Top: Integer;
    Left: Integer;
    Height: Integer;
    constructor Create(
      const aLeft: Integer;
      const aTop: Integer;
      const aHeight: Integer);
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
  rect: TRectangle;
  maxLineHeight: Integer;
  Left: Integer;
  Top: Integer;
begin
  Left := MarginHorizontal;
  Top := MarginVertical;
  maxLineHeight := 0;
  for rect in rectangles do
  begin
    Left := Left + MarginHorizontal + FormWidth;
    maxLineHeight := Max(maxLineHeight, rect.Height);
    if Left + FormWidth >= ScreenWidth then
    begin
      Top := Top + maxLineHeight + MarginVertical;
      maxLineHeight := 0;
      Left := MarginHorizontal;
    end;
  end;
  Result := TRectangle.Create(left, top, aNewRectangleHeight);
end;

{ TRectangle }

constructor TRectangle.Create(const aLeft, aTop, aHeight: Integer);
begin
  Left := aLeft;
  Top := aTop;
  Height := aHeight;
end;

end.
