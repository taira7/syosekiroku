//
//  WideButton.swift
//  syosekiroku

import SwiftUI

struct CustomWideButton: View {
    let text: String
    let fontColor: Color
    let backgroundColor: Color
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action,label: {
            Text(text)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(backgroundColor)
                .foregroundColor(fontColor)
                .cornerRadius(10)
                .padding(.horizontal,20)
                .padding(.vertical,8)
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.8 : 1.0)
    }
}
