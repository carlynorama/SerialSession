# SerialSession

Library to make simple serial connections via a Session class. Many hobby electronics boards including [Arduino](https://www.arduino.cc) reboot every time a serial connection is opened in order to make loading code onto them easier. This means code that interacts with them needs to avoid reopening the serial ports as much as possible. 

This library currently wraps a fork of the [SwiftSerial](https://swiftpackageindex.com/yeokm1/SwiftSerial) library, a Linux and MacOS compatible library with no dependencies.  That may change over time.  I liked it because it uses very standard C commands. Tried to find some useful links about them to put in the resources. 

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



## Example Usage

### MacOS App

Find the name of your connected device via `ls /dev/cu.*`

After adding the package as a dependency it can be used directly from a View.

For more see the companion repo: https://github.com/carlynorama/SerialSessionUI

```swift
import SwiftUI
import SerialSession

struct ContentView: View {
    @StateObject var serialSession:SimpleSerialSession = SimpleSerialSession(portName: "/dev/cu.usbmodem1101")
    
    var body: some View {
        TabView {
            WriteView()
            ReadView()
        }.environmentObject(serialSession)
    }
}
```


```swift
struct WriteView: View {
    @EnvironmentObject var serialWriter:SimpleSerialSession
    
        @State var brightness:Double = 0.5
        var body: some View {
            VStack {
                Slider(value: $brightness) { editing in
                    if !editing {
                        let val = UInt8(brightness * 255)
                        print(val)
                        serialWriter.sendByte(val)
                    }
                }
            }
            .padding()
        }
}
```

```swift
import SwiftUI
import SerialSession

struct ReadView: View {
    @EnvironmentObject var serialReader:SimpleSerialSession
    
    @State var reading:String = ""
    var body: some View {
        VStack {
            Text("\(reading)")
            Button("Read") {
                updateText()
            }
        }
        .padding()
    }
    
    func updateText() {
        let result = serialReader.readBytes(count: 256)
        switch result {
        case .success(let message):
            reading = String(data: message, encoding: .utf8)!
        case .failure(let error):
            print(error)
        }
    }
```

