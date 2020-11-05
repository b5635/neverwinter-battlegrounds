void main()
{
    object oPC = GetLastOpenedBy();

    if (GetHitDice(oPC) < 7)
    {
        SendMessageToPC(oPC, "You can't enter until you have finished leveling up.");
    }
    else
    {
        BeginConversation("choose_team", oPC);
    }
}
