#include "inc_sessions"
#include "inc_teams"
#include "inc_player"

void main()
{
    ExportAllCharacters();

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
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        SetTeamFaction(oPC);

        string sResRef = GetResRef(GetArea(oPC));

        if (sResRef == "_system" || sResRef == "_choice") DetermineGold(oPC);

        oPC = GetNextPC();
    }
}
