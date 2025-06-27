//
//  MainView.swift
//  syosekiroku

import SwiftUI

struct MainStack: View {
    @State private var navigationPath: [ScreenID] = []
    var body: some View {
        NavigationStack(path: $navigationPath){
            BookListView(navigationPath: $navigationPath)
                .navigationBarTitle("Book List")
                .navigationDestination(for: ScreenID.self){ screen in
                    switch screen {
                    case .barcordScanner:
                        BarcodeScannerView()
                    }
                }
        }
    }
}

#Preview {
    MainStack()
}
