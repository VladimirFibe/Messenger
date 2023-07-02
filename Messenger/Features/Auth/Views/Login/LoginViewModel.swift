import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}
