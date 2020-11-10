#include "inc_constants"

void DetermineGold(object oPC)
{
    int nMaxGold = GetXP(oPC);

    int nCurrentGold = GetGold(oPC);
    int nItemGold;

    object oItem = GetFirstItemInInventory(oPC);
    while (oItem != OBJECT_INVALID) {
        SetIdentified(oItem, TRUE);
        nItemGold = nItemGold + GetGoldPieceValue(oItem);
        oItem = GetNextItemInInventory(oPC);
    }

    int nSlot;
    object oItemInSlot;
    for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot )
    {
        oItemInSlot = GetItemInSlot(nSlot, oPC);
        if (GetIsObjectValid(oItemInSlot)) nItemGold = nItemGold + GetGoldPieceValue(oItemInSlot);
    }

// Now add up all the gold calculated from items.
   nCurrentGold = nCurrentGold + nItemGold;

   int nDifference = nMaxGold - nCurrentGold;

// Add or subtract gold if over this amount.
   if (nDifference < 0) TakeGoldFromCreature(nDifference, oPC, TRUE);
   if (nDifference > 0) GiveGoldToCreature(oPC, nDifference);

// Re-calculate the gold after the difference.
   nCurrentGold = GetGold(oPC);

   if (nCurrentGold > nMaxGold)
   {
        SendMessageToPC(oPC, "You have too much gold. You need to drop some gold or items to continue. Difference: "+IntToString(nDifference));
   }
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

//void main() {}
