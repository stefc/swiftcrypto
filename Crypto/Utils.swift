//
//  Utils.swift
//  Crypto
//
//  Created by Stefan Böther on 20.11.14.
//  Copyright (c) 2014 Stefc. All rights reserved.
//

import Foundation


// Sequence in ein Array umwandeln
func toArray<S : SequenceType, T where T == S.Generator.Element> (seq: S) -> [T] {
    return Array(seq)
}

// Binärsuche
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

// Datenarray in Hex-String umwandeln
func toHex( data : [UInt8] ) -> String {
    
    let symbols = Array("0123456789ABCDEF")
    return data
        .map( {(x: UInt8) -> String in
            return String(symbols[Int(x >> 4)]) + String(symbols[Int(x & 0xF)])} )
        .reduce( "", + )
}

// Base36 Encoding / Decoding

private let base36 : UInt64 = 36

private let symbols = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")

private class PowersOfTwo : SequenceType {
    func generate() -> GeneratorOf<UInt64> {
        var current : UInt64 = 1
        
        return GeneratorOf<UInt64> {
            let ret = current
            current *= base36
            return ret
        }
    }
}

private class Factors : SequenceType {
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

func encodeBase36 ( x : UInt64 ) -> String
{
    return String(toArray(Factors(x:x)).reverse())
}

func decodeBase36 ( s : String ) -> UInt64
{
    let find = { x in binarySearch(symbols, x) }
    let a = Array(s).reverse().map( find )
    let b = PowersOfTwo()
    return  map(Zip2(a,b), * ).reduce(0, +)
}

