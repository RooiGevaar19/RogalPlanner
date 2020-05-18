unit RogalScript;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

type
    RSEnvironment = object
    private 
        {private declarations}
    public
     {public declarations}
        constructor create;
        destructor destroy;
        function run(input : String) : String;
        function printPrompt() : String;
    end;

implementation

constructor RSEnvironment.create;
begin
    writeln('RogalScript Environment activated.');
end;

destructor RSEnvironment.destroy;
begin
   writeln('RogalScript Environment stopped working.');
end;

function RSEnvironment.run(input : String) : String;
begin
    writeln('You entered ', input, '.');
end;

end.

