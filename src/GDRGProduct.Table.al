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
            NotBlank = true;
            ToolTip = 'Specifies the unique product number.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the product description.';

            trigger OnValidate()
            begin
                if Description <> '' then
                    "Search Description" := UpperCase(Description);
            end;
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            ToolTip = 'Specifies the unit price for the product.';
        }
        field(4; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            ToolTip = 'Specifies the category code for the product.';

            trigger OnValidate()
            begin
                if "Category Code" <> '' then
                    "Category Name" := "Category Code" + ' Category';
            end;
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            ToolTip = 'Specifies the vendor number.';
        }
        field(10; "Search Description"; Text[100])
        {
            Caption = 'Search Description';
            Editable = false;
            ToolTip = 'Specifies the search description calculated from the product description.';
        }
        field(11; "Category Name"; Text[50])
        {
            Caption = 'Category Name';
            Editable = false;
            ToolTip = 'Specifies the category name calculated from the category code.';
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