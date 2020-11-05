#include "x3_inc_string"
#include "inc_constants"
#include "nwnx_area"

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
    InitializeBase(TEAM_BLUE, FOG_COLOR_BLUE);
    InitializeBase(TEAM_RED, FOG_COLOR_RED);

    DestroyArea(GetObjectByTag("_BASE"));
}