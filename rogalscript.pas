unit RogalScript;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, StrUtils;

type
    RSEnvironment = object
    private 
        {private declarations}
    public
     {public declarations}
        constructor create;
        destructor destroy;
        function runCommand(input : String) : String;
    end;

implementation

function string_toC(dupa : String) : String;
begin
	dupa := StringReplace(dupa, '\a', #7, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\b', #8, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\e', #27, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\f', #12, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\n', #10, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\r', #13, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\t', #9, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\v', #11, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\\', '\', [rfReplaceAll]);
	dupa := StringReplace(dupa, '\''', #39, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\"', #34, [rfReplaceAll]);
	dupa := StringReplace(dupa, '\?', '?', [rfReplaceAll]);
	string_toC := dupa;
end;

constructor RSEnvironment.create;
begin
    writeln('RogalScript Environment activated.');
end;

destructor RSEnvironment.destroy;
begin
   writeln('RogalScript Environment stopped working.');
end;

function RSEnvironment.runCommand(input : String) : String;
var
    L : TStringArray;
begin
    L := input.Split([' ', #9, #13, #10], '"');
    case L[0] of 
        '\q' : ;
        'print' : begin
            if (LeftStr(L[1], 1) = '"') and (RightStr(L[1], 1) = '"') 
                then writeln(string_toC(L[1].Substring(1, L[1].Length - 2)))
                else writeln(string_toC(L[1]));
        end;
        'quit' : ;
        else writeln('Unknown command');
    end;
end;

end.

