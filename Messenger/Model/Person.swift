import Foundation

struct Person: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let username: String
    let email: String?
    let avatar: String?
}

extension Person {
    static let MOCK_PERSON = Person(username: "macuser", email: "macuser@mail.ru", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0fjjYfJWcu4XyiNgEz08cpAqme93TePmnKXCscwJRNnMNyr4kS26iI16FctxRhW3J1Fo&usqp=CAU")
}
