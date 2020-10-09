unit DBDriver;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, IBConnection, db, sqldb, sqlite3conn, RSUtils;

type RSDatabase = object
    protected
        Conn   : TSQLConnector;
        Trans  : TSQLTransaction;
        Query  : TSQLQuery;
        dbname : String;
        procedure init();
    public
        constructor Create;
        destructor Destroy;
        function GetBaseLocation() : String;
        procedure DropDatabase();
        procedure test();

end;

implementation

procedure RSDatabase.init();
begin
    //writeln(GetAppConfigDir(false)+'RogalBase.db');
    Conn := TSQLConnector.Create(nil);
    with Conn do
    begin
        ConnectorType := 'SQLite3';
        HostName := ''; // not important
        DatabaseName := GetAppConfigDir(false)+'RogalBase.db';
        UserName := ''; // not important
        Password := ''; // not important
    end;

    Trans := TSQLTransaction.Create(nil);
    Conn.Transaction := Trans;


    Conn.Close;
    try
        If Not DirectoryExists(GetAppConfigDir(false)) then
            If Not CreateDir (GetAppConfigDir(false)) Then
                writeln('Failed to set up a directory for the database.');

        if not FileExists(Conn.DatabaseName) then
        begin
            try
                Conn.Open;
                Trans.Active := true;

                Conn.ExecuteDirect('CREATE TABLE Event('+
                    ' id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                    ' EventName VARCHAR(50) NOT NULL, ' +
                    ' EventDate DATETIME NOT NULL, ' +
                    ' RepeatsEvery SMALLINT NOT NULL DEFAULT 0,' +
                    ' Active SMALLINT NOT NULL DEFAULT 1, ' +
                    ' Info TEXT, ' +
                    ' BoundPeople VARCHAR(200), '+
                    ' Address VARCHAR(200), '+
                    ' Telephone VARCHAR(50), '+
                    ' Mail VARCHAR(50) '+
                    ');');

                //Conn.ExecuteDirect('CREATE UNIQUE INDEX "Event_id_idx" ON Event( "id" );');

                Conn.ExecuteDirect('CREATE TABLE Tag('+
                    ' id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'+
                    ' Name VARCHAR(50) NOT NULL, ' +
                    ' Color VARCHAR(50) NOT NULL ' +
                    ');');

                //Conn.ExecuteDirect('CREATE UNIQUE INDEX "Tag_id_idx" ON Tag( "id" );');

                Trans.Commit;
            except
                On E : Exception do writeln(E.ToString);
                //writeln('Unable to Create new Database');
            end;
        end;
    except
        writeln('Unable to check if database file exists');
    end;
    Conn.Open;
end;

constructor RSDatabase.Create();
begin
     init();


  //Query := TSQLQuery.Create(nil);
  //Query.DataBase := Conn;
  //Query.SQL.Text := 'insert your sql query here';
  //// Query.ParamByName('...').AsWhatever := ... fill if you use parameterized query
  //Query.ExecSQL; // or Query.Open; depending whether your query is select or not

  // for select query
  // while not Query.EOF do begin
  // do whatever you want, access row field with Query.FieldByName('...').AsWhatever
  //   Query.Next;
  // end;
  // Query.Close;

  // for non-select
  //Trans.Commit;
end;

function RSDatabase.GetBaseLocation() : String;
begin
    GetBaseLocation := Conn.DatabaseName;
end;

destructor RSDatabase.Destroy();
begin
    Conn.Destroy();
end;

procedure RSDatabase.DropDatabase();
begin
    try
        //Query := TSQLQuery.Create(nil);
        //Query.DataBase := Conn;
        //Query.SQL.Text := 'DROP TABLE '+dbname;
        //Query.ExecSQL; // or Query.Open; depending whether your query is select or not
        //Trans.Commit;
        If FileExists(Conn.DatabaseName) Then
            DeleteFile(Conn.DatabaseName);
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

procedure RSDatabase.test();
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT 2+2';
        Query.Open;
        //Trans.Commit;
        writeln('2+2 is *checking database* obviously ', Query.Fields[0].AsString, '! :)');
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

end.


