//
//  SerialPortProvider.swift
//  
//
//  Created by Carlyn Maw on 8/25/23.
//

public protocol SerialPortService {  
      
    static func makeForSession(devicePath:String, with:SerialPortConfiguration?) throws -> Self
    
    //If a real service, must handle closing and releasing the fileDescriptor
    //on destruction. 
    //func close() -> Void
    
    func write<T>(_ outBytes:T) throws -> Int
    
    func bytesAvailable() -> Int
    
    //Never block, only takes whats available
    //Must be careful to not call these too too frequently
    func readIfAvailable(maxCount:Int) throws -> [UInt8]
    func readAllAvailable() throws -> [UInt8]
    func readAvailableLines(maxLength:Int) throws -> (lines:[String], remainder:String)
    
    //TODO: make async instead. Currently uses non blocking read.
    func readUntil(oneOf:[UInt8], orMaxCount maxCount:Int, tries:Int) -> [UInt8]
    
    //Uses readEscape configuration. If that's not set, will never return.
    func awaitBytes(count:Int) async -> Result<[UInt8], Error>
    
}
