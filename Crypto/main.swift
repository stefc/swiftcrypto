//
//  main.swift
//  Crypto
//
//  Created by Stefc on 10.11.14.
//  Copyright (c) 2014 Stefc. All rights reserved.
//

import Foundation

// Sender's Key

let alicesk : [UInt8] = [
    0x77, 0x07, 0x6d, 0x0a, 0x73, 0x18, 0xa5, 0x7d, 0x3c, 0x16, 0xc1,
    0x72, 0x51, 0xb2, 0x66, 0x45, 0xdf, 0x4c, 0x2f, 0x87, 0xeb, 0xc0,
    0x99, 0x2a, 0xb1, 0x77, 0xfb, 0xa5, 0x1d, 0xb9, 0x2c, 0x2a ]

let alicepk = createPublicKey(alicesk)

println("Alice Public-Key: \t" + toHex(alicepk))
// 8520F0098930A754748B7DDCB43EF75A0DBF3A0D26381AF4EBA4A98EAA9B4E6A


// Receiver's Key

let bobsk : [UInt8] = [
    0x5d, 0xab, 0x08, 0x7e, 0x62, 0x4a, 0x8a, 0x4b, 0x79, 0xe1, 0x7f,
    0x8b, 0x83, 0x80, 0x0e, 0xe6, 0x6f, 0x3b, 0xb1, 0x29, 0x26, 0x18,
    0xb6, 0xfd, 0x1c, 0x2f, 0x8b, 0x27, 0xff, 0x88, 0xe0, 0xeb ]

let bobpk = createPublicKey(bobsk)
println("Bob Public-Key: \t" + toHex(bobpk))
// DE9EDB7D7B7DC1B4D35B61C2ECE435373F8343C85B78674DADFC7E146F882B4F


// Calculate the shared secret between Sender & Receiver

let senderSharedSk = calcSharedSecret(alicesk, bobpk)
let receiverSharedSk = calcSharedSecret(bobsk, alicepk)

println("Shared Secret: \t" + toHex(senderSharedSk))
println("Shared Secret: \t" + toHex(receiverSharedSk))

// 4A5D9D5BA4CE2DE1728E3BF480350F25E07E21C947D19E3376F09B3C1E161742




// Shared Secret between Bob's Public key and Alice's Private key
let shared = senderSharedSk


// Nonce ist 24 Bytes lang, wobei nur die ersten 16 Bytes in den HSalsa20 gegeben werden
let nonceprefix : [UInt8] = [
    0x69,0x69,0x6e,0xe9,0x55,0xb6,0x2b,0x73
    ,0xcd,0x62,0xbd,0xa8,0x75,0xfc,0x73,0xd6]

// Nonce ist 24 Bytes lang, wobei nur die ersten 16 Bytes in den HSalsa20 gegeben werden
let noncesuffix : [UInt8] = [
    0x82, 0x19, 0xe0, 0x03, 0x6b, 0x7a, 0x0b, 0x37]

let key2 = encodeSharedSecret(shared, nonceprefix)
println("k2:" + toHex(key2))

let nonce = nonceprefix + noncesuffix
println("nonce:" + toHex(nonce))

var buffer = Array<UInt8>(count: 4194304, repeatedValue: 0)

println("sha-256:" + toHex(hashSHA256(buffer)))

// Verschlüsselung
buffer = cryptXSalsa20(buffer, shared, nonce)

println(buffer[0] )
println("sha-256:" + toHex(hashSHA256(buffer)))

// Entschlüsselung
buffer = cryptXSalsa20(buffer, shared, nonce)
println(buffer[0] )
println("sha-256:" + toHex(hashSHA256(buffer)))



let crypted = encodeXSalsa20("Hallo Welt!", shared, nonce)

let text = decodeXSalsa20(crypted, shared, nonce)



println("text:" + text)

//let x = crypto_stream_salsa20(&buffer, UInt64(buffer.count), nonce, shared)
//println("decoded:" + toHex(buffer))



// k1:1B27556473E985D462CD51197A9A46C76009549EAC6474F206C4EE0844F68389

// k2:DC908DDA0B9344A953629B733820778880F3CEB421BB61B91CBD4C3E66256CE4


let key = Array<UInt8>(count: 16, repeatedValue:3)

var data = Array<UInt8>(count: 10, repeatedValue:0)
let const = Array<UInt8>(count: 16, repeatedValue:0)

let ch : Character = "a"

let raw  = toArray("expand 32-byte k".utf8)


//let si = 4711
//let res = crypto_core_hsalsa20(&buffer, data, key, const)


let num : UInt64 = 1234567890
println(encodeBase36(num))
println(decodeBase36("KF12OI"))

let it = GeneratorOfOne(4711)
for x in it {
    println(x)
}

//println(0b01 << 41)
// let x = pow(2.0,41.0)
//let x = log(pow(2.0,41.0)) / log(pow(2.0,36.0))
//println( x )
//println("Hello, World!")

