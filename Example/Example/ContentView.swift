//
//  ContentView.swift
//  Example
//
//  Created by ky0me22 on 2025/04/03.
//

import SwiftUI
import CalcPicker

struct ContentView: View {
    @State var value: Double = .zero
    @State var isPresented = false

    var body: some View {
        VStack {
            Button {
                isPresented.toggle()
            } label: {
                Text("Open CalcPicker")
            }
            .calcPicker(value: $value, isPresented: $isPresented)
            Text(value.description)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
