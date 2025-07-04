//
//  ContentView.swift
//  syosekiroku

import SwiftUI
import Supabase

struct InitialView: View {
    @EnvironmentObject var authService: AuthService
    var body: some View {
        Group{
            if !authService.isAuth {
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
