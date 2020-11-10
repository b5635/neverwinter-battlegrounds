#include "inc_player"
#include "inc_teams"

void main()
{
    object oPC = GetEnteringObject();

    if (GetIsPC(oPC))
    {
        DetermineGold(oPC);
        ExploreAreaForPlayer(OBJECT_SELF, oPC, TRUE);
        SetTeamFaction(oPC);
    }
}
