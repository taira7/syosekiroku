//
//  SwiftUIView.swift
//  syosekiroku

import SwiftUI
import VisionKit

struct BarcodeScannerView: View {
    @State private var scannedCode: String?
    @State private var isPresentingScanner = false
    
    var imageURL: URL? {
        guard let code = scannedCode else { return nil }
        return URL(string: "https://ndlsearch.ndl.go.jp/thumbnail/\(code).jpg")
    }
    
    
    var body: some View {
        if scannedCode != nil {
            AsyncImage(url: imageURL){ phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    // 失敗時の代替イメージ
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                @unknown default:
                    //別のケースが追加された時
                    EmptyView()
                }
            }
        }
        
        VStack(spacing: 20) {
            if let code = scannedCode {
                Text("読み取ったバーコード: \(code)")
                    .padding()
            } else {
                Text("バーコードを読み取ってください")
            }
            
            Button("バーコードをスキャン") {
                isPresentingScanner = true
            }
            .sheet(isPresented: $isPresentingScanner) {
                BarcodeScannerRepresentable { scanValue in
                    print("🟦scanValue:\(scanValue)")
                    self.scannedCode = scanValue
                    isPresentingScanner = false
                }
            }
        }
        .padding()
    }
    
}

#Preview {
    BarcodeScannerView()
}
