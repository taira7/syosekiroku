//
//  User.swift
//  syosekiroku

import Foundation
import Supabase

//今後のユーザー情報の拡張(好きなジャンルやSNS要素の追加など)のために作成しておく
struct AppUser: Identifiable, Codable {
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

extension AppUser {
    init(from authUser: Auth.User) {
        self.id = authUser.id.uuidString
        self.email = authUser.email ?? ""
        self.name = authUser.userMetadata["name"]?.stringValue ?? "名前なし"
        self.iconURL = authUser.userMetadata["avatar_url"]?.stringValue ?? "メールアドレス未設定"
        self.createdAt = authUser.createdAt
    }
}
