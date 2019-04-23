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

}