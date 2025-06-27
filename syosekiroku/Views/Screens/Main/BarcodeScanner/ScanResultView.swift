//
//  ScanResultView.swift
//  syosekiroku

import SwiftUI

struct ScanResultView: View {
    @Binding var scannedCode: String?
    @Binding var isScannerPresented: Bool
    
    var imageURL: URL? {
        guard let code = scannedCode else { return nil }
        return URL(string: "https://ndlsearch.ndl.go.jp/thumbnail/\(code).jpg")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let code = scannedCode {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                            ProgressView()
                        }
                        .frame(width: 172, height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 220, height: 300)
                    case .failure:
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding()
                
                Text("読み取ったバーコード: \(code)")
                    .padding()
                    .padding(.bottom,30)
                
                CustomWideButton(text: "追加する", fontColor: Color.white, backgroundColor: Color.green, isDisabled: false){
                    print("追加する")
                }
                
                CustomWideButton(text: "キャンセル", fontColor: Color.white, backgroundColor: Color.gray, isDisabled: false){
                    print("キャンセル")
                    isScannerPresented = false
                }
                
                
            } else {
                Text("バーコードを読み取ってください")
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var scannedCode:String? = "9784873115658"
    @Previewable @State var isScannerPresented:Bool = false
    ScanResultView(scannedCode: $scannedCode, isScannerPresented: $isScannerPresented)
}
