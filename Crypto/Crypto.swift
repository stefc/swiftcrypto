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
    
    var basepoint = [UInt8](count:KEY_SIZE, repeatedValue: 0)
    basepoint[0] = 9
    var mypublic = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    curve25519_donna(&mypublic, privKey, basepoint)
    return mypublic
}

func createKeyPair() -> (prv: [UInt8], pub:[UInt8]) {
    let secret = createPrivateKey()
    return (prv: secret, pub: createPublicKey(secret))
}

func calcSharedSecret( pair : ([UInt8], [UInt8])) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    curve25519_donna(&shared, pair.0, pair.1)
    return shared
}

// HSalsa20 für einen Block berechnen
func calcHSalsa20( input: [UInt8], k:[UInt8], c:[UInt8] ) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    var output = [UInt8](count:32, repeatedValue:0)
    crypto_core(&output, input, k, c)
    return output
}

// Shared Secret zusätzlich encodieren mit  HSalsa20( nonce, HSalsa20( 0, secret, c), c)
func encodeSharedSecret( sharedSecret: [UInt8] ) -> [UInt8] {
    
    let zero = [UInt8](count:32, repeatedValue:0)
    
    let c = toArray("expand 32-byte k".utf8)
    
    let firstkey = calcHSalsa20(zero, sharedSecret, c)
    
    
    // Nonce ist 24 Bytes lang, wobei nur die ersten 16 Bytes in den HSalsa20 gegeben werden
    let nonceprefix : [UInt8] = [
        0x69,0x69,0x6e,0xe9,0x55,0xb6,0x2b,0x73
        ,0xcd,0x62,0xbd,0xa8,0x75,0xfc,0x73,0xd6]
    
    return calcHSalsa20(nonceprefix, firstkey, c)
}

