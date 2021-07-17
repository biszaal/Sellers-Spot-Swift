//
//  postComment.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 28/06/2021.
//  Copyright © 2021 Bishal Aryal. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCommentView: View
{
    var comment: CommentDetails
    
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var user: UserData = UserData(id: "", name: "", email: "", image: "")
    
    var body: some View
    {
        HStack
        {
            WebImage(url: URL(string: user.image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 5)
            
            Text(comment.comment)
                .font(.subheadline)
                .lineLimit(5)
                .padding()
                .frame(width: UIScreen.main.bounds.width, height: 30, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding(.leading, 20)
        }
        .onAppear()
        {
            
            userObserver.getUserDetails(id: comment.userId)
            { user in
                self.user = user
            }
        }
    }
}
