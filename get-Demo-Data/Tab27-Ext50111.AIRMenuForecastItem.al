tableextension 50111 "AIR MenuForecastItem" extends Item //27
{

    fields
    {
        field(50111; "AIR Is Children Menu"; Boolean)
        {

        }
    }
    procedure GetCurrentInventory(): Decimal
    begin
        CalcFields(Inventory);
        Exit(Inventory)
    end;

    procedure CheckIfGoList(No2: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        with Item do begin
            SetRange("No. 2", No2);
            If not FindFirst() then
                exit(false);
            exit(GetCurrentInventory() > "Maximum Inventory");
        end;
    end;

}