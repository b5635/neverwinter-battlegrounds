#include "inc_constants"

struct Teams
{
    int redTeam;
    int redHitDice;
    int blueTeam;
    int blueHitDice;
};

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

    TeamHash.redTeam = nRedCount;
    TeamHash.redHitDice = nRedHitDice;
    TeamHash.blueTeam = nBlueCount;
    TeamHash.blueHitDice = nBlueHitDice;

    return TeamHash;
}

//void main() {}
