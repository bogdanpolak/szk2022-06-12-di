program cw05_FactoryFunction;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Container;

type
  IMainService = interface
    ['{333CAFBE-E9C7-4F1C-9ECA-5F070523007E}']
    procedure Connect();
    procedure Run();
  end;

  IDbConnection = interface
    ['{6DCC3C50-A008-437C-8821-7A637DBB9BBA}']
    procedure ExecuteSql(const aSql: string);
  end;

  IConfiguration = interface
    ['{C1CC9640-3B2C-431B-A5F1-FAFA0DDED277}']
    function GetConnectionString(): string;
  end;

{$M+}

  TConnectionFactoryFunc = reference to function(const aConnectionString
    : string): IDbConnection;
{$M-}

type
  TMainService = class(TInterfacedObject, IMainService)
  private
    fConnectionFactoryFunc: TConnectionFactoryFunc;
    fConfiguration: IConfiguration;
    fConnection: IDbConnection;
  public
    constructor Create(
      const aConnectionFactoryFunc: TConnectionFactoryFunc;
      const aConfiguration: IConfiguration);
    procedure Connect();
    procedure Run();
  end;

  TConfiguration = class(TInterfacedObject, IConfiguration)
    function GetConnectionString(): string;
  end;

TDbConnection = class(TInterfacedObject, IDbConnection)public constructor Create
  (const aConnectionString: string);

procedure ExecuteSql(const aSql: string);
end;

{ TMainService }

constructor TMainService.Create(
  const aConnectionFactoryFunc: TConnectionFactoryFunc;
  const aConfiguration: IConfiguration);
begin
  fConnectionFactoryFunc := aConnectionFactoryFunc;
  fConfiguration := aConfiguration;
end;

procedure TMainService.Connect();
var
  connectionString: string;
begin
  connectionString := fConfiguration.GetConnectionString();
  fConnection := fConnectionFactoryFunc(connectionString);
end;

procedure TMainService.Run;
begin
  fConnection.ExecuteSql('SELECT * FROM table');
end;

{ TConfiguration }

function TConfiguration.GetConnectionString: string;
begin
  Result := 'Server=SQLite;Database=abc.sdb;';
end;

{ TDbConnection }

constructor TDbConnection.Create(const aConnectionString: string);
begin
  writeln(Format('1. Connected to database using "%s"', [aConnectionString]));
end;

procedure TDbConnection.ExecuteSql(const aSql: string);
begin
  writeln(Format('2. Executed SQL: "%s"', [aSql]));
end;

{ Demo }

procedure RunDemo();
var
  mainService: IMainService;
begin
  GlobalContainer.RegisterType<IMainService, TMainService>();
  GlobalContainer.RegisterType<IConfiguration, TConfiguration>();
  GlobalContainer.RegisterType<IDbConnection, TDbConnection>();
  GlobalContainer.RegisterType<TConnectionFactoryFunc>().AsFactory();
  GlobalContainer.Build;
  mainService := GlobalContainer.Resolve<IMainService>();
  mainService.Connect();
  mainService.Run();
end;

begin
  try
    RunDemo;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
