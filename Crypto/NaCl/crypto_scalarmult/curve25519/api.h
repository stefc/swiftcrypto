
#include "crypto_scalarmult_curve25519.h"

#define crypto_scalarmult_curve25519_implementation_name \
    crypto_scalarmult_curve25519_donna_c64_implementation_name

#define crypto_scalarmult crypto_scalarmult_curve25519
#define crypto_scalarmult_base crypto_scalarmult_curve25519_base

#define HAVE_TI_MODE

