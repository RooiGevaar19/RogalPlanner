unit EventHandler;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils,  
    DBDriver, EventModel,
    IBConnection, db, sqldb, sqlite3conn;

type TEvents = array of Event;

type
    EventDB = object(RSDatabase)
        //private
        //    Collection : array of Event;
        public
            constructor Create; //override;
            destructor Destroy; //override;
            procedure insert(x : Event);
            procedure updateByID(id : LongInt; new : Event);
            procedure deleteByID(id : LongInt);
            function findByID(id : LongInt) : Event;
            function findByName(name : String) : TEvents;
            //function findAll(count : Integer = 0) : TTags;
            function findAll(count : Integer = 0; conditions : String = '') : TEvents;
    end;


implementation

//constructor EventDB.Create;
//begin
//    Inherited;
//    SetLength(Collection, 0);
//    // code
//end;
//
//destructor EventDB.Destroy;
//begin
//    // code
//    SetLength(Collection, 0);
//    Inherited;
//end;

constructor EventDB.Create;
begin
    Inherited;
    dbname := 'Event';
    // code
end;

destructor EventDB.Destroy;
begin
    // code
    Inherited;
end;

procedure EventDB.insert(x : Event);
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'INSERT INTO Event(EventName, EventDate, RepeatsEvery, Active, Info, BoundPeople, Address, Telephone, Mail) '
                         +'VALUES (:name, :edat, :repe, :acti, :info, :boun, :addr, :tele, :mail)';
        Query.ParamByName('name').AsString  := x.getEventName();
        Query.ParamByName('edat').AsString  := x.getEventDate();
        Query.ParamByName('repe').AsInteger := x.getRepeatsEvery();
        Query.ParamByName('acti').AsInteger := eventStateToInt(x.getActive());
        Query.ParamByName('info').AsString  := x.getInfo();
        Query.ParamByName('boun').AsString  := x.getBoundPeople();
        Query.ParamByName('addr').AsString  := x.getAddress();
        Query.ParamByName('tele').AsString  := x.getTelephone();
        Query.ParamByName('mail').AsString  := x.getMail();
        Query.ExecSQL; // or Query.Open; depending whether your query is select or not
        Trans.Commit;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

procedure EventDB.updateByID(id : LongInt; new : Event);
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'UPDATE Event '
                         +'SET EventName = :name, EventDate = :edat, RepeatsEvery = :repe, Active = :acti, Info = :info, BoundPeople = :boun, Address = :addr, Telephone = :tele, Mail = :mail '
                         +'WHERE id = :id';
        Query.ParamByName('name').AsString  := new.getEventName();
        Query.ParamByName('edat').AsString  := new.getEventDate();
        Query.ParamByName('repe').AsInteger := new.getRepeatsEvery();
        Query.ParamByName('acti').AsInteger := EventStateToInt(new.getActive());
        Query.ParamByName('info').AsString  := new.getInfo();
        Query.ParamByName('boun').AsString  := new.getBoundPeople();
        Query.ParamByName('addr').AsString  := new.getAddress();
        Query.ParamByName('tele').AsString  := new.getTelephone();
        Query.ParamByName('mail').AsString  := new.getMail();
        Query.ParamByName('id').AsInteger := id;
        Query.ExecSQL;
        Trans.Commit;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

procedure EventDB.deleteByID(id : LongInt);
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'DELETE FROM Event WHERE id = :id';
        Query.ParamByName('id').AsInteger := id;
        Query.ExecSQL;
        Trans.Commit;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

function EventDB.findByID(id : LongInt) : Event;
var
    pom : Event;
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT id, EventName, EventDate, RepeatsEvery, Active, Info, BoundPeople, Address, Telephone, Mail '
                         +'FROM Event WHERE id = :id';
        Query.ParamByName('id').AsInteger := id;
        Query.Open;
        pom.setID(Query.FieldByName('id').AsInteger);
        pom.setEventName(Query.FieldByName('EventName').AsString);
        pom.setEventDate(Query.FieldByName('EventDate').AsString);
        pom.setRepeatsEvery(Query.FieldByName('RepeatsEvery').AsInteger);
        pom.setActive(IntToEventState(Query.FieldByName('Active').AsInteger));
        pom.setInfo(Query.FieldByName('Info').AsString);
        pom.setBoundPeople(Query.FieldByName('BoundPeople').AsString);
        pom.setAddress(Query.FieldByName('Address').AsString);
        pom.setTelephone(Query.FieldByName('Telephone').AsString);
        pom.setMail(Query.FieldByName('Mail').AsString);
        Result := pom;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

function EventDB.findByName(name : String) : TEvents;
var
    pom : TEvents;
    i   : LongInt;
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT id, EventName, EventDate, RepeatsEvery, Active, Info, BoundPeople, Address, Telephone, Mail '
                         +'FROM Event WHERE Name = :name';
        Query.ParamByName('name').AsString := name;
        Query.Open;
        SetLength(pom, Query.RecordCount);
        i := 0;
        while not Query.EOF do begin
            pom[i].setID(Query.FieldByName('id').AsInteger);
            pom[i].setEventName(Query.FieldByName('EventName').AsString);
            pom[i].setEventDate(Query.FieldByName('EventDate').AsString);
            pom[i].setRepeatsEvery(Query.FieldByName('RepeatsEvery').AsInteger);
            pom[i].setActive(IntToEventState(Query.FieldByName('Active').AsInteger));
            pom[i].setInfo(Query.FieldByName('Info').AsString);
            pom[i].setBoundPeople(Query.FieldByName('BoundPeople').AsString);
            pom[i].setAddress(Query.FieldByName('Address').AsString);
            pom[i].setTelephone(Query.FieldByName('Telephone').AsString);
            pom[i].setMail(Query.FieldByName('Mail').AsString);
            inc(i);
            Query.Next();
        end;
        Result := pom;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

//function TagDB.findAll(count : Integer = 0) : TTags;
//var
//    pom : TTags;
//    i   : LongInt;
//begin
//    try
//        Query := TSQLQuery.Create(nil);
//        Query.DataBase := Conn;
//        Query.SQL.Text := 'SELECT id, Name, Color FROM Tag';
//        if count > 0 then Query.SQL.Text := Query.SQL.Text + ' LIMIT ' + IntToStr(count);
//        Query.Open;
//        SetLength(pom, Query.RecordCount);
//        i := 0;
//        while not Query.EOF do begin
//            pom[i].setID(Query.FieldByName('id').AsInteger);
//            pom[i].setName(Query.FieldByName('Name').AsString);
//            pom[i].setColor(Query.FieldByName('Color').AsString);
//            inc(i);
//            Query.Next();
//        end;
//        Result := pom;
//    except
//        On E : Exception do writeln(E.ToString);
//    end;
//end;

function EventDB.findAll(count : Integer = 0; conditions : String = '') : TEvents;
var
    pom : TEvents;
    i   : LongInt;
begin
    try
        Query := TSQLQuery.Create(nil);
        Query.DataBase := Conn;
        Query.SQL.Text := 'SELECT id, EventName, EventDate, RepeatsEvery, Active, Info, BoundPeople, Address, Telephone, Mail  '
                         +'FROM Event';
        if conditions <> '' then Query.SQL.Text := Query.SQL.Text + ' WHERE (' + conditions + ')';
        if count > 0 then Query.SQL.Text := Query.SQL.Text + ' LIMIT ' + IntToStr(count);
        Query.Open;
        SetLength(pom, Query.RecordCount);
        i := 0;
        while not Query.EOF do begin
            pom[i].setID(Query.FieldByName('id').AsInteger);
            pom[i].setEventName(Query.FieldByName('EventName').AsString);
            pom[i].setEventDate(Query.FieldByName('EventDate').AsString);
            pom[i].setRepeatsEvery(Query.FieldByName('RepeatsEvery').AsInteger);
            pom[i].setActive(IntToEventState(Query.FieldByName('Active').AsInteger));
            pom[i].setInfo(Query.FieldByName('Info').AsString);
            pom[i].setBoundPeople(Query.FieldByName('BoundPeople').AsString);
            pom[i].setAddress(Query.FieldByName('Address').AsString);
            pom[i].setTelephone(Query.FieldByName('Telephone').AsString);
            pom[i].setMail(Query.FieldByName('Mail').AsString);
            inc(i);
            Query.Next();
        end;
        Result := pom;
    except
        On E : Exception do writeln(E.ToString);
    end;
end;

end.
