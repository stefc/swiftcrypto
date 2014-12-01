//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//


extern int crypto_scalarmult_curve25519(unsigned char *q, const unsigned char *n,
                                        const unsigned char *p);

extern int crypto_scalarmult_curve25519_base(unsigned char *q, const unsigned char *n);


extern int crypto_hash_sha256(unsigned char *out,
                              const unsigned char *in,
                              unsigned long long inlen);


extern int crypto_core_hsalsa20(uint8_t *out, const uint8_t *in,
                       const uint8_t *k, const uint8_t *c );

extern int crypto_stream_salsa20(unsigned char *c,
                                 unsigned long long clen,
                                 const unsigned char *n,
                                 const unsigned char *k);

extern int crypto_stream_salsa20_xor(unsigned char *c, const unsigned char *m,
                              unsigned long long mlen, const unsigned char *n,
                              const unsigned char *k);

extern int crypto_stream_xsalsa20(unsigned char *c,
                                 unsigned long long clen,
                                 const unsigned char *n,
                                 const unsigned char *k);

extern int crypto_stream_xsalsa20_xor(unsigned char *c, const unsigned char *m,
                                     unsigned long long mlen, const unsigned char *n,
                                     const unsigned char *k);



