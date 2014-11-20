//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include "api.h"

int crypto_core_hsalsa20(unsigned char *out, const unsigned char *in,
                         const unsigned char *k, const unsigned char *c);

