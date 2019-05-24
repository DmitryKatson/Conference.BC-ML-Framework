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
                    ApplicationArea = all;
                }
                field("Delta"; "Delta")
                {
                    ApplicationArea = all;
                }

                //field("Go_List"; "IsGoList")
                //{
                //    ApplicationArea = All;
                //}
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
        IsChildrenEvent: Boolean;
        IsMusic_Event: Boolean;
        FestName: Text;

    trigger OnAfterGetRecord()
    var
        MyEvents: Record "AIR MF Event Schedule";
    begin
        IsChildrenEvent := MyEvents.CheckIfChildrenEvent("Period Start Date");
        IsMusic_Event := MyEvents.CheckIfMusicEvent("Period Start Date");
        FestName := MyEvents.GetFestivalName("Period Start Date");
    end;
}