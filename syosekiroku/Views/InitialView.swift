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
                SignView()
            } else {
                MainStack()
            }
        }
    }
}

#Preview {
    InitialView()
}
