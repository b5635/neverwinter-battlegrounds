#include "inc_player"

void main()
{
    object oPC = GetEnteringObject();

    if (GetIsPC(oPC))
    {
        DetermineGold(oPC);
        ExploreAreaForPlayer(OBJECT_SELF, oPC, TRUE);
    }
}
