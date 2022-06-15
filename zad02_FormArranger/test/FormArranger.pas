unit FormArranger;

interface

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

  TPosition = record
    Left: Integer;
    Top: Integer;
  public
    constructor Create(const aLeft, aTop: Integer);
  end;

// IFormArranger

implementation

{ TRectangle }

constructor TRectangle.Create(const aLeft, aTop, aHeight: Integer);
begin
  Left := aLeft;
  Top := aTop;
  Height := aHeight;
end;

{ TPosition }

constructor TPosition.Create(const aLeft, aTop: Integer);
begin
  Left := aLeft;
  Top := aTop;
end;

end.
