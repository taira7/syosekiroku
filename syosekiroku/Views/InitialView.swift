//
//  ContentView.swift
//  syosekiroku

import SwiftUI
import Supabase

struct InitialView: View {
    @EnvironmentObject var auth: AuthManager
    var body: some View {
        Group{
            if !auth.isAuth {
                SigninView()
            } else {
                MainStack()
            }
        }
    }
}

#Preview {
    InitialView()
}
