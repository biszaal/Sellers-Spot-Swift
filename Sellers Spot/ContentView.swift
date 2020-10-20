//
//  ContentView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/9.
//

import SwiftUI

struct ContentView: View
{
    @State var loggedIn: Bool = UserDefaults.standard.bool(forKey: "status")
    @State var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        ZStack
        {
            if loggedIn
            {
            TabView
            {
                HomeMain().tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                MessagesMain().tabItem {
                    Image(systemName: "message.fill")
                    Text("Messages")
                }
                
                FriendsMain().tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Friends")
                }
                
                AccountMain().tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
            }
            }
            else
            {
                SignInView()
            }
        }
        .onAppear()
        {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main)
            { (_) in
                let loggedIn = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
                let username: String = UserDefaults.standard.string(forKey: "username") ?? ""
               let userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                let userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
                
                self.loggedIn = loggedIn
                self.userId = userId
                self.username = username
                self.userEmail = userEmail
                self.userImage = userImage
                
                if loggedIn
                {
                    user.addUserData(id: userId, name: username, email: userEmail, image: userImage)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
