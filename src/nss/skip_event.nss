#include "nwnx_events"

void main()
{
    SendMessageToPC(OBJECT_SELF, "That action is not allowed.");
    NWNX_Events_SkipEvent();
}
