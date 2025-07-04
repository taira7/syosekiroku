//
//  syosekirokuApp.swift
//  syosekiroku

import SwiftUI
import GoogleSignIn

@main
struct syosekirokuApp: App {
    @StateObject var authManager = AuthManager()
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(authManager)
                .onOpenURL { url in
                  GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
