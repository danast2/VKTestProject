import Foundation

/// Класс для загрузки отзывов.
final class ReviewsProvider {

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

}

// MARK: - Internal

extension ReviewsProvider {

    typealias GetReviewsResult = Result<Data, GetReviewsError>

    enum GetReviewsError: Error {

        case badURL
        case badData(Error)

    }
    
    
    //изменяем так, чтобы загрузка выполнялась асинхронно, не блокируя основной поток
    func getReviews(offset: Int = 0, completion: @escaping (GetReviewsResult) -> Void) {
        guard let url = bundle.url(forResource: "getReviews.response", withExtension: "json") else {
            return completion(.failure(.badURL))
        }
        
        // Асинхронно симулируем сетевой запрос, не блокируя UI
        DispatchQueue.global(qos: .background).async {
            // Симуляция задержки запроса
            usleep(.random(in: 100_000...1_000_000))
            
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.badData(error)))
                }
            }
        }
    }


}
