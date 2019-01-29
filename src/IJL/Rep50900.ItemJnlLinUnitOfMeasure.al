report 50900 "TTTHGS ItemJnlLinUnitOfMeasure"
{
    Caption = 'Update Item Journal Line Unit of Measure';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(IJL; "Item Journal Line")
        {
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord()
            var
                locrecItem: Record Item;
                loccuUOMMgt: Codeunit "Unit of Measure Management";
            begin
                locrecItem.Get("Item No.");
                "Unit of Measure Code" := locrecItem."Base Unit of Measure";
                "Qty. per Unit of Measure" := loccuUOMMgt.GetQtyPerUnitOfMeasure(locrecItem, "Unit of Measure Code");
                if "Unit of Measure Code" <> '' then
                    Modify(false)
            end;
        }
    }
}