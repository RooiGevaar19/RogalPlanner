unit EventHandler;

{$mode objfpc}{$H+}

interface

uses DBDriver;

type
    EventDriver = object(RSDatabase)
        private
            x : Integer;
        public
            //constructor Create;
            //destructor Destroy;
    end;


implementation

end.
