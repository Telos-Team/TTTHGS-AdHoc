report 50901 "TTTHGS FieldChange"
{
    Caption = 'Field Change';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Bank Account Ledger Entry" = M;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            MaxIteration = 1;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Settings)
                {
                    Caption = 'Settings';
                    field(TableNo; intTableNo)
                    {
                        Caption = 'Table No.';
                        ApplicationArea = All;
                        BlankZero = true;

                        trigger OnValidate()
                        begin
                            OnValidateTableNo(intTableNo);
                        end;
                    }
                    field(TableName; txtTableName)
                    {
                        Caption = 'Table Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(TableFilter; txtTableFilter)
                    {
                        Caption = 'Table Filter';
                        ToolTip = 'Table Filter example: Where(No. = Filter(10000..20000))';
                        ApplicationArea = All;
                    }
                    field(FieldNo; intFieldNo)
                    {
                        Caption = 'Field No.';
                        ApplicationArea = All;
                        BlankZero = true;

                        trigger OnValidate()
                        begin
                            OnValidateFieldNo(intTableNo, intFieldNo);
                        end;
                    }
                    field(FieldName; txtFieldName)
                    {
                        Caption = 'Field Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(UseAction; optAction)
                    {
                        Caption = 'Action';
                        ApplicationArea = All;
                    }
                    field(NewValue; txtNewValue)
                    {
                        Caption = 'New value';
                        ApplicationArea = All;
                    }
                    field(UseOnModify; booUseOnModify)
                    {
                        Caption = 'Use OnModify';
                        ApplicationArea = All;
                    }
                    field(UseOnValidate; booUseOnValidate)
                    {
                        Caption = 'Use OnValidate';
                        ApplicationArea = All;
                    }
                    field(UseCommitPerRecords; intCommitPerRecords)
                    {
                        Caption = 'Use COMMIT per no. of records';
                        ApplicationArea = All;
                        BlankZero = true;

                        trigger OnValidate()
                        begin
                            if intCommitPerRecords > 0 then begin
                                Clear(intCommitPerSeconds);
                                Clear(booUseTest);
                            end;
                        end;
                    }
                    field(UseCommitPerSeconds; intCommitPerSeconds)
                    {
                        Caption = 'Use COMMIT per no. of seconds';
                        ApplicationArea = All;
                        BlankZero = true;

                        trigger OnValidate()
                        begin
                            if intCommitPerSeconds > 0 then begin
                                Clear(intCommitPerRecords);
                                Clear(booUseTest);
                            end;
                        end;
                    }
                    field(UseTest; booUseTest)
                    {
                        Caption = 'Use Test';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if booUseTest then begin
                                Clear(intCommitPerRecords);
                                Clear(intCommitPerSeconds);
                            end;
                        end;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        Start();
    end;

    var
        intTableNo: Integer;
        intFieldNo: Integer;
        intCommitPerRecords: Integer;
        intCommitPerSeconds: Integer;
        txtTableFilter: Text;
        txtNewValue: Text;
        txtTableName: Text;
        txtFieldName: Text;
        optAction: Option "ClearValue","InitValue","SetValue";
        booUseOnModify: Boolean;
        booUseOnValidate: Boolean;
        booUseTest: Boolean;
        dlgWindow: Dialog;
        dtStart: DateTime;
        dtEnd: DateTime;
        durTime: Duration;
        textProgressDialogTxt: Label 'Current record:\#1################################################';
        textFinishMessageTxt: Label '%1 records\%2';
        textTestCancellationTxt: Label 'Selecting TEST cancelled the COMMIT of all changes!';

    local procedure OnValidateTableNo(var parvarintTableNo: Integer)
    var
        locrrTable: RecordRef;
    begin
        locrrTable.Open(parvarintTableNo);
        txtTableName := locrrTable.Name();
        OnValidateFieldNo(parvarintTableNo, intFieldNo);
    end;

    local procedure OnValidateFieldNo(parintTableNo: Integer; var parvarintFieldNo: Integer)
    var
        locrrTable: RecordRef;
        locfrField: FieldRef;
    begin
        locrrTable.Open(parintTableNo);
        if locrrTable.FieldExist(parvarintFieldNo) then begin
            locfrField := locrrTable.Field(parvarintFieldNo);
            txtFieldName := locfrField.Name();
        end else begin
            Clear(parvarintFieldNo);
            Clear(txtFieldName);
        end;
    end;

    procedure Start()
    var
        locrrTable: RecordRef;
        locrrNew: RecordRef;
        locfrField: FieldRef;
        locfrNew: FieldRef;
        locintRecordCount: Integer;
        locdtNextCommit: DateTime;
    begin
        dtStart := CurrentDateTime();
        locrrNew.OPEN(intTableNo);
        case optAction of
            optAction::ClearValue:
                locfrNew := locrrNew.Field(intFieldNo);
            optAction::InitValue:
                begin
                    locrrNew.INIT();
                    locfrNew := locrrNew.Field(intFieldNo);
                end;
            optAction::SetValue:
                begin
                    locfrNew := locrrNew.Field(intFieldNo);
                    EVALUATE(locfrNew, txtNewValue);
                end;
        end;

        locrrTable.Open(intTableNo);
        if txtTableFilter <> '' then
            locrrTable.SetView(txtTableFilter);
        locrrTable.FindSet(true, false);
        if intCommitPerSeconds > 0 then
            locdtNextCommit := CurrentDateTime() + intCommitPerSeconds * 1000;
        if GuiAllowed() then
            dlgWindow.Open(textProgressDialogTxt);
        repeat
            locintRecordCount += 1;
            if GuiAllowed() then
                dlgWindow.Update(1, locrrTable.GetPosition(true));
            locfrField := locrrTable.Field(intFieldNo);
            if booUseOnValidate then
                locfrField.Validate(locfrNew.Value())
            else
                locfrField.Value := locfrNew.Value();
            locrrTable.Modify(booUseOnModify);

            if intCommitPerRecords > 0 then
                if locintRecordCount mod intCommitPerRecords = 0 then
                    Commit();
            if intCommitPerSeconds > 0 then
                if CurrentDateTime() > locdtNextCommit then begin
                    Commit();
                    locdtNextCommit := CurrentDateTime() + intCommitPerRecords * 10000;
                end;
        until locrrTable.Next() = 0;
        if GuiAllowed() then
            dlgWindow.Close();

        dtEnd := CurrentDateTime();
        durTime := dtEnd - dtStart;
        Message(textFinishMessageTxt, locintRecordCount, durTime);

        if booUseTest then
            Error(textTestCancellationTxt);
    end;
}