#include "inc_nwnx"
#include "inc_general"

void main()
{
    object oPC = GetExitingObject();

    object oPCCount = GetFirstPC();
    int nPCs = -1;

    while (GetIsObjectValid(oPCCount))
    {
        nPCs = nPCs + 1;
        oPCCount = GetNextPC();
    }

    if (nPCs < 0) nPCs = 0;

    string sMessage = PlayerDetailedName(oPC)+" has left the game.";

    WriteTimestampedLogEntry(sMessage);

    SendDiscordMessage(sMessage+" - there " + (nPCs == 1 ? "is" : "are") + " now " + IntToString(nPCs) + " player" + (nPCs == 1 ? "" : "s") + " online.");
}
