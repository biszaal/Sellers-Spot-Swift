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
    
    @State var selectedIndex: Int = 1
    @State var newPostView: Bool = false
    @State var photoUplodingProgress: Float = 0
    @State var isUploading: Bool = false
    @State var hideTabBar: Bool = false
    
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        ZStack
        {
            if loggedIn
            {
                VStack
                {
                    
                    if selectedIndex == 1
                    {
                        HomeMain()
                    }
                    
                    if selectedIndex == 2
                    {
                        MessagesMain(hideTabBar: self.$hideTabBar)
                    }
                    
                    if selectedIndex == 3
                    {
                        FriendsMain()
                    }
                    
                    if selectedIndex == 4
                    {
                        AccountMain(hideTabBar: self.$hideTabBar)
                    }
                    
                    //MARK: Process Bar
                    if isUploading
                    {
                        ProgressView("Uploading...", value: photoUplodingProgress, total: 1)
                            .onDisappear()
                            {
                                //Refreshing the page
                                selectedIndex = 0
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                                {
                                    selectedIndex = 1
                                }
                            }
                    }
                    
                    Spacer()
                    
                    if !hideTabBar
                    {
                        CustomTabView(selectedIndex: self.$selectedIndex, newPostView: $newPostView)
                            .animation(.default)
                            .transition(.move(edge: .bottom))
                    }
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                
                .sheet(isPresented: $newPostView, content: {
                    NewPostView(newPostView: self.$newPostView, photoUplodingProgress: self.$photoUplodingProgress, isUploading: self.$isUploading)
                })
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
                
                //When logged in save the userdata
                if loggedIn
                {
                    user.addUserData(id: userId, name: username, email: userEmail, image: userImage)
                }
            }
        }
        
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
