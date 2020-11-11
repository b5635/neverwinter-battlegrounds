#include "inc_constants"
#include "util_i_color"

// int redCount, int redHitDice, int blueCount, int blueHitDice
struct Teams
{
    int redCount;
    int redHitDice;
    int blueCount;
    int blueHitDice;
};

// int redCount, int redHitDice, int blueCount, int blueHitDice
struct Teams GetData();
struct Teams GetData()
{
    struct Teams TeamHash;
    object oPC = GetFirstPC();

    int nRedCount = 0;
    int nRedHitDice = 0;
    int nBlueCount = 0;
    int nBlueHitDice = 0;

    string sTeam;

    while (GetIsObjectValid(oPC))
    {
        if (!GetIsDM(oPC))
        {
            sTeam = GetLocalString(oPC, "team");
            if (sTeam == TEAM_BLUE)
            {
                nBlueCount = nBlueCount + 1;
                nBlueHitDice = nBlueHitDice + GetHitDice(oPC);
            }
            else if (sTeam == TEAM_RED)
            {
                nRedCount = nRedCount + 1;
                nRedHitDice = nRedHitDice + GetHitDice(oPC);
            }
        }
        oPC = GetNextPC();
    }

    TeamHash.redCount = nRedCount;
    TeamHash.redHitDice = nRedHitDice;
    TeamHash.blueCount = nBlueCount;
    TeamHash.blueHitDice = nBlueHitDice;

    return TeamHash;
}

// Wrapper function for getting the player or bot.
// If the target isn't a player, we will retrieve the master instead.
// This whole thing simply checks for the "team" local.
// This is typically used for tracking the last attacker/killer.
object GetPlayer(object oPC = OBJECT_SELF);
object GetPlayer(object oPC = OBJECT_SELF)
{
    string sTeam = GetLocalString(oPC, "team");

    if (sTeam != TEAM_BLUE && sTeam != TEAM_RED)
    {
        oPC = GetMaster(oPC);
        sTeam = GetLocalString(oPC, "team");

        if (sTeam != TEAM_BLUE && sTeam != TEAM_RED)
        {
            return OBJECT_INVALID;
        }
        else
        {
            return oPC;
        }
    }
    else
    {
        return oPC;
    }
}

void SetBotMaster(object oBot)
{
    if (GetIsObjectValid(GetMaster(oBot))) return;

    string sTeam = GetLocalString(oBot, "team");

    object oPC = GetFirstPC();
    object oArea = GetArea(oBot);

    while (GetIsObjectValid(oPC))
    {
        if (!GetIsDead(oPC) && GetArea(oPC) == oArea && GetLocalString(oPC, "team") == sTeam)
        {
            AddHenchman(oPC, oBot);
            break;
        }

        oPC = GetNextPC();
    }
}

// Puts the creature into the correct faction
void SetTeamFaction(object oCreature);
void SetTeamFaction(object oCreature)
{
    string sTeam = GetLocalString(oCreature, "team");

    if (sTeam == TEAM_BLUE)
    {
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, oCreature);
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 0, oCreature);
        if (!GetIsObjectValid(GetMaster(oCreature))) ChangeToStandardFaction(oCreature, STANDARD_FACTION_DEFENDER);
    }
    else if (sTeam == TEAM_RED)
    {
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 0, oCreature);
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 100, oCreature);
        if (!GetIsObjectValid(GetMaster(oCreature))) ChangeToStandardFaction(oCreature, STANDARD_FACTION_MERCHANT);
    }

    if (!GetIsPC(oCreature)) SetBotMaster(oCreature);
}

// Makes the creature join the specified team.
void JoinTeam(object oCreature, string sTeam);
void JoinTeam(object oCreature, string sTeam)
{
    SetLocalString(oCreature, "team", sTeam);

    SetTeamFaction(oCreature);

    if (GetIsPC(oCreature))
    {
        string sTeamName = HexColorString("Blue Team!", COLOR_BLUE);
        if (sTeam == TEAM_RED) sTeamName = HexColorString("Red Team!", COLOR_RED);

        AssignCommand(GetModule(), SpeakString(HexColorString(GetName(oCreature)+" ("+IntToString(GetHitDice(oCreature))+")", COLOR_PURPLE)+" has joined the "+sTeamName, TALKVOLUME_SHOUT));
    }
}

// Stores information about the last attacker.
// Used for determining points, mainly on suicides and team kills.
void StoreLastAttacker(object oVictim, object oAttacker);
void StoreLastAttacker(object oVictim, object oAttacker)
{
    oAttacker = GetPlayer(oAttacker);

    if (!GetIsObjectValid(oAttacker)) return;

    string sVictimTeam = GetLocalString(oVictim, "team");
    string sAttackerTeam = GetLocalString(oAttacker, "team");

    if (sVictimTeam != sAttackerTeam)
    {
        SetLocalInt(oVictim, "last_attacker_level", GetHitDice(oAttacker));
        SetLocalString(oVictim, "last_attacker_name", GetName(oAttacker));
        SetLocalString(oVictim, "last_attacker_team", sAttackerTeam);
        SetLocalObject(oVictim, "last_attacker", oAttacker);
    }
}

//void main() {}
