#include "inc_player"

void main()
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        DetermineGold(oPC);
        oPC = GetNextPC();
    }
}
