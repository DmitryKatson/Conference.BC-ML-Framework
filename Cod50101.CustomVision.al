codeunit 50101 "AIR CustomVision"
{

    procedure CheckIfSpoiled(var AbortPosting: Boolean; MediaId: Guid)
    var
        ImageAnalisysMgt: Codeunit "Image Analysis Management";
        ImageAnalisysResult: Codeunit "Image Analysis Result";
        i: Integer;
    begin
        ImageAnalisysMgt.SetUriAndKey(GetCustomVisionUri(), GetCustomVisionKey());
        ImageAnalisysMgt.SetMedia(MediaId);
        ImageAnalisysMgt.AnalyzeTags(ImageAnalisysResult);

        for i := 1 to ImageAnalisysResult.TagCount() do begin
            if (ImageAnalisysResult.TagName(i) = GetSpoiledTagName()) and (ImageAnalisysResult.TagConfidence(i) >= GetMinSpoiledProbability()) then begin
                AbortPosting := true;
                exit;
            end;
        end;
    end;


    local procedure GetCustomVisionUri(): Text
    begin
        exit('https://westeurope.api.cognitive.microsoft.com/customvision/v3.0/Prediction/3913a53c-04bc-41ea-9f53-a837a84b622e/classify/iterations/Iteration1/image')
    end;

    local procedure GetCustomVisionKey(): Text
    begin
        exit('e2ce5799fe4f4f9bb6b71210005b53c2')
    end;

    local procedure GetSpoiledTagName(): Text
    begin
        exit('Spoiled Tomato');
    end;

    local procedure GetMinSpoiledProbability(): Decimal
    begin
        exit(0.4)
    end;


}