import Foundation

class RegistationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
}
