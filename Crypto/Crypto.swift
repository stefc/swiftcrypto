//
//  Crypto.swift
//  crypt
//
//  Created by Stefan Böther on 14.11.14.
//  Copyright (c) 2014 Stefan Böther. All rights reserved.
//

import Foundation


// Alle Schlüssel sind 256 Bit lang
let KEY_SIZE = 32

// Privaten Schlüssel per Zufallsgenerator erzeugen
func createPrivateKey() -> [UInt8] {
    
    var mysecret = [UInt8](count: KEY_SIZE, repeatedValue: 0)

    arc4random_buf(&mysecret, UInt(KEY_SIZE))
    
    return mysecret
}

func createPrivateKeyStd() -> [UInt8] {
    var mysecret = [UInt8](count: KEY_SIZE, repeatedValue: 42)
    
    mysecret[0] &= 248
    mysecret[31] &= 127
    mysecret[31] |= 64
    
    return mysecret
}

// Public Key für einen Privaten Key berrechnen (Elliptische Kurve 25519)
func createPublicKey(privKey: [UInt8]) -> [UInt8] {
    var mypublic = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    crypto_scalarmult_curve25519_base(&mypublic, privKey)
    return mypublic
}

func createKeyPair() -> (prv: [UInt8], pub:[UInt8]) {
    let secret = createPrivateKey()
    return (prv: secret, pub: createPublicKey(secret))
}

func calcSharedSecret( a : [UInt8],  b: [UInt8]) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    crypto_scalarmult_curve25519(&shared, a, b)
    return shared
}

// HSalsa20 für einen Block berechnen
func calcHSalsa20( input: [UInt8], k:[UInt8], c:[UInt8] ) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    var output = [UInt8](count:32, repeatedValue:0)
    crypto_core_hsalsa20(&output, input, k, c)
    return output
}

// Shared Secret zusätzlich encodieren mit  HSalsa20( nonce, HSalsa20( 0, secret, c), c)
func encodeSharedSecret( sharedSecret: [UInt8] , nonceprefix: [UInt8] ) -> [UInt8] {
    
    let zero = [UInt8](count:32, repeatedValue:0)
    
    let c = toArray("expand 32-byte k".utf8)
    
    let firstkey = calcHSalsa20(zero, sharedSecret, c)
    
    return calcHSalsa20(nonceprefix, firstkey, c)
}

// SHA-256 Hashcode ermitteln
func hashSHA256( data: [UInt8] ) -> [UInt8] {
    
    var h = [UInt8](count:32, repeatedValue: 0)
    
    crypto_hash_sha256(&h, data, UInt64(data.count))

    return h
}

// XSalsa20 Symetric Chiper
func cryptXSalsa20( var message: [UInt8], sharedSecret: [UInt8], nonce: [UInt8] ) -> [UInt8] {
    
    crypto_stream_xsalsa20_xor(&message, message, UInt64(message.count), nonce, sharedSecret)
    
    return message
}

// String codieren
func encodeXSalsa20( message: String, sharedSecret: [UInt8], nonce: [UInt8] ) -> [UInt8] {
    return cryptXSalsa20(toArray(message.utf8), sharedSecret, nonce)
}


// String decodieren
func decodeXSalsa20( message: [UInt8], sharedSecret: [UInt8], nonce: [UInt8] ) -> String {
    return toString(cryptXSalsa20(message, sharedSecret, nonce))
}