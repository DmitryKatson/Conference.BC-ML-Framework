table 50100 "AIR RestSalesEntry"
{

    fields
    {

        field(1; "date"; Date)
        {
            CaptionML = ENU = 'date';
        }
        field(2; "menu_item"; Text[250])
        {
            CaptionML = ENU = 'menu_item';
        }
        field(3; "stock_count"; Decimal)
        {
            CaptionML = ENU = 'stock_count';
        }
        field(4; "orders"; Decimal)
        {
            CaptionML = ENU = 'orders';
        }
        field(5; "menu_item_id"; Code[10])
        {
            CaptionML = ENU = 'menu_item_id';
        }
        field(6; "in_children_menu"; Boolean)
        {
            CaptionML = ENU = 'in_children_menu';
        }
        field(7; "max_stock_quantity"; Decimal)
        {
            CaptionML = ENU = 'max_stock_quantity';
        }
        field(8; "Children_Event"; Boolean)
        {
            CaptionML = ENU = 'Children_Event';
        }
        field(9; "Music_Event"; Boolean)
        {
            CaptionML = ENU = 'Music_Event';
        }
        field(10; "fest_name"; Text[250])
        {
            CaptionML = ENU = 'fest_name';
        }

    }

    keys
    {
        key(Primary; date, menu_item_id)
        {
            Clustered = true;
        }
    }

    procedure RefreshRestSales();
    var
        Refreshrestsales: Codeunit "AIR RefreshRestSales";
    begin
        Refreshrestsales.Refresh();
    end;


}
