#include "inc_constants"

void main()
{
    object oSession = GetObjectByTag(SESSION_TAG);

    int nEnd = GetLocalInt(oSession, "end");

    object oDoor = GetLocalObject(OBJECT_SELF, "door");

    if (nEnd != 1 && GetIsObjectValid(oDoor))
    {
        SetTransitionTarget(OBJECT_SELF, oDoor);
        SetLocked(OBJECT_SELF, FALSE);
        if (!GetIsOpen(OBJECT_SELF)) ActionOpenDoor(OBJECT_SELF);
    }
    else
    {
        SetTransitionTarget(OBJECT_SELF, OBJECT_SELF);
        SetLocked(OBJECT_SELF, TRUE);
        if (GetIsOpen(OBJECT_SELF)) ActionCloseDoor(OBJECT_SELF);
    }
}
