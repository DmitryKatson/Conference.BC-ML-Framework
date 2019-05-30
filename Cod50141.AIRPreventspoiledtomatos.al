codeunit 50141 "AIR Prevent spoiled tomatos"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterTestPurchLine', '', true, true)]
    local procedure AbortPostingIfLineHasSpoiledTomato(PurchLine: Record "Purchase Line")
    var
        HasItem: Boolean;
        AbortPosting: Boolean;
    begin
        CheckIfPurchaseLineHasItem(HasItem, PurchLine);
        CheckIfItemIsSpoiledTomato(HasItem, AbortPosting, PurchLine."No.");
        AbortPostingIfSpoiledTomato(AbortPosting);
    end;

    local procedure CheckIfPurchaseLineHasItem(var HasItem: Boolean; PurchLine: Record "Purchase Line")
    begin
        HasItem := (PurchLine.Type = PurchLine.Type::Item) and (PurchLine."No." <> '')
    end;

    local procedure CheckIfItemIsSpoiledTomato(var HasItem: Boolean; var AbortPosting: Boolean; ItemNo: Code[20])
    var
        Item: Record Item;
        ImageAnalisysMgt: Codeunit "Image Analysis Management";
        ImageAnalisysResult: Codeunit "Image Analysis Result";
        i: Integer;
    begin
        if not HasItem then
            exit;
        Item.Get(ItemNo);

        ImageAnalisysMgt.SetUriAndKey(GetCustomVisionUri(), GetCustomVisionKey());
        ImageAnalisysMgt.SetMedia(Item.Picture.Item(Item.Picture.Count()));
        ImageAnalisysMgt.AnalyzeTags(ImageAnalisysResult);

        for i := 1 to ImageAnalisysResult.TagCount() do begin
            if (ImageAnalisysResult.TagName(i) = GetSpoiledTomatoTagName()) and (ImageAnalisysResult.TagConfidence(i) >= GetMinSpoiledTomatoProbability()) then begin
                AbortPosting := true;
                exit;
            end;
        end;
    end;

    local procedure AbortPostingIfSpoiledTomato(AbortPosting: Boolean)
    begin
        if not AbortPosting then
            exit;
        Error('You have spolied tomatos. Please remove them from Purchase order and Try again.');
    end;

    local procedure GetCustomVisionUri(): Text
    begin
        exit('https://westeurope.api.cognitive.microsoft.com/customvision/v3.0/Prediction/3913a53c-04bc-41ea-9f53-a837a84b622e/classify/iterations/Iteration1/image')
    end;

    local procedure GetCustomVisionKey(): Text
    begin
        exit('e2ce5799fe4f4f9bb6b71210005b53c2')
    end;

    local procedure GetSpoiledTomatoTagName(): Text
    begin
        exit('Spoiled Tomato');
    end;

    local procedure GetMinSpoiledTomatoProbability(): Decimal
    begin
        exit(0.8)
    end;

}