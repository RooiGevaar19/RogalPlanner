unit TagHandler;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, 
    DBDriver, TagModel,
    IBConnection, db, sqldb, sqlite3conn, RSUtils;

type TTags = array of Tag;

type TagDB = object(RSDatabase)
    public
        constructor Create; //override;
        destructor Destroy; //override;
        procedure insert(x : Tag);
        procedure updateByID(id : LongInt; new : Tag);
        procedure deleteByID(id : LongInt);
        function findByID(id : LongInt) : Tag;
        function findByName(name : String) : TTags;
        function findAll(count : Integer = 0) : TTags;
end;


implementation


constructor TagDB.Create;
begin
    Inherited;
    dbname := 'Tag';
    // code
end;

destructor TagDB.Destroy;
begin
    // code
    Inherited;
end;

procedure TagDB.insert(x : Tag);
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'INSERT INTO Tag(Name, Color) VALUES (:name, :color)';
        Query.ParamByName('name').AsString := x.getName();
        Query.ParamByName('color').AsString := x.getColor();
        Query.ExecSQL; // or Query.Open; depending whether your query is select or not
        Trans.Commit;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

procedure TagDB.updateByID(id : LongInt; new : Tag);
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'UPDATE Tag SET Name = :name, Color = :color WHERE id = :id';
        Query.ParamByName('name').AsString := new.getName();
        Query.ParamByName('color').AsString := new.getColor();
        Query.ParamByName('id').AsInteger := id;
        Query.ExecSQL;
        Trans.Commit;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

procedure TagDB.deleteByID(id : LongInt);
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'DELETE FROM Tag WHERE id = :id';
        Query.ParamByName('id').AsInteger := id;
        Query.ExecSQL;
        Trans.Commit;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

function TagDB.findByID(id : LongInt) : Tag;
var
    pom : Tag;
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT id, Name, Color FROM Tag WHERE id = :id';
        Query.ParamByName('id').AsInteger := id;
        Query.Open;
        pom.setID(Query.FieldByName('id').AsInteger);
        pom.setName(Query.FieldByName('Name').AsString);
        pom.setColor(Query.FieldByName('Color').AsString);
        Result := pom;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

function TagDB.findByName(name : String) : TTags;
var
    pom : TTags;
    i   : LongInt;
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT id, Name, Color FROM Tag WHERE Name = :name';
        Query.ParamByName('Name').AsString := name;
        Query.Open;
        SetLength(pom, Query.RecordCount);
        i := 0;
        while not Query.EOF do begin
            pom[i].setID(Query.FieldByName('id').AsInteger);
            pom[i].setName(Query.FieldByName('Name').AsString);
            pom[i].setColor(Query.FieldByName('Color').AsString);
            inc(i);
            Query.Next();
        end;
        Result := pom;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

function TagDB.findAll(count : Integer = 0) : TTags;
var
    pom : TTags;
    i   : LongInt;
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT id, Name, Color FROM Tag';
        if count > 0 then Query.SQL.Text := Query.SQL.Text + ' LIMIT ' + IntToStr(count);
        Query.Open;
        SetLength(pom, Query.RecordCount);
        i := 0;
        while not Query.EOF do begin
            pom[i].setID(Query.FieldByName('id').AsInteger);
            pom[i].setName(Query.FieldByName('Name').AsString);
            pom[i].setColor(Query.FieldByName('Color').AsString);
            inc(i);
            Query.Next();
        end;
        Result := pom;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

end.

