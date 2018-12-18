table 50912 "TTTHGS Nav2BcTemplate"
{
    Description = 'TTTHGS Nav2Bc Template';
    Caption = 'Nav2Bc Template';
    DataCaptionFields = "TTTHGS Code", "TTTHGS Description";
    DataClassification = CustomerContent;
    LookupPageId = "TTTHGS Nav2BcTemplates";
    DrillDownPageId = "TTTHGS Nav2BcTemplates";

    fields
    {
        field(1; "TTTHGS Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "TTTHGS Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "TTTHGS DataLines"; Integer)
        {
            Caption = 'Data Lines';
            FieldClass = FlowField;
            CalcFormula = Count ("TTTHGS Nav2BcData" where (
                "TTTHGS TemplateCode" = field ("TTTHGS Code"),
                "TTTHGS Company" = field ("TTTHGS CompanyFilter")));
            Editable = false;
            BlankZero = true;
        }
        field(4; "TTTHGS CompanyFilter"; Text[30])
        {
            Caption = 'Company Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "TTTHGS Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        locrecData: Record "TTTHGS Nav2BcData";
    begin
        locrecData.SetRange("TTTHGS TemplateCode", "TTTHGS Code");
        locrecData.DeleteAll(true);
    end;

    procedure ImportData()
    var
        loccuMgt: Codeunit "TTTHGS Nav2BcManagement";
    begin
        loccuMgt.ImportData(Rec);
    end;

    procedure SplitData()
    var
        loccuMgt: Codeunit "TTTHGS Nav2BcManagement";
    begin
        loccuMgt.SplitData(Rec);
    end;

    procedure InsertData()
    var
        loccuMgt: Codeunit "TTTHGS Nav2BcManagement";
    begin
        loccuMgt.InsertData(Rec);
    end;

    procedure ShowRecords()
    var
        loccuMgt: Codeunit "TTTHGS Nav2BcManagement";
    begin
        loccuMgt.ShowData(rec);
    end;
}