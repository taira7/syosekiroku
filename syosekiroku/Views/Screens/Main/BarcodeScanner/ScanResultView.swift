//
//  ScanResultView.swift
//  syosekiroku

import SwiftUI

struct ScanResultView: View {
    @Binding var scannedCode: String
    @Binding var isScannerPresented: Bool

    @State private var imageURL: URL? = nil
    @State private var bookDetail: Book? = nil

    let rakutenBookSearchService: RakutenBookSearchService =
        RakutenBookSearchService()

    func fetchBookDetail(scannedCode: String) async {

        if let book = await rakutenBookSearchService.searchBook(
            isbn: scannedCode)
        {
            bookDetail = book
            //書籍の表紙画像のurlを取得
            imageURL = URL(string: book.largeImageUrl)
        } else {
            bookDetail = nil
            imageURL = nil
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if scannedCode != "" {
                    if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                    ProgressView()
                                }
                                .frame(width: 220, height: 300)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 200, height: 260)
                            case .failure:
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(.vertical, 4)

                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                            Text("No Image")
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 220, height: 300)
                        .padding(.vertical, 4)
                    }

                    Text("バーコード番号: \(scannedCode)")
                        .padding(4)

                    if let book = bookDetail {
                        VStack {

                            BookInfoRow(title: "タイトル：", value: book.title)
                                .padding(2)
                            BookInfoRow(title: "著者：", value: book.author)
                                .padding(2)
                            BookInfoRow(
                                title: "出版社：", value: book.publisherName
                            )
                            .padding(2)

                        }
                    } else {
                        Text("書籍データが見つかりません")
                            .padding(.bottom, 30)
                    }

                    CustomWideButton(
                        text: "追加する", fontColor: Color.white,
                        backgroundColor: Color.green, isDisabled: false
                    ) {
                        print("追加する")
                    }

                    CustomWideButton(
                        text: "キャンセル", fontColor: Color.white,
                        backgroundColor: Color.gray, isDisabled: false
                    ) {
                        print("キャンセル")
                        isScannerPresented = false
                    }

                } else {
                    //念の為の処理
                    Text("バーコードを読み取ってください")
                }
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            Task {
                await fetchBookDetail(scannedCode: scannedCode)
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var scannedCode: String = "9784873115658"
    @Previewable @State var isScannerPresented: Bool = false
    ScanResultView(
        scannedCode: $scannedCode, isScannerPresented: $isScannerPresented)
}
