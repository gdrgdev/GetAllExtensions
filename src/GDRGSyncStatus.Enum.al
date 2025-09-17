enum 50100 "GDRG Sync Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Synced)
    {
        Caption = 'Synced';
    }
    value(2; Error)
    {
        Caption = 'Error';
    }
    value(3; Deleted)
    {
        Caption = 'Deleted';
    }
}