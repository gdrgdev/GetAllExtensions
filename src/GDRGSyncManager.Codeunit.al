codeunit 50100 "GDRG Sync Manager"
{

    Permissions = tabledata "GDRG Product" = rimd,
                  tabledata "GDRG Product Buffer" = rimd,
                  tabledata "Field Buffer" = rimd;

    var
        TypeHelper: Codeunit "Type Helper";

    /// <summary>
    /// Synchronizes selected fields from buffer to Business Central table
    /// </summary>
    /// <param name="ProductBuffer">Source buffer record</param>
    procedure SyncToBusinessCentral(var ProductBuffer: Record "GDRG Product Buffer")
    begin
        // Check if already deleted
        if ProductBuffer."Sync Status" = "GDRG Sync Status"::Deleted then
            exit;

        if not TrySyncToBusinessCentral(ProductBuffer) then begin
            ProductBuffer.UpdateSyncStatus("GDRG Sync Status"::Error);
            ProductBuffer."Last Modified" := CurrentDateTime();
            ProductBuffer.Modify(true);
        end;
    end;

    [TryFunction]
    local procedure TrySyncToBusinessCentral(var ProductBuffer: Record "GDRG Product Buffer")
    var
        Product: Record "GDRG Product";
        TempFieldBuffer: Record "Field Buffer" temporary;
        ProductRecordRef: RecordRef;
        RecordExists: Boolean;
    begin
        RecordExists := Product.Get(TransformExternalIdToNo(ProductBuffer."External ID"));

        if not RecordExists then begin
            Product.Init();
            Product."No." := TransformExternalIdToNo(ProductBuffer."External ID");
        end;

        // Apply transformations before sync
        ApplyDataTransformations(ProductBuffer);

        RegisterSyncFields(TempFieldBuffer);
        ProductRecordRef.GetTable(Product);

        TypeHelper.TransferFieldsWithValidate(TempFieldBuffer, ProductBuffer, ProductRecordRef);
        ProductRecordRef.SetTable(Product);

        if RecordExists then
            Product.Modify(true)
        else
            Product.Insert(true);

        ProductBuffer.UpdateSyncStatus("GDRG Sync Status"::Synced);

        UpdateBufferFromBC(Product, ProductBuffer);
    end;

    /// <summary>
    /// Synchronizes changes from Business Central back to buffer
    /// </summary>
    /// <param name="Product">Source Business Central record</param>
    procedure SyncFromBusinessCentral(var Product: Record "GDRG Product")
    var
        ProductBuffer: Record "GDRG Product Buffer";
    begin
        if ProductBuffer.Get(Product."No.") then begin
            UpdateBufferFromBC(Product, ProductBuffer);
            ProductBuffer.Modify(true);
        end;
    end;

    local procedure RegisterSyncFields(var TempFieldBuffer: Record "Field Buffer" temporary)
    var
        ProductBuffer: Record "GDRG Product Buffer";
    begin
        TempFieldBuffer.DeleteAll(false);

        AddFieldToBuffer(TempFieldBuffer, Database::"GDRG Product Buffer", ProductBuffer.FieldNo("No."));
        AddFieldToBuffer(TempFieldBuffer, Database::"GDRG Product Buffer", ProductBuffer.FieldNo(Description));
        AddFieldToBuffer(TempFieldBuffer, Database::"GDRG Product Buffer", ProductBuffer.FieldNo("Unit Price"));
        AddFieldToBuffer(TempFieldBuffer, Database::"GDRG Product Buffer", ProductBuffer.FieldNo("Category Code"));
        AddFieldToBuffer(TempFieldBuffer, Database::"GDRG Product Buffer", ProductBuffer.FieldNo("Vendor No."));
    end;

    local procedure AddFieldToBuffer(var TempFieldBuffer: Record "Field Buffer" temporary; TableID: Integer; FieldID: Integer)
    var
        LastOrderNo: Integer;
    begin
        if TempFieldBuffer.FindLast() then
            LastOrderNo := TempFieldBuffer.Order + 1
        else
            LastOrderNo := 1;

        Clear(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := TableID;
        TempFieldBuffer."Field ID" := FieldID;
        TempFieldBuffer.Insert(false);
    end;

    local procedure UpdateBufferFromBC(var Product: Record "GDRG Product"; var ProductBuffer: Record "GDRG Product Buffer")
    begin
        ProductBuffer."No." := Product."No.";
        ProductBuffer.Description := Product.Description;
        ProductBuffer."Unit Price" := Product."Unit Price";
        ProductBuffer."Category Code" := Product."Category Code";
        ProductBuffer."Vendor No." := Product."Vendor No.";
        ProductBuffer."Last Modified" := CurrentDateTime();
    end;

    [EventSubscriber(ObjectType::Table, Database::"GDRG Product", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertProduct(var Rec: Record "GDRG Product"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            SyncFromBusinessCentral(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"GDRG Product", OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyProduct(var Rec: Record "GDRG Product"; var xRec: Record "GDRG Product"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            SyncFromBusinessCentral(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"GDRG Product", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteProduct(var Rec: Record "GDRG Product"; RunTrigger: Boolean)
    var
        ProductBuffer: Record "GDRG Product Buffer";
    begin
        if not RunTrigger then
            exit;

        if ProductBuffer.Get(Rec."No.") then begin
            ProductBuffer.UpdateSyncStatus("GDRG Sync Status"::Deleted);
            ProductBuffer."Last Modified" := CurrentDateTime();
            ProductBuffer.Modify(true);
        end;
    end;

    local procedure TransformExternalIdToNo(ExternalId: Text[50]): Code[20]
    begin
        // Transform "EXT_12345" -> "12345"
        if ExternalId.StartsWith('EXT_') then
            exit(CopyStr(ExternalId.Substring(5), 1, 20))
        else
            exit(CopyStr(ExternalId, 1, 20));
    end;

    local procedure ApplyDataTransformations(var ProductBuffer: Record "GDRG Product Buffer")
    begin
        // Transform No. field from External ID
        ProductBuffer."No." := TransformExternalIdToNo(ProductBuffer."External ID");

        // Transform Category Code mapping
        case ProductBuffer."Category Code" of
            'ELEC':
                ProductBuffer."Category Code" := 'ELECTRONICS';
            'FURN':
                ProductBuffer."Category Code" := 'FURNITURE';
            'CLOTH':
                ProductBuffer."Category Code" := 'CLOTHING';
        end;

        // Add prefix to Description
        if not ProductBuffer.Description.StartsWith('[FROM API] ') then
            ProductBuffer.Description := CopyStr('[FROM API] ' + ProductBuffer.Description, 1, 100);
    end;
}
