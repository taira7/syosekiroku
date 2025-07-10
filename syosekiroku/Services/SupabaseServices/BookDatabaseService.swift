//
//  BookDatabaseService.swift
//  syosekiroku

import Foundation
import Supabase

final class BookDatabaseService {
    private let supabase: SupabaseClient

    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }

    func fetchAllBooks(userId: String) async -> [BookEntity] {
        do {
            let books: [BookEntity] =
                try await supabase
                .from("books")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .execute()
                .value
            return books
        } catch {
            print("error:\(error.localizedDescription)")
            return []
        }
    }

    func addBook(book: BookEntity) async -> BookEntity? {
        do {
            let inserted: [BookEntity] =
                try await supabase
                .from("books")
                .upsert(book, onConflict: "isbn", ignoreDuplicates: true)
                .select()
                .execute()
                .value
            return inserted.first
        } catch {
            print("error:\(error.localizedDescription)")
            return nil
        }
    }

    func deleteBook(bookId: Int64) async -> Bool {
        do {
            try await supabase
                .from("books")
                .delete()
                .eq("id", value: Int(bookId))
                .execute()
            return true
        } catch {
            print("error:\(error.localizedDescription)")
            return false
        }
    }
}
