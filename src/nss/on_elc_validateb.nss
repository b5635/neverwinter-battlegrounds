#include "nwnx_admin"

void main()
{
    NWNX_Administration_DeleteTURD(GetPCPlayerName(OBJECT_SELF), GetName(OBJECT_SELF));
}
