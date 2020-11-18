unit RogalConnector;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

type RSSettings = object
    private
        _isDevel : Boolean;
        BaseDir  : String;
    public
        function isDevelopment() : Boolean;
        procedure setDevelopment(x : Boolean);
end;
//
//type RSIO = object
//    private
//
//    public
//        procedure message(x : String);
//        function dialogYesNo(x : String) : Boolean;
//end;
// todo: make a different object for console and for GUI

procedure printMessage(x : String);
function showDialogYesNo(x : String) : Boolean;

implementation

function RSSettings.isDevelopment() : Boolean;
begin
    isDevelopment := _isDevel;
end;

procedure RSSettings.setDevelopment(x : Boolean);
begin
    _isDevel := x;
end;

function showDialogYesNo(x : String) : Boolean;
var
    input : Char;
    value : Boolean;
begin
    value := False;
    writeln(x);
    repeat
        write('Type Y or N: ');
        readln(input);
        if (input in ['Y', 'y']) then value := True;
    until input in ['Y', 'N', 'y', 'n'];
    Result := value;
end;

procedure printMessage(x : String);
begin
    writeln(x);
end;

// ConsolePrinter object

end.


