// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  SerialManager.swift
//  HelloArduino
//
//  Created by Carlyn Maw on 8/24/23.
//

import Foundation
import SwiftSerial

public class SerialSession {
    let portName:String //not retrievable from SwiftSerial
    let serialPort: SerialPort
    
    let maintainConnection:Bool
    var isOpen:Bool = false
    var configuration:SerialPortConfiguration
    
    public init(portName: String, maintainConnection:Bool = true, settings:SerialPortConfiguration = SerialPortConfiguration.defaultSettings) {
        self.portName = portName
        self.serialPort = SerialPort(path: portName)
        self.maintainConnection = maintainConnection
        self.configuration = settings
        if maintainConnection {
            //print("safe open")
            self.safeOpen()
        }
    }
    
    deinit {
        close()
    }
    
    func open() throws {
        print("Attempting to open port: \(portName)")
        try serialPort.openPort()
        print("Serial port \(portName) opened successfully.")
        serialPort.setSettings(receiveRate: .baud9600,
                               transmitRate: .baud9600, minimumBytesToRead: 1)
        isOpen = true
    }
    
    func safeOpen() {
        do {
            try open()
        } catch PortError.failedToOpen {
            isOpen = false
            print("Serial port \(portName) failed to open.")
        } catch {
            //TODO: divide out PortErrors into connection error and format errors
            //MUST know for sure if is connected or not.
            fatalError("Error: \(error)")
        }
    }
    
    func close() {
        serialPort.closePort()
        print("Port Closed")
        isOpen = false
    }
    
    private func wrappedThrowing<I, R>(function:(I) throws -> R, parameter:I) -> Result<R,Error> {
        defer {
            if !maintainConnection { close() }
        }
        do {
            if !isOpen { try open() }
            let r = try function(parameter)
            return .success(r)

        } catch PortError.failedToOpen {
            print("Serial port \(portName) failed to open.")
            return .failure(PortError.failedToOpen)
        } catch {
            //TODO: divide out PortErrors into connection error and format errors
            //MUST know for sure if is connected or not.
            fatalError("Error: \(error)")
        }
    }
    

    @discardableResult
    public func pingII() -> Result<Int, Error> {
        return wrappedThrowing(function: serialPort.writeString, parameter: "A")
        
    }
    
    @discardableResult
    public func sendByte(_ byte:UInt8) -> Result<Int, Error> {
        return wrappedThrowing(function: writeByteWrapper, parameter: byte)
    }
    
    private func writeByteWrapper(_ byte:UInt8) throws  -> Int {
        var m_message = byte
        return try serialPort.writeBytes(from: &m_message, size: 1)
    }
    
    public func readBytes(count:Int) -> Result<Data, Error>{
        return wrappedThrowing(function: serialPort.readData, parameter: count)
    }
    
    public func readLine() -> Result<String, Error>{
        return wrappedThrowing(function: serialPort.readUntilChar, parameter: CChar(10))
    }
}
