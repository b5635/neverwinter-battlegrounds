void main()
{
    object oClicker = GetClickingObject();

    object oDoor = OBJECT_SELF;

// Handle choosing a random spawn.
    if (FindSubString(GetTag(OBJECT_SELF), "SPAWNRANDOM") != -1)
    {
        int nRandom = d2();

        oDoor = GetObjectByTag("DOOR_SPAWN"+IntToString(nRandom)+"_"+GetStringUpperCase(GetLocalString(OBJECT_SELF, "team")));
    }

    object oTarget = GetTransitionTarget(oDoor);

    SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

    AssignCommand(oClicker,JumpToObject(oTarget));
}
