table 50100 "GDRG Product Buffer"
{
    DataClassification = CustomerContent;
    Caption = 'GDRG Product Buffer';
    LookupPageId = "GDRG Product Buffer List";
    DrillDownPageId = "GDRG Product Buffer List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            ToolTip = 'Specifies the unique product number.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the product description.';
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the unit price for the product.';
        }
        field(4; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            ToolTip = 'Specifies the category code for the product.';
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            ToolTip = 'Specifies the vendor number.';
        }
        field(10; "External ID"; Text[50])
        {
            Caption = 'External ID';
            ToolTip = 'Specifies the external system identifier.';
        }
        field(11; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            ToolTip = 'Specifies when the record was last modified.';
        }
        field(12; "Sync Status"; Enum "GDRG Sync Status")
        {
            Caption = 'Sync Status';
            ToolTip = 'Specifies the synchronization status of the record.';
        }
        field(13; "External Notes"; Text[250])
        {
            Caption = 'External Notes';
            ToolTip = 'Specifies external system notes.';
        }
        field(14; "Auto Sync"; Boolean)
        {
            Caption = 'Auto Sync to BC';
            ToolTip = 'Specifies if the record should be automatically synchronized to Business Central.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Unit Price", "Sync Status")
        {
        }
        fieldgroup(Brick; "No.", Description, "Unit Price")
        {
        }
    }

    /// <summary>
    /// Updates the sync status of the buffer record
    /// </summary>
    /// <param name="NewStatus">The new sync status</param>
    procedure UpdateSyncStatus(NewStatus: Enum "GDRG Sync Status")
    begin
        "Sync Status" := NewStatus;
        "Last Modified" := CurrentDateTime();
        Modify(true);
    end;
}