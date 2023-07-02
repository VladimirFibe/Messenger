import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistationViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 30.0) {
            Image(systemName: "swift")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundStyle(.blue)
            
            VStack {
                TextField("Email", text: $viewModel.email)
                TextField("Username", text: $viewModel.username)
                SecureField("Password", text: $viewModel.password)
            }
            .font(.subheadline)
            .textFieldStyle(.roundedBorder)
            
            Button {
                
            } label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
            Divider()
            Button(action: {
                dismiss()
            }) {
                Text("Already have an account? ") + Text("Sign In").bold()
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

