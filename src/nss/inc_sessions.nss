#include "inc_constants"
#include "util_i_csvlists"

// Get a random map by game mode.
// Valid options: "tdm"
string GetRandomMapResRef(string sGameMode);
string GetRandomMapResRef(string sGameMode)
{
    string sList = GetLocalString(GetModule(), sGameMode+"_list");

    int nCount = CountList(sList);

    return GetListItem(sList, Random(nCount));
}

// Creates a new session. TDM only currently.
// Will return TRUE if created successfully.
// Only works if there isn't a session in progress.
int StartSession();
int StartSession()
{
    object oSession = GetObjectByTag(SESSION_TAG);

// if there is a session in progress, do not continue
    if (GetIsObjectValid(oSession)) return FALSE;

    oSession = CreateArea(GetRandomMapResRef("tdm"), SESSION_TAG);

// do not continue if the session was not created successfully
    if (!GetIsObjectValid(oSession)) return FALSE;

    object oObject = GetFirstObjectInArea(oSession);

    object oTeam1Door1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(TEAM_BLUE));
    object oTeam1Door2 = GetObjectByTag("DOOR_SPAWN2_"+GetStringUpperCase(TEAM_BLUE));
    object oTeam2Door1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(TEAM_RED));
    object oTeam2Door2 = GetObjectByTag("DOOR_SPAWN2_"+GetStringUpperCase(TEAM_RED));

// randomize team selection for spawn doors
    if (d2() == 1)
    {
        object oTeam1Door1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(TEAM_RED));
        object oTeam1Door2 = GetObjectByTag("DOOR_SPAWN2_"+GetStringUpperCase(TEAM_RED));
        object oTeam2Door1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(TEAM_BLUE));
        object oTeam2Door2 = GetObjectByTag("DOOR_SPAWN2_"+GetStringUpperCase(TEAM_BLUE));
    }

    string sTag;
    while (GetIsObjectValid(oObject))
    {
        switch (GetObjectType(oObject))
        {
            case OBJECT_TYPE_DOOR:
                sTag = GetTag(oObject);

                if (sTag == "TEAM1_SPAWN1")
                {
                    SetLocalObject(oTeam1Door1, "door", oObject);
                }
                else if (sTag == "TEAM1_SPAWN2")
                {
                    SetLocalObject(oTeam1Door2, "door", oObject);
                }
                else if (sTag == "TEAM2_SPAWN1")
                {
                    SetLocalObject(oTeam2Door1, "door", oObject);
                }
                else if (sTag == "TEAM2_SPAWN2")
                {
                    SetLocalObject(oTeam2Door2, "door", oObject);
                }
            break;
        }

        oObject = GetNextObjectInArea(oSession);
    }

    SetEventScript(oSession, EVENT_SCRIPT_AREA_ON_ENTER, "area_on_enter");

    AssignCommand(GetModule(), SpeakString(GetName(oSession)+" has started!", TALKVOLUME_SHOUT));

    return TRUE;

}

//void main() {}
