unit EventHandler;

{$mode objfpc}{$H+}

interface

uses DBDriver;

type
    EventDB = object(RSDatabase)
        //private
        //    x : Integer;
        public
            constructor Create; //override;
            destructor Destroy; //override;
    end;


implementation

constructor EventDB.Create;
begin
    Inherited;
    // code
end;

destructor EventDB.Destroy;
begin
    // code
    Inherited;
end;

end.
