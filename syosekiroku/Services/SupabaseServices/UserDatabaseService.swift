//
//  UserDatabaseService.swift
//  syosekiroku

import Foundation
import Supabase

final class UserDatabaseService {
    private let supabase: SupabaseClient

    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }

    // 現在は使用しない
    func getUser(userId: String) async -> AppUser? {
        do {
            let user: AppUser =
                try await supabase
                .from("users")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            return user
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }

    // 既存の場合は無視する 配列で 空 or 1件のみ 返却される
    func addUser(user: AppUser) async {
        do {
            let _: [AppUser] =
                try await supabase
                .from("users")
                .upsert(user, onConflict: "id", ignoreDuplicates: true)
                .select()
                .execute()
                .value

        } catch {
            print("Failed to insert user: \(error)")
        }
    }

    func deleteUser(userId: String) async {
        do {
            let _ =
                try await supabase
                .from("users")
                .delete()
                .eq("id", value: userId)
                .execute()
        } catch {
            print("Failed to delete user: \(error)")
        }
    }
}
