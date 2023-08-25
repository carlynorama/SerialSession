# SerialSession

Library to make simple serial connections via a Session class. Many hobby electronics boards including [Arduino](https://www.arduino.cc) reboot every time a serial connection is opened in order to make loading code onto them easier. This means code that interacts with them needs to avoid reopening the serial ports as much as possible. 

This library currently wraps the [SwiftSerial](https://swiftpackageindex.com/yeokm1/SwiftSerial) library, a Linux and MacOS compatible library with no dependencies.  That may change over time. 

## Example Usage

### MacOS App

Find the name of your connected device via `ls /dev/cu.*`

After adding the package as a dependency it can be used directly from a View.

For more see the companion repo: 

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

