//
//  AuthService.swift
//  syosekiroku

import Foundation
import GoogleSignIn
import Supabase

@MainActor
final class AuthService : ObservableObject{
    let supabase: SupabaseClient
    @Published var isAuth: Bool = false
    @Published var user: User? = nil
    
    init() {
        guard
            let supabaseProjectId = AppConfigManager.get(keyName: "SUPABASE_PROJECT_ID") as? String,
            let supabaseAnonKey = AppConfigManager.get(keyName: "SUPABASE_ANON_KEY") as? String,
            let supabaseURL = URL(string: "https://\(supabaseProjectId).supabase.co")
        else {
            fatalError("環境変数の読み込みに失敗しました")
        }
        
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseAnonKey
        )
        
        Task{
            await self.checkSession()
            
            for await (event, session) in supabase.auth.authStateChanges {
                switch event {
                case .signedIn:
                        isAuth = true
                        user = supabase.auth.currentUser
                case .signedOut:
                        isAuth = false
                        user = nil
                default:
                    break
                }
            }
        }
    }
    
    private func checkSession() async {
        do{
            let currentSession = try await supabase.auth.session
            let currentUser = supabase.auth.currentUser
            
            if currentUser != nil {
                isAuth = true
                user = currentUser
                print("既存のセッションがあります: \(currentUser?.email ?? "no email")")
            } else {
                isAuth = false
                user = nil
            }
        }catch{
            print("")
        }
    }

    
    func SigninWithGoogle() async {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
                print("rootViewController取得に失敗しました")
                return
            }
        
        if let clientID = AppConfigManager.get(keyName: "GIDClientID") as? String {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            fatalError("GIDClientIDが取得できません")
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
              guard let idToken = result.user.idToken?.tokenString else {
                  print("idToken取得に失敗しました")
                return
              }
              let accessToken = result.user.accessToken.tokenString
                try await supabase.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                  provider: .google,
                  idToken: idToken,
                  accessToken: accessToken
                )
              )
            
            if let user = supabase.auth.currentUser {
                print("user", user)
            } else {
                print("Supabase currentUserがnil です")
            }

        }catch{
            print("error:\(error.localizedDescription)")
        }
        
    }
    
    func signOut() async {
        do{
            try await supabase.auth.signOut()
            print("サインアウトしました")

        }catch{
            print("サインアウトできませんでした")
        }
    }
    
}
