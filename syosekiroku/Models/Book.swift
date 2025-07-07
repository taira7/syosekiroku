//
//  Book.swift
//  syosekiroku

import Foundation

// apiから取得する構造
struct BookResponse: Decodable {
    let Items: [BookWrapper]
}

struct BookWrapper: Decodable {
    let Item: Book
}

struct Book: Decodable {
    let author: String
    let isbn: String
    let itemCaption: String
    let largeImageUrl: String
    let publisherName: String
    let salesDate: String
    let title: String
}

// データベースで扱う構造体
struct BookEntity: Identifiable, Codable {
    let id: Int64?
    let userId: String
    let isbn: String
    let author: String
    let itemCaption: String
    let title: String
    let coverURL: String
    let publisherName: String
    let salesDate: String
    let isFavorite: Bool
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case isbn
        case author
        case itemCaption = "item_caption"
        case title
        case coverURL = "cover_url"
        case publisherName = "publisher_name"
        case salesDate = "sales_date"
        case isFavorite = "is_favorite"
        case createdAt = "created_at"
    }
}

extension BookEntity {
    init(from apiBook: Book, userId: String) {
        self.id = nil  // Supabaseでauto increment
        self.userId = userId
        self.isbn = apiBook.isbn
        self.author = apiBook.author
        self.itemCaption = apiBook.itemCaption
        self.title = apiBook.title
        self.coverURL = apiBook.largeImageUrl
        self.publisherName = apiBook.publisherName
        self.salesDate = apiBook.salesDate
        self.isFavorite = false
        self.createdAt = nil
    }
}
