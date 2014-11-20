//
//  main.swift
//  Crypto
//
//  Created by Stefc on 10.11.14.
//  Copyright (c) 2014 Stefc. All rights reserved.
//

import Foundation

let symbols = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")

// Sequence in ein Array umwandeln
func toArray<S : SequenceType, T where T == S.Generator.Element> (seq: S) -> [T] {
    return Array(seq)
}
/*

extension Zip2 {
    
    func toArray<T where T == self.Generator.Element>() -> [T] {
        return Array<T>(self)
    }
    
    
    
}

*/

class PowersOfTwo : SequenceType {
    func generate() -> GeneratorOf<UInt64> {
        var current : UInt64 = 1
        
        return GeneratorOf<UInt64> {
            let ret = current
            current *= base36
            return ret
        }
    }
}

let base36 : UInt64 = 36

class Factors : SequenceType {
    private var x : UInt64
    
    init(x : UInt64) {
        self.x = x
    }
    
    func generate() -> GeneratorOf<Character> {
        var current = x
        
        return GeneratorOf<Character> {
            if (current == 0) {
                return nil
            }
            
            let ret = symbols[Int(current % base36)]
            
            current /= base36
            return ret
        }
    }
}

func binarySearch<T : Comparable>(xs: [T], x : T) -> UInt64 {
    var recurse : ((Int,Int) -> Int)!
        recurse = {(low,high) in switch (low + high)/2 {
            //case _ where high < low: return nil
            case let mid where xs[mid] > x: return recurse(low, mid - 1)
            case let mid where xs[mid] < x: return recurse(mid + 1, high)
            case let mid: return mid
        }}
    return UInt64(recurse(0, xs.count-1))
}

func encodeBase36 ( x : UInt64 ) -> String
{
    return String(toArray(Factors(x:x)).reverse())
}

func decodeBase36 ( s : String ) -> UInt64
{
    let find = { x in binarySearch(symbols, x) }
    let a = Array(s).reverse().map( find )
    let b = PowersOfTwo()
    println(Zip2(a,b))
    return  map(Zip2(a,b), * ).reduce(0, +)
}


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

