import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    let person: Person
    var body: some View {
        VStack {
            header
            sections
        }
    }
    
    var sections: some View {
        List {
            Section {
                ForEach(SettingsOptionsViewModel.allCases) { settings in
                    Label(settings.title, systemImage: settings.image)
                        .foregroundStyle(.black, settings.color)
                }
            }
            Section {
                Button("Log Out"){}
                Button("Delte Account"){}
            }
            .tint(.red)
        }
    }
    var header: some View {
        VStack {
            PhotosPicker(selection: $viewModel.selectedItem) {
                Group {
                    if let image = viewModel.profileImage {
                        image.resizable()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            }
            Text(person.username)
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}
