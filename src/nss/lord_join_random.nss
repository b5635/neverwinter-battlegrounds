#include "inc_constants"

void main()
{
    object oPC = GetPCSpeaker();

    string sTeam;

    if (d2() == 1)
    {
        sTeam = TEAM_BLUE;
    }
    else
    {
        sTeam = TEAM_RED;
    }

    SetScriptParam("team", sTeam);
    SetScriptParam("object_self", "1");

    ExecuteScript("lord_join_team", oPC);
}
