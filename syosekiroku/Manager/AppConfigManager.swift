//
//  APIKeysManager.swift
//  syosekiroku

import Foundation

enum AppConfigManager {
    private static var config: [String: Any]? {
        return Bundle.main.object(forInfoDictionaryKey: "AppConfig") as? [String: Any]
    }
    
    static func get(keyName: String) -> Any{
        guard let key = config?[keyName] else {
            //もしapiKeyが無かった場合に強制的に終了する
            fatalError("APIキー '\(keyName)' が設定されていません")
        }
        return key
    }
    
}
