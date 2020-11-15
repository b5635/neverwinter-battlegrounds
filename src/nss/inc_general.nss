// Returns the player's name, character name, and level
string PlayerDetailedName(object oPC);
string PlayerDetailedName(object oPC)
{
    return GetPCPlayerName(oPC)+" (L"+IntToString(GetHitDice(oPC))+" "+GetName(oPC)+")";
}

void PlayNonMeleePainSound(object oDamager)
{
    if (GetIsDead(OBJECT_SELF)) return;

    int nWeaponDamage = GetDamageDealtByType(DAMAGE_TYPE_BASE_WEAPON);

    int bRanged = GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDamager));

    if (bRanged || nWeaponDamage == -1)
    {
        switch (d6())
        {
            case 1: PlayVoiceChat(VOICE_CHAT_PAIN1); break;
            case 2: PlayVoiceChat(VOICE_CHAT_PAIN2); break;
            case 3: PlayVoiceChat(VOICE_CHAT_PAIN3); break;
        }
    }
}

void Gibs(object oCreature)
{
    int nHP = GetCurrentHitPoints(oCreature);
    if (nHP <= -15 && nHP <= -(GetMaxHitPoints(oCreature)/4))
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_BALLISTA), GetLocation(oCreature));
}


//void main() {}
