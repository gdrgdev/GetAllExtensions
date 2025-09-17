page 50102 "GDRG Product API"
{
    PageType = API;
    APIPublisher = 'gdr';
    APIGroup = 'demo';
    APIVersion = 'v1.0';
    EntityName = 'product';
    EntitySetName = 'products';
    SourceTable = "GDRG Product Buffer";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Description));
                    end;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Unit Price"));
                    end;
                }
                field(categoryCode; Rec."Category Code")
                {
                    Caption = 'Category Code';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Category Code"));
                    end;
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Vendor No."));
                    end;
                }
                field(externalId; Rec."External ID")
                {
                    Caption = 'External ID';
                }
                field(lastModified; Rec."Last Modified")
                {
                    Caption = 'Last Modified';
                }
                field(syncStatus; Rec."Sync Status")
                {
                    Caption = 'Sync Status';
                }
                field(externalNotes; Rec."External Notes")
                {
                    Caption = 'External Notes';
                }
                field(autoSync; Rec."Auto Sync")
                {
                    Caption = 'Auto Sync';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SyncManager: Codeunit "GDRG Sync Manager";
    begin
        Rec.Insert(true);

        if Rec."Auto Sync" then
            SyncManager.SyncToBusinessCentral(Rec)
        else
            Rec.UpdateSyncStatus("GDRG Sync Status"::Pending);

        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        SyncManager: Codeunit "GDRG Sync Manager";
    begin
        if Rec."Auto Sync" then
            SyncManager.SyncToBusinessCentral(Rec)
        else
            Rec.UpdateSyncStatus("GDRG Sync Status"::Pending);

        exit(true);
    end;

    var
        TempFieldSet: Record Field temporary;

    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(Database::"GDRG Product Buffer", FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::"GDRG Product Buffer";
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;
}
