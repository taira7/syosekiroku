//
//  ContentView.swift
//  syosekiroku


import SwiftUI

struct InitialView: View {
    @State var isAuth = true
    var body: some View {
        if !isAuth {
            SignView()
        } else if isAuth {
            MainStack()
        }
    }
}

#Preview {
    InitialView()
}
