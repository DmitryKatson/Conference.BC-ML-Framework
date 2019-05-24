codeunit 50115 "AIR SetWorkDate"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterCompanyOpen', '', false, false)]
    local procedure SetWorkDate()
    begin
        WorkDate(Today);
    end;

}