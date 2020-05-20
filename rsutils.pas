unit RSUtils;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

type RSSettings = object
    private
        _isDevel : Boolean;
    public
        function isDevelopment() : Boolean;
        procedure setDevelopment(x : Boolean);
end;

implementation

function RSSettings.isDevelopment() : Boolean;
begin
    isDevelopment := _isDevel;
end;

procedure RSSettings.setDevelopment(x : Boolean);
begin
    _isDevel := x;
end;

end.

