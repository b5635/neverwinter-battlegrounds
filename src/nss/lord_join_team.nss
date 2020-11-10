#include "inc_teams"

void main()
{
    object oPC = GetPCSpeaker();

    if (GetScriptParam("object_self") == "1") oPC = OBJECT_SELF;

    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;

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
        JoinTeam(oPC, sTeam);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), GetLocation(oPC));
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag("WP_START_"+GetStringUpperCase(sTeam))))));
    }
    else
    {
        SendMessageToPC(oPC, "You cannot join the "+sTeam+" because it will be imbalanced.");
    }
}
