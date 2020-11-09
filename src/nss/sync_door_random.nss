void main()
{
    object oDoor1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(GetLocalString(OBJECT_SELF, "team")));
    object oDoor = GetLocalObject(oDoor1, "door");

    if (GetIsObjectValid(oDoor))
    {
        SetTransitionTarget(OBJECT_SELF, OBJECT_SELF);
        SetLocked(OBJECT_SELF, FALSE);
        if (!GetIsOpen(OBJECT_SELF)) ActionOpenDoor(OBJECT_SELF);
    }
    else
    {
        SetLocked(OBJECT_SELF, TRUE);
        if (GetIsOpen(OBJECT_SELF)) ActionCloseDoor(OBJECT_SELF);
    }
}
