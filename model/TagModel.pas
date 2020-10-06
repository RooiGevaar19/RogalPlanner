unit TagModel;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

type Tag = object
    private
        id    : LongInt;
        Name  : String;
        Color : String;
    public
        procedure setID(val : LongInt);
        function  getID() : LongInt;
        procedure setName(val : String);
        function  getName() : String;
        procedure setColor(val : String);
        function  getColor() : String;
end;

implementation

procedure Tag.setID(val : LongInt);
begin
    id := val;
end;
function Tag.getID() : LongInt;
begin
    Result := id;
end;

procedure Tag.setName(val : String);
begin
    Name := val;
end;
function Tag.getName() : String;
begin
    Result := Name;
end;

procedure Tag.setColor(val : String);
begin
    Color := val;
end;
function Tag.getColor() : String;
begin
    Result := Color;
end;

end.

