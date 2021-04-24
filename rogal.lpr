program rogal;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF MSWINDOWS}
  windows,
  {$ENDIF}
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
  silent   : Boolean;
  filemode : Boolean;
  y,m,d    : Word;
begin
    // quick check parameters
    ErrorMsg:=CheckOptions('hsf:', 'helpsilentfile:');
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

    silent := False;
    filemode := False;

    if HasOption('s' ,'silent') then begin
        silent := True;
    end;

    if HasOption('f' ,'file') then begin
        filemode := True;
    end;

    env.create();
    if not silent then
    begin
        writeln('===[RogalPlanner]===');
        writeln('Version 0.0.12 - April 24, 2021');
        writeln('by RooiGevaar19 & rozirogal');
        writeln('Since 05/18/2020, proudly written in FreePascal. :)');
        writeln();
        DecodeDate(Date, y,m,d);
        if (m = 12) and (d in [24, 25, 26]) then begin
            writeln('I wish you Merry Christmas! 🥐❤️');
            writeln('Spend your time with the people you care! ❤️🎅🎁⛪');
            writeln();
        end;
        if ((m = 12) and (d in [30, 31])) then begin
            writeln('I wish you Happy New Year! 🥐❤️');
            if (isLeapYear(y+1)) 
                then writeln('Enjoy the next 366 days. Hope I will help you when you need it! ❤️🎉📅')
                else writeln('Enjoy the next 365 days. Hope I will help you when you need it! ❤️🎉📅');
            writeln();
        end;
        if ((m = 1) and (d in [1, 2])) then begin
            writeln('I wish you Happy New Year! 🥐❤️');
            if (isLeapYear(y)) 
                then writeln('Enjoy the next 366 days. Hope I will help you when you need it! ❤️🎉📅')
                else writeln('Enjoy the next 365 days. Hope I will help you when you need it! ❤️🎉📅');
            writeln();
        end;
    end;
    if filemode then
    begin
        env.runFile(getOptionValue('f', 'file'));
    end else begin
        if not silent then
        begin
            writeln('Type "\q" or "\quit" to quit the program.');
            writeln();
        end;
        while (command <> '\q') and (command <> '\quit') do
        begin
            write('=> ');
            readln(command);
            case command of
                '\help' : WriteHelp();
                '\q' : ; 
                '\quit' : ;
                else env.runFromString(command); 
            end;
        end;
        if not silent then writeln('See you soon.');
    end;
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
    {$IFDEF MSWINDOWS}
    Sleep(500);
    {$ENDIF}
    //readln();
end.

