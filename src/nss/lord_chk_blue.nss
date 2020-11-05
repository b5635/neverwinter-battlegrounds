#include "inc_teams"

int StartingConditional()
{
    struct Teams stTeam = GetData();

    int nDifference = stTeam.blueHitDice - stTeam.redHitDice;

    if (nDifference < TEAM_MAX_DIFFERENCE)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
