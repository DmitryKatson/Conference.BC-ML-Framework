codeunit 50103 "AIR Train Rest. Forecast ML"
{

    procedure Train();
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
        //MLPrediction.AddFeature(RestSalesHistory.FieldNo(menu_item_id));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(in_children_menu));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(fest_name));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(children_event));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(music_Event));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(s_month));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(s_day));
        MLPrediction.AddFeature(RestSalesHistory.FieldNo(s_go_list));

        //Set label
        MLPrediction.SetLabel(RestSalesHistory.FieldNo(orders));

        //Train model
        MLPrediction.Train(MyModel, MyModelQuality);

        //Save model
        Setup.InsertIfNotExists();
        Setup.SetRestaurantModel(MyModel);
        Setup.Validate("My Model Quality", MyModelQuality);
        Setup.Validate("My Features", 'in_children_menu,fest_name,children_event,music_Event,month,day,go_list');
        Setup.Validate("My Label", 'orders');
        Setup.Modify(true);

        //Inform about traininig status
        Message('Model is trained. Quality is %1%', Round(MyModelQuality * 100, 1));

    end;

    procedure DownloadPlotOfTheModel()
    var
        MLPrediction: Codeunit "ML Prediction Management";
        PlotBase64: Text;
        Setup: Record "AIR Rest. ML Forecast Setup";
    begin
        Setup.Get();
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);

        PlotBase64 := MLPrediction.PlotModel(Setup.GetRestaurantModel(), Setup."My Features", Setup."My Label");

        MLPrediction.DownloadPlot(PlotBase64, 'rest_sales_prediction');
    end;

}