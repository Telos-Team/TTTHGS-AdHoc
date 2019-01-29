codeunit 50915 "TTTHGS Nav2BcManagement"
{
    Description = 'TTTHGS Nav2Bc Management';
    Subtype = Normal;

    trigger OnRun()
    begin
    end;

    procedure ImportData(parrecTempl: Record "TTTHGS Nav2BcTemplate")
    var
        locxmlImport: XmlPort "TTTHGS Nav2BcImportData";
        locstrmIn: InStream;
        locbooOK: Boolean;
        locdlgWindow: Dialog;
        loctxtClientFilename: Text;
        loclblActionLbl: Label 'Action: #1############################\File: #2############################\Action: #3############################';
        loclblUploadingLbl: Label 'Uploading data...';
        loclblImportingLbl: Label 'Importing data...';
    begin
        if GuiAllowed() then begin
            locdlgWindow.Open(loclblActionLbl);
            locdlgWindow.Update(1, loclblUploadingLbl);
        end;

        locbooOK := UploadIntoStream('Select a file to upload', '', '', loctxtClientFilename, locstrmIn);
        if GuiAllowed() then
            locdlgWindow.Update(1, loclblUploadingLbl);
        while locbooOK do begin
            if GuiAllowed() then begin
                locdlgWindow.Update(1, '');
                locdlgWindow.Update(2, loctxtClientFilename);
                locdlgWindow.Update(3, loclblImportingLbl);
            end;
            locxmlImport.SetTemplateCode(parrecTempl."TTTHGS Code");
            locxmlImport.TextEncoding(TextEncoding::MSDos);
            locxmlImport.SetSource(locstrmIn);
            locbooOK := locxmlImport.Import();
            Message('OK1');
            Commit();
            if GuiAllowed() then begin
                locdlgWindow.Update(1, loclblUploadingLbl);
                locdlgWindow.Update(3, '');
            end;
            locbooOK := UploadIntoStream('Select a file to upload', '', '', loctxtClientFilename, locstrmIn);
            Message('OK2');
        end;

        locdlgWindow.Close();
    end;

    procedure SplitData(parrecTempl: Record "TTTHGS Nav2BcTemplate")
    var
        locrecTempl: Record "TTTHGS Nav2BcTemplate";
        locrecData: Record "TTTHGS Nav2BcData";
        locrecData2: Record "TTTHGS Nav2BcData";
        locrecAllObj: Record AllObjWithCaption;
        loccuTiming: Codeunit "TTTHGS Nav2BcTiming";
        locdlgWindow: Dialog;
        loclblActionLbl: Label 'Action: #1############################\Company: #2############################\Table: #3############################';
        loclblSplittingLbl: Label 'Splitting data...';
    begin
        loccuTiming.StartTimer();
        locrecData.SetRange("TTTHGS TemplateCode", parrecTempl."TTTHGS Code");
        locrecData.FindSet();
        if GuiAllowed() then begin
            locdlgWindow.Open(loclblActionLbl);
            locdlgWindow.Update(1, loclblSplittingLbl);
        end;
        repeat
            if not locrecTempl.Get(StrSubstNo('%1%2', locrecData."TTTHGS TemplateCode", locrecData."TTTHGS TableNo")) then begin
                if GuiAllowed() then begin
                    locdlgWindow.Update(2, locrecData."TTTHGS Company");
                    locdlgWindow.Update(3, locrecData."TTTHGS TableNo");
                end;
                locrecTempl.Init();
                locrecTempl.Validate("TTTHGS Code", StrSubstNo('%1%2', locrecData."TTTHGS TemplateCode", locrecData."TTTHGS TableNo"));
                if locrecAllObj.Get(locrecAllObj."Object Type"::Table, locrecData."TTTHGS TableNo") then
                    locrectempl."TTTHGS Description" := locrecAllObj."Object Name";
                locrecTempl.Insert(true);
            end;
            locrecData2 := locrecData;
            locrecData2."TTTHGS TemplateCode" := locrectempl."TTTHGS Code";
            locrecData2.Insert();
        until locrecData.Next() = 0;
        if GuiAllowed() then
            locdlgWindow.Close();
        loccuTiming.ShowDuration();
    end;

    procedure InsertData(var parvarrecTempl: Record "TTTHGS Nav2BcTemplate")
    var
        locrecData: Record "TTTHGS Nav2BcData";
        locrecAllObj: Record AllObjWithCaption;
        locrrTable: RecordRef;
        locfrField: FieldRef;
        locdfEmpty: DateFormula;
        locintLastTableNo: Integer;
        locintLastRecordNo: Integer;
        locintEmpty: Integer;
        locdecEmpty: Decimal;
        locbooEmpty: Boolean;
        locdatEmpty: Date;
        loctimEmpty: Time;
        locdtEmpty: DateTime;
    begin
        locrecData.SetRange("TTTHGS TemplateCode", parvarrecTempl."TTTHGS Code");
        if parvarrecTempl.GetFilter("TTTHGS CompanyFilter") <> '' then
            locrecData.SetFilter("TTTHGS Company", parvarrecTempl.GetFilter("TTTHGS CompanyFilter"));
        locrecData.SetFilter("TTTHGS RecordNo", '>%1', 0);
        locrecData.FindSet();
        repeat
            if locrecAllObj.Get(locrecAllObj."Object Type"::Table, locrecData."TTTHGS TableNo") then begin
                if (locrecData."TTTHGS TableNo" <> locintLastTableNo) or (locrecData."TTTHGS RecordNo" <> locintLastRecordNo) then begin
                    if locintLastRecordNo <> 0 then
                        if locrrTable.Insert(false) then;
                    locintLastTableNo := locrecData."TTTHGS TableNo";
                    locintLastRecordNo := locrecData."TTTHGS RecordNo";
                    locrrTable.Close();
                    locrrTable.Open(locrecData."TTTHGS TableNo");
                end;
                if locrrTable.FieldExist(locrecData."TTTHGS FieldNo") then begin
                    locfrField := locrrTable.Field(locrecData."TTTHGS FieldNo");
                    case locfrField.Type() of
                        fieldtype::Code:
                            locfrField.Value := locrecData."TTTHGS FieldValue";
                        fieldtype::Text:
                            locfrField.Value := locrecData."TTTHGS FieldValue";
                        fieldtype::Integer,
                        fieldtype::Option:
                            begin
                                evaluate(locintEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := locintEmpty;
                            end;
                        fieldtype::Decimal:
                            begin
                                evaluate(locdecEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := locdecEmpty;
                            end;
                        fieldtype::Date:
                            begin
                                evaluate(locdatEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := locdatEmpty;
                            end;
                        fieldtype::Time:
                            begin
                                evaluate(loctimEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := loctimEmpty;
                            end;
                        fieldtype::DateTime:
                            begin
                                evaluate(locdtEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := locdtEmpty;
                            end;
                        fieldtype::DateFormula:
                            begin
                                evaluate(locdfEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := locdfEmpty;
                            end;
                        fieldtype::Boolean:
                            begin
                                evaluate(locbooEmpty, locrecData."TTTHGS FieldValue");
                                locfrField.Value := locbooEmpty;
                            end;
                        else
                            Error('Unmanaged field type: %1 %2 %3 %4 %5', locrecData."TTTHGS TableNo", locrecdata."TTTHGS RecordNo", locrecData."TTTHGS FieldNo", locfrField.Type());
                    end;
                end;
            end;
        until locrecData.Next() = 0;
        if locrrTable.Insert(false) then;
    end;

    procedure ShowData(parrecTempl: Record "TTTHGS Nav2BcTemplate")
    var
        locrecData: Record "TTTHGS Nav2BcData";
        loctmprecRecords: Record "TTTHGS Nav2BcRecord" temporary;
        locintRecCount: Integer;
        i: Integer;
    begin
        locrecData.SetRange("TTTHGS TemplateCode", parrecTempl."TTTHGS Code");
        if not locrecData.FindLast() then
            exit;
        locintRecCount := locrecData."TTTHGS RecordNo";
        for i := 1 to locintRecCount do begin
            loctmprecRecords.Init();
            loctmprecRecords."TTTHGS TemplateCode" := locrecData."TTTHGS TemplateCode";
            loctmprecRecords."TTTHGS Company" := locrecData."TTTHGS Company";
            loctmprecRecords."TTTHGS TableNo" := locrecData."TTTHGS TableNo";
            loctmprecRecords."TTTHGS RecordNo" := i;
            loctmprecRecords.Insert(false);
        end;
        loctmprecRecords.FindSet();
        page.Run(0, loctmprecRecords);
    end;
}