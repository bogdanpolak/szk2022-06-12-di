program cw06_StrategyByContainer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Spring.Collections,
  Spring.Container;

type
  TServiceInfo = (siServiceA, siServiceB);

  IService = interface
    ['{09D2AC06-85AE-4E27-B614-49B9195AD0F5}']
    function GetType: TServiceInfo;
    procedure Execute();
  end;

  TServiceA = class(TInterfacedObject, IService)
    function GetType: TServiceInfo;
    procedure Execute();
  end;

  TServiceB = class(TInterfacedObject, IService)
    function GetType: TServiceInfo;
    procedure Execute();
  end;

  { TServiceA }

function TServiceA.GetType: TServiceInfo;
begin
  Result := siServiceA;
end;

procedure TServiceA.Execute;
begin
  Writeln('Service A executed');
end;

{ TServiceB }

function TServiceB.GetType: TServiceInfo;
begin
  Result := siServiceB;
end;

procedure TServiceB.Execute;
begin
  Writeln('Service B executed');
end;

{ Demo }

procedure RunDemo();
var
  svs: TArray<IService>;
  services: IList<IService>;
  algorithm: TServiceInfo;
begin
  GlobalContainer.RegisterType<IService, TServiceA>('A').AsDefault();
  GlobalContainer.RegisterType<IService, TServiceB>('B');
  GlobalContainer.Build;
  svs := GlobalContainer.Resolve<TArray<IService>>();
  services := TCollections.CreateList<IService>(svs);
  algorithm := TServiceInfo(random(2));
  services.Where(
    function(const svr: IService): boolean
    begin
      Result := (svr.GetType = algorithm);
    end).First.Execute();
end;

begin
  try
    randomize;
    RunDemo();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
