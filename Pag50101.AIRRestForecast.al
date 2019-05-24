page 50101 "AIR RestForecast"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    SourceTable = "Time Series Forecast";
    Caption = 'Restaurant AI sales forecast';

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
            part(ItemPicture; "Item Picture")
            {
                Caption = 'Picture';
                ApplicationArea = All;
                SubPageLink = "No. 2" = field ("Group ID");
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
        MyEvents: Record "AIR MF Event Schedule";
        Item: Record Item;
    begin
        IsGoList := Item.CheckIfGoList("Group ID");
        IsChildrenEvent := MyEvents.CheckIfChildrenEvent("Period Start Date");
        IsMusic_Event := MyEvents.CheckIfMusicEvent("Period Start Date");
        FestName := MyEvents.GetFestivalName("Period Start Date");
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