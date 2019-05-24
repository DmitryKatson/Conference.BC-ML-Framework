pageextension 50100 "AIR MenuForecastItemCard" extends "Item Card" //30
{
    layout
    {
        addafter("Item Category Code")
        {
            field("AIR Is Children Menu"; "AIR Is Children Menu")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {

        addafter(AdjustInventory)
        {
            group("AIR Restaurant")
            {
                Image = Forecast;
                Caption = 'Restaurant';

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
                        RestForecastCalculate.CalculateRestForecast(Rec."No. 2");
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

                action("AIR OpenRestHistory")
                {
                    Caption = 'Open Rest. History';
                    Image = History;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RestSalesHistory: Record "AIR RestSalesEntry";
                    begin
                        RestSalesHistory.SetRange(menu_item_id, "No. 2");
                        Page.Run(page::"AIR RestSalesEntries", RestSalesHistory);
                    end;
                }

            }

        }
    }

}
