unit RectanglesBuilder;

interface

uses
  Spring.Collections,
  {}
  FormArranger;

type
  TRectangleBuilder = class
  private
    fRectagles: IList<TRectangle>;
    fArrangerConfiguration: TArrangerConfiguration;
  public
    constructor Create(aArrangerConfiguration: TArrangerConfiguration);
    function WithLineOfRectangles(
      const aTop: Integer;
      const aRectnagleHeights: TArray<Integer>): TRectangleBuilder;
    function Build: IList<TRectangle>;
  end;

function GivenLineOfRectagles(
  const aRectnagleHeights: TArray<Integer>;
  const aArrangerConfiguration: TArrangerConfiguration): IList<TRectangle>;

implementation

function GivenLineOfRectagles(
  const aRectnagleHeights: TArray<Integer>;
  const aArrangerConfiguration: TArrangerConfiguration): IList<TRectangle>;
var
  builder: TRectangleBuilder;
begin
  builder := TRectangleBuilder.Create(aArrangerConfiguration).WithLineOfRectangles(20,
    aRectnagleHeights);
  Result := builder.Build();
  builder.Free;
end;

{ TRectangleBuilder }

constructor TRectangleBuilder.Create(aArrangerConfiguration
  : TArrangerConfiguration);
begin
  fRectagles := TCollections.CreateList<TRectangle>();
  fArrangerConfiguration := aArrangerConfiguration;
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
  left := fArrangerConfiguration.MarginHorizontal;
  top := aTop;
  for height in aRectnagleHeights do
  begin
    if height > 0 then
    begin
      fRectagles.Add(TRectangle.Create(left, top, height));
    end;
    left := left + fArrangerConfiguration.MarginHorizontal +
      fArrangerConfiguration.FormWidth;
  end;
end;

end.
