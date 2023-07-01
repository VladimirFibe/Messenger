import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0 ..< 8) { item in
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundStyle(.secondary)
                            .overlay(
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                                    .padding(2)
                                    .background(
                                        Circle().fill(Color.white))
                                    .padding(.bottom, 2)
                                    .padding(.trailing, 2)
                                , alignment: .bottomTrailing)
                        Text("Steve")
                    }
                }
            }
        }
    }
}

#Preview {
    ActiveNowView()
}
