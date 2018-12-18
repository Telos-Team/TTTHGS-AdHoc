codeunit 50920 "TTTHGS Nav2BcTiming"
{
    trigger OnRun()
    begin
    end;

    var
        dtStart: DateTime;
        dtFinish: DateTime;
        durTime: Duration;
        txtName: Text;
        lblDurationMessageLbl: Label 'Duration %2: %1';

    procedure SetName(partxtName: Text)
    begin
        txtName := partxtName;
    end;

    procedure StartTimer()
    begin
        dtStart := CurrentDateTime();
    end;

    procedure StopTimer()
    begin
        dtFinish := CurrentDateTime();
    end;

    procedure GetStart(): DateTime
    begin
        exit(dtStart);
    end;

    procedure GetFinish(): DateTime
    begin
        exit(dtFinish);
    end;

    procedure GetDuration(): Duration
    begin
        durTime := GetFinish() - GetStart();
        exit(durTime);
    end;

    procedure ShowDuration()
    begin
        if GetFinish() = 0DT then
            StopTimer();
        if GuiAllowed() then
            MESSAGE(lblDurationMessageLbl, GetDuration(), txtName);
    end;

}