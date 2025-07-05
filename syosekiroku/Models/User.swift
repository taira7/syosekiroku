//
//  User.swift
//  syosekiroku

import Foundation
import Supabase

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let iconURL: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case iconURL = "icon_url"
        case createdAt = "created_at"
    }
}

extension User {
    init(from authUser: Auth.User) {
        self.id = authUser.id.uuidString
        self.email = authUser.email ?? ""
        self.name = authUser.userMetadata["name"]?.stringValue ?? "名前なし"
        self.iconURL = authUser.userMetadata["avatar_url"]?.stringValue ?? "メールアドレス未設定"
        self.createdAt = Date()
    }
}
