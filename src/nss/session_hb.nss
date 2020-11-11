#include "inc_sessions"
#include "inc_player"
#include "inc_teams"
#include "util_i_csvlists"

void DetermineBot(string sTeam)
{
    int nRoll = d100();
    int nLevel = 7;

    if (nRoll <= BOT_LVL12) { nLevel = 12; }
    else if (nRoll <= BOT_LVL11) { nLevel = 11;}
    else if (nRoll <= BOT_LVL10) { nLevel = 10;}
    else if (nRoll <= BOT_LVL9) { nLevel = 9;}
    else if (nRoll <= BOT_LVL8) { nLevel = 8;}

    string sList = GetLocalString(GetModule(), "bot_lvl"+IntToString(nLevel));
    int nListCount = CountList(sList);

    object oBot, oDoor;
    string sTag;

// Keep doing this until a bot is created
    while (!GetIsObjectValid(oBot))
    {
        sTag = GetListItem(sList, Random(nListCount));

// Only create this bot if it doesn't already exist
//        if (!GetIsObjectValid(GetObjectByTag(sTag)))
//        {
            oDoor = GetTransitionTarget(GetObjectByTag("DOOR_SPAWN"+IntToString(d2())+"_"+GetStringUpperCase(sTeam)));

// Failsafe to make sure the door is in the current area
            if (GetArea(oDoor) == OBJECT_SELF)
            {
                oBot = CreateObject(OBJECT_TYPE_CREATURE, sTag, GetLocation(oDoor), FALSE, sTag);
                JoinTeam(oBot, sTeam);
            }
//        }
    }
}

void main()
{
    struct Teams stTeam = GetData();

    object oBot = GetFirstObjectInArea(OBJECT_SELF);

    int nBlueBots = 0;
    int nRedBots = 0;

    string sBotTeam;

    while (GetIsObjectValid(oBot))
    {
        if (GetObjectType(oBot) == OBJECT_TYPE_CREATURE && !GetIsPC(oBot))
        {
            sBotTeam = GetLocalString(oBot, "team");

            if (sBotTeam == TEAM_BLUE)
            {
                nBlueBots = nBlueBots + 1;
            }
            else if (sBotTeam == TEAM_RED)
            {
                nRedBots = nRedBots + 1;
            }
        }

        oBot = GetNextObjectInArea(OBJECT_SELF);
    }

    int nBlueBotsToCreate = BOTS_PER_TEAM - (nBlueBots + stTeam.blueCount);
    int nRedBotsToCreate = BOTS_PER_TEAM - (nRedBots + stTeam.redCount);

    int i;
    for (i = 1; i <= nBlueBotsToCreate; i++)
        DelayCommand(IntToFloat(d4()), DetermineBot(TEAM_BLUE));

    for (i = 1; i <= nRedBotsToCreate; i++)
        DelayCommand(IntToFloat(d4()), DetermineBot(TEAM_RED));
}
