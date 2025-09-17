table 50101 "GDRG Product"
{
    DataClassification = CustomerContent;
    Caption = 'GDRG Product';
    LookupPageId = "GDRG Product List";
    DrillDownPageId = "GDRG Product List";

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

            trigger OnValidate()
            begin
                if Description <> '' then
                    "Search Description" := UpperCase(Description);
            end;
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(4; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Category Code" <> '' then
                    "Category Name" := "Category Code" + ' Category';
            end;
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }
        field(10; "Search Description"; Text[100])
        {
            Caption = 'Search Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Category Name"; Text[50])
        {
            Caption = 'Category Name';
            DataClassification = CustomerContent;
            Editable = false;
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
        fieldgroup(DropDown; "No.", Description, "Unit Price", "Category Code")
        {
        }
        fieldgroup(Brick; "No.", Description, "Unit Price")
        {
        }
    }
}