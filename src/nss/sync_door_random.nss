#include "inc_constants"

void main()
{
    object oSession = GetObjectByTag(SESSION_TAG);

    int nEnd = GetLocalInt(oSession, "end");

    object oDoor1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(GetLocalString(OBJECT_SELF, "team")));
    object oDoor = GetLocalObject(oDoor1, "door");

    if (nEnd != 1 && GetIsObjectValid(oDoor))
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
