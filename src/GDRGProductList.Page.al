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
                }
                field(Description; Rec.Description)
                {
                }
                field("Search Description"; Rec."Search Description")
                {
                    Style = Strong;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Category Code"; Rec."Category Code")
                {
                }
                field("Category Name"; Rec."Category Name")
                {
                    Style = Strong;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
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
                ToolTip = 'Delete product for demo.';
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
