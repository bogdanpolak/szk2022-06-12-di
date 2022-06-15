unit FormArrangerC;

interface

uses
  System.Math,
  Spring.Collections,
  {}
  FormArranger;

type
  TFormArranger = class
  private
    fArrangerConfiguration: TArrangerConfiguration;
  public
    constructor Create(aArrangerConfiguration: TArrangerConfiguration);
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
  marginX: Integer;
  marginY: Integer;
  formWidth: Integer;
  rect: TRectangle;
  maxLineHeight: Integer;
  Left: Integer;
  Top: Integer;
begin
  marginX := fArrangerConfiguration.MarginHorizontal;
  marginY := fArrangerConfiguration.MarginVertical;
  formWidth := fArrangerConfiguration.FormWidth;
  Left := fArrangerConfiguration.MarginHorizontal;
  Top := fArrangerConfiguration.MarginVertical;
  maxLineHeight := 0;
  if rectangles.IsEmpty or (rectangles.First.Left <> marginX) or
    (rectangles.First.Top <> marginY) then
    Exit(TPosition.Create(Left, Top));
  for rect in rectangles do
  begin
    Left := Left + marginX + formWidth;
    maxLineHeight := Max(maxLineHeight, rect.Height);
    if Left + formWidth >= fArrangerConfiguration.ScreenWidth then
    begin
      Top := Top + maxLineHeight + marginY;
      maxLineHeight := 0;
      Left := marginX;
    end;
  end;
  Result := TPosition.Create(Left, Top);
end;

constructor TFormArranger.Create(
  aArrangerConfiguration: TArrangerConfiguration);
begin
  fArrangerConfiguration := aArrangerConfiguration;
end;

end.
