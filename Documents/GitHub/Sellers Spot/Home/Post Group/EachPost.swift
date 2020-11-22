//
//  EachProduct.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/7.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseDatabase

struct EachPost: View
{
    @State private var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    @State var user: UserData = UserData(id: "", name: "", email: "", image: "")
    
    @State var productSold: Bool = false
    @State var likePressed: Bool = false
    @State var dislikePressed: Bool = false
    @State var likes: Int = 0
    @State var dislikes: Int = 0
    
    @State var postDeleted: Bool = false
    
    var post: PostDetails
    @Binding var selectedTab: Int
    
    @ObservedObject var postObserver = PostObserver()
    @ObservedObject var messageObserver = MessagesObserver()
    @ObservedObject var userObserver = UserDataObserver()
    
    var body: some View
    {
        if (!postDeleted)
        {
            VStack(alignment: .leading)
            {
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        HStack(spacing: 5)
                        {
                            WebImage(url: URL(string: self.user.image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .overlay(
                                    Circle().stroke(Color.blue, lineWidth: 1))
                                .shadow(radius: 5)
                            
                            Text(self.user.name)
                        }
                        .onAppear()
                        {
                            // fetching user details
                            userObserver.getUserDetails(id: post.userId)
                            { user in
                                self.user = user
                            }
                        }
                        
                        HStack
                        {
                            Image(systemName: "mappin.and.ellipse")
                            Text(post.postLocation)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5)
                    {
                        if post.userId == myId   // if this is my post then only I can delete it
                        {
                            Button(action: deletePost)
                            {
                                Image(systemName: "trash.fill")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        
                        Text(post.postDate.timeAgoDisplayed())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(post.postName)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .frame(alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                
                Text(post.postDescription)
                    .font(.subheadline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack(spacing: 10)
                    {
                        ForEach(0..<post.postImage.count)
                        { i in
                            WebImage(url: URL(string: (self.post.postImage[i] ?? "")))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .background(Color.secondary.colorInvert().opacity(0.5))
                                .cornerRadius(10)
                        }
                    }
                }
                
                // Like, Dislike Button
                HStack
                {
                    Button(action: didLike)
                    {
                        if likePressed
                        {
                            Text("\(likes.shorten()) 👍")
                                .padding(10)
                                .background(Color.secondary.opacity(0.5))
                                .cornerRadius(30)
                        }
                        else
                        {
                            Text("\(likes.shorten()) 👍")
                                .padding(10)
                        }
                    }
                    
                    Button(action: didDislike)
                    {
                        if dislikePressed
                        {
                            Text("\(dislikes.shorten()) 👎")
                                .padding(10)
                                .background(Color.secondary.opacity(0.5))
                                .cornerRadius(30)
                        }
                        else
                        {
                            Text("\(dislikes.shorten()) 👎")
                                .padding(10)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Price: $\(String(format: "%.2f", post.postPrice))")
                        .foregroundColor(.primary)
                    
                }
                .font(Font.subheadline.weight(.bold))
                .foregroundColor(Color(UIColor.systemBlue))
                
                //Buy, Message Button
                if post.userId != myId
                {
                    HStack
                    {
                        Button(action: {
                            // when bought
                            self.productSold = true
                        })
                        {
                            Text(self.productSold ? "Sold" : "Buy")
                                .padding(10)
                                .lineLimit(1)
                                .frame(width: 150)
                                .foregroundColor(.white)
                                .background(self.productSold ? .secondary : Color("ButtonColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(self.productSold)
                        .shadow(color: self.productSold ? .secondary : Color("ButtonColor"), radius: 5, x: 3, y: 3)
                        
                        Spacer()
                        
                        Button(action:
                                {
                                    messageObserver.addMessage(chatId: UUID().uuidString, theirId: post.userId, message: "Hi there!")
                                    selectedTab = 2
                                })
                        {
                            Text("Message")
                                .padding(10)
                                .lineLimit(1)
                                .frame(width: 150)
                                .foregroundColor(.white)
                                .background(self.productSold ? .secondary : Color("ButtonColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(self.productSold)
                        .shadow(color: self.productSold ? .secondary : Color("ButtonColor"), radius: 5, x: 3, y: 3)
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            .onAppear()
            {
                likes = post.postLike.count
                dislikes = post.postDislike.count
                
                if post.postLike.contains(myId)
                {   // fetch if user already liked
                    likePressed = true
                    self.likes = post.postLike.count
                }
                
                if post.postDislike.contains(myId)
                {
                    dislikePressed = true
                    self.dislikes = post.postDislike.count
                }
            }
        }
    }
    
    // MARK: Like
    
    // if post is liked and click like again will remove the like, same with dislike
    // if post is disliked and click like then dislike will remove and like will add, vice versa
    
    func didLike()
    {
        if likePressed
        {
            postObserver.removeLikeDislike(postId: post.id, userId: myId, like: true, dislike: false)
            likePressed = false
            likes -= 1
        }
        else if dislikePressed
        {
            postObserver.removeLikeDislike(postId: post.id, userId: myId, like: false, dislike: true)
            dislikePressed = false
            dislikes -= 1
            
            postObserver.addLikeDislike(postId: post.id, userId: myId, like: true, dislike: false)
            likePressed = true
            likes += 1
        }
        else
        {
            postObserver.addLikeDislike(postId: post.id, userId: myId, like: true, dislike: false)
            likePressed = true
            likes += 1
        }
    }
    
    // MARK: Dislike
    func didDislike()
    {
        if dislikePressed
        {
            postObserver.removeLikeDislike(postId: post.id, userId: myId, like: false, dislike: true)
            dislikePressed = false
            dislikes -= 1
        }
        else if likePressed
        {
            postObserver.removeLikeDislike(postId: post.id, userId: myId, like: true, dislike: false)
            likePressed = false
            likes -= 1
            
            postObserver.addLikeDislike(postId: post.id, userId: myId, like: false, dislike: true)
            dislikePressed = true
            dislikes += 1
        }
        else
        {
            postObserver.addLikeDislike(postId: post.id, userId: myId, like: false, dislike: true)
            dislikePressed = true
            dislikes += 1
        }
    }
    
    // MARK: Delete Post
    func deletePost()
    {
        // delete the post
        let database = Database.database().reference()
        database.child("posts").child(post.id).setValue(nil)
        
        // delete every images
        let storage = Storage.storage().reference()
        for i in 0..<post.postImage.count
        {
            storage.child("ImagesOfPosts/\(post.userId)/\(post.id)/image\(i).jpeg").delete { error in
                if error != nil {
                    print("Error deleting image")
                } else {
                    print("deleting images successful")
                }
            }
        }
        
        postDeleted = true
    }
    
    func buttonBackground() -> some View
    {
        return ZStack
        {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(self.productSold ? .secondary : Color(#colorLiteral(red: 0.01822857372, green: 0.2216099203, blue: 0.4166321754, alpha: 1)))
                .blur(radius: 4)
                .offset(y: 5)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(self.productSold ? .secondary : Color("ButtonColor"))
                .padding(3)
                .blur(radius: 2)
        }
    }
}

