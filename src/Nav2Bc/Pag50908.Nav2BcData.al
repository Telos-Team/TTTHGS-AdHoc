page 50908 "TTTHGS Nav2BcData"
{
    Description = 'TTTHGS Nav2Bc Data';
    Caption = 'Nav2Bc Data';
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "TTTHGS Nav2BcData";

    layout
    {
        area(Content)
        {
            repeater("TTTHGS Group")
            {
                field("TTTHGS Template Code"; "TTTHGS TemplateCode")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS Company"; "TTTHGS Company")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS TableNo"; "TTTHGS TableNo")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS RecordNo"; "TTTHGS RecordNo")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS FieldNo"; "TTTHGS FieldNo")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS FieldType"; "TTTHGS FieldType")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS FieldLength"; "TTTHGS FieldLength")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS FieldValue"; "TTTHGS FieldValue")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}