//
//  File.swift
//  
//
//  Created by Carlyn Maw on 8/25/23.
//

import Foundation
import SwiftSerial

extension SerialPort:SerialPortService {
    public static func make(path: String) -> Self {
        SerialPort(path: path) as! Self
    }
    
    public func openPort(with settings: SerialPortConfiguration) throws {
        try self.openPort()
        print("Serial port opened successfully.")
        self.setSettings(receiveRate: settings.receiveRate,
                         transmitRate: settings.transmitRate,
                         minimumBytesToRead: settings.minimumBytesToRead,
                         timeout: settings.timeout,
                         parityType: settings.parityType,
                         sendTwoStopBits: settings.sendTwoStopBits,
                         dataBitsSize: settings.dataBitsSize,
                         useHardwareFlowControl: settings.useHardwareFlowControl,
                         useSoftwareFlowControl: settings.useSoftwareFlowControl,
                         processOutput: settings.processOutput)
    }
    

}
