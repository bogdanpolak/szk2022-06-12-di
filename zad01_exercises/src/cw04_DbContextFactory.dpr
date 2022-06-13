program cw04_DbContextFactory;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  Spring.Container,
  Spring.Collections,
  {}
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  {}
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  {}
  Helper.TDataSet in 'Helper.TDataSet.pas';

type
  IDbContext = interface
    ['{F4653C0C-2C05-4348-A744-3288E520F586}']
    procedure Execute;
  end;

  IDbContextFactory = interface(IInvokable)
    ['{F632D1FB-9C34-48FD-BD72-6BBC436D1B47}']
    function Create(const aConnectionString: string): IDbContext; overload;
  end;

type
  TProduct = class
  public
    ProductId: Integer;
    ProductName: string;
    CategoryName: string;
  end;

  TDbContext = class(TInterfacedObject, IDbContext)
  private
    fConnection: TFDConnection;
    fConnectionString: string;
  public
    constructor Create(const aConnectionString: string);
    destructor Destroy; override;
    procedure Execute;
  end;

  { TDbContext }

constructor TDbContext.Create(const aConnectionString: string);
begin
  fConnectionString := aConnectionString;
  writeln(Format('Connection: "%s"', [fConnectionString]));
  fConnection := TFDConnection.Create(nil);
  fConnection.ConnectionString := fConnectionString;
end;

destructor TDbContext.Destroy;
begin
  fConnection.Free;
  inherited;
end;

procedure TDbContext.Execute;
var
  query: TFDQuery;
  products: IList<TProduct>;
begin
  query := TFDQuery.Create(fConnection);
  query.connection := fConnection;
  query.Open('SELECT prod.ProductId, prod.ProductName, prod.SupplierId, ' +
    '  sup.CompanyName as SupplierName, sup.City as SupplierCity, ' +
    '  prod.CategoryId, cat.CategoryName as CategoryName, ' +
    '  prod.QuantityPerUnit, prod.UnitPrice, prod.UnitsInStock, ' +
    '  prod.UnitsOnOrder, prod.ReorderLevel, prod.Discontinued ' +
    'FROM {id Products} prod ' +
    '  INNER JOIN {id Suppliers} sup ON prod.SupplierId = sup.SupplierId ' +
    '  INNER JOIN {id Categories} cat ON cat.CategoryId = prod.CategoryId ');
  products := query.LoadData<TProduct>();
  writeln(Format('Loaded rows: %d', [products.Count]));
  products.Where(
    function(const prod: TProduct): boolean
    begin
      Result := prod.CategoryName = 'Beverages';
    end).ForEach(
    procedure(const prod: TProduct)
    begin
      writeln(Format('%d, %s, %s', [prod.ProductId, prod.CategoryName,
        prod.ProductName]));
    end);
end;

{ RunDemo }

procedure RunDemo();
var
  dbContextFactory: IDbContextFactory;
  ConnectionString: string;
  context: IDbContext;
begin
  GlobalContainer.RegisterType<IDbContext, TDbContext>;
  GlobalContainer.RegisterType<IDbContextFactory>.AsFactory;
  GlobalContainer.Build;
  dbContextFactory := GlobalContainer.Resolve<IDbContextFactory>();
  randomize;
  case random(2) of
    0:
      ConnectionString := 'DriverID=FB;' +
        'Server=localhost;Database=c:\database\fddemo.fdb;' +
        'User_name=sysdba;Password=masterkey';
    1:
      ConnectionString := 'DriverID=SQLite;' +
        'Server=localhost;Database=c:\database\fddemo.sdb';
  end;
  context := dbContextFactory.Create(ConnectionString);
  context.Execute;
end;

begin
  try
    RunDemo();
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
