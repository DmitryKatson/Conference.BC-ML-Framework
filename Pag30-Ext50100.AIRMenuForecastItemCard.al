pageextension 50100 "AIR MenuForecastItemCard" extends "Item Card" //30
{
    layout
    {

    }

    actions
    {

        addafter(AdjustInventory)
        {
            group("AIR Restaurant")
            {
                Image = Forecast;

                action("AIR UpdateForecast")
                {
                    Caption = 'Update Rest. Forecast';
                    Image = Forecast;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        RestForecastCalculate: Codeunit "AIR Calculate Rest. Forecast";
                    begin
                        RestForecastCalculate.CalculateRestForecast(Rec);
                    end;
                }
                action("AIR OpenEvents")
                {
                    Caption = 'Open Events Schedule';
                    Image = Calendar;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "AIR MF Event Schedule List";
                }

            }

        }
    }
}
