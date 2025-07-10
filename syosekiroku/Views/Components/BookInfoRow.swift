//
//  BookInfoRow.swift
//  syosekiroku

import SwiftUI

struct BookInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .padding(.horizontal, 2)

        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.6), radius: 3, x: 2, y: 2)
    }
}
