page 50101 "GDRG Product List"
{
    PageType = List;
    SourceTable = "GDRG Product";
    Caption = 'GDRG Product List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product description';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the search description (calculated)';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code';
                }
                field("Category Name"; Rec."Category Name")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the category name (calculated)';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor number';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeleteProduct)
            {
                Caption = 'Delete Product (Demo)';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Deletes the selected product and marks buffer as Deleted';

                trigger OnAction()
                begin
                    if Confirm('Delete product %1?', false, Rec."No.") then begin
                        Rec.Delete(true);
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
}
