//
//  BookListView.swift
//  syosekiroku


import SwiftUI

struct BookListView: View {
    @Binding var navigationPath:[ScreenID]
    
    @State private var isbnToImageURL: [String: URL] = [:]
    
    let rakutenBookSearchService: RakutenBookSearchService = RakutenBookSearchService()
    
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
        "9784088845104"
    ]
    
    private func loadBookImageURLs() async {
        
        for isbn in isbnList {
            if let book = await rakutenBookSearchService.searchBook(isbn: isbn){
                let url = URL(string: book.largeImageUrl)
                isbnToImageURL[isbn] = url
            }
            
            //楽天apiが1秒につき1件のリクエストのみなので1秒待機する
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
    }
    let items = Array(1...14)
    
    // 3列のグリッドレイアウト
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(isbnList, id: \.self) { isbn in
                        AsyncImage(url: isbnToImageURL[isbn]){ phase in
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
                    }
                }
                .padding(4)
            }
            .scrollIndicators(.hidden)
            .padding()
            .padding(.bottom,64)
            
            CustomWideButton(text: "スキャン", fontColor: Color.white, backgroundColor: Color.green, isDisabled: false){
                print("スキャン開始")
                navigationPath.append(.barcordScanner)
            }
            .background(Color(.systemGray6))
            
        }
        .onAppear{
            Task{
                await loadBookImageURLs()
            }
        }
    }
}

#Preview {
    @Previewable @State var navigationPath: [ScreenID] = []
    BookListView(navigationPath: $navigationPath)
}
