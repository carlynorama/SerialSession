//
//  SerialPortProvider.swift
//  
//
//  Created by Carlyn Maw on 8/25/23.
//

import Foundation

public protocol SerialPortService {
    static func make(path: String) -> Self
    
    func openPort(with:SerialPortConfiguration) throws -> Void
    func closePort() -> Void
    
    
    //MARK: As in SwiftSerial
    //TODO: WHICH ONES TO KEEP?
    
    //receiving
    func readBytes(into buffer: UnsafeMutablePointer<UInt8>, size: Int) throws -> Int
    
    //NOTE: requires Foundation. Better part of hardware layer or session layer?
    func readData(ofLength length: Int) throws -> Data
    
    
    func readString(ofLength length: Int) throws -> String
    
    func readUntilChar(_ terminator: CChar) throws -> String
    
    func readLine() throws -> String
    
    func readByte() throws -> UInt8
    
    func readChar() throws -> UnicodeScalar
    
    //transmitting
    
    func writeBytes(from buffer: UnsafeMutablePointer<UInt8>, size: Int) throws -> Int
    
    //NOTE: requires Foundation. Better part of hardware layer or session layer?
    func writeData(_ data: Data) throws -> Int
    
    func writeString(_ string: String) throws -> Int
    
    func writeChar(_ character: UnicodeScalar) throws -> Int
    
}


