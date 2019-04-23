codeunit 50101 "AIR Calculate Rest. Forecast"
{

    procedure CalculateRestForecast(Item: Record Item)
    var
        Date: Record Date;
        ForecastStartDate: Date;

        AzureMLConnector: Codeunit "Azure ML Connector";
        PredictionOrders: Text;
        PredictionValue: Decimal;

        TempTimeSeriesForecast: Record "Time Series Forecast" temporary;
    begin

        //Setup connection
        AzureMLConnector.Initialize(getMLKey(), getMLUri(), 30);

        //Setup name of the input and output web service according to the schema
        AzureMLConnector.SetInputName('input1');
        AzureMLConnector.SetOutputName('output1');

        //Setup names of the input web service fields according to the schema
        AzureMLConnector.AddInputColumnName('date');
        AzureMLConnector.AddInputColumnName('stock_count');
        AzureMLConnector.AddInputColumnName('menu_item_id');
        AzureMLConnector.AddInputColumnName('in_children_menu');
        AzureMLConnector.AddInputColumnName('fest_name');
        AzureMLConnector.AddInputColumnName('Children_Event');
        AzureMLConnector.AddInputColumnName('Music_Event');
        AzureMLConnector.AddInputColumnName('max_stock_quantity');
        //repeat the same for all columns in the API input schema

        //indicate that you are going to input values 
        AzureMLConnector.AddInputRow();

        //Specify forecast start date
        ForecastStartDate := WorkDate();

        //Specify forecast period type and number of forecast periods
        Date.Setrange("Period Type", Date."Period Type"::Date);
        Date.SetRange("Period Start", ForecastStartDate, CalcDate('<7D>', ForecastStartDate));
        if Date.FindSet() then
            repeat

                //Add input values
                AzureMLConnector.AddInputValue(Format(Date."Period Start"));
                AzureMLConnector.AddInputValue(Format(Item.GetCurrentInventory));
                AzureMLConnector.AddInputValue(Item."No. 2");
                AzureMLConnector.AddInputValue(Format(CheckIfItemMenuBelongsToChildrenMenu(Item)));
                AzureMLConnector.AddInputValue(GetFestivalName(Date."Period Start"));
                AzureMLConnector.AddInputValue(Format(CheckIfChildrenEvent(Date."Period Start")));
                AzureMLConnector.AddInputValue(Format(CheckIfMusicEvent(Date."Period Start")));
                AzureMLConnector.AddInputValue(Format(Item."Maximum Inventory"));
                // repeat the same for all columns in the API input schema

                //Calculate forecast
                AzureMLConnector.SendToAzureML();

                //Get forecast
                AzureMLConnector.GetOutput(1, 1, PredictionOrders); //change AML output schema, if needed

                //Save forecast
                Evaluate(PredictionValue, PredictionOrders);
                SaveForecastResult(Item."No.", Date."Period Start", PredictionValue, TempTimeSeriesForecast);
            until Date.Next() = 0;

        //Show forecast
        Page.Run(Page::"AIR RestForecast", TempTimeSeriesForecast);
    end;

    local procedure getMLUri(): Text
    begin
        exit('https://europewest.services.azureml.net/workspaces/9d1ba609dfba49d580b7d65a379aaa64/services/68199b14c46b4014b998205bd084a04b/execute?api-version=2.0&details=true')
    end;

    local procedure getMLKey(): Text
    begin
        exit('M6iIWjDURzjzXKBmiG17fUBK2Nj1wy5DBOdN216Xr9idualQX8hINsnCXt0cdhQoUpUerixbG6IHDwPltZrJbQ==')
    end;

    local procedure CheckIfItemMenuBelongsToChildrenMenu(Item: Record Item): Integer
    begin
        if Item."AIR Is Children Menu" then
            exit(1);
        exit(0);
    end;

    local procedure GetFestivalName(ForecastDate: Date): Text
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::Festival) then
            exit('');
        exit(MFEvent."Event Name");
    end;

    local procedure CheckIfChildrenEvent(ForecastDate: Date): Integer
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Children Event") then
            exit(0);
        exit(1);
    end;

    local procedure CheckIfMusicEvent(ForecastDate: Date): Integer
    var
        MFEvent: Record "AIR MF Event Schedule";
    begin
        IF Not MFEvent.Get(ForecastDate, MFEvent."Event Type"::"Music Event") then
            exit(0);
        exit(1);
    end;

    local procedure SaveForecastResult(ItemNo: Code[20]; ForecastDate: Date; PredictionValue: Decimal; var TempTimeSeriesForecast: Record "Time Series Forecast" temporary)
    begin
        with TempTimeSeriesForecast do begin
            Init();
            "Group ID" := ItemNo;
            "Period Start Date" := ForecastDate;
            Value := PredictionValue;
            Insert();
        end;
    end;
}