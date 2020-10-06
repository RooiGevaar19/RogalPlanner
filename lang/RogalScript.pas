unit RogalScript;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, StrUtils, RSUtils,
    EventModel, EventHandler,
    TagModel, TagHandler;

type RSEnvironment = object
    private
        Settings : RSSettings;
    public
        Database : EventDB;
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

procedure doCreateTag(name, color : String);
var
    db  : TagDB;
    pom : Tag;
begin
    db.Create;
    pom.setName(name);
    pom.setColor(color);
    db.insert(pom);
    db.Destroy;
end;

procedure doGetAllTags();
var
    db  : TagDB;
    pom : TTags;
    i   : Tag;
begin
    db.Create;
    pom := db.findAll();
    for i in pom do
    begin
        write(i.getName()+#9);
    end;
    writeln();
    db.Destroy;
end;

constructor RSEnvironment.create;
begin
    Database.Create();
end;

destructor RSEnvironment.destroy;
begin
    Database.Destroy();
end;

function RSEnvironment.runCommand(input : String) : String;
var
    L : TStringArray;
begin
    if (input <> '') then
    begin
        L := input.Split([' ', #9, #13, #10], '"');
        case L[0] of
            '\q' : ;
            'print' : begin
                if (LeftStr(L[1], 1) = '"') and (RightStr(L[1], 1) = '"')
                    then writeln(string_toC(L[1].Substring(1, L[1].Length - 2)))
                    else writeln(string_toC(L[1]));
            end;
            'reset' : begin
                if (L[1] = 'all') then
                begin
                    writeln();
                    if (showDialogYesNo('Are you sure you want to drop all events and build a completely new database?'+#13#10+'Your data will be lost FOREVER!')) then
                    begin
                        Database.DropDatabase();
                        Database.Create();
                    end;
                end else begin
                    writeln('Type "reset all" if you want to reset all database.');
                end;
            end;
            'test' : begin
                Database.test();
            end;
            'create' : begin
                case L[1] of
                    'tag' : begin
                        if (LeftStr(L[2], 1) = '"') and (RightStr(L[2], 1) = '"') 
                            then doCreateTag(string_toC(L[2].Substring(1, L[2].Length - 2)), 'Default')
                            else writeln('Error: the name must be quoted.');
                    end;
                    else writeln('syntax: create (tag) "name"');
                end;
            end;
            'get' : begin
                case L[1] of
                    'all' : begin
                        case L[2] of
                            'tags' : begin
                                doGetAllTags();
                            end;
                        end;
                    end;
                end;
            end;
            'quit' : ;
            else writeln('Unknown command');
        end;
    end;
end;

end.


