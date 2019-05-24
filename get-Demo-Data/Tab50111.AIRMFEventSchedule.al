table 50111 "AIR MF Event Schedule"
{

    fields
    {
        field(1; "Event Date"; Date)
        {
        }
        field(2; "Event Type"; Option)
        {
            OptionMembers = " ","Music Event","Children Event",Festival;
        }
        field(10; "Event Name"; Text[250])
        {

        }
    }

    keys
    {
        key(PK; "Event Date", "Event Type")
        {
            Clustered = true;
        }
    }

    procedure GetFestivalName(ForecastDate: Date): Text
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::Festival) then
            exit('');
        exit(MFEvent."Event Name");
    end;

    procedure CheckIfChildrenEvent(ForecastDate: Date): Integer
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Children Event") then
            exit(0);
        exit(1);
    end;

    procedure CheckIfChildrenEventBool(ForecastDate: Date): Boolean
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Children Event") then
            exit(false);
        exit(true);
    end;

    procedure CheckIfMusicEvent(ForecastDate: Date): Integer
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Music Event") then
            exit(0);
        exit(1);
    end;

    procedure CheckIfMusicEventBool(ForecastDate: Date): Boolean
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Music Event") then
            exit(false);
        exit(true);
    end;




}