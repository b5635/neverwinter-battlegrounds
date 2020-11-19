#include "inc_constants"
#include "inc_sessions"
#include "inc_general"
//#include "nwnx_object"

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

    //object oBloodstain = CreateObject(OBJECT_TYPE_PLACEABLE, "_bloodstain", GetLocation(oPC));
    //NWNX_Object_SetPlaceableIsStatic(oBloodstain, TRUE);

    DeleteLocalInt(oPC, "last_attacker_level");
    DeleteLocalString(oPC, "last_attacker_name");
    DeleteLocalString(oPC, "last_attacker_team");
    DeleteLocalObject(oPC, "last_attacker");

    Gibs(oPC);

    DetermineKillPoints(oPC);

    DelayCommand(IntToFloat(RESPAWN_TIME), DoRespawn(oPC));

    object oSession = GetObjectByTag(SESSION_TAG);
    string sTeam = GetLocalString(oPC, "team");
    object oHenchman = GetFirstObjectInArea(oSession);

    while (GetIsObjectValid(oHenchman))
    {
        if (GetLocalString(oHenchman, "team") == sTeam)
            RemoveHenchman(oPC, oHenchman);

        oHenchman = GetNextObjectInArea(oSession);
    }
}
