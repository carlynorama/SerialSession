//
//  SerialPort+SerialPortService.swift
//  
//
//  Created by Carlyn Maw on 8/28/23.
//

import SwiftSerialPort

extension SerialPort:SerialPortService {
    
    public static func makeForSession(devicePath: String, with config: SerialPortConfiguration?) throws -> SwiftSerialPort.SerialPort {
        //This can be a let because what's being set is the termios struct.
        let port = try SwiftSerialPort.SerialPort(at:devicePath)
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
