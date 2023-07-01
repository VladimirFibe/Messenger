import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("InstagramLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .textInputAutocapitalization(.none)
                    SecureField("Enter your password", text: $viewModel.password)
                }
                .textFieldStyle(.roundedBorder)
                
                Button(action: {}) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button(action: {}) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                
                Divider()
                    .overlay(
                        Text("OR")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .background(Color.white)
                            
                    )
                
                Image(.continueWithFacebook)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                Divider()
                NavigationLink {
                    //                    AddEmailview()
                } label: {
                    HStack(spacing: 4.0) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
