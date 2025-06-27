//
//  APIKeysManager.swift
//  syosekiroku

import Foundation

enum APIKeysManager {
    private static var apiKeys: [String: Any]? {
        return Bundle.main.object(forInfoDictionaryKey: "APIKeys") as? [String: Any]
    }
    
    static func get(apiKeyName: String) -> Any{
        guard let key = apiKeys?[apiKeyName] else {
            //もしapiKeyが無かった場合に強制的に終了する
            fatalError("APIキー '\(apiKeyName)' が設定されていません")
        }
        return key
    }
    
}
