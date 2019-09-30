table 50101 "AIR Rest. ML Forecast Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }

        field(3; "My Model"; Blob)
        {
        }

        field(5; "My Model Quality"; Decimal)
        {
            Editable = false;
            MinValue = 0;
            MaxValue = 1;
        }
        field(6; "My Features"; Text[1024])
        {
            Editable = false;
        }
        field(7; "My Label"; Text[250])
        {
            Editable = false;
        }


    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    procedure getMLUri(): Text
    begin
        exit('https://europewest.services.azureml.net/workspaces/9d1ba609dfba49d580b7d65a379aaa64/services/419fa286d388472cacf7f11e8911c98f/execute?api-version=2.0&details=true')
    end;

    procedure getMLKey(): Text
    begin
        exit('ZQ8cpUHEpPoej9q/iNqfX2zmfWxbEwmufJddaXRcKvA6aDnO2xl07bqOO1avgMT0MoJt7stKpaShwa9+eAw45g==')
    end;

    procedure SetRestaurantModel(ModelAsText: Text)
    var
        OutStream: OutStream;
    begin
        "My Model".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(ModelAsText);
    end;

    procedure GetRestaurantModel() Content: Text
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
    begin
        TempBlob.FromRecord(Rec, FieldNo("My Model"));
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(Content);
    end;




}