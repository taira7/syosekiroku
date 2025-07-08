import SwiftUI
import GoogleSignInSwift

struct SigninView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        ZStack {

            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.5, green: 0.95, blue: 0.5),
                    Color(red: 0.0, green: 0.7, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.green)

                    Text("書籍録")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                }
                .padding(.top, 20)

                Divider()
                    .background(Color.green)
                    .padding(.horizontal, 40)
                    .padding(.vertical,8)

                GoogleSignInButton(
                    scheme: .light,
                    style: .wide,
                    state: .normal
                ) {
                    Task{
                        await auth.SigninWithGoogle()
                    }
                }
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                //楽天ウェブサービスのクレジット
                Link("Supported by Rakuten Developers", destination: URL(string: "https://developers.rakuten.com/")!)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .frame(maxWidth: 400,maxHeight: 360)
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    SigninView()
}
