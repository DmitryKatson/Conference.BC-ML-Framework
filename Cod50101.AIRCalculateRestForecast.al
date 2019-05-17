codeunit 50101 "AIR Calculate Rest. Forecast"
{

    procedure CalculateRestForecast(ItemNo: Code[20])
    var
        RestSalesEntry: Record "AIR RestSalesEntry";
    begin

    end;

    local procedure getMLUri(): Text
    begin
        exit('ml-uri')
    end;

    local procedure getMLKey(): Text
    begin
        exit('ml-key')
    end;

}