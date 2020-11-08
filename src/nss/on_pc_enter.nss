#include "nwnx_events"
#include "inc_constants"

void RemoveAllItemProperties(object oItem)
{
      itemproperty ipProperty = GetFirstItemProperty(oItem);

      while (GetIsItemPropertyValid(ipProperty))
      {
          RemoveItemProperty(oItem, ipProperty);
          ipProperty = GetNextItemProperty(oItem);
      }
}

// This function sychronizes the player's item with the what is available in the module.
void SyncItem(object oItem, object oPC)
{
    if (!GetIsObjectValid(oItem)) return;

    object oModuleItem = GetItemPossessedBy(GetObjectByTag(ITEM_CHECK_TAG+IntToString(GetBaseItemType(oItem))), GetTag(oItem));
    string sName = GetName(oItem);

    if (!GetIsObjectValid(oModuleItem) && FindSubString(sName, "(defunct)") == -1)
    {
        SendMessageToPC(oPC, GetName(oItem)+" is now defunct because it no longer exists in the module.");
        RemoveAllItemProperties(oItem);
        SetTag(oItem, "defunct");
        SetName(oItem, sName+" (defunct)");
    }
    else
    {
        itemproperty ipModuleProperty = GetFirstItemProperty(oModuleItem);
        itemproperty ipProperty = GetFirstItemProperty(oItem);
        int nMatch = TRUE;

        while (GetIsItemPropertyValid(ipProperty))
        {
            if (nMatch == TRUE && ipModuleProperty != ipProperty)
            {
                nMatch = FALSE;
                break;
            }
            ipModuleProperty = GetNextItemProperty(oModuleItem);
            ipProperty = GetNextItemProperty(oItem);
        }

// delete all item properties if there isn't a match, and re-add properties from the module item
        if (nMatch == FALSE)
        {
            RemoveAllItemProperties(oItem);
            ipModuleProperty = GetFirstItemProperty(oModuleItem);

            while (GetIsItemPropertyValid(ipModuleProperty))
            {
                AddItemProperty(DURATION_TYPE_PERMANENT, ipModuleProperty, oItem);
                ipModuleProperty = GetNextItemProperty(oModuleItem);
            }
        }
    }
}

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
        while (oItem != OBJECT_INVALID) {
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oPC);
        }
        // Destroy equipped items.
        for ( nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot )
            DestroyObject(GetItemInSlot(nSlot, oPC));

        // Remove all gold.
        AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));
    }
    else
    {
        object oItem = GetFirstItemInInventory(oPC);
        while (oItem != OBJECT_INVALID)
        {
            SyncItem(oItem, oPC);
            oItem = GetNextItemInInventory(oPC);
        }

        int nSlot;
        for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot)
            SyncItem(GetItemInSlot(nSlot, oPC), oPC);

    }
}
