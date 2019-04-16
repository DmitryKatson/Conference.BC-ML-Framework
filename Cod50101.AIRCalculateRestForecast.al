codeunit 50101 "AIR Calculate Rest. Forecast"
{

    procedure CalculateRestForecast(ItemNo: Code[20])
    var
        TimeSeriesMgt: Codeunit "Time Series Management";
        RestSalesEntry: Record "AIR RestSalesEntry";
        Date: Record Date;
        TempTimeSeriesForecast: Record "Time Series Forecast" temporary;
    begin

        //Setup Connection
        TimeSeriesMgt.Initialize(getMLUri(), getMLKey(), 30, false);

        //Get Historical Data
        RestSalesEntry.SetRange(menu_item_id, ItemNo);

        //Prepare data for the forecast
        TimeSeriesMgt.PrepareData(RestSalesEntry,
                                RestSalesEntry.FieldNo(menu_item_id),
                                RestSalesEntry.FieldNo(date),
                                RestSalesEntry.FieldNo(orders),
                                Date."Period Type"::Date,
                                WorkDate(),
                                7);

        //Setup Forecast 
        TimeSeriesMgt.Forecast(1, 0, 0);

        //Get Forecast
        TimeSeriesMgt.GetForecast(TempTimeSeriesForecast);

        //Show forecast
        Page.Run(Page::"AIR RestForecast", TempTimeSeriesForecast);
    end;

    local procedure getMLUri(): Text
    begin
        exit('https://europewest.services.azureml.net/workspaces/9d1ba609dfba49d580b7d65a379aaa64/services/4cfedcaed2de492c9160c2c38104c358/execute?api-version=2.0&details=true')
    end;

    local procedure getMLKey(): Text
    begin
        exit('eFp5IY7xyMfA99ta1Q3Eqyb/UgigT8U+lZTJfqJcmO2zAvEZLtvG2IylY+Atp1/Fr67pnIwXhFOlafafo6hmzA==')
    end;

}