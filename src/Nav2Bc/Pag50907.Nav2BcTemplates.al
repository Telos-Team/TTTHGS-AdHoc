page 50907 "TTTHGS Nav2BcTemplates"
{
    Description = 'TTTHGS Nav2Bc Templates';
    Caption = 'Nav2Bc Templates';
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "TTTHGS Nav2BcTemplate";

    layout
    {
        area(Content)
        {
            repeater("TTTHGS Group")
            {
                field("TTTHGS Code"; "TTTHGS Code")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS Description"; "TTTHGS Description")
                {
                    ApplicationArea = All;
                }
                field("TTTHGS DataLines"; "TTTHGS DataLines")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("TTTHGS ImportData")
            {
                Caption = 'Import Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Import;

                trigger OnAction();
                begin
                    ImportData();
                end;
            }
            action("TTTHGS SplitData")
            {
                Caption = 'Split Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Split;

                trigger OnAction();
                begin
                    SplitData();
                end;
            }
            action("TTTHGS InsertData")
            {
                Caption = 'Insert Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Save;

                trigger OnAction();
                begin
                    InsertData();
                end;
            }
        }
        area(Navigation)
        {
            action("TTTHGS ShowData")
            {
                Caption = 'Show Data';
                ApplicationArea = All;
                Promoted = True;
                PromotedIsBig = True;
                PromotedOnly = True;
                PromotedCategory = Process;
                Image = ShowList;
                RunObject = page "TTTHGS Nav2BcData";
                RunPageLink = "TTTHGS TemplateCode" = FIELD ("TTTHGS Code");
            }
            action("TTTHGS ShowRecords")
            {
                Caption = 'Show Records';
                ApplicationArea = All;
                Promoted = True;
                PromotedIsBig = True;
                PromotedOnly = True;
                PromotedCategory = Process;
                Image = ShowList;

                trigger OnAction()
                begin
                    ShowRecords();
                end;
            }
        }
    }
}