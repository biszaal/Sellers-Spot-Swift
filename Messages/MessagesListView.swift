//
//  MessagesListView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/10.
//

import SwiftUI

struct MessagesListView: View
{
    var data: Messages
    
    @ObservedObject var messageData = MessagesObserver()
    
    var body: some View
    {
        HStack(spacing: 12)
        {
            Image(data.userImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 12)
            {
                Text(data.username)
                
                Text(data.message)
                    .font(.caption)
            }
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            VStack
            {
                Text(data.date)
                
                Spacer()
            }
        }
        .padding(.vertical)
    }
}


struct Messages: Identifiable, Equatable
{
    var id: String
    var username: String
    var userImage: String
    var message: String
    var date: String
}

var data = [
    Messages(id: "01", username: "brownguyintokyo", userImage: "rumon", message: "What's up my bro?", date: "1996/09/04"),
    Messages(id: "02", username: "lakku", userImage: "lakku", message: "Hey my love", date: "2020/07/04"),
    Messages(id: "03", username: "bubblyQueen", userImage: "sapana", message: "Sup guys?", date: "2020/08/10"),
    Messages(id: "04", username: "stranzer", userImage: "niraj", message: "Namaskar!!!!!!!!!!!!!!!!!", date: "2020/09/03"),
    Messages(id: "05", username: "theteDon", userImage: "emon", message: "Dai, ludo khelam!", date: "2020/09/10"),
    Messages(id: "06", username: "biszaal", userImage: "user", message: "Its me the developer", date: "2020/08/30")
]
