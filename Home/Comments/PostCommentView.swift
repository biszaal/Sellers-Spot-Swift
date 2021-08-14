//
//  postComment.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 28/06/2021.
//  Copyright © 2021 Bishal Aryal. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct PostCommentView: View
{
    var comment: CommentDetails
    var postId: String
    
    @ObservedObject var userObserver = UserDataObserver()
    @State var user: UserData = UserData(id: "", name: "", email: "", image: "")
    
    @State var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
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
            
            VStack(alignment: .leading, spacing: 5)
            {
                Text(comment.userComment)
                    .font(.subheadline)
                    .lineLimit(nil)
                
                Text(comment.commentDate.timeAgoDisplayed())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer(minLength: 0)
            
            if comment.userId == myId   // if this is my post then only I can delete it
            {
                Button(action: { deleteComment() })
                {
                    Image(systemName: "trash.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            
            else
            {
                Button(action: { /* Report Comment */ })
                {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding()
                }
            }
        }
        .padding()
        .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
        .padding(.leading, 20)
        
        
        .onAppear()
        {
            userObserver.getUserDetails(id: self.comment.userId)
            { user in
                self.user = user
            }
            
        }
    }
    
    func deleteComment()
    {
        let database = Database.database().reference()
        database.child("posts").child(postId).child("postComments").child(comment.id).setValue(nil)
    }
}
