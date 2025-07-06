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

    //重複する場合は無視する
    func addUser(user: AppUser) async {
        do {
            let insertedUser: AppUser =
                try await supabase
                .from("users")
                .upsert(user, onConflict: "id", ignoreDuplicates: true)
                .select()
                .single()
                .execute()
                .value
            print("Inserted User:", insertedUser)
        } catch {
            print("Failed to insert user: \(error)")
        }
    }

    func deleteUser(userId: String) async {
        do {
            let response =
                try await supabase
                .from("users")
                .delete()
                .eq("id", value: userId)
                .execute()
            print("Deleted user with id: \(userId), status: \(response.status)")
        } catch {
            print("Failed to delete user: \(error)")
        }
    }
}
