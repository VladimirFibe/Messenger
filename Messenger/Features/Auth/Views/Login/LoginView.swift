import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 30.0) {
                Image(systemName: "swift")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.blue)
                VStack {
                    TextField("Email", text: $viewModel.email)
                    SecureField("Password", text: $viewModel.password)
                }
                .font(.subheadline)
                .textFieldStyle(.roundedBorder)
                Button {
                    
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Button {
                    
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
                Divider()
                NavigationLink(destination: RegistrationView()) {
                    Text("Don't have an account? ") + Text("Sign Up").bold()
                }
            }
            .padding()
        }
    }
}

