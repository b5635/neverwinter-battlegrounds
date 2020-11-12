/************************ [On Death] *******************************************
    Filename: j_ai_ondeath or nw_c2_default7
************************* [On Death] *******************************************
    Speeded up no end, when compiling, with seperate Include.
    Cleans up all un-droppable items, all ints and all local things when destroyed.

    Check down near the bottom for a good place to add XP or corpse lines ;-)
************************* [History] ********************************************
    1.3 - Added in Turn of corpses toggle
        - Added in appropriate space for XP awards, marked with ideas (effect death)
************************* [Workings] *******************************************
    You can edit this for experience, there is a seperate section for it.

    It will use DeathCheck to execute a cleanup-and-destroy script, that removes
    any coprse, named "j_ai_destroyself".
************************* [Arguments] ******************************************
    Arguments: GetLastKiller.
************************* [On Death] ******************************************/

// We only require the constants/debug file. We have 1 function, not worth another include.
#include "j_inc_constants"
#include "inc_sessions"
#include "inc_general"

void main()
{
    Gibs(OBJECT_SELF);

    CreateObject(OBJECT_TYPE_PLACEABLE, "_bloodstain", GetLocation(OBJECT_SELF));

    DelayCommand(IntToFloat(RESPAWN_TIME)-0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), GetLocation(OBJECT_SELF)));

    DetermineKillPoints();

    // Always shout when we are killed. Reactions - Morale penalty, and attack the killer.
    AISpeakString(I_WAS_KILLED);

    // Signal the death event.
    FireUserEvent(AI_FLAG_UDE_DEATH_EVENT, EVENT_DEATH_EVENT);
}
