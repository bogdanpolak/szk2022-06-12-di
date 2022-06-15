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
    function RectangleAtSlot(
      const aLeft, aTop: Integer;
      const rectangles: IList<TRectangle>): TRectangle;
  public
    constructor Create(aArrangerConfiguration: TArrangerConfiguration);
    function Arrange(
      const rectangles: IList<TRectangle>;
      const aNewRectangleHeight: Integer): TPosition;
  end;

implementation

{ TFormArranger }

function TFormArranger.RectangleAtSlot(
  const aLeft, aTop: Integer;
  const rectangles: IList<TRectangle>): TRectangle;
begin
  Result := rectangles.Where(
    function(const rect: TRectangle): boolean
    begin
      Result := (rect.Left = aLeft) and (rect.Top = aTop);
    end).FirstOrDefault;
end;

function TFormArranger.Arrange(
  const rectangles: IList<TRectangle>;
  const aNewRectangleHeight: Integer): TPosition;
var
  marginX: Integer;
  marginY: Integer;
  formWidth: Integer;
  maxLineHeight: Integer;
  rect: TRectangle;
begin
  marginX := fArrangerConfiguration.MarginHorizontal;
  marginY := fArrangerConfiguration.MarginVertical;
  formWidth := fArrangerConfiguration.formWidth;
  Result := TPosition.Create(marginX, marginY);
  maxLineHeight := 0;
  while true do
  begin
    rect := RectangleAtSlot(Result.Left, Result.Top, rectangles);
    if rect = nil then
      Exit;
    Result.Left := Result.Left + marginX + formWidth;
    maxLineHeight := Max(maxLineHeight, rect.Height);
    if Result.Left + formWidth >= fArrangerConfiguration.ScreenWidth then
    begin
      Result.Top := Result.Top + maxLineHeight + marginY;
      maxLineHeight := 0;
      Result.Left := marginX;
    end;
  end;
end;

constructor TFormArranger.Create(aArrangerConfiguration
  : TArrangerConfiguration);
begin
  fArrangerConfiguration := aArrangerConfiguration;
end;

end.
