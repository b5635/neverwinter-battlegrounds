void main()
{
    if (GetIsOpen(OBJECT_SELF))
    {
        int nOpen = GetLocalInt(OBJECT_SELF, "open");
        SetLocalInt(OBJECT_SELF, "open", nOpen+1);

        if (nOpen > 2)
        {
            DeleteLocalInt(OBJECT_SELF, "open");
            ActionCloseDoor(OBJECT_SELF);
        }
    }
}
