//
//  SerialManager.swift
//  SerialSession
//
//  Created by Carlyn Maw on 8/24/23.
//

//TODO: Replace Error types?
import SwiftSerialPort
import Foundation //For Data type

public typealias SerialSession = BaseSerialSession<SerialPort>

public class BaseSerialSession<Port:SerialPortService> {
    let devicePath:String
    var serialPort:Port?

    var configuration:SerialPortConfiguration?
    var isOpen:Bool {
        serialPort != nil
    }

    init(devicePath:String,
         serialPort:Port?,
         settings:SerialPortConfiguration?) {
        self.devicePath = devicePath
        self.configuration = settings
        self.serialPort = serialPort
        self.configuration = settings
    }
    
    deinit {
        close()
    }
    
    func open(forcedReset:Bool = false) throws {
        print("Attempting to open port: \(devicePath)")
        if forcedReset || !isOpen {
            serialPort = nil
            self.serialPort = try Port.make(devicePath: devicePath, with: configuration)
        }
    }
    
    func close() {
        serialPort = nil //
        print("Port Closed")
    }
    
}

//MARK: SerialSession inits
extension BaseSerialSession where Port == SwiftSerialPort.SerialPort {
    
    public convenience init(devicePath: String, settings:SerialPortConfiguration? = nil) {
        
        var port:Port? = nil
        
        do {
            port = try SerialPort.make(devicePath: devicePath, with: settings)
        } catch {
            print("Creating session with nil port: \(error)")
        }

        self.init(devicePath: devicePath, serialPort: port,  settings: settings)
    }
    
    convenience init(devicePath: String,
                     baudRate:CInt) {
       let settings = SerialPortConfiguration(baudRate: baudRate, readEscape: nil)
        self.init(devicePath:devicePath, settings:settings)
    }
}


//TODO: re-make wrapped?
extension BaseSerialSession {
    
    //MARK: Transmit
    @discardableResult
    public func pingII() -> Result<Int, Error> {
        if let serialPort {
            do {
                let bytesWritten = try serialPort.write("A")
                return .success(bytesWritten)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(SerialSessionError.noActivePort)
        }
    }
    
    @discardableResult
    public func send<T>(_ value:T) -> Result<Int, Error> {
        if let serialPort {
            do {
                let bytesWritten = try serialPort.write(value)
                return .success(bytesWritten)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(SerialSessionError.noActivePort)
        }
    }
    
    //MARK: Receive
    public func readAvailable() -> Result<Data, Error>{
        if let serialPort {
            do {
                let bytesReceived = try serialPort.readAllAvailable()
                if bytesReceived.isEmpty {
                    return .failure(SerialSessionError.noBytesAvailable)
                }
                return .success(Data(bytesReceived))
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(SerialSessionError.noActivePort)
        }
    }
    
    //TODO: Have Session handle remainders as part of AsyncStream iterator.
    public func readLines() -> Result<(lines:[String], remainder:String), Error>{
        if let serialPort {
            do {
                let dataReceived = try serialPort.readAvailableLines(maxLength: 1000)
                if dataReceived.lines.isEmpty {
                    return .failure(SerialSessionError.noBytesAvailable)
                }
                return .success(dataReceived)
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(SerialSessionError.noActivePort)
        }
    }
}



