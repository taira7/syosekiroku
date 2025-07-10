//
//  AuthService.swift
//  syosekiroku

import Foundation
import GoogleSignIn
import Supabase

@MainActor
final class AuthManager: ObservableObject {
    @Published var supabase: SupabaseClient
    @Published var isAuth: Bool = false
    @Published var user: AppUser? = nil
    init() {
        guard
            let supabaseProjectId = AppConfigManager.get(
                keyName: "SUPABASE_PROJECT_ID") as? String,
            let supabaseAnonKey = AppConfigManager.get(
                keyName: "SUPABASE_ANON_KEY") as? String,
            let supabaseURL = URL(
                string: "https://\(supabaseProjectId).supabase.co")
        else {
            fatalError("環境変数の読み込みに失敗しました")
        }

        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseAnonKey
        )
    }

    func SigninWithGoogle() async {

        guard
            let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let rootViewController = windowScene.windows.first?
                .rootViewController
        else {
            print("rootViewController取得に失敗しました")
            return
        }

        if let clientID = AppConfigManager.get(keyName: "GIDClientID")
            as? String
        {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(
                clientID: clientID)
        } else {
            fatalError("GIDClientIDが取得できません")
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController)
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

            if let authUser = supabase.auth.currentUser {
                let appUser = AppUser(from: authUser)
                user = appUser
                let userDB = UserDatabaseService(supabase: supabase)
                await userDB.addUser(user: appUser)
            } else {
                print("Supabase currentUserがnil です")
            }

        } catch {
            print("error:\(error.localizedDescription)")
        }

    }

    func signOut() async {
        do {
            try await supabase.auth.signOut()
            user = nil
            isAuth = false
        } catch {
            print("サインアウトできませんでした")
        }
    }

}
