//
//  AuthService.swift
//  syosekiroku

import Foundation
import Supabase

final class AuthService {
    
    let supabaseClient:SupabaseClient
    
    private init() {
        guard
            let supabaseURLString = AppConfigManager.get(keyName: "SUPABASE_URL") as? String,
            let supabaseAnonKey = AppConfigManager.get(keyName: "SUPABASE_ANON_KEY") as? String,
            let url = URL(string: supabaseURLString)
        else {
            fatalError("環境変数の読み込みに失敗しました")
        }
        
        self.supabaseClient = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseAnonKey
        )
    }
    
}
