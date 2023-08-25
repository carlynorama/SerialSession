//
//  SerialManager.swift
//  SerialSession
//
//  Created by Carlyn Maw on 8/24/23.
//

//TODO: Replace Error types?
import SwiftSerial
import Foundation //For Data type

public typealias SimpleSerialSession = SerialSession<SerialPort>

public class SerialSession<Port:SerialPortService> {
    let portName:String //not retrievable from SwiftSerial
    let serialPort:Port
    
    let maintainConnection:Bool
    var isOpen:Bool = false
    var configuration:SerialPortConfiguration
    
    //TODO: Serial Port Service should be able to provide the port name, right?
    //TODO: Should maintainConnection be a setting?
    init(portName:String,
         serialPort:Port,
         maintainConnection:Bool,
         settings:SerialPortConfiguration) {
        
        self.portName = portName
        self.configuration = settings
        self.serialPort = serialPort
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
        try serialPort.openPort(with: configuration)
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
    
}

extension SerialSession where Port == SwiftSerial.SerialPort {
    
    public convenience init(portName: String, maintainConnection:Bool = true, settings:SerialPortConfiguration = SerialPortConfiguration.defaultSettings) {
        
        self.init(portName: portName, serialPort: SerialPort.make(path: portName), maintainConnection: maintainConnection, settings: settings)
    }
}



extension SerialSession {
    
    //Main wrapper to provide persistent connection as needed. 
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



