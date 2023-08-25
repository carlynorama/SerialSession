//
//  File.swift
//  
//
//  Created by Carlyn Maw on 8/25/23.
//

import Foundation
import SwiftSerial


public struct SerialPortConfiguration {
    let receiveRate: BaudRate = .baud9600
    let transmitRate: BaudRate = .baud9600
    let minimumBytesToRead: Int = 1
    let timeout: Int = 0 /* 0 means wait indefinitely */
    let parityType: ParityType = .none
    let sendTwoStopBits: Bool = false /* 1 stop bit is the default */
    let dataBitsSize: DataBitsSize = .bits8
    let useHardwareFlowControl: Bool = false
    let useSoftwareFlowControl: Bool = false
    let processOutput: Bool = false
    
    public static let defaultSettings = SerialPortConfiguration()
    
}

