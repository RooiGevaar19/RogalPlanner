unit EventModel;

{$mode objfpc}{$H+}

interface

type EventState = (Corrupt, Obsolete, Inactive, Active);

type Event = class
    private
        id           : LongInt;
        EventName    : String;
        EventDate    : String;
        RepeatsEvery : LongInt;
        Active       : EventState;
        Info         : String;
        BoundPeople  : String;
        Address      : String;
        Telephone    : String;
        Mail         : String;
    public
        procedure setID(val : LongInt);
        function  getID() : LongInt;
        procedure setEventName(val : String);
        function  getEventName() : String;
        procedure setEventDate(val : String);
        function  getEventDate() : String;
        procedure setRepeatsEvery(val : LongInt);
        function  getRepeatsEvery() : LongInt;
        procedure setActive(val : EventState);
        function  getActive() : EventState;
        procedure setInfo(val : String);
        function  getInfo() : String;
        procedure setBoundPeople(val : String);
        function  getBoundPeople() : String;
        procedure setAddress(val : String);
        function  getAddress() : String;
        procedure setTelephone(val : String);
        function  getTelephone() : String;
        procedure setMail(val : String);
        function  getMail() : String;
end;

implementation

procedure Event.setID(val : LongInt);
begin
    id := val;
end;
function  Event.getID() : LongInt;
begin
    Result := id;
end;

procedure Event.setEventName(val : String);
begin
    EventName := val;
end;
function  Event.getEventName() : String;
begin
    Result := EventName;
end;

procedure Event.setEventDate(val : String);
begin
    EventDate := val;
end;
function  Event.getEventDate() : String;
begin
    Result := EventDate;
end;

procedure Event.setRepeatsEvery(val : LongInt);
begin
    RepeatsEvery := val;
end;
function  Event.getRepeatsEvery() : LongInt;
begin
    Result := RepeatsEvery;
end;

procedure Event.setActive(val : EventState);
begin
    Active := val;
end;
function  Event.getActive() : EventState;
begin
    Result := Active;
end;

procedure Event.setInfo(val : String);
begin
    Info := val;
end;
function  Event.getInfo() : String;
begin
    Result := Info;
end;

procedure Event.setBoundPeople(val : String);
begin
    BoundPeople := val;
end;
function  Event.getBoundPeople() : String;
begin
    Result := BoundPeople;
end;

procedure Event.setAddress(val : String);
begin
    Address := val;
end;
function  Event.getAddress() : String;
begin
    Result := Address;
end;

procedure Event.setTelephone(val : String);
begin
    Telephone := val;
end;
function  Event.getTelephone() : String;
begin
    Result := Telephone;
end;

procedure Event.setMail(val : String);
begin
    Mail := val;
end;
function  Event.getMail() : String;
begin
    Result := Mail;
end;

end.
