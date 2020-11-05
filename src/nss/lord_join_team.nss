#include "inc_teams"

void main()
{
    object oPC = GetPCSpeaker();

    string sTeam = GetScriptParam("team");

    struct Teams stTeam = GetData();


    int nDifference;
    if (sTeam == "Blue")
    {
        nDifference = stTeam.blueHitDice - stTeam.redHitDice;
    }
    else
    {
        nDifference = stTeam.redHitDice - stTeam.blueHitDice;
    }

    if (nDifference < TEAM_MAX_DIFFERENCE)
    {
        SetLocalString(oPC, "team", sTeam);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), GetLocation(oPC));
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag("WP_START_"+GetStringUpperCase(sTeam))))));
    }
    else
    {
        SendMessageToPC(oPC, "You cannot join the "+sTeam+" because it will be imbalanced.");
    }
}
