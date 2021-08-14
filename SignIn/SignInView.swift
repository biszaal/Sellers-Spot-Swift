//
//  SignInView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/11.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKLoginKit

struct SignInView: View
{
    var body: some View
    {
        VStack(spacing:20)
        {
            Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, alignment: .center)
            
            Image("LoginImage1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .blendMode(.multiply)
            
            GoogleSignView().frame(width: 200, height: 55)
                .shadow(radius: 10)
                
            FacebookSignInView().frame(width: 100, height: 50)
                .shadow(radius: 10)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
        .ignoresSafeArea(.all)
        .background(Color.backgroundColor)
    }
}

struct GoogleSignView: UIViewRepresentable
{
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton
    {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
        
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
        
    }
}

struct FacebookSignInView: UIViewRepresentable
{
    func makeCoordinator() -> Coordinator {
        return FacebookSignInView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<FacebookSignInView>) -> FBLoginButton
    {
        let button = FBLoginButton()
        button.permissions = ["public_profile","email"]
        button.delegate = context.coordinator
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate
    {
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?)
        {
            if error != nil
            {
                print((error?.localizedDescription)!)
                return
            }
            
            if AccessToken.current != nil
            {
                let accessToken = AccessToken.current
                
                guard let accessTokenString = accessToken?.tokenString else {return}
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                
                Auth.auth().signIn(with: credential)
                { (res, err) in
                    
                    if err != nil
                    {
                        print((err?.localizedDescription)!)
                        return
                    }
                    
                    print("Facebook Login Success")
                    
                    // this uid is taken from firebase not from facebook
                    // that is why it is here not below where we get other data from facebook api
                    // we can also get the email and photoURL from here as well
                    
                    let id = res?.user.uid ?? ""
                    UserDefaults.standard.set(id, forKey: "userId")
                }
                
                GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.type(large)"]).start { (connection, results, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                                return

                            }
                    let data = results as! [String : AnyObject]
                    let email = data["email"] as? String ?? ""
                    let username = data["name"] as? String ?? ""
                    let image = data["picture"] as? NSDictionary
                    let imageData = image!["data"] as? NSDictionary
                    let imageURL = imageData!["url"] as? String ?? ""
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(imageURL, forKey: "userImage")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    
                    NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                    
                    
                }
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton)
        {
            
        }
        
        
    }
}
