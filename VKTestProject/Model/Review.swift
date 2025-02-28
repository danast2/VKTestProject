/// Модель отзыва.
/// Модель отзыва.
struct Review: Decodable {
    let firstName: String
    let lastName: String
    let text: String
    let created: String
    let rating: Int
    let avatarURL: String?
}
