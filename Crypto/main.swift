//
//  main.swift
//  Crypto
//
//  Created by Stefc on 10.11.14.
//  Copyright (c) 2014 Stefc. All rights reserved.
//

import Foundation



let bob = createKeyPair()
let mary = createKeyPair()

let sharedA = calcSharedSecret((bob.prv,mary.pub))
let sharedB = calcSharedSecret((mary.prv,bob.pub))

println(toHex(mary.prv))
println(toHex(mary.pub))
println(toHex(bob.prv))
println(toHex(bob.pub))


// Shared Secret between Bob's Public key and Alice's Private key
let shared : [UInt8] = [
    0x4a,0x5d,0x9d,0x5b,0xa4,0xce,0x2d,0xe1
    ,0x72,0x8e,0x3b,0xf4,0x80,0x35,0x0f,0x25
    ,0xe0,0x7e,0x21,0xc9,0x47,0xd1,0x9e,0x33
    ,0x76,0xf0,0x9b,0x3c,0x1e,0x16,0x17,0x42]

let zero = [UInt8](count:32, repeatedValue:0)

let c : [UInt8] = [
    0x65,0x78,0x70,0x61,0x6e,0x64,0x20,0x33
    ,0x32,0x2d,0x62,0x79,0x74,0x65,0x20,0x6b]

let firstkey = calcHSalsa20(zero, shared, c)

println(toHex(firstkey))

println()


// Nonce ist 24 Bytes lang, wobei nur die ersten 16 Bytes in den HSalsa20 gegeben werden
let nonceprefix : [UInt8] = [
    0x69,0x69,0x6e,0xe9,0x55,0xb6,0x2b,0x73
    ,0xcd,0x62,0xbd,0xa8,0x75,0xfc,0x73,0xd6]

let secondkey = calcHSalsa20(nonceprefix, firstkey, c)

// HSalsa20(HSalsa20(k, 0), n1);

println(toHex(secondkey))


/*

extension Zip2 {
    
    func toArray<T where T == self.Generator.Element>() -> [T] {
        return Array<T>(self)
    }
    
    
    
}

*/



let key = Array<UInt8>(count: 16, repeatedValue:3)
let nonce = Array<UInt8>(count: 32, repeatedValue: 42)

var data = Array<UInt8>(count: 10, repeatedValue:0)
var buffer = Array<UInt8>(count: 10, repeatedValue:11)
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

