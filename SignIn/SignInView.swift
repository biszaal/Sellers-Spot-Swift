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

struct SignInView: View
{
    var body: some View
    {
        VStack
        {
            GoogleSignView().frame(width: 200, height: 55)
            .shadow(radius: 10)
        }
    }
}

struct GoogleSignView: UIViewRepresentable
{
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton
    {
        let button = GIDSignInButton()
        button.colorScheme = .dark
        button.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
        
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
        
    }
}
