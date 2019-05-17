codeunit 50103 "AIR Train Rest. Forecast ML"
{

    procedure Train()
    var
        MLPrediction: Codeunit "ML Prediction Management";
        MyModel: Text;
        MyModelQuality: Decimal;

        Setup: Record "AIR Rest. ML Forecast Setup";
        RestSalesHistory: Record "AIR RestSalesEntry";
    begin

        //Setup connection
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);

        //Prepare data for the training
        MLPrediction.SetRecord(RestSalesHistory);

        //Set features
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(date));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(stock_count));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(menu_item_id));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(in_children_menu));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(fest_name));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(Children_Event));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(Music_Event));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(max_stock_quantity));

        //Set label
        MLPrediction.SetLabel(RestSalesHistory.FieldNo(orders));

        //Train model
        MLPrediction.Train(MyModel, MyModelQuality);

        //Save model
        Setup.InsertIfNotExists();
        Setup.SetRestaurantModel(MyModel);
        Setup.Validate("My Model Quality", MyModelQuality);
        Setup.Modify(true);

        //Inform about traininig status
        Message('Model is trained. Quality is %1%', Round(MyModelQuality * 100, 1));

    end;
}