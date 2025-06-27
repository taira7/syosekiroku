//
//  SignupView.swift
//  syosekiroku

import SwiftUI

struct SignupView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var isSignupPresented: Bool
    @State private var isErrorPresented = false
    
    private func isInputInvalid() -> Bool {
        return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               password.trimmingCharacters(in: .whitespacesAndNewlines).count < 6
    }
    
    var body: some View {
            
        VStack{
            
            HStack{
                Spacer()
                
                Button(action: {
                    isSignupPresented = false
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20,alignment: .trailing)
                        .foregroundColor(.green)
                        .shadow(color:.green.opacity(0.3),radius: 2, x: 3, y: 3)
                        .padding(.trailing,28)
                }
            }
            .padding(.top,28)
            .padding(.bottom,40)
            
            VStack{
                Image(systemName:"books.vertical.fill")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 148, height: 148)
                    .foregroundColor(Color.green)
                    .padding(.bottom,8)
                
                Text("アカウント登録")
                    .font(.system(size: 36, weight: .medium, design: .rounded))
                    .foregroundColor(Color.green)
                    .shadow(color: .green.opacity(0.4), radius: 6)
                
                TextField(
                    text: $name,
                    prompt: Text("名前")
                ){
                    
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
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .shadow(color: .green.opacity(0.2), radius: 2)
                .keyboardType(.default)
                
                
                TextField(
                    text: $email,
                    prompt: Text("メールアドレス")
                ){
                    
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
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .shadow(color: .green.opacity(0.2), radius: 2)
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
                .padding(.horizontal, 24)
                .padding(.bottom, 80)
                .shadow(color: .green.opacity(0.2), radius: 2)
                .keyboardType(.alphabet)
                
                CustomWideButton(
                    text: "登録する",
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
    @Previewable @State var isSignupPresented: Bool = false
    SignupView(isSignupPresented: $isSignupPresented)
}
