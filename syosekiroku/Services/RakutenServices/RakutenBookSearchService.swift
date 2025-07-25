//
//  RakutenBookSearchService.swift
//  syosekiroku

import Foundation

final class RakutenBookSearchService {

    let rakutenApplicationId = AppConfigManager.get(
        keyName: "RAKUTEN_APPLICATION_ID")

    func searchBook(isbn: String) async -> Book? {
        let baseURL =
            "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&isbn=\(isbn)&booksGenreId=001&applicationId=\(rakutenApplicationId)"

        guard let url = URL(string: baseURL) else {
            print("url生成エラー")
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(BookResponse.self, from: data)

            return result.Items.first?.Item
        } catch {
            print("error:\(error)")

            return nil
        }
    }

}
