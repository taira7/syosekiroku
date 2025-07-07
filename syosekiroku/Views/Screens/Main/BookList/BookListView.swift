//
//  BookListView.swift
//  syosekiroku

import SwiftUI

struct BookListView: View {
    @EnvironmentObject var auth: AuthManager
    @Binding var navigationPath: [ScreenID]

    @State private var isbnToImageURL: [String: URL] = [:]
    @State private var books: [BookEntity] = []
    @State private var isLoading = false

    let rakutenBookSearchService: RakutenBookSearchService =
        RakutenBookSearchService()

    var bookDB: BookDatabaseService {
        BookDatabaseService(supabase: auth.supabase)
    }

    // 3列のグリッドレイアウト
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {

        ZStack(alignment: .bottom) {
            ScrollView {
                if isLoading {
                    ProgressView("読み込み中...")
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(books) { book in
                            Button {
                                print("book", book)
                            } label: {
                                if let url = URL(string: book.coverURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ZStack {
                                                Rectangle()
                                                    .fill(
                                                        Color.gray.opacity(0.2)
                                                    )
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
                    }
                    .padding(4)
                }
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
        .onAppear {
            if let userId = auth.user?.id {
                Task {
                    isLoading = true
                    books = await bookDB.fetchAllBooks(userId: userId)
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var navigationPath: [ScreenID] = []
    BookListView(navigationPath: $navigationPath)
}
