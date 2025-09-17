permissionset 50100 "GDRG Demo Perms"
{
    Assignable = true;
    Caption = 'GDRG Demo Perms', MaxLength = 30;

    Permissions =
        table "GDRG Product" = X,
        tabledata "GDRG Product" = RMID,
        table "GDRG Product Buffer" = X,
        tabledata "GDRG Product Buffer" = RMID,
        codeunit "GDRG Sync Manager" = X,
        page "GDRG Product List" = X,
        page "GDRG Product Buffer List" = X,
        page "GDRG Product API" = X;
}
