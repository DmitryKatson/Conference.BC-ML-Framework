page 50101 "AIR RestForecast"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
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

            }
        }
    }
}