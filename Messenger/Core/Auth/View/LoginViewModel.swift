import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}
