import Supabase
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        VStack(spacing: 20) {
            if let user = auth.user {
                if let avatarValue = user.userMetadata["avatar_url"],
                    let avatarURLString = avatarValue.stringValue,
                    let url = URL(string: avatarURLString)
                {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        case .failure:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                        Text("No Image")
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 120, height: 120)
                    .shadow(radius: 5)
                }

                Text(user.userMetadata["full_name"]?.stringValue ?? "名前なし")
                    .font(.title)
                    .fontWeight(.bold)

                Text(user.userMetadata["email"]?.stringValue ?? "メールアドレス未設定")
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)

                Text("ゲスト")
                    .font(.title)
                    .fontWeight(.bold)

                Text("未ログイン")
                    .foregroundColor(.secondary)
            }

            Spacer()

            CustomWideButton(
                text: "ログアウト", fontColor: .white,
                backgroundColor: .red, isDisabled: false
            ) {
                Task {
                    await auth.signOut()
                }
            }
        }
        .padding()
        .navigationTitle("プロフィール")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthManager())
    }
}
