#include "x3_inc_string"
#include "inc_constants"

void InitializeBase(string sTeam)
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
}

void main()
{
    InitializeBase(TEAM_BLUE);
    InitializeBase(TEAM_RED);

    DestroyArea(GetObjectByTag("_BASE"));
}
