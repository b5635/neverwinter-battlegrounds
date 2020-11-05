#include "inc_teams"

int StartingConditional()
{
    struct Teams stTeam = GetData();

    int nDifference = stTeam.blueHitDice - stTeam.redHitDice;

    if (nDifference > TEAM_MAX_DIFFERENCE || nDifference < -TEAM_MAX_DIFFERENCE)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
