xmlport 50900 "TTTHGS Nav2BcImportData"
{
    Description = 'TTTHGS Nav2Bc Import Data';
    Caption = 'Nav2Bc Import Data';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("TTTHGS Nav2BcData"; "TTTHGS Nav2BcData")
            {
                XmlName = 'Import';
                fieldelement(Company; "TTTHGS Nav2BcData"."TTTHGS Company")
                {
                }
                fieldelement(TableNo; "TTTHGS Nav2BcData"."TTTHGS TableNo")
                {
                    MinOccurs = Zero;
                }
                fieldelement(RecordNo; "TTTHGS Nav2BcData"."TTTHGS RecordNo")
                {
                    MinOccurs = Zero;
                }
                fieldelement(FieldNo; "TTTHGS Nav2BcData"."TTTHGS FieldNo")
                {
                    MinOccurs = Zero;
                }
                fieldelement(FieldType; "TTTHGS Nav2BcData"."TTTHGS FieldType")
                {
                    MinOccurs = Zero;
                }
                fieldelement(FieldLength; "TTTHGS Nav2BcData"."TTTHGS FieldLength")
                {
                    MinOccurs = Zero;
                }
                textelement(FieldValue)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    var
                        locstrmOut: OutStream;
                    begin
                        IF STRLEN(FieldValue) <= MAXSTRLEN("TTTHGS Nav2BcData"."TTTHGS FieldValue") THEN
                            "TTTHGS Nav2BcData"."TTTHGS FieldValue" := FieldValue
                        ELSE BEGIN
                            "TTTHGS Nav2BcData"."TTTHGS BlobValue".CREATEOUTSTREAM(locstrmOut);
                            locstrmOut.WRITE(FieldValue);
                        END;
                    end;
                }

                trigger OnAfterInsertRecord()
                begin
                    intCount += 1;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "TTTHGS Nav2BcData"."TTTHGS TemplateCode" := codTemplate;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        dtFinish := CURRENTDATETIME();
        durTime := dtFinish - dtStart;
        if GuiAllowed() then
            MESSAGE(lblPostMessageLbl, intCount, durTime);
    end;

    trigger OnPreXmlPort()
    begin
        dtStart := CURRENTDATETIME();
    end;

    var
        intCount: Integer;
        codTemplate: Code[20];
        dtStart: DateTime;
        dtFinish: DateTime;
        durTime: Duration;
        lblPostMessageLbl: Label 'Import count: %1\Time: %2';

    procedure SetTemplateCode(parcodTemplateCode: Text)
    begin
        codTemplate := CopyStr(parcodTemplateCode, 1, MaxStrLen(codTemplate));
    end;
}
