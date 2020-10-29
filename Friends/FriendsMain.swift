//
//  FriendsMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on २०/१०/१२.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct FriendsMain: View
{
    @State var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    @ObservedObject var message = MessagesObserver()
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var users = [UserData]()
    @State var searchTextField: String = ""
    
    var body: some View
    {
        VStack()
        {
            HStack
            {
                Image(systemName: "magnifyingglass")
                    .padding()
                    .foregroundColor(.secondary)
                
                TextField("Search", text: $searchTextField)
                    .onReceive(Just(searchTextField))
                    { (newValue: String) in
                        self.searchTextField = String(newValue.prefix(20))
                    }
                
            }
            .frame(height: 50, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .padding(.horizontal, 20)
            
            List(users)
            {   each in
                HStack
                {
                    WebImage(url: URL(string: each.image))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .overlay(
                            Circle().stroke(Color.blue, lineWidth: 1))
                        .shadow(radius: 5)
                    
                    Text(each.name)
                        .font(.body)
                }
                .onTapGesture
                {
                    message.addMessage(chatId: UUID().uuidString, userId: myId, SendToId: each.id, message: "Hello")
                }
            }
        }
        .onAppear()
        {
            userObserver.fetchData()
            { user in
                users.append(contentsOf: user)
            }
        }
        
        .onChange(of: searchTextField) { (_) in
            if searchTextField != ""
            {
                print("not empty")
            }
        }
    }
}
