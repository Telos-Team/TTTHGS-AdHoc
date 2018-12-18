table 50913 "TTTHGS Nav2BcRecord"
{
    Description = 'TTTHGS Nav2BC Record';
    Caption = 'Nav2BC Record';
    DataCaptionFields = "TTTHGS Company", "TTTHGS TableNo", "TTTHGS RecordNo";
    DataClassification = CustomerContent;
    LookupPageId = "TTTHGS Nav2BcRecords";
    DrillDownPageId = "TTTHGS Nav2BcRecords";

    fields
    {
        field(1; "TTTHGS TemplateCode"; Code[20])
        {
            Caption = 'Template Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "TTTHGS Nav2BcTemplate";
        }
        field(2; "TTTHGS Company"; Text[30])
        {
            Caption = 'Company';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; "TTTHGS TableNo"; Integer)
        {
            Caption = 'Table No.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(4; "TTTHGS RecordNo"; Integer)
        {
            Caption = 'Record No.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "TTTHGS TemplateCode", "TTTHGS Company", "TTTHGS TableNo", "TTTHGS RecordNo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure GetFieldValue(parintFieldNo: Integer): Text
    var
        locrecData: Record "TTTHGS Nav2BcData";
    begin
        locrecData.SetRange("TTTHGS TemplateCode", "TTTHGS TemplateCode");
        locrecData.SetRange("TTTHGS Company", "TTTHGS Company");
        locrecData.SetRange("TTTHGS RecordNo", "TTTHGS RecordNo");
        if locrecData.FindFirst() then
            if parintFieldNo > 1 then
                if locrecdata.Next(parintFieldNo - 1) <> parintFieldNo - 1 then
                    exit('');
        exit(locrecData."TTTHGS FieldValue");
    end;

    procedure GetFieldHeader(parintFieldNo: Integer): Text
    var
        locrecData: Record "TTTHGS Nav2BcData";
    begin
        locrecData.SetRange("TTTHGS TemplateCode", "TTTHGS TemplateCode");
        locrecData.SetRange("TTTHGS Company", "TTTHGS Company");
        locrecData.SetRange("TTTHGS RecordNo", 0);
        if locrecData.FindFirst() then
            if parintFieldNo > 1 then
                if locrecdata.Next(parintFieldNo - 1) <> parintFieldNo - 1 then
                    exit('');
        exit(locrecData."TTTHGS FieldValue");
    end;

    procedure GetFieldVisible(parintFieldNo: Integer): Boolean
    begin
        exit(GetFieldHeader(parintFieldNo) <> '');
    end;
}
