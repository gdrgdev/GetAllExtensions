page 50100 "GDRG Product Buffer List"
{
    PageType = List;
    SourceTable = "GDRG Product Buffer";
    Caption = 'GDRG Product Buffer List';
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
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor number';
                }
                field("External ID"; Rec."External ID")
                {
                    ApplicationArea = All;
                    Style = Attention;
                    ToolTip = 'Specifies the external system ID';
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ApplicationArea = All;
                    Style = Attention;
                    ToolTip = 'Specifies when the record was last modified';
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ApplicationArea = All;
                    Style = Attention;
                    ToolTip = 'Specifies the synchronization status';
                }
                field("External Notes"; Rec."External Notes")
                {
                    ApplicationArea = All;
                    Style = Attention;
                    ToolTip = 'Specifies external system notes';
                }
                field("Auto Sync"; Rec."Auto Sync")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies if record should be automatically synced';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SyncToBc)
            {
                Caption = 'Sync to Business Central';
                ApplicationArea = All;
                Image = Approve;
                ToolTip = 'Synchronizes the selected record to Business Central';

                trigger OnAction()
                var
                    SyncManager: Codeunit "GDRG Sync Manager";
                begin
                    SyncManager.SyncToBusinessCentral(Rec);
                    CurrPage.Update();
                end;
            }
            action(ForceError)
            {
                Caption = 'Force Error (Demo)';
                ApplicationArea = All;
                Image = Error;
                ToolTip = 'Forces an error by setting invalid data for demonstration';

                trigger OnAction()
                var
                    SyncManager: Codeunit "GDRG Sync Manager";
                begin
                    // Force error by setting invalid Category Code
                    Rec."Category Code" := CopyStr('INVALID_CODE_FAIL', 1, 20);
                    Rec.Modify();

                    // Try to sync - this will fail and set Error status
                    SyncManager.SyncToBusinessCentral(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
}
