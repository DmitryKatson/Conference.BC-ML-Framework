codeunit 50101 "AIR Calculate Rest. Forecast"
{

    procedure CalculateRestForecast(Item: Record Item)
    var
        MLPrediction: Codeunit "ML Prediction Management";

        Setup: Record "AIR Rest. ML Forecast Setup";
        RestSalesHistory: Record "AIR RestSalesEntry" temporary;

        TempTimeSeriesForecast: Record "Time Series Forecast" temporary;
    begin

        Setup.Get();
        Setup.TestField("My Model");

        //Setup connection
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);

        //Prepare data for the forecast
        PrepareData(Item, RestSalesHistory);
        MLPrediction.SetRecord(RestSalesHistory);

        //Set features
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(month));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(day));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(stock_count));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(menu_item_id));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(in_children_menu));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(fest_name));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(Children_Event));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(Music_Event));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(max_stock_quantity));

        //Set label
        MLPrediction.SetLabel(RestSalesHistory.FieldNo(orders));

        //Set confidence field (only for classification models)
        //MLPrediction.SetConfidence(RestSalesHistory.FieldNo(confidence));

        //Predict
        MLPrediction.Predict(Setup.GetRestaurantModel());

        //Save forecast
        SaveForecastResult(RestSalesHistory, TempTimeSeriesForecast);

        //Show forecast
        Page.Run(Page::"AIR RestForecast", TempTimeSeriesForecast);
    end;

    local procedure PrepareData(Item: Record Item; var RestSalesHistory: Record "AIR RestSalesEntry" temporary)
    var
        Dates: Record Date;
        ForecastStartDate: Date;
    begin
        //Specify forecast start date
        ForecastStartDate := WorkDate();

        //Specify forecast period type and number of forecast periods
        Dates.Setrange("Period Type", Dates."Period Type"::Date);
        Dates.SetRange("Period Start", ForecastStartDate, CalcDate('<7D>', ForecastStartDate));
        if Dates.FindSet() then
            repeat
                with RestSalesHistory do begin
                    Init();
                    date := Dates."Period Start";
                    day := Date2DMY(Dates."Period Start", 1);
                    month := Date2DMY(Dates."Period Start", 2);
                    stock_count := Item.GetCurrentInventory();
                    menu_item_id := Item."No. 2";
                    in_children_menu := Item."AIR Is Children Menu";
                    fest_name := GetFestivalName(Dates."Period Start");
                    Children_Event := CheckIfChildrenEvent(Dates."Period Start");
                    Music_Event := CheckIfMusicEvent(Dates."Period Start");
                    max_stock_quantity := Item."Maximum Inventory";
                    Insert();
                end;
            until Dates.Next() = 0;
    end;

    procedure GetFestivalName(ForecastDate: Date): Text
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::Festival) then
            exit('NA');
        exit(MFEvent."Event Name");
    end;

    procedure CheckIfChildrenEvent(ForecastDate: Date): Boolean
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Children Event") then
            exit(false);
        exit(true);
    end;

    procedure CheckIfMusicEvent(ForecastDate: Date): Boolean
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Music Event") then
            exit(false);
        exit(true);
    end;

    local procedure SaveForecastResult(var RestSalesHistory: Record "AIR RestSalesEntry" temporary; var TempTimeSeriesForecast: Record "Time Series Forecast" temporary)
    begin
        if not RestSalesHistory.FindSet() then
            exit;
        repeat
            with TempTimeSeriesForecast do begin
                Init();
                "Group ID" := RestSalesHistory.menu_item_id;
                "Period No." := Count + 1;
                "Period Start Date" := RestSalesHistory.date;
                Value := RestSalesHistory.orders;
                Insert();
            end;
        until RestSalesHistory.Next() = 0;
    end;
}