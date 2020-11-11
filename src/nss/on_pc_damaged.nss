#include "inc_teams"
#include "inc_general"

void main()
{
    object oDamager = GetLastDamager();

    PlayNonMeleePainSound(oDamager);
    StoreLastAttacker(OBJECT_SELF, oDamager);
}
