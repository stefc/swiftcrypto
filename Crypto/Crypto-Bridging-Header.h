//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//


extern void curve25519_donna(uint8_t *output, const uint8_t *secret, const uint8_t *bp);

extern int crypto_core(uint8_t *out, const uint8_t *in,
                       const uint8_t *k, const uint8_t *c );

