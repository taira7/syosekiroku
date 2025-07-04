//
//  BookListView.swift
//  syosekiroku

import SwiftUI

struct BookListView: View {
    @Binding var navigationPath: [ScreenID]

    @State private var isbnToImageURL: [String: URL] = [:]

    let rakutenBookSearchService: RakutenBookSearchService =
        RakutenBookSearchService()

    //サンプルデータ
    let isbnList = [
        "9784088827315",
        "9784088827940",
        "9784088830070",
        "9784088830636",
        "9784088831497",
        "9784088831923",
        "9784088832593",
        "9784088833897",
        "9784088834337",
        "9784088835396",
        "9784088835914",
        "9784088836904",
        "9784088837901",
        "9784088838489",
        "9784088840413",
        "9784088841335",
        "9784088842073",
        "9784088843834",
        "9784088844107",
        "9784088845104",
    ]

    let imageURLs = [
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7315/9784088827315_1_5.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7940/9784088827940_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/0070/9784088830070_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/0636/9784088830636_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/1497/9784088831497_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/1923/9784088831923_1_4.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/2593/9784088832593_1_2.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/3897/9784088833897_1_5.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/4337/9784088834337_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5396/9784088835396_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5914/9784088835914_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/6904/9784088836904_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7901/9784088837901_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/8489/9784088838489_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/0413/9784088840413_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/1335/9784088841335_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/2073/9784088842073_1_3.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/3834/9784088843834_1_10.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/4107/9784088844107_1_9.jpg?_ex=200x200",
        "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5104/9784088845104_1_11.jpg?_ex=200x200",
    ]

    //    private func loadBookImageURLs() async {
    //
    //        for isbn in isbnList {
    //            if let book = await rakutenBookSearchService.searchBook(isbn: isbn)
    //            {
    //                let url = URL(string: book.largeImageUrl)
    //                isbnToImageURL[isbn] = url
    //            }
    //
    //            //楽天apiが1秒につき1件のリクエストのみなので1秒待機する
    //            try? await Task.sleep(nanoseconds: 1_000_000_000)
    //        }
    //
    //    }

    // 3列のグリッドレイアウト
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {

        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(imageURLs, id: \.self) { url in
                        if url != "" {
                            AsyncImage(url: URL(string: url)) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 160)
                                        ProgressView()
                                    }
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(height: 160)
                                        .cornerRadius(10)
                                        .shadow(radius: 4)

                                case .failure:
                                    // 失敗時の代替イメージ
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .frame(height: 160)
                                        .padding(10)
                                @unknown default:
                                    //別のケースが追加された時
                                    EmptyView()
                                        .frame(height: 160)
                                }
                            }
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                Text("No Image")
                                    .foregroundColor(.secondary)
                            }
                            .frame(height: 160)
                        }
                    }
                }
                .padding(4)
            }
            .scrollIndicators(.hidden)
            .padding()
            .padding(.bottom, 64)

            CustomWideButton(
                text: "スキャン", fontColor: Color.white,
                backgroundColor: Color.green, isDisabled: false
            ) {
                print("スキャン開始")
                navigationPath.append(.barcordScanner)
            }
            .background(Color(.systemGray6))

        }
        .navigationTitle("Book List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        navigationPath.append(.profile)

                    },
                    label: {
                        Image(systemName: "person.circle")
                            .foregroundColor(.green)
                    })
            }
        }
        //        .onAppear {
        //            Task {
        //                await loadBookImageURLs()
        //            }
        //        }
    }
}

#Preview {
    @Previewable @State var navigationPath: [ScreenID] = []
    BookListView(navigationPath: $navigationPath)
}
