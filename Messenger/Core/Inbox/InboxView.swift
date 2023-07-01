import SwiftUI

struct InboxView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { topBarLeading }
                ToolbarItem(placement: .topBarTrailing) { topBarTrailing }
            }
        }
    }
    var topBarLeading: some View {
        HStack {
            Image(systemName: "person.circle.fill")
            Text("Chats")
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    var topBarTrailing: some View {
        HStack {
            Image(systemName: "camera.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.black, Color.black.opacity(0.04))
            Image(systemName: "square.and.pencil.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.black, Color.black.opacity(0.04))
        }
    }
}

#Preview {
    InboxView()
}
