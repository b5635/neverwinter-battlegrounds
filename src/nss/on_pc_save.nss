#include "nwnx_events"

void main()
{

    int bPolymorph = FALSE;

    effect e = GetFirstEffect(OBJECT_SELF);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == EFFECT_TYPE_POLYMORPH)
        {
            bPolymorph = TRUE;
            break;
        }
        e = GetNextEffect(OBJECT_SELF);
    }

    if (bPolymorph)
        NWNX_Events_SkipEvent();
}
