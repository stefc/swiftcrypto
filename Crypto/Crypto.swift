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
    
  /*  mysecret[0] &= 248
    mysecret[31] &= 127
    mysecret[31] |= 64
    */
    
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

/*
func calcSharedSecret(privKey: [UInt8], pubKey: [UInt8]) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    curve25519_donna(&shared, privKey, pubKey)
    return shared
} */

func calcSharedSecret( pair : ([UInt8], [UInt8])) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    curve25519_donna(&shared, pair.0, pair.1)
    return shared
}

func calcHSalsa20( input: [UInt8], k:[UInt8], c:[UInt8] ) -> [UInt8] {
    var shared = [UInt8](count: KEY_SIZE, repeatedValue: 0)
    
    var output = [UInt8](count:32, repeatedValue:0)
    crypto_core(&output, input, k, c)
    return output
}




