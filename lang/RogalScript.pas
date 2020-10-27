unit RogalScript;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, StrUtils, RSUtils,
    EventModel, EventHandler,
    TagModel, TagHandler;

type QueryEntity = (Nothing, Tags);

type RogalDB = object
    public
        Tags : TagDB;
        constructor create;
        destructor destroy;
        procedure resetAll();
        procedure test();
        procedure getDBLocation();
end;

type RSEnvironment = object
    private
        Settings : RSSettings;
    public
        Database : RogalDB;
        constructor create;
        destructor destroy;
        procedure runCommand(input : String);
        procedure runFromString(str : String);
        procedure runFile(filename : String);
end;

implementation

constructor RogalDB.create;
begin
    Tags.Create();
end;

destructor RogalDB.destroy;
begin
    Tags.Destroy();
end;

procedure RogalDB.resetAll();
begin
    Tags.DropDatabase();
    Tags.Create();
end;

procedure RogalDB.test();
begin
    Tags.test();
end;

procedure RogalDB.getDBLocation();
begin
    writeln(Tags.GetBaseLocation());
end;

// ========== Utilities

function checkLevel(input : String) : Integer;
begin
         if (LeftStr(input, 1) = '(') 
        and (RightStr(input, 1) = ')') then Result := 0
    else if (LeftStr(input, 1) = '(')  then Result := 1
    else if (RightStr(input, 1) = ')') then Result := -1
    else Result := 0;
end;

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

procedure doCreateTag(var db : TagDB; name, color : String);
var
    pom : Tag;
begin
    pom.setName(name);
    pom.setColor(color);
    db.insert(pom);
end;

procedure doGetTags(var db : TagDB; count : Integer = 0; conditions : String = '');
var
    pom : TTags;
    i   : Tag;
begin
    pom := db.findAll(count, conditions);
    for i in pom do
    begin
        writeln('[#',i.getID,'] ',i.getName());
    end;
    writeln();
end;

procedure doDeleteTagsByID(var db : TagDB; id : Integer);
begin
    db.deleteByID(id);
end;

// ================ Environment

constructor RSEnvironment.create;
begin
    Database.Create();
end;

destructor RSEnvironment.destroy;
begin
    Database.Destroy();
end;

procedure RSEnvironment.runCommand(input : String);
var
    L             : TStringArray;
    count, cursor : LongInt;
    whattoget     : QueryEntity;
    nestlv        : ShortInt;
	nesttx        : String;
begin
    if (input <> '') then
    begin
        L := input.Split([' ', #9, #13, #10], '''');
        case L[0] of
            'add' : begin
                case L[1] of
                    'tag' : begin
                        if (LeftStr(L[2], 1) = '''') and (RightStr(L[2], 1) = '''') 
                            then doCreateTag(Database.Tags, string_toC(L[2].Substring(1, L[2].Length - 2)), 'Default')
                            else writeln('Error: the name must be quoted.');
                    end;
                    else writeln('syntax: create (tag) "name"');
                end;
            end;
            'delete' : begin
                case L[1] of
                    'tag' : begin
                        if (LeftStr(L[2], 1) = '#') then
                        begin
                            doDeleteTagsByID(Database.Tags, StrToInt(L[2].Substring(1, L[2].Length - 1)));
                        end else begin
                            writeln('syntax: delete tag #id');  
                        end; 
                    end;
                    else writeln('syntax: delete (tag) #id');
                end;
            end;
            'get' : begin
                count := -1;
                case L[1] of
                    'all' : begin
                        count := 0;
                        cursor := 2;
                    end;
                    'top' : begin
                        count := StrToInt(L[2]);
                        // work on exceptions
                        cursor := 3;
                    end;
                    else begin
                        count := 0;
                        cursor := 1;
                    end;
                end;
                case L[cursor] of
                    'tags' : begin
                        whattoget := Tags;
                        cursor := cursor + 1;
                        
                    end;
                    'database' : begin
                        whattoget := Nothing;
                        case L[cursor+1] of
                            'location' : begin
                                Database.getDBLocation();
                            end;
                        end;
                    end;
                    'db' : begin
                        whattoget := Nothing;
                        case L[cursor+1] of
                            'location' : begin
                                Database.getDBLocation();
                            end;
                        end;
                    end;
                    else begin 
                        whattoget := Nothing;
                        writeln('Syntax: get');
                        writeln('            [all|top N] (tags)');
                        writeln('            [database|db] (location)');
                    end;
                end;

                if (whattoget <> Nothing) then
                begin
                    nesttx := '';
                    if (cursor < Length(L)) then
                    begin
                        case L[cursor] of
                            'of' : begin
                                nestlv := 0;
                                nesttx := '';
                                cursor := cursor + 1;
                                while (nestlv >= 0) and (cursor < Length(L)) do begin
                                    nestlv := nestlv + checkLevel(L[cursor]);
				                	if (nestlv >= 0) then nesttx := nesttx + ' ' + L[cursor];
                                    Inc(cursor);
                                end;
                                //doGetTags(Database.Tags, count, nesttx);
                            end;
                        end;
                    end;
                    case whattoget of
                        Tags : doGetTags(Database.Tags, count, nesttx);
                    end;
                end;
            end;
            'print' : begin
                if (LeftStr(L[1], 1) = '''') and (RightStr(L[1], 1) = '''')
                    then writeln(string_toC(L[1].Substring(1, L[1].Length - 2)))
                    else writeln(string_toC(L[1]));
            end;
            'reset' : begin
                if (L[1] = 'all') then
                begin
                    writeln();
                    if (showDialogYesNo('Are you sure you want to drop all events and build a completely new database?'+#13#10+'Your data will be lost FOREVER!')) then
                    begin
                        Database.resetAll();
                    end;
                end else begin
                    writeln('Type "reset all" if you want to reset all database.');
                end;
            end;
            'test' : begin
                Database.test();
            end;
            else writeln('Unknown command');
        end;
    end;
end;

procedure RSEnvironment.runFromString(str : String);
var
    L : TStringArray;
    i : String;
begin
    if (str <> '') then
    begin
        L := str.Split([';'], '''');
        for i in L do runCommand(trim(i));
    end;
end;

procedure RSEnvironment.runFile(filename : String);
var
    fun, S : String;
    fp     : Text;
begin
    fun := '';
    assignfile(fp, filename);
    reset(fp);
    while not eof(fp) do
    begin
        readln(fp, S);
        //if (S <> '') then S := cutCommentMultiline(S);
        //S := DelChars(S, #13);
        //S := DelChars(S, #10);
        S := trim(S);
        fun := fun + #10 + S;
    end;
    closefile(fp);
    runFromString(fun);
end;

end.


