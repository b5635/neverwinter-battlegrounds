#include "x2_inc_itemprop"
#include "inc_constants"

const string TREASURE_MELEE_SEED_CHEST = "melee_seed";
const string TREASURE_RANGE_SEED_CHEST = "range_seed";

// This function determines the AC from the armor given
int GetBaseArmorAC(object oArmor)
{
  return
  StringToInt
  (
    Get2DAString
    (
      "parts_chest",
      "ACBONUS",
      GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_TORSO)
    )
  );
}

void CopyItemToStore(object oItem, string sTag)
{
    location lStaging = Location(GetObjectByTag("_seed"), Vector(), 0.0);
    object oStore = GetObjectByTag(sTag);
    if (!GetIsObjectValid(oStore)) oStore = CreateObject(OBJECT_TYPE_STORE, "mer_template", lStaging, FALSE, sTag);

    SetTag(oItem, GetName(oItem));

    CopyItem(oItem, GetObjectByTag(ITEM_CHECK_TAG+IntToString(GetBaseItemType(oItem))));
    object oNewItem = CopyItem(oItem, oStore);
    SetInfiniteFlag(oNewItem, TRUE);
}

void DistributeItem(object oItem, string sString = "")
{
    string sResRef = GetResRef(oItem);
    int nItemType = GetBaseItemType(oItem);

    if (sString != "") sResRef = sString;

    SetIdentified(oItem, TRUE);

    if (GetGoldPieceValue(oItem) > 22000) return;

    if (GetStringLeft(sResRef, 6) == "weapon")
    {
        switch (nItemType)
        {
            case BASE_ITEM_BASTARDSWORD: CopyItemToStore(oItem, "mer_bastardswords"); break;
            case BASE_ITEM_BATTLEAXE: CopyItemToStore(oItem, "mer_battleaxes"); break;
            case BASE_ITEM_CLUB: CopyItemToStore(oItem, "mer_clubs"); break;
            case BASE_ITEM_DAGGER: CopyItemToStore(oItem, "mer_daggers"); break;
            case BASE_ITEM_DIREMACE: CopyItemToStore(oItem, "mer_diremaces"); break;
            case BASE_ITEM_DOUBLEAXE: CopyItemToStore(oItem, "mer_doubleaxes"); break;
            case BASE_ITEM_DWARVENWARAXE: CopyItemToStore(oItem, "mer_waraxes"); break;
            case BASE_ITEM_GREATAXE: CopyItemToStore(oItem, "mer_greataxes"); break;
            case BASE_ITEM_GREATSWORD: CopyItemToStore(oItem, "mer_greatswords"); break;
            case BASE_ITEM_HALBERD: CopyItemToStore(oItem, "mer_halberds"); break;
            case BASE_ITEM_HANDAXE: CopyItemToStore(oItem, "mer_handaxes"); break;
            case BASE_ITEM_HEAVYCROSSBOW: CopyItemToStore(oItem, "mer_heavycrossbows"); break;
            case BASE_ITEM_HEAVYFLAIL: CopyItemToStore(oItem, "mer_heavyflails"); break;
            case BASE_ITEM_KAMA: CopyItemToStore(oItem, "mer_kamas"); break;
            case BASE_ITEM_KATANA: CopyItemToStore(oItem, "mer_katanas"); break;
            case BASE_ITEM_KUKRI: CopyItemToStore(oItem, "mer_kukris"); break;
            case BASE_ITEM_LIGHTCROSSBOW: CopyItemToStore(oItem, "mer_lightcrossbows"); break;
            case BASE_ITEM_LIGHTFLAIL: CopyItemToStore(oItem, "mer_lightflails"); break;
            case BASE_ITEM_LIGHTHAMMER: CopyItemToStore(oItem, "mer_lighthammers"); break;
            case BASE_ITEM_LIGHTMACE: CopyItemToStore(oItem, "mer_lightmaces"); break;
            case BASE_ITEM_LONGBOW: CopyItemToStore(oItem, "mer_longbows"); break;
            case BASE_ITEM_LONGSWORD: CopyItemToStore(oItem, "mer_longswords"); break;
            case BASE_ITEM_MORNINGSTAR: CopyItemToStore(oItem, "mer_morningstars"); break;
            case BASE_ITEM_QUARTERSTAFF: CopyItemToStore(oItem, "mer_quarterstaves"); break;
            case BASE_ITEM_RAPIER: CopyItemToStore(oItem, "mer_rapiers"); break;
            case BASE_ITEM_SCIMITAR: CopyItemToStore(oItem,"mer_scythes"); break;
            case BASE_ITEM_SHORTBOW: CopyItemToStore(oItem, "mer_shortbows"); break;
            case BASE_ITEM_SHORTSPEAR: CopyItemToStore(oItem, "mer_spears"); break;
            case BASE_ITEM_SHORTSWORD: CopyItemToStore(oItem, "mer_shortswords"); break;
            case BASE_ITEM_SICKLE: CopyItemToStore(oItem, "mer_sickles"); break;
            case BASE_ITEM_SLING: CopyItemToStore(oItem, "mer_slings"); break;
            case BASE_ITEM_TRIDENT: CopyItemToStore(oItem, "mer_tridents"); break;
            case BASE_ITEM_TWOBLADEDSWORD: CopyItemToStore(oItem, "mer_twobladedswords"); break;
            case BASE_ITEM_WARHAMMER: CopyItemToStore(oItem, "mer_warhammers"); break;
            case BASE_ITEM_WHIP: CopyItemToStore(oItem, "mer_whips"); break;
            case BASE_ITEM_GLOVES: CopyItemToStore(oItem, "mer_monkgloves"); break;
            case BASE_ITEM_MISCMEDIUM:
            break;
        }
    }
    else if (GetStringLeft(sResRef, 5) == "armor")
    {
        switch (nItemType)
        {
            case BASE_ITEM_LARGESHIELD: CopyItemToStore(oItem, "mer_largeshields"); break;
            case BASE_ITEM_SMALLSHIELD: CopyItemToStore(oItem, "mer_smallshields"); break;
            case BASE_ITEM_TOWERSHIELD: CopyItemToStore(oItem, "mer_towershields"); break;
            case BASE_ITEM_ARMOR:
                switch (GetBaseArmorAC(oItem))
                {
                case 0: CopyItemToStore(oItem, "mer_clothing"); break;
                case 1:
                case 2:
                case 3: CopyItemToStore(oItem, "mer_lightarmor"); break;
                case 4:
                case 5: CopyItemToStore(oItem, "mer_mediumarmor"); break;
                case 6:
                case 7:
                case 8: CopyItemToStore(oItem, "mer_heavyarmor"); break;
                }
            break;
            case BASE_ITEM_HELMET:
                CopyItemToStore(oItem, "mer_helmets");
            break;
        }
    }
    else if (GetStringLeft(sResRef, 7) == "apparel")
    {
        switch (nItemType)
        {
            case BASE_ITEM_AMULET: CopyItemToStore(oItem, "mer_amulets"); break;
            case BASE_ITEM_BOOTS: CopyItemToStore(oItem, "mer_boots"); break;
            case BASE_ITEM_BRACER: CopyItemToStore(oItem, "mer_bracers"); break;
            case BASE_ITEM_BELT: CopyItemToStore(oItem, "mer_belts"); break;
            case BASE_ITEM_CLOAK: CopyItemToStore(oItem, "mer_cloaks"); break;
            case BASE_ITEM_RING: CopyItemToStore(oItem, "mer_rings"); break;
            case BASE_ITEM_GLOVES: CopyItemToStore(oItem, "mer_gloves"); break;
        }
    }
    else if (GetStringLeft(sResRef, 4) == "misc")
    {
        CopyItemToStore(oItem, "mer_misc");
    }
}

void CreateTypeLoot(string sType)
{
    int nIndex;
    object oItem;

    location lStaging = Location(GetObjectByTag("_seed"), Vector(), 0.0);

    for (nIndex = 1; nIndex < 300; nIndex++)
    {
       oItem = CreateObject(OBJECT_TYPE_ITEM, sType+IntToString(nIndex), lStaging);

       DistributeItem(oItem);
    }
}

object ChangeSpecialWeapon(object oItem, int nTopModel, int nTopColor)
{
     int nBaseType = GetBaseItemType(oItem);

     string sSimpleModel, sSimpleColor, sCombinedModel;

     sSimpleModel = IntToString(nTopModel);
     sSimpleColor = IntToString(nTopColor);

     if (sSimpleModel == "0") sSimpleModel = "1";
     if (sSimpleColor == "0") sSimpleColor = "1";

// Fix for out of bounds number for these item types.
     if ((nBaseType == BASE_ITEM_DART || nBaseType == BASE_ITEM_SHURIKEN) && sSimpleColor == "4") sSimpleColor = "1";

     sCombinedModel = sSimpleModel+sSimpleColor;
     object oRet = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, StringToInt(sCombinedModel), TRUE);
     DestroyObject(oItem);

     return oRet;
}

object DyeWeaponColor(object oItem, int nColorType, int nColor)
{
        int nBaseType = GetBaseItemType(oItem);

        object oRet;
        if (nBaseType != BASE_ITEM_WHIP) // Whips do not have alternative colors
        {
          oRet = CopyItemAndModify(oItem,ITEM_APPR_TYPE_WEAPON_COLOR,nColorType,nColor,TRUE);
          DestroyObject(oItem); // remove old item
        }
        else
        {
          oRet = oItem;
        }
        return oRet; //return new item
}

object ChangeWeaponModel(object oItem, int nModelType, int nModel)
{
        int nBaseType = GetBaseItemType(oItem);
        object oRet;

        switch (nBaseType)
        {
            // These items do not have any other model, so do not change them.
            case BASE_ITEM_WHIP:
            case BASE_ITEM_KUKRI:
            case BASE_ITEM_SICKLE:
            case BASE_ITEM_KAMA:
            {
               oRet = oItem;
               break;
            }
            default:
            {
               oRet = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nModelType, nModel, TRUE);
               DestroyObject(oItem); // remove old item
               break;
            }
        }
        return oRet; //return new item
}


//
// ------------------------------------------
// This is the function that will populate a
// a melee or range loot chest. Should not be
// used with other item types!
// ------------------------------------------
//

void PopulateChestWeapon(string sSeedChestTag, string sPrependName, string sAppendName, string sDescription, int nTopModel, int nMiddleModel, int nBottomModel, int nTopColor, int nMiddleColor, int nBottomColor, itemproperty ipProp1, itemproperty ipProp2, itemproperty ipProp3)
{
   object oSeedChest = GetObjectByTag(sSeedChestTag);
   object oItem = GetFirstItemInInventory(oSeedChest);
   object oNewItemStaging;
   string sOldName;

   location lStaging = Location(GetObjectByTag("_seed"), Vector(), 0.0);

// if it matches this item prop, skip it
   itemproperty ipInvalidItemProp = ItemPropertyNoDamage();

   while (GetIsObjectValid(oItem))
   {
// Get the current name of the item ex: "Longsword"
       sOldName = GetName(oItem);

// Copy the item, but for now put it in a modding area
       oNewItemStaging = CopyObject(oItem, lStaging);

// Modify the appearance. If 0, leave unchanged.
       int nBaseType = GetBaseItemType(oNewItemStaging);

       if (nTopModel != 0) oNewItemStaging = ChangeWeaponModel(oNewItemStaging, ITEM_APPR_WEAPON_MODEL_TOP, nTopModel);
       if (nMiddleModel != 0) oNewItemStaging = ChangeWeaponModel(oNewItemStaging, ITEM_APPR_WEAPON_MODEL_MIDDLE, nMiddleModel);
       if (nBottomModel != 0) oNewItemStaging = ChangeWeaponModel(oNewItemStaging, ITEM_APPR_WEAPON_MODEL_BOTTOM, nBottomModel);

// Do the same for colors.
       if (nTopColor != 0) oNewItemStaging = DyeWeaponColor(oNewItemStaging, ITEM_APPR_WEAPON_COLOR_TOP, nTopColor);
       if (nMiddleColor != 0) oNewItemStaging = DyeWeaponColor(oNewItemStaging, ITEM_APPR_WEAPON_COLOR_MIDDLE, nMiddleColor);
       if (nBottomColor != 0) oNewItemStaging = DyeWeaponColor(oNewItemStaging, ITEM_APPR_WEAPON_COLOR_BOTTOM, nBottomColor);

// Add item property, if the arg is there.
       if (GetItemPropertyType(ipProp1) != GetItemPropertyType(ipInvalidItemProp)) AddItemProperty(DURATION_TYPE_PERMANENT, ipProp1, oNewItemStaging);
       if (GetItemPropertyType(ipProp2) != GetItemPropertyType(ipInvalidItemProp)) AddItemProperty(DURATION_TYPE_PERMANENT, ipProp2, oNewItemStaging);
       if (GetItemPropertyType(ipProp3) != GetItemPropertyType(ipInvalidItemProp)) AddItemProperty(DURATION_TYPE_PERMANENT, ipProp3, oNewItemStaging);

       SetDescription(oNewItemStaging, sDescription);
       SetName(oNewItemStaging, sPrependName+sOldName+sAppendName); // set given name

       DistributeItem(oNewItemStaging, "weapon");

       oItem = GetNextItemInInventory(oSeedChest);
   }
}

void PopulateChestArmor(string sSeedChestTag, string sPrependName, string sAppendName, string sDescription, int nCloth1, int nCloth2, int nLeather1, int nLeather2, int nMetal1, int nMetal2, int nShoulder, int nForeArm, itemproperty ipProp1, itemproperty ipProp2, itemproperty ipProp3)
{

   object oSeedChest = GetObjectByTag(sSeedChestTag);
   object oItem = GetFirstItemInInventory(oSeedChest);
   object oNewItemStaging;
   string sOldName;

   location lStaging = Location(GetObjectByTag("_seed"), Vector(), 0.0);

   itemproperty ipInvalidItemProp = ItemPropertyNoDamage(); // if it matches this item prop, skip it

   while (GetIsObjectValid(oItem))
   {
// Get the current name of the item ex: "Leather Armor"
       sOldName = GetName(oItem);

// Copy the item, but for now put it in a modding area.
       oNewItemStaging = CopyObject(oItem, lStaging);

// Modify the appearance. If 0, leave unchanged.
       if (nCloth1 != 0) oNewItemStaging = IPDyeArmor(oNewItemStaging, ITEM_APPR_ARMOR_COLOR_CLOTH1, nCloth1);
       if (nCloth2 != 0) oNewItemStaging = IPDyeArmor(oNewItemStaging, ITEM_APPR_ARMOR_COLOR_CLOTH2, nCloth2);
       if (nLeather1 != 0) oNewItemStaging = IPDyeArmor(oNewItemStaging, ITEM_APPR_ARMOR_COLOR_LEATHER1, nLeather1);
       if (nLeather2 != 0) oNewItemStaging = IPDyeArmor(oNewItemStaging, ITEM_APPR_ARMOR_COLOR_LEATHER2, nLeather2);
       if (nMetal1 != 0) oNewItemStaging = IPDyeArmor(oNewItemStaging, ITEM_APPR_ARMOR_COLOR_METAL1, nMetal1);
       if (nMetal2 != 0) oNewItemStaging = IPDyeArmor(oNewItemStaging, ITEM_APPR_ARMOR_COLOR_METAL2, nMetal2);

// Add item property, if the arg is there.
       if (GetItemPropertyType(ipProp1) != GetItemPropertyType(ipInvalidItemProp)) AddItemProperty(DURATION_TYPE_PERMANENT, ipProp1, oNewItemStaging);
       if (GetItemPropertyType(ipProp2) != GetItemPropertyType(ipInvalidItemProp)) AddItemProperty(DURATION_TYPE_PERMANENT, ipProp2, oNewItemStaging);
       if (GetItemPropertyType(ipProp3) != GetItemPropertyType(ipInvalidItemProp)) AddItemProperty(DURATION_TYPE_PERMANENT, ipProp3, oNewItemStaging);

       SetDescription(oNewItemStaging, sDescription);
       SetName(oNewItemStaging, sPrependName+sOldName+sAppendName);

       DistributeItem(oNewItemStaging, "armor");

       oItem = GetNextItemInInventory(oSeedChest);
   }

}

void main()
{
    location lSystem = Location(GetObjectByTag("_system"), Vector(), 0.0);

    int i;
    for (i = 0; i < 150; i++)
    {
        CreateObject(OBJECT_TYPE_CREATURE, ITEM_CHECK_TAG, lSystem, FALSE, ITEM_CHECK_TAG+IntToString(i));
    }



// ==============================================
//  START TREASURE
// ==============================================

   location lStaging = Location(GetObjectByTag("_seed"), Vector(), 0.0);

   object oApparel = CreateObject(OBJECT_TYPE_STORE, "mer_template", lStaging, FALSE, "mer_apparel");
   object oMisc = CreateObject(OBJECT_TYPE_STORE, "mer_template", lStaging, FALSE, "mer_misc");
   object oWeapon = CreateObject(OBJECT_TYPE_STORE, "mer_template", lStaging, FALSE, "mer_weapon");
   object oArmor = CreateObject(OBJECT_TYPE_STORE, "mer_template", lStaging, FALSE, "mer_armor");
   object oShield = CreateObject(OBJECT_TYPE_STORE, "mer_template", lStaging, FALSE, "mer_shield");

// grab items from palette
   CreateTypeLoot("apparel");
   CreateTypeLoot("misc");
   CreateTypeLoot("weapon");
   CreateTypeLoot("armor");

// ==============================================
//  ARMORS
// ==============================================

// +1, +2, +3 armors
   string sEnchantedArmor = "This magic armor grants additional protection to its wearer, but it doesn't bear the hallmarks of any specific maker.";

   PopulateChestArmor("armor_seed", "", " +1", sEnchantedArmor, 15, 6, 51, 15, 18, 19, 0, 0, ItemPropertyACBonus(1), ItemPropertyNoDamage(), ItemPropertyNoDamage());
   PopulateChestArmor("armor_seed", "", " +2", sEnchantedArmor, 15, 7, 7, 15, 10, 17, 0, 0, ItemPropertyACBonus(2), ItemPropertyNoDamage(), ItemPropertyNoDamage());
   PopulateChestArmor("armor_seed", "", " +3", sEnchantedArmor, 46, 23, 23, 46, 3, 39, 0, 0, ItemPropertyACBonus(3), ItemPropertyNoDamage(), ItemPropertyNoDamage());
   WriteTimestampedLogEntry("Armors created");

// ------------------------------------------
// Melee weapons
// ------------------------------------------

// +1, +2, and +3 melee weapons
   string sEnchanted = "This magic weapon has an enhancement bonus to attack and damage, but it doesn't bear the hallmarks of any specific maker.";

   PopulateChestWeapon(TREASURE_MELEE_SEED_CHEST, "", " +1", sEnchanted, 2, 0, 0, 3, 3, 3, ItemPropertyEnhancementBonus(1), ItemPropertyNoDamage(), ItemPropertyNoDamage());
   PopulateChestWeapon(TREASURE_MELEE_SEED_CHEST, "", " +2", sEnchanted, 3, 0, 0, 2, 2, 2, ItemPropertyEnhancementBonus(2), ItemPropertyNoDamage(), ItemPropertyNoDamage());
   PopulateChestWeapon(TREASURE_MELEE_SEED_CHEST, "", " +3", sEnchanted, 1, 3, 2, 4, 1, 4, ItemPropertyEnhancementBonus(3), ItemPropertyNoDamage(), ItemPropertyNoDamage());

   string sColdIron = "A series of these weapons were constructed for the defense of the library fortress of Candlekeep some 200 years ago. The keep had acquired a tome detailing the imprisonment of the pit fiend Aegatohl, and a score of malevolent creatures came to claim it. A small horde was held at bay by the Knights of the Mailed Fist, along with the unexpected assistance of Devon's Privateers, a group of pirates. The tome was later destroyed.";

   PopulateChestWeapon(TREASURE_MELEE_SEED_CHEST, "Cold Iron ", "", sColdIron, 2, 2, 2, 1, 1, 1, ItemPropertyAttackBonus(1), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6), ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 1));
   WriteTimestampedLogEntry("Melee weapons created");
// ------------------------------------------
// Range weapons
// ------------------------------------------

   string sCompositeEnchanted = "This magic weapon has a bonus to attack. As well, it allows the wielder to add part of their strength modifier to the damage dealt.";

// +1, +2, and +3
   PopulateChestWeapon(TREASURE_RANGE_SEED_CHEST, "Composite ", " +1", sCompositeEnchanted, 2, 3, 4, 3, 3, 3, ItemPropertyAttackBonus(1), ItemPropertyMaxRangeStrengthMod(3), ItemPropertyNoDamage());
   PopulateChestWeapon(TREASURE_RANGE_SEED_CHEST, "Composite ", " +2", sCompositeEnchanted, 2, 3, 4, 2, 2, 2, ItemPropertyAttackBonus(2), ItemPropertyMaxRangeStrengthMod(4), ItemPropertyNoDamage());
   PopulateChestWeapon(TREASURE_RANGE_SEED_CHEST, "Composite ", " +3", sCompositeEnchanted, 2, 3, 4, 4, 4, 4, ItemPropertyAttackBonus(3), ItemPropertyMaxRangeStrengthMod(5), ItemPropertyNoDamage());

   WriteTimestampedLogEntry("Range weapons created");

// delete creatures that do not have any items to check
    object oItemCheck;
    for (i = 0; i < 150; i++)
    {
        oItemCheck = GetObjectByTag(ITEM_CHECK_TAG+IntToString(i));
        if (!GetIsObjectValid(GetFirstItemInInventory(oItemCheck))) DestroyObject(oItemCheck);
    }

   WriteTimestampedLogEntry("Seed finished");
}
