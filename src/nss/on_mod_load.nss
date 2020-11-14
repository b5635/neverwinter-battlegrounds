#include "x3_inc_string"
#include "inc_constants"
#include "nwnx_area"
#include "nwnx_util"
#include "nwnx_admin"
#include "nwnx_events"
#include "util_i_csvlists"
#include "inc_nwnx"

void InitializeBase(string sTeam, int nColor)
{
    SetMaxHenchmen(999);

    object oArea = CreateArea("_base", "BASE_"+GetStringUpperCase(sTeam), sTeam+" Base");

    object oObject = GetFirstObjectInArea(oArea);

    string sTag;
    while (GetIsObjectValid(oObject))
    {
        sTag = GetTag(oObject);
        if (sTag != "") SetTag(oObject, StringReplace(sTag, "NONE", GetStringUpperCase(sTeam)));
        SetLocalString(oObject, "team", sTeam);

        oObject = GetNextObjectInArea(oArea);
    }

    NWNX_Area_SetSunMoonColors(oArea, NWNX_AREA_COLOR_TYPE_MOON_AMBIENT, nColor);
    NWNX_Area_SetSunMoonColors(oArea, NWNX_AREA_COLOR_TYPE_SUN_AMBIENT, nColor);
}

void main()
{
// No player should be able to login.
    NWNX_Administration_SetPlayerPassword(GetRandomUUID());

    SetLocalString(GetModule(), "DISCORD_WEBHOOK", NWNX_Util_GetEnvironmentVariable("DISCORD_WEBHOOK"));

    SendDiscordMessage("The server is initializing...");

    NWNX_Administration_SetPlayOption(NWNX_ADMINISTRATION_OPTION_USE_MAX_HITPOINTS, TRUE);
    NWNX_Administration_SetPlayOption(NWNX_ADMINISTRATION_OPTION_AUTO_FAIL_SAVE_ON_1, TRUE);

// Set a very high instruction limit so we can run the initialization scripts without TMI
    NWNX_Util_SetInstructionLimit(52428888);

    ExecuteScript("generate_items");

    InitializeBase(TEAM_BLUE, FOG_COLOR_BLUE);
    InitializeBase(TEAM_RED, FOG_COLOR_RED);

    DestroyArea(GetObjectByTag("_BASE"));

    NWNX_Util_SetInstructionLimit(-1);

// Look through each of the areas and add to the respective list.
    object oModule = GetModule();
    object oArea = GetFirstArea();
    string sTDM = "";
    string sResRef, sResRef3;

    while (GetIsObjectValid(oArea))
    {
        sResRef = GetResRef(oArea);
        sResRef3 = GetStringLeft(sResRef, 3);

        if (sResRef3 == "tdm")
        {
            sTDM = AddListItem(GetListItem(sTDM), sResRef, TRUE);
        }

        SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "area_on_enter");

        oArea = GetNextArea();
    }

    SetLocalString(oModule, "tdm_list", sTDM);
    WriteTimestampedLogEntry("tdm_list: "+sTDM);

// loop through and get the list of valid bots
    int i;
    object oBot;
    string sHitDice, sList, sListName;
    location lSystem = Location(GetObjectByTag("_system"), Vector(), 0.0);
    for (i = 1; i < 75; i++)
    {
        oBot = CreateObject(OBJECT_TYPE_CREATURE, "bot"+IntToString(i), lSystem);
        sHitDice = IntToString(GetHitDice(oBot));

// bots with this script set is considered complete
        if (GetIsObjectValid(oBot) && GetEventScript(oBot, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR) == "j_ai_onblocked")
        {
            sList = AddListItem(GetLocalString(GetModule(), "bot_lvl"+sHitDice), GetResRef(oBot), TRUE);
            SetLocalString(GetModule(), "bot_lvl"+sHitDice, sList);

            sListName = AddListItem(GetLocalString(GetModule(), "bot_lvl_name"+sHitDice), GetName(oBot), TRUE);
            SetLocalString(GetModule(), "bot_lvl_name"+sHitDice, sListName);
        }

        DestroyObject(oBot);
    }

    for (i = 7; i <= 12; i++)
    {
        WriteTimestampedLogEntry("bot_lvl"+IntToString(i)+": "+GetLocalString(GetModule(), "bot_lvl"+IntToString(i)));
        WriteTimestampedLogEntry("bot_lvl_name"+IntToString(i)+": "+GetLocalString(GetModule(), "bot_lvl_name"+IntToString(i)));
    }

    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_CONNECT_BEFORE", "on_pc_connectb");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_CONNECT_AFTER", "on_pc_connecta");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_AFTER", "on_pc_dconnecta");

// This script makes players always start at "The Choice"
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "on_elc_validateb");

// We must skip this if polymorphed or bartering.
    NWNX_Events_SubscribeEvent("NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE", "on_pc_save");

// This is to make spells instant in certain areas.
    NWNX_Events_SubscribeEvent("NWNX_ON_INPUT_CAST_SPELL_BEFORE", "on_inputspellb");

    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_LEAVE_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_KICK_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_ACCEPT_INVITATION_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_REJECT_INVITATION_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_IGNORE_INVITATION_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_INVITE_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PARTY_KICK_HENCHMAN_BEFORE", "skip_event");
    NWNX_Events_SubscribeEvent("NWNX_ON_PVP_ATTITUDE_CHANGE_BEFORE", "skip_event");

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

    SendDiscordMessage("The server is now up and connectable.");
}
