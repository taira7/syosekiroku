//
//  BookListView.swift
//  syosekiroku


import SwiftUI

struct BookListView: View {
    @Binding var navigationPath:[ScreenID]
    
//デスノート　9784088736211
// リーダブルコード　9784873115658
    
//    var imageURL = URL(string: "https://ndlsearch.ndl.go.jp/thumbnail/9784873115658.jpg")
//    var imageURL = URL(string: "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/9801/9784861529801_1_6.jpg?_ex=250x250")
    
//    var imageURL = URL(string: "https://img.hanmoto.com/bd/img/9784873115658.jpg")
    
    func randomBookImageURL() -> URL? {
        let isbnList = [
            "9784873115658", // リーダブルコード
            "9784088736211", // デスノート
            "9784815601577", // その他テスト
            "9784088827315"  // アオのハコ
        ]
        
        guard let randomISBN = isbnList.randomElement() else {
            return nil
        }
        
        // 画像提供元のURLにあわせて選択
        return URL(string: "https://ndlsearch.ndl.go.jp/thumbnail/\(randomISBN).jpg")
    }
    
    var body: some View {
        let items = Array(1...14)

        // 3列のグリッドレイアウト
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(items, id: \.self) { item in
//                        AsyncImage(url: imageURL){ phase in
                        if let imageURL = randomBookImageURL(){
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
                    
                }
                .padding()
                .padding(.bottom,64)
            }
            
            CustomWideButton(text: "スキャン", fontColor: Color.white, backgroundColor: Color.green, isDisabled: false){
                print("スキャン開始")
                navigationPath.append(.barcordScanner)
            }
            .background(Color(.systemGray6))
            
        }
    }
}

#Preview {
    @Previewable @State var navigationPath: [ScreenID] = []
    BookListView(navigationPath: $navigationPath)
}
