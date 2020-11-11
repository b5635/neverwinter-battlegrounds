void main()
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        if (GetArea(oPC) == OBJECT_SELF)
        {
            AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag("WP_START_"+GetLocalString(oPC, "team")))));
        }

        oPC = GetNextPC();
    }

    if (GetLocalInt(OBJECT_SELF, "end") == 1) DestroyArea(OBJECT_SELF);
}
