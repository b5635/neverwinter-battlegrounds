#include "nwnx_events"

void main()
{
    object oPC = GetEnteringObject();

// Do this only for PCs
    if (!GetIsPC(oPC)) return;

    SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "on_pc_damaged");


// If the PC has less than the starting XP, then do this.
// Safe to assume a non-new character in this way.
    if (GetXP(oPC) < 21000)
    {
        SetXP(oPC, 21000);

        int nSlot;

        // Destroy the items in the main inventory.
        object oItem = GetFirstItemInInventory(oPC);
        while ( oItem != OBJECT_INVALID ) {
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oPC);
        }
        // Destroy equipped items.
        for ( nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot )
            DestroyObject(GetItemInSlot(nSlot, oPC));

        // Remove all gold.
        AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));
    }
}
