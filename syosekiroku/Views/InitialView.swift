//
//  ContentView.swift
//  syosekiroku

import Supabase
import SwiftUI

struct InitialView: View {
    @EnvironmentObject var auth: AuthManager
    var supabase: SupabaseClient {
        auth.supabase
    }

    var body: some View {
        Group {
            if !auth.isAuth {
                SigninView()
            } else {
                MainStack()
            }
        }
        .task {
            // 認証状態の監視
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(
                    state.event)
                {
                    if state.session != nil {
                        auth.isAuth = true
                        if let currentUser = supabase.auth.currentUser {
                            auth.user = AppUser(from: currentUser)
                        }
                    } else {
                        auth.isAuth = false
                        auth.user = nil
                    }
                }
            }
        }
    }
}

#Preview {
    InitialView()
        .environmentObject(AuthManager())
}
