unit EventHandler;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils,  
    DBDriver, EventModel,
    IBConnection, db, sqldb, sqlite3conn;

type
    EventDB = object(RSDatabase)
        private
            Collection : array of Event;
        public
            constructor Create; //override;
            destructor Destroy; //override;
    end;


implementation

constructor EventDB.Create;
begin
    Inherited;
    SetLength(Collection, 0);
    // code
end;

destructor EventDB.Destroy;
begin
    // code
    SetLength(Collection, 0);
    Inherited;
end;

end.
