//
//  MainView.swift
//  syosekiroku

import SwiftUI

struct MainStack: View {
    @EnvironmentObject var auth: AuthService
    @State private var navigationPath: [ScreenID] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            BookListView(navigationPath: $navigationPath)
                .navigationTitle("Book List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            Task{
                                await auth.signOut()
                            }
                            print("ログアウト")
                        }, label:{
                            Image(systemName: "person.circle")
                                .foregroundColor(.green)
                        })
                    }
                }
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
