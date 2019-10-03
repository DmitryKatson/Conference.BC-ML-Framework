pageextension 50101 "AIR PictureExt" extends "Purchase Order" //50
{
    layout
    {

    }

    actions
    {
        addbefore(CopyDocument)
        {
            action("AIR NewPurchaseLineFromCamera")
            {
                ApplicationArea = Basic;
                Caption = 'Create New Purchase Line from Camera';
                Image = Camera;
                ToolTip = 'Create an new document line by taking a photo of the item with your mobile device camera. The photo will be attached to the new line.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    AppleMgt: Codeunit "AIR Apple Mgt.";
                begin
                    AppleMgt.TakePictureAndCreateNewLine(Rec)
                end;
            }
        }
    }

}