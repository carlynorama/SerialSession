# SerialSession

WARNING: works, still very version 0.0.0

Library to make simple serial connections via a Session class. Many hobby electronics boards including [Arduino](https://www.arduino.cc) reboot every time a serial connection is opened in order to make loading code onto them easier. This means code that interacts with them needs to avoid reopening the serial ports as much as possible. 

This library wraps [SwiftSerialPort](https://swiftpackageindex.com/carlynorama/SwiftSerialPort) library, a Linux (TODO: confirm on Ubuntu) and MacOS (v13) compatible library with no dependencies, and no Foundation.  

For usage examples see the companion repo: https://github.com/carlynorama/SerialSessionUI


## Misc Resources

### Swift/Apple links
- https://swiftpackageindex.com/yeokm1/SwiftSerial
- https://developer.apple.com/documentation/iokit
- https://developer.apple.com/documentation/iokit/communicating_with_a_modem_on_a_serial_port
- https://developer.apple.com/documentation/driverkit
- if decide to use libusb: https://forums.swift.org/t/linking-to-c-libraries/55651/2

### C/terminos links. 
- https://tldp.org/HOWTO/Serial-Programming-HOWTO/intro.html
- https://en.wikibooks.org/wiki/Serial_Programming/termios
- https://blog.nelhage.com/2009/12/a-brief-introduction-to-termios/
- http://unixwiz.net/techtips/termios-vmin-vtime.html
- talks about open()/fileDescriptors etc: https://www.youtube.com/watch?v=BQJBe4IbsvQ

### From SwiftSerial
- https://www.xanthium.in/Serial-Port-Programming-on-Linux
    - Book rec: [Serial Programming Guide for POSIX Operating Systems by Michael Sweet](https://www.msweet.org/serial/serial.html)
- https://chrisheydrick.com/2012/06/17/how-to-read-serial-data-from-an-arduino-in-linux-with-c-part-3/
- Author's talk: https://www.youtube.com/watch?v=6PWP1eZo53s
