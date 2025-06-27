//
//  SignView.swift
//  syosekiroku

import SwiftUI

struct SignView: View {
    @State var isSigninPresented: Bool = false
    @State var isSignupPresented: Bool = false
    
    var body: some View {
        
        VStack{
            
            Image(systemName:"books.vertical.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(Color.green)
                .padding()
                .padding(.bottom,8)
            
            Text("書籍録")
                .font(.largeTitle)
                .padding(.top,0)
                .padding(.bottom,100)
            
            
            CustomWideButton(
                text: "ログインする",
                fontColor: Color.white,
                backgroundColor: Color.green,
                isDisabled: false,
                action: {
                    isSigninPresented  = true
                    
                }
            )
            
            Button(action:{
                isSignupPresented = true
            },label: {
                Text("アカウントを作成する")
                    .font(.headline)
                    .foregroundColor(Color.green)
            })
            .padding(.top,28)
        }
        .fullScreenCover(isPresented: $isSigninPresented){
            SigninView(isSigninPresented: $isSigninPresented)
        }
        .fullScreenCover(isPresented: $isSignupPresented){
            SignupView(isSignupPresented: $isSignupPresented)
        }
    }
}

#Preview {
    SignView()
}
