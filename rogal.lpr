program rogal;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, RogalScript
  { you can add units after this };

type
    { TRogalPlanner }
    TRogalPlanner = class(TCustomApplication)
    protected
      procedure DoRun; override;
    public
      constructor Create(TheOwner: TComponent); override;
      destructor Destroy; override;
      procedure WriteHelp; virtual;
end;

{ TRogalPlanner }

procedure TRogalPlanner.DoRun;
var
  ErrorMsg : String;
  command  : String;
  env      : RSEnvironment;
begin
    // quick check parameters
    ErrorMsg:=CheckOptions('h', 'help');
    if ErrorMsg<>'' then begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;

    // parse parameters
    if HasOption('h', 'help') then begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    { add your program here }
    env.create();
    writeln('===[RogalPlanner]===');
    writeln('Version 0.0.6 – October 6, 2020');
    writeln('by RooiGevaar19 & rozirogal');
    writeln('Since 05/18/2020, proudly written in FreePascal. :)');
    writeln();
    writeln('Type "\q" or "quit" to quit the program.');
    writeln();
    while (command <> '\q') and (command <> 'quit') do
    begin
        write('=> ');
        readln(command);
        env.runCommand(command);
    end;
    writeln('See you soon.');

    // stop program loop
    env.destroy();
    Terminate;
end;

constructor TRogalPlanner.Create(TheOwner: TComponent);
begin
    inherited Create(TheOwner);
    StopOnException:=True;
end;

destructor TRogalPlanner.Destroy;
begin
    inherited Destroy;
end;

procedure TRogalPlanner.WriteHelp;
begin
    { add your help code here }
    writeln('Usage: ', ExeName, ' -h');
end;

var Application: TRogalPlanner;

{$R *.res}

begin
    Application:=TRogalPlanner.Create(nil);
    Application.Title:='RogalPlanner';
    Application.Run;
    Application.Free;
end.

