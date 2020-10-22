//
//  MessagesMain.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/8.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessagesMain: View
{
    @State private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
            NavigationView
            {
                List(user.userData)
                {   each in

                    NavigationLink(destination: ChatBoxView(userId: userId, sendToId: each.id))
                    {
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
                    }
                }
                .navigationTitle("Messages")
            }
            .onAppear()
            {
                user.fetchData()
            }
        
//        Text("😉 Coming Soon...")
//            .font(.largeTitle)
//            .foregroundColor(.yellow) // everytime users sees this will be different color
//        
    }
}
