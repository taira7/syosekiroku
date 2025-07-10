//
//  SwiftUIView.swift
//  syosekiroku

import SwiftUI
import VisionKit

struct BarcodeScannerView: View {
    @Binding var navigationPath: [ScreenID]
    @State private var scannedCode: String = ""
    @State private var isScannerPresented = false

    var body: some View {
        ZStack {
            BarcodeScannerRepresentable { scanValue in
                scannedCode = scanValue
                isScannerPresented = true
            }
            .sheet(isPresented: $isScannerPresented) {
                ScanResultView(
                    scannedCode: $scannedCode,
                    isScannerPresented: $isScannerPresented,
                    onClose: { navigationPath = [] })
            }
            .onChange(of: isScannerPresented) { _, newValue in
                if newValue == false {
                    scannedCode = ""
                }
            }

            // 枠線のガイド
            Rectangle()
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 300, height: 200)
                .opacity(0.8)
        }
        .navigationTitle("スキャン")
        .navigationBarTitleDisplayMode(.inline)
    }

}
