# CalcPicker

Calculator Picker for iOS using SwiftUI.

![Image](https://github.com/user-attachments/assets/f6c1ddfa-cb09-492e-88a1-f5195221d7f3)

## Requirements

- Development with Xcode 16.4+
- Written in Swift 6.1
- Compatible with iOS 18.0+

## Usage

```swift
import SwiftUI
import CalcPicker

struct ContentView: View {
    @State var value = ""
    @State var isPresented = false

    var body: some View {
        VStack {
            Button {
                isPresented.toggle()
            } label: {
                Text("Open CalcPicker")
            }
            .calcPicker(value: $value, isPresented: $isPresented)
        }
        .padding()
    }
}
```

## Privacy Manifest

This library does not collect or track user information, so it does not include a PrivacyInfo.xcprivacy file.

## Demo

This repository includes demonstration app for iOS & macOS.

Open [Example/Example.xcodeproj](/Example/Example.xcodeproj) and Run it.
