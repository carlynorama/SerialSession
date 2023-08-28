//
//  SerialPort+SerialPortService.swift
//  
//
//  Created by Carlyn Maw on 8/28/23.
//

import SwiftSerialPort

extension SerialPort:SerialPortService {
    
    public static func make(devicePath: String, with config: SerialPortConfiguration?) throws -> SwiftSerialPort.SerialPort {
        var port = try SwiftSerialPort.SerialPort(at:devicePath)
        if let config {
            if let baud = config.baudRate {
                try port.setBaudRate(CInt(baud))
            }
            if let readEsc = config.readEscape {
                try port.setReadEscapes(wait: readEsc.timeOut, minNumberOfBytes: readEsc.byteMin)
            }
        }
        return port
    }
}
