program cw02_LazyService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Spring,
  Spring.Container;

type
  IExampleService = interface
    ['{9722C609-5444-4054-B544-24D30DE8B3B3}']
  end;
  TExampleService = class(TInterfacedObject, IExampleService)
    constructor Create;
  end;

type
  THomeController = class
  private
    fService: Lazy<IExampleService>;
    function GetService: IExampleService;
  public
    constructor Create(const service: Lazy<IExampleService>);
    property Service: IExampleService read GetService;
  end;

{ TExampleService }

constructor TExampleService.Create;
begin
  writeln('TExampleService.Create');
end;

{ THomeController }

constructor THomeController.Create(const service: Lazy<IExampleService>);
begin
  fService := service;
  writeln('THomeController.Create');
end;

function THomeController.GetService: IExampleService;
begin
  writeln('THomeController.GetService');
  Result := fService.Value;
end;

{ Demo }

procedure RunDemo();
var
  homeControler: THomeController;
begin
  GlobalContainer.RegisterType<THomeController>().AsSingleton();
  GlobalContainer.RegisterType<IExampleService,TExampleService>();
  GlobalContainer.Build();
  homeControler := GlobalContainer.Resolve<THomeController>();
  writeln('... lot of other code ... :)');
  homeControler.GetService();
end;

begin
  try
    RunDemo();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
