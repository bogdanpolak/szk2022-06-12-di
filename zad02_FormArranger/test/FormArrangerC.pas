unit FormArrangerC;

interface

uses
  System.Math,
  Spring.Collections,
  {}
  FormArranger;

type
  TFormArranger = class
    function Arrange(
      const rectangles: IList<TRectangle>;
      const aNewRectangleHeight: Integer): TPosition;
  end;

implementation

{ TFormArranger }

function TFormArranger.Arrange(
  const rectangles: IList<TRectangle>;
  const aNewRectangleHeight: Integer): TPosition;
var
  rect: TRectangle;
  maxLineHeight: Integer;
  Left: Integer;
  Top: Integer;
begin
  Left := MarginHorizontal;
  Top := MarginVertical;
  maxLineHeight := 0;
  if rectangles.IsEmpty or (rectangles.First.Left <> MarginHorizontal) or
    (rectangles.First.Top <> MarginVertical) then
    Exit(TPosition.Create(Left, Top));
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
  Result := TPosition.Create(Left, Top);
end;

end.
