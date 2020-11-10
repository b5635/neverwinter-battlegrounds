#include "nwnx_events"
#include "nwnx_object"

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    string sResRef = GetResRef(oArea);

    if (sResRef == "_base" || sResRef == "_choice")
    {
        object oTarget = NWNX_Object_StringToObject(NWNX_Events_GetEventData("TARGET"));

        int nSpell = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));
        int nMetamagic = StringToInt(NWNX_Events_GetEventData("META_TYPE"));

        if (GetIsObjectValid(oTarget))
        {
            ActionCastSpellAtObject(nSpell, oTarget, nMetamagic, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        else if (StringToInt(NWNX_Events_GetEventData("IS_AREA_TARGET")))
        {
            float fX = StringToFloat(NWNX_Events_GetEventData("POS_X"));
            float fY = StringToFloat(NWNX_Events_GetEventData("POS_Y"));
            float fZ = StringToFloat(NWNX_Events_GetEventData("POS_Z"));
            location lLocation = Location(oArea, Vector(fX, fY, fZ), GetFacing(OBJECT_SELF));

            ActionCastSpellAtLocation(nSpell, lLocation, nMetamagic, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }

        NWNX_Events_SkipEvent();
    }
}
