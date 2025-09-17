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
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(4; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }
        field(10; "External ID"; Text[50])
        {
            Caption = 'External ID';
            DataClassification = CustomerContent;
        }
        field(11; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            DataClassification = CustomerContent;
        }
        field(12; "Sync Status"; Option)
        {
            Caption = 'Sync Status';
            DataClassification = CustomerContent;
            OptionMembers = Pending,Synced,Error,Deleted;
            OptionCaption = 'Pending,Synced,Error,Deleted';
        }
        field(13; "External Notes"; Text[250])
        {
            Caption = 'External Notes';
            DataClassification = CustomerContent;
        }
        field(14; "Auto Sync"; Boolean)
        {
            Caption = 'Auto Sync to BC';
            DataClassification = CustomerContent;
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
    procedure UpdateSyncStatus(NewStatus: Option)
    begin
        "Sync Status" := NewStatus;
        "Last Modified" := CurrentDateTime;
        Modify();
    end;
}