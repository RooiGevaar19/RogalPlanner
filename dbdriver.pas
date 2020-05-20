unit DBDriver;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, IBConnection, db, sqldb, sqlite3conn;

type RSDatabase = object
    private
        Conn  : TSQLConnector;
        Trans : TSQLTransaction;
        Query : TSQLQuery;
    public
        constructor Create;
        destructor Destroy;
end; 

implementation

constructor RSDatabase.Create();
var
    newFile : Boolean;
begin
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
                    ' IsCyclic INTEGER NOT NULL,' +
                    ' Info TEXT);');

                Conn.ExecuteDirect('CREATE UNIQUE INDEX "Event_id_idx" ON Event( "id" );');

                Trans.Commit;
                writeln('Succesfully created database.');
            except
                writeln('Unable to Create new Database');
            end;
        end;
    except
        writeln('Unable to check if database file exists');
    end;
    Conn.Open; 


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

destructor RSDatabase.Destroy();
begin
    Conn.Destroy();
end;

end.

