//
//  AccountMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/9.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct AccountMain: View
{
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    @ObservedObject var imageLoader = ImageLoader()
    @State var loggedIn: Bool = UserDefaults.standard.bool(forKey: "status")
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                HStack(spacing: 30)
                {
                    if loggedIn
                    {
                        NavigationLink(destination: UserDetailsView())
                        {
                            Image("user")
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
                    else {
                        
                        NavigationLink(destination: SignInView())
                        {
                            Text("Sign Up")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                    }
                }
                .frame(height: 150)
            }
        }
        .onAppear()
        {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main)
            { (_) in
                let loggedIn = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                let username: String = UserDefaults.standard.string(forKey: "username") ?? ""
               let userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                let userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
                
                self.loggedIn = loggedIn
                self.username = username
                self.userEmail = userEmail
                self.userImage = userImage
            }
        }
    }
}

struct AccountMain_Previews: PreviewProvider {
    static var previews: some View {
        AccountMain()
    }
}
