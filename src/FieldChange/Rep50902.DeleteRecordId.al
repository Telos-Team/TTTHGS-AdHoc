report 50902 "TTTHGS DeleteRecordId"
{
    Caption = 'Delete RecordId';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where (Number = const (1));
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
                    field(ridDelete; ridDelete)
                    {
                        Caption = 'Record ID';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            OnValidateRecordId(ridDelete);
                        end;
                    }
                    field(txtDeleteRecordId; txtDeleteRecordId)
                    {
                        Caption = 'Record ID Text';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            OnValidateTextRecordId(txtDeleteRecordId);
                        end;
                    }
                    field(UseOnModify; booUseTableTrigger)
                    {
                        Caption = 'Use OnModify';
                        ApplicationArea = All;
                    }
                    field(UseTest; booUseTest)
                    {
                        Caption = 'Use Test';
                        ApplicationArea = All;
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
        ridDelete: RecordId;
        txtDeleteRecordId: Text;
        booUseTableTrigger: Boolean;
        booUseTest: Boolean;
        textTestCancellationTxt: Label 'Selecting TEST cancelled the COMMIT of all changes!';

    local procedure OnValidateRecordId(var parridDelete: RecordId)
    var
        locrrTable: RecordRef;
    begin
        locrrTable := parridDelete.GetRecord();
        txtDeleteRecordId := Format(parridDelete);
    end;

    local procedure OnValidateTextRecordId(var partxtRecordId: Text)
    var
        locridDelete: RecordId;
    begin
        Evaluate(locridDelete, partxtRecordId);
        ridDelete := locridDelete;
    end;

    procedure Start()
    var
        locrrTable: RecordRef;
    begin
        locrrTable := ridDelete.GetRecord();
        locrrTable.Delete(booUseTableTrigger);

        if booUseTest then
            Error(textTestCancellationTxt);
        Message('OK');
    end;
}
