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
                }
                field(Description; Rec.Description)
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Category Code"; Rec."Category Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("External ID"; Rec."External ID")
                {
                    Style = Attention;
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    Style = Attention;
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    Style = Attention;
                }
                field("External Notes"; Rec."External Notes")
                {
                    Style = Attention;
                }
                field("Auto Sync"; Rec."Auto Sync")
                {
                    Style = Strong;
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
                ToolTip = 'Sync to Business Central.';
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
                ToolTip = 'Force error for demo.';
                trigger OnAction()
                var
                    SyncManager: Codeunit "GDRG Sync Manager";
                begin
                    // Force error by setting invalid Category Code
                    Rec."Category Code" := CopyStr('INVALID_CODE_FAIL', 1, 20);
                    Rec.Modify(true);

                    // Try to sync - this will fail and set Error status
                    SyncManager.SyncToBusinessCentral(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
}
