int StartingConditional()
{
    if (GetHitDice(GetPCSpeaker()) < 7)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
