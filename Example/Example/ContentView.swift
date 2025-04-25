//
//  ContentView.swift
//  Example
//
//  Created by ky0me22 on 2025/04/03.
//

import SwiftUI
import CalcPicker

struct ContentView: View {
    @State var value: String = ""
    @State var isPresented = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Button {
                isPresented.toggle()
            } label: {
                Text("Open CalcPicker")
            }
            .accessibilityIdentifier("openCalcPickerButton")
            .calcPicker(value: $value, isPresented: $isPresented)
            Text(value.isEmpty ? " " : value)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            LinearGradient(
                colors: [.blue.opacity(0.3), .red.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
