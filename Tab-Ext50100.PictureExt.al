tableextension 50100 "AIR PictureExt" extends "Purchase Line" //MyTargetTableId
{
    fields
    {
        field(50000; "AIR Item Photo"; Media)
        {
            Caption = 'Item Photo';
            ExtendedDatatype = Person;
        }

    }

}