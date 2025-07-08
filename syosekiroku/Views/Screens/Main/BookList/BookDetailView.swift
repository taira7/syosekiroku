//
//  SwiftUIView.swift
//  syosekiroku

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var auth: AuthManager
    @Binding var book: BookEntity?
    @State private var isShowingDeleteAlert = false
    @Binding var isBookDetailPresented: Bool
    var onDelete: () -> Void

    var userDB: UserDatabaseService {
        UserDatabaseService(supabase: auth.supabase)
    }

    let rakutenBookSearchService: RakutenBookSearchService =
        RakutenBookSearchService()

    var bookDB: BookDatabaseService {
        BookDatabaseService(supabase: auth.supabase)
    }

    var body: some View {
        ScrollView {
            if let book = book {
                VStack(spacing: 8) {
                    AsyncImage(url: URL(string: book.coverURL)) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                ProgressView()
                            }
                            .frame(width: 200, height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 200, height: 260)
                        case .failure:
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                Text("Error")
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 240, height: 360)
                            .padding(.vertical, 4)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 4)

                    BookInfoRow(title: "タイトル：", value: book.title)
                        .padding(2)
                    BookInfoRow(title: "著者：", value: book.author)
                        .padding(2)
                    BookInfoRow(
                        title: "概要：", value: book.itemCaption
                    )
                    .padding(2)
                    BookInfoRow(title: "出版社：", value: book.publisherName)
                        .padding(2)
                    BookInfoRow(title: "発売日", value: book.salesDate)
                        .padding(2)
                    BookInfoRow(title: "ISBN：", value: book.isbn)
                        .padding(2)

                    CustomWideButton(
                        text: "登録を解除する", fontColor: Color.white,
                        backgroundColor: Color.red, isDisabled: false
                    ) {
                        isShowingDeleteAlert = true
                    }
                    .alert(
                        "登録を解除しますか？",
                        isPresented: $isShowingDeleteAlert
                    ) {
                        Button("解除する", role: .destructive) {
                            if let bookId = book.id {
                                Task {
                                    _ = await bookDB.deleteBook(bookId: bookId)
                                    onDelete()
                                    isBookDetailPresented = false
                                }
                            }
                        }
                        Button("キャンセル", role: .cancel) {}
                    }
                }
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    Text("No Image")
                        .foregroundColor(.secondary)
                }
                .frame(width: 220, height: 300)
                .padding()
                .padding(.vertical, 32)

                Text("データが取得できませんでした")
                    .font(.title2)
                    .bold()
                    .padding()
                    .padding(.vertical, 40)

            }

            CustomWideButton(
                text: "閉じる", fontColor: Color.white,
                backgroundColor: Color.gray, isDisabled: false
            ) {
                print("閉じる")
                isBookDetailPresented = false

            }
            
            //楽天ウェブサービスのクレジット
            Link("Supported by Rakuten Developers", destination: URL(string: "https://developers.rakuten.com/")!)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .padding()
    }
}

#Preview {
    @Previewable @State var book: BookEntity? = nil
    @Previewable @State var isBookDetailPresented: Bool = false
    BookDetailView(
        book: $book, isBookDetailPresented: $isBookDetailPresented, onDelete: {}
    )
    .environmentObject(AuthManager())
}
