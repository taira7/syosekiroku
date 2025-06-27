//
//  SigninView.swift
//  syosekiroku

import SwiftUI

struct SigninView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var isSigninPresented: Bool
    @State private var isErrorPresented = false
    
    private func isInputInvalid() -> Bool {
        return email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        password.trimmingCharacters(in: .whitespacesAndNewlines).count < 6
    }
    var body: some View {

        VStack{
            
            HStack{
                Spacer()
                
                Spacer()
                
                Button(action: {
                    isSigninPresented = false
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20,alignment: .trailing)
                        .foregroundColor(.green)
                        .shadow(color:.green.opacity(0.3),radius: 2, x: 3, y: 3)
                        .padding(.trailing,28)
                }
            }
            .padding(.top,0)
            .padding(.bottom,80)
            
            VStack{
                
                Image(systemName:"books.vertical.fill")
                    .resizable()
                    .frame(width: 148, height: 148)
                    .foregroundColor(Color.green)
                    .padding(.bottom,8)
                Text("ログイン")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .foregroundColor(Color.green)
                    .shadow(color: .green.opacity(0.3), radius: 2, x: 3, y: 3)
                
                
                
                TextField(
                    text: $email,
                    prompt: Text("メールアドレス")
                ){}
                    .font(.system(size: 20))
                    .padding(12)
                    .padding(.leading,8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green.opacity(0.6), lineWidth: 2)
                    )
                    .shadow(color: .green.opacity(0.2), radius: 2)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .keyboardType(.emailAddress)
                
                
                SecureField(
                    text: $password,
                    prompt: Text("パスワード(6文字以上)")
                ) {
                }
                .font(.system(size: 20))
                .padding(12)
                .padding(.leading,8)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green.opacity(0.6), lineWidth: 2)
                )
                .shadow(color: .green.opacity(0.2), radius: 2)
                .padding(.horizontal, 24)
                .padding(.bottom, 80)
                .keyboardType(.alphabet)
                
                CustomWideButton(
                    text: "ログイン",
                    fontColor: Color.white,
                    backgroundColor: Color.green,
                    isDisabled: isInputInvalid(),
                    action: {
                    }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .alert("エラー",isPresented: $isErrorPresented){
            Button("OK",role: .cancel){
//                authService.errorMessage = nil
            }
        } message: {
//            Text(authService.errorMessage ?? "")
        }
    }
}

#Preview {
    @Previewable @State var isSigninPresented: Bool = false
    SigninView(isSigninPresented: $isSigninPresented)
}
