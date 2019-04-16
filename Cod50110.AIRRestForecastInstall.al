codeunit 50110 "AIR RestForecast Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        EnableWebServicesCallsInTheSandbox();
    end;

    trigger OnInstallAppPerCompany()
    begin
        if not isEvaluationCompany() then
            exit;

        LoadDemoData();
        LoadRestHistory();
    end;

    local procedure EnableWebServicesCallsInTheSandbox()
    var
        NavAppSetting: Record "NAV App Setting";
        TenantMgt: Codeunit "Tenant Management";
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);

        If TenantMgt.IsSandbox() Then begin
            NavAppSetting."App ID" := AppInfo.Id();
            NavAppSetting."Allow HttpClient Requests" := true;
            if not NavAppSetting.Insert() then
                NavAppSetting.Modify();
        end;
    end;

    local procedure isEvaluationCompany(): Boolean
    var
        Company: Record Company;
    begin
        Company.Get(CompanyName());
        exit(Company."Evaluation Company");
    end;

    local procedure LoadDemoData()
    var
        MFLoadDemoData: Codeunit "AIR Rest. Load Demo Data";
    begin
        MFLoadDemoData.LoadDemoData();
    end;

    local procedure LoadRestHistory()
    var
        Refreshrestsales: Codeunit "AIR RefreshRestSales";
        RestSalesEntry: Record "AIR RestSalesEntry";
    begin
        if Not RestSalesEntry.IsEmpty then
            exit;

        Refreshrestsales.Refresh();
    end;
}