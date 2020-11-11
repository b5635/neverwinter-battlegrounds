#include "inc_constants"
#include "util_i_csvlists"
#include "util_i_color"
#include "inc_teams"
#include "nwnx_area"

// Get a random map by game mode.
// Valid options: "tdm"
string GetRandomMapResRef(string sGameMode);
string GetRandomMapResRef(string sGameMode)
{
    string sList = GetLocalString(GetModule(), sGameMode+"_list");

    int nCount = CountList(sList);

    return GetListItem(sList, Random(nCount));
}

void TriggerDoorsScript(string sTeam)
{
    object oTeamDoor1 = GetObjectByTag("DOOR_SPAWN1_"+GetStringUpperCase(sTeam));
    object oTeamDoor2 = GetObjectByTag("DOOR_SPAWN2_"+GetStringUpperCase(sTeam));
    object oTeamDoorRandom = GetObjectByTag("DOOR_SPAWNRANDOM_"+GetStringUpperCase(sTeam));

    ExecuteScript(GetEventScript(oTeamDoor1, EVENT_SCRIPT_DOOR_ON_HEARTBEAT), oTeamDoor1);
    ExecuteScript(GetEventScript(oTeamDoor2, EVENT_SCRIPT_DOOR_ON_HEARTBEAT), oTeamDoor2);
    ExecuteScript(GetEventScript(oTeamDoorRandom, EVENT_SCRIPT_DOOR_ON_HEARTBEAT), oTeamDoorRandom);
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

    NWNX_Area_SetNoRestingAllowed(oSession, TRUE);

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
                SetTag(oObject, "SESSION_"+sTag);
                sTag = GetTag(oObject);

                if (sTag == "SESSION_TEAM1_SPAWN1")
                {
                    SetLocalObject(oTeam1Door1, "door", oObject);
                }
                else if (sTag == "SESSION_TEAM1_SPAWN2")
                {
                    SetLocalObject(oTeam1Door2, "door", oObject);
                }
                else if (sTag == "SESSION_TEAM2_SPAWN1")
                {
                    SetLocalObject(oTeam2Door1, "door", oObject);
                }
                else if (sTag == "SESSION_TEAM2_SPAWN2")
                {
                    SetLocalObject(oTeam2Door2, "door", oObject);
                }
            break;
        }

        oObject = GetNextObjectInArea(oSession);
    }

    TriggerDoorsScript(TEAM_BLUE);
    TriggerDoorsScript(TEAM_RED);

    SetEventScript(oSession, EVENT_SCRIPT_AREA_ON_ENTER, "area_on_enter");
    SetEventScript(oSession, EVENT_SCRIPT_AREA_ON_HEARTBEAT, "session_hb");

    AssignCommand(GetModule(), SpeakString(HexColorString(GetName(oSession), COLOR_PURPLE)+" has started!", TALKVOLUME_SHOUT));

    return TRUE;
}

// This function awards points to the selected team.
// Also awards XP to PCs in the current map.
// And will end the game if the maximum points have been exceeded.
void AwardPoints(int nPoints, string sTeam);
void AwardPoints(int nPoints, string sTeam)
{
    object oSession = GetObjectByTag(SESSION_TAG);

    if (GetLocalInt(oSession, "end") == 1) return;

// Award every PC inside the session map for these points.
    object oPC = GetFirstPC();
    {
        if (GetArea(oPC) == oSession && GetLocalString(oPC, "team") == sTeam)
            SetXP(oPC, GetXP(oPC) + (nPoints*XP_PER_POINT));

        oPC = GetNextPC();
    }

// Store the points on the session
    int nCurrentPoints = GetLocalInt(oSession, "points_"+sTeam);
    SetLocalInt(oSession, "points_"+sTeam, nCurrentPoints+nPoints);

// Retrieve it again after adding to the current.
    nCurrentPoints = GetLocalInt(oSession, "points_"+sTeam);

    if (nCurrentPoints >= POINTS_TO_WIN)
    {
// This is set so "end of session" never triggers twice.
        SetLocalInt(oSession, "end", 1);

// Award end of session XP
        oPC = GetFirstPC();
        {
            if (GetLocalString(oPC, "team") == sTeam)
            {
                SetXP(oPC, GetXP(oPC) + (END_SESSION_XP*2)); // Winners get doubled end of session XP
            }
            else
            {
                SetXP(oPC, GetXP(oPC) + END_SESSION_XP);
            }

            oPC = GetNextPC();
        }

// Trigger the scripts of each door to get them to close itself.
        TriggerDoorsScript(TEAM_BLUE);
        TriggerDoorsScript(TEAM_RED);

        SetEventScript(oSession, EVENT_SCRIPT_AREA_ON_HEARTBEAT, "session_end_hb");

// Play end of session message.
        string sTeamWin = HexColorString("Blue Team wins!", COLOR_BLUE);
        if (sTeam == TEAM_RED) sTeamWin = HexColorString("Red Team wins!", COLOR_RED);
        AssignCommand(GetModule(), SpeakString(HexColorString(GetName(oSession), COLOR_PURPLE)+" has ended! "+sTeamWin, TALKVOLUME_SHOUT));
    }
}

// Determines the points for a kill.
// This MUST be used on either PC death or creature death.
void DetermineKillPoints(object oCreature = OBJECT_SELF);
void DetermineKillPoints(object oCreature = OBJECT_SELF)
{
    object oSession = GetObjectByTag(SESSION_TAG);
// do not proceed if the session has already ended
    if (GetLocalInt(oSession, "end") == 1) return;

    object oKiller = GetPlayer(GetLastHostileActor(oCreature));

    object oLastAttacker = GetLocalObject(oCreature, "last_attacker");

    string sVictimName = GetName(oCreature);
    string sVictimTeam = GetLocalString(oCreature, "team");

    string sName, sTeam;
    int nHitDice;

    if (GetIsObjectValid(oKiller))
    {
        sName = GetName(oKiller);
        nHitDice = GetHitDice(oKiller);
        sTeam = GetLocalString(oKiller, "team");
    }
    else
    {
        oKiller = GetPlayer(oLastAttacker);
        sName = GetLocalString(oCreature, "last_attacker_name");
        nHitDice = GetLocalInt(oCreature, "last_attacker_level");
        sTeam = GetLocalString(oCreature, "last_attacker_team");
    }

    if (sName != "" && sTeam != sVictimTeam)
    {
        int nVictimHitDice = GetHitDice(oCreature);
        int nDifference = nVictimHitDice - nHitDice;
        int nPoints = POINTS_PER_KILL + nDifference;

        string sPoints = IntToString(nPoints)+" points!";
        if (nPoints == 1) sPoints = IntToString(nPoints)+" point!";

        FloatingTextStringOnCreature("You killed "+sVictimName+" for "+sPoints, oKiller, FALSE);

        sName = sName+" ("+IntToString(nHitDice)+")";

        sVictimName = sVictimName+" ("+IntToString(nVictimHitDice)+")";

        sPoints = HexColorString(sPoints, COLOR_PURPLE);

// Colorize victim name
        if (sVictimTeam == TEAM_BLUE) { sVictimName = HexColorString(sVictimName, COLOR_BLUE); }
        else if (sVictimTeam == TEAM_RED) { sVictimName = HexColorString(sVictimName, COLOR_RED); }

        int nEffect;
// Same for killer name
        if (sTeam == TEAM_BLUE) { sName = HexColorString(sName, COLOR_BLUE); nEffect = VFX_IMP_PULSE_COLD;}
        else if (sTeam == TEAM_RED) { sName = HexColorString(sName, COLOR_RED); nEffect = VFX_IMP_PULSE_NEGATIVE;}

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nEffect), GetLocation(oKiller));


        AssignCommand(GetModule(), SpeakString(sName+" has killed "+sVictimName+" for "+sPoints, TALKVOLUME_SHOUT));

        AwardPoints(nPoints, sTeam);
    }
}

//void main() {}
