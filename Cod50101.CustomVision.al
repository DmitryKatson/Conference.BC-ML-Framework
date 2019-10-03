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
        exit('https://westeurope.api.cognitive.microsoft.com/customvision/v3.0/Prediction/1d06bd25-041f-439b-9d19-ddb38d35a7e9/classify/iterations/main/image')
    end;

    local procedure GetCustomVisionKey(): Text
    begin
        exit('e2ce5799fe4f4f9bb6b71210005b53c2')
    end;

    local procedure GetSpoiledTagName(): Text
    begin
        exit('spoiled');
    end;

    local procedure GetMinSpoiledProbability(): Decimal
    begin
        exit(0.4)
    end;


}