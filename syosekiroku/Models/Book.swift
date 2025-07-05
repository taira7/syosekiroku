//
//  Book.swift
//  syosekiroku

import Foundation

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

struct BookEntity: Identifiable, Codable {
    let id: Int64
    let userId: String
    let isbn: String
    let title: String
    let coverURL: String
    let isFavorite: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case isbn
        case title
        case coverURL = "cover_url"
        case isFavorite = "is_favorite"
        case createdAt = "created_at"
    }
}

extension BookEntity {
    init(from apiBook: Book, userId: String) {
        self.id = 0 // Supabaseでauto increment
        self.userId = userId
        self.isbn = apiBook.isbn
        self.title = apiBook.title
        self.coverURL = apiBook.largeImageUrl
        self.isFavorite = false
        self.createdAt = Date()
    }
}
