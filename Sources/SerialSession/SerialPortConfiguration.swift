//
//  SerialPortConfiguration.swift
//  
//
//  Created by Carlyn Maw on 8/25/23.
//

//import Foundation
//import SwiftSerial


public struct SerialPortConfiguration {
    let baudRate: CInt?
    let readEscape: (timeOut:UInt8, byteMin:UInt8)?
}
