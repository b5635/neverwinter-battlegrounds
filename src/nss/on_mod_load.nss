#include "x3_inc_string"
#include "inc_constants"
#include "nwnx_area"
#include "nwnx_util"
#include "nwnx_admin"
#include "nwnx_events"

void InitializeBase(string sTeam, int nColor)
{
    object oArea = CreateArea("_base", "BASE_"+GetStringUpperCase(sTeam), sTeam+" Base");

    object oObject = GetFirstObjectInArea(oArea);

    string sTag;
    while (GetIsObjectValid(oObject))
    {
        sTag = GetTag(oObject);
        if (sTag != "") SetTag(oObject, StringReplace(sTag, "NONE", GetStringUpperCase(sTeam)));

        oObject = GetNextObjectInArea(oArea);
    }

    NWNX_Area_SetSunMoonColors(oArea, NWNX_AREA_COLOR_TYPE_MOON_AMBIENT, nColor);
    NWNX_Area_SetSunMoonColors(oArea, NWNX_AREA_COLOR_TYPE_SUN_AMBIENT, nColor);
}

void main()
{
// No player should be able to login.
    NWNX_Administration_SetPlayerPassword(GetRandomUUID());

// Set a very high instruction limit so we can run the initialization scripts without TMI
    NWNX_Util_SetInstructionLimit(52428888);

    ExecuteScript("generate_items");

    InitializeBase(TEAM_BLUE, FOG_COLOR_BLUE);
    InitializeBase(TEAM_RED, FOG_COLOR_RED);

    DestroyArea(GetObjectByTag("_BASE"));

    NWNX_Util_SetInstructionLimit(-1);

// This script makes players always start at "The Choice"
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "on_elc_validateb");

// We must skip this if polymorphed or bartering.
    NWNX_Events_SubscribeEvent("NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE", "on_pc_save");


// Following actions are not allowed under any circumstance
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_CHANGE_DIFFICULTY_BEFORE", "dm_never");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_FACTION_BEFORE", "dm_never");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_FACTION_REPUTATION_BEFORE", "dm_never");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_TIME_BEFORE", "dm_never");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_DATE_BEFORE", "dm_never");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_STAT_BEFORE", "dm_never");

// Following DM events are not allowed except by developer
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_CHANGE_DIFFICULTY_BEFORE", "dm_chk_dev");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_ITEM_BEFORE", "dm_chk_dev");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_GOLD_BEFORE", "dm_chk_dev");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_XP_BEFORE", "dm_chk_dev");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_LEVEL_BEFORE", "dm_chk_dev");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_ALIGNMENT_BEFORE", "dm_chk_dev");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SET_VARIABLE_BEFORE", "dm_chk_dev");

// Following actions will not work on dm_immune objects (merchants or quests)
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_KILL_BEFORE", "dm_chk_actions");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_TOGGLE_INVULNERABLE_BEFORE", "dm_chk_actions");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_LIMBO_BEFORE", "dm_chk_actions");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_TOGGLE_AI_BEFORE", "dm_chk_actions");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_TOGGLE_IMMORTAL_BEFORE", "dm_chk_actions");

// Now player should be able to login.
    NWNX_Administration_ClearPlayerPassword();
}
