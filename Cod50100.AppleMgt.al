codeunit 50100 "AIR Apple Mgt."
{
    procedure TakePictureAndCreateNewLine(Rec: Record "Purchase Header")
    var
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        CreateNewLineTemporary(Rec, TempPurchLine);
        TakePicture(TempPurchLine);
        AbortIfSpoiled(TempPurchLine);
        SaveIfFresh(Rec, TempPurchLine);
    end;

    local procedure CreateNewLineTemporary(PurchHeader: Record "Purchase Header"; var TempPurchLine: Record "Purchase Line" temporary)
    begin
        Clear(TempPurchLine);
        TempPurchLine.Validate("Document Type", PurchHeader."Document Type");
        TempPurchLine.Validate("Document No.", PurchHeader."No.");
        TempPurchLine.insert;
    end;


    local procedure TakePicture(var TempPurchLine: Record "Purchase Line" temporary);
    var
        //CameraInteraction: Page "Camera Interaction";
        PictureStream: InStream;

        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        //CameraInteraction.AllowEdit(true);
        //CameraInteraction.Quality(100);
        //CameraInteraction.EncodingType('PNG');
        //CameraInteraction.RunModal();

        //if (CameraInteraction.GetPicture(PictureStream)) then begin
        //    TempPurchLine."AIR Item Photo".ImportStream(PictureStream, CameraInteraction.GetPictureName());
        //end;

        FileManagement.BLOBImport(TempBlob, FileName);
        TempBlob.CreateInStream(PictureStream);
        TempPurchLine."AIR Item Photo".ImportStream(PictureStream, FileName);
    end;

    local procedure AbortIfSpoiled(TempPurchLine: Record "Purchase Line" temporary)
    var
        AbortPosting: Boolean;
        CustomVision: Codeunit "AIR CustomVision";
    begin
        CustomVision.CheckIfSpoiled(AbortPosting, TempPurchLine."AIR Item Photo".MediaId);
        ShowErrorIfSpoiled(AbortPosting);
    end;

    local procedure ShowErrorIfSpoiled(AbortPosting: Boolean)
    begin
        if not AbortPosting then
            exit;
        Error('This item is spoiled. Please replace it with a fresh one and Try again.');
    end;

    local procedure SaveIfFresh(PurchaseHeader: Record "Purchase Header"; TempPurchLine: Record "Purchase Line" temporary)
    var
        PurchLine: Record "Purchase Line";
    begin
        InsertEmptyPurchaseLine(PurchaseHeader, PurchLine);
        PurchLine.Validate(Type, PurchLine.Type::Item);
        PurchLine.Validate("No.", GetFreshAppleItemNo());
        PurchLine.Modify();
    end;

    local procedure InsertEmptyPurchaseLine(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        LineNo: Integer;
    begin
        Clear(PurchaseLine);
        PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");

        LineNo := 10000;
        PurchaseLine.SetRecFilter;
        PurchaseLine.SetRange("Line No.");
        if PurchaseLine.FindLast then
            LineNo := LineNo + PurchaseLine."Line No.";
        PurchaseLine.Validate("Line No.", LineNo);

        PurchaseLine.Insert(true);
    end;

    local procedure GetFreshAppleItemNo(): Code[20]
    var
        item: Record Item;
    begin
        item.SetRange("No. 2", '35');
        if not item.FindFirst() then
            exit;
        exit(item."No.");
    end;


}