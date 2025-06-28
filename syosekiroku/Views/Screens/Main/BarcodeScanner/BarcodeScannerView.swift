//
//  SwiftUIView.swift
//  syosekiroku

import SwiftUI
import VisionKit

struct BarcodeScannerView: View {
    @State private var scannedCode: String = ""
    @State private var isScannerPresented = false
    
    var body: some View {
        BarcodeScannerRepresentable { scanValue in
            print("🟦scanValue:\(scanValue)")
            scannedCode = scanValue
            isScannerPresented = true
        }
        .sheet(isPresented: $isScannerPresented) {
            ScanResultView(scannedCode: $scannedCode, isScannerPresented: $isScannerPresented)
        }
        .onChange(of: isScannerPresented) { _ , newValue in
            if newValue == false {
                scannedCode = ""
            }
        }
    }
    
}

#Preview {
    BarcodeScannerView()
}
