//
//  syosekirokuApp.swift
//  syosekiroku

import SwiftUI
import GoogleSignIn

@main
struct syosekirokuApp: App {
    @StateObject var authService = AuthService()
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(authService)
                .onOpenURL { url in
                  GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
