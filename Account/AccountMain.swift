//
//  AccountMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/9.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import GoogleSignIn

struct AccountMain: View
{
    
    @State var loggedIn: Bool = UserDefaults.standard.bool(forKey: "status")
    @State var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                HStack(spacing: 30)
                {
                        NavigationLink(destination: UserDetailsView())
                        {
                            WebImage(url: URL(string: userImage))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .overlay(
                                    Circle().stroke(Color.blue, lineWidth: 1))
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading, spacing: 20)
                            {
                                Text(username)
                                    .font(.title)
                                
                                Text(userEmail)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                
                            }
                        }
                }
                .frame(height: 150)
            }
            .navigationTitle("Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
