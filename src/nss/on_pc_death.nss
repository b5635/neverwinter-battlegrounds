#include "inc_constants"
#include "inc_sessions"

void DoRespawn(object oPC)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), GetLocation(oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ForceRest(oPC);
    AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag("WP_START_"+GetStringUpperCase(GetLocalString(oPC, "team"))))));
}

void main()
{
    object oPC = GetLastPlayerDied();

    DetermineKillPoints(oPC);

    DelayCommand(IntToFloat(RESPAWN_TIME), DoRespawn(oPC));

    object oSession = GetObjectByTag(SESSION_TAG);

    string sTeam = GetLocalString(oPC, "team");

    object oHenchman = GetFirstObjectInArea(oSession);

    while (GetIsObjectValid(oHenchman))
    {
        if (GetLocalString(oHenchman, "team") == sTeam)
        {
            RemoveHenchman(oPC, oHenchman);
        }

        oHenchman = GetNextObjectInArea(oSession);
    }
}