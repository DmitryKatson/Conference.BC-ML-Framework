page 50101 "AIR RestForecast"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    SourceTable = "Time Series Forecast";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Group ID"; "Group ID")
                {
                    ApplicationArea = all;
                }
                field("Period Start Date"; "Period Start Date")
                {
                    ApplicationArea = all;
                }
                field("Value"; "Value")
                {
                    ApplicationArea = all;
                }
                field("Delta %"; "Delta %")
                {
                    //ApplicationArea = all;
                }
                field("Delta"; "Delta")
                {
                    //ApplicationArea = all;
                }
                field("Go_List"; "IsGoList")
                {
                    ApplicationArea = All;
                }
                field("Children_Event"; "IsChildrenEvent")
                {
                    ApplicationArea = All;
                }
                field("Music_Event"; "IsMusic_Event")
                {
                    ApplicationArea = All;
                }
                field("fest_name"; "FestName")
                {
                    ApplicationArea = All;
                }

            }

        }
        area(FactBoxes)
        {
            part(PDFViewer; "AIR PDF Viewer Part")
            {
                Caption = 'PDF Viewer';
                ApplicationArea = All;
            }

        }
    }

    var
        [InDataSet]
        IsGoList: Boolean;
        IsChildrenEvent: Boolean;
        IsMusic_Event: Boolean;
        FestName: Text;

    trigger OnAfterGetRecord()
    var
        CalcRestSales: Codeunit "AIR Calculate Rest. Forecast";
    begin
        IsGoList := CalcRestSales.CheckIfGoList("Group ID");
        IsChildrenEvent := CalcRestSales.CheckIfChildrenEvent("Period Start Date");
        IsMusic_Event := CalcRestSales.CheckIfMusicEvent("Period Start Date");
        FestName := CalcRestSales.GetFestivalName("Period Start Date");
        ShowPdfInViewer();
    end;

    local procedure ShowPdfInViewer()
    begin
        CurrPage.PDFViewer.Page.LoadPdfFromBase64(GetPlotOfTheModel());
    end;

    local procedure GetPlotOfTheModel() PlotBase64: Text
    var
        Setup: Record "AIR Rest. ML Forecast Setup";
        MLPrediction: Codeunit "ML Prediction Management";
    begin
        Setup.Get();
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);
        PlotBase64 := MLPrediction.PlotModel(Setup.GetRestaurantModel(), Setup."My Features", Setup."My Label");
    end;


}