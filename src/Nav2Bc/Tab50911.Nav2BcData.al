table 50911 "TTTHGS Nav2BcData"
{
    Description = 'TTTHGS Nav2BC Data';
    Caption = 'Nav2BC Data';
    DataCaptionFields = "TTTHGS Company", "TTTHGS TableNo", "TTTHGS RecordNo", "TTTHGS FieldNo";
    DataClassification = CustomerContent;
    LookupPageId = "TTTHGS Nav2BcData";
    DrillDownPageId = "TTTHGS Nav2BcData";

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
        field(5; "TTTHGS FieldNo"; Integer)
        {
            Caption = 'Field No.';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(6; "TTTHGS FieldType"; Text[30])
        {
            Caption = 'Field Type';
            DataClassification = SystemMetadata;
        }
        field(7; "TTTHGS FieldLength"; Integer)
        {
            Caption = 'Field Length';
            DataClassification = SystemMetadata;
        }
        field(8; "TTTHGS FieldValue"; Text[80])
        {
            Caption = 'Field Value';
            DataClassification = CustomerContent;
        }
        field(9; "TTTHGS BlobValue"; BLOB)
        {
            Caption = 'Blob Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "TTTHGS TemplateCode", "TTTHGS Company", "TTTHGS TableNo", "TTTHGS RecordNo", "TTTHGS FieldNo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}
