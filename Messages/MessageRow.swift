//
//  MessageRow.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/10.
//

import SwiftUI

struct MessageRow: View
{
    @State var myId: String = UserDefaults.standard.string(forKey: "username")!
    
    @State var userImage: String = ""
    
    var userId: String
    var sendToId: String
    var message: String
    
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        HStack
        {
            if myId == userId
            {
                Spacer()
                
                Text(message)
                    .padding(8)
                    .background(Color(UIColor.systemTeal))
                    .cornerRadius(6.0)
                
                Image(userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 5)
            }
            else
            {
                Image(userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 5)
                
                Text(message)
                    .padding(8)
                    .background(Color(UIColor.systemGreen))
                    .cornerRadius(6.0)
                
                Spacer()
                
            }
        }
        
    }
}
