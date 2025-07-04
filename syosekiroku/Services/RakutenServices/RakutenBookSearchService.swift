//
//  RakutenBookSearchService.swift
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

final class RakutenBookSearchService {
    
    let rakutenApplicationId = AppConfigManager.get(keyName: "RAKUTEN_APPLICATION_ID")
    
    func searchBook(isbn: String) async -> Book?{
        let baseURL = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&isbn=\(isbn)&booksGenreId=001&applicationId=\(rakutenApplicationId)"
        
        guard let url = URL(string: baseURL) else {
            print("url生成エラー")
            return nil
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(BookResponse.self,from: data)
            
//            print("レスポンス: \(String(data: data, encoding: .utf8) ?? "")")
            
            return result.Items.first?.Item
        }catch{
            print("error:\(error)")
            
            return nil
        }
    }
    
}
