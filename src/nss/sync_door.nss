void main()
{
    object oDoor = GetLocalObject(OBJECT_SELF, "door");

    if (GetIsObjectValid(oDoor))
    {
        SetTransitionTarget(OBJECT_SELF, oDoor);
        SetLocked(OBJECT_SELF, FALSE);
        if (!GetIsOpen(OBJECT_SELF)) ActionOpenDoor(OBJECT_SELF);
    }
    else
    {
        SetLocked(OBJECT_SELF, TRUE);
        if (GetIsOpen(OBJECT_SELF)) ActionCloseDoor(OBJECT_SELF);
    }
}
