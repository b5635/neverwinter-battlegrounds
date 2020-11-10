#include "inc_sessions"

void main()
{
    object oSession = GetObjectByTag(SESSION_TAG);

    if (!GetIsObjectValid(oSession))
    {
        int nCount = GetLocalInt(OBJECT_SELF, "session_count");

        if (nCount >= SESSION_COUNT)
        {
            DeleteLocalInt(OBJECT_SELF, "session_count");
            StartSession();
        }
        else
        {
            SetLocalInt(OBJECT_SELF, "session_count", nCount+1);
        }
    }
}
