//
//  Errors.swift
//  SerialSession
//
//  Created by Carlyn Maw on 8/28/23.
//


enum SerialSessionError:Error {
    case noActivePort
    case noBytesAvailable
}
