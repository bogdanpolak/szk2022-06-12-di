program cw01_ConsoleService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Spring.Container;

type
  IConsole = interface
    ['{AE2EFACD-3876-4394-9213-CDD3CD94459B}']
    procedure LogInfo(const msg: string);
  end;

  TConsole = class(TInterfacedObject, IService, IConsole)
    procedure LogInfo(const msg: string);
  end;


  TApplicationRoot = class
  private
    fConsole: IConsole;
  public
    constructor Create(const aConsole: IConsole);
    procedure Execute();
  end;


{ TConsole }

procedure TConsole.LogInfo(const msg: string);
begin
  writeln(msg);
end;

{ TApplicationRoot }

constructor TApplicationRoot.Create(const aConsole: IConsole);
begin
  fConsole := aConsole;
end;

procedure TApplicationRoot.Execute;
begin
  fConsole.LogInfo('Hello Dependency Injection');
end;

{ Run }

procedure RunDemo();
var
  applicationRoot: TApplicationRoot;
begin
  GlobalContainer.RegisterType<IConsole, TConsole>();
  GlobalContainer.RegisterType<TApplicationRoot>().AsSingleton();
  GlobalContainer.Build();
  applicationRoot := GlobalContainer.Resolve<TApplicationRoot>();
  applicationRoot.Execute;
end;

begin
  try
    ReportMemoryLeaksOnShutdown := true;
    RunDemo();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
