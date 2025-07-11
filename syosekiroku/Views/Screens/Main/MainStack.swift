//
//  MainView.swift
//  syosekiroku

import SwiftUI

struct MainStack: View {
    @EnvironmentObject var auth: AuthManager
    @State private var navigationPath: [ScreenID] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
            BookListView(navigationPath: $navigationPath)
                .navigationDestination(for: ScreenID.self) { screen in
                    switch screen {
                    case .barcordScanner:
                        BarcodeScannerView(navigationPath: $navigationPath)
                    case .profile:
                        ProfileView()
                    }
                }
        }
    }
}

#Preview {
    MainStack()
}
