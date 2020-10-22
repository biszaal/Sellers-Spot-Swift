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
    @State private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    @State var buttonText: String = "Buy"
    @State var buttonColor: UIColor = UIColor.systemOrange
    
    @State var likePressed: Bool = false
    @State var dislikePressed: Bool = false
    @State var likes: Int = 0
    @State var dislikes: Int = 0
    
    @State var postDeleted: Bool = false
    
    var posts: PostDetails
    
    @ObservedObject var postObserver = PostObserver()
    
    var body: some View
    {
        if !postDeleted
        {
            VStack(alignment: .leading)
            {
                HStack
                {
                    VStack(alignment: .leading, spacing: 2)
                    {
                        WebImage(url: URL(string: posts.userImage))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(
                                Circle().stroke(Color.blue, lineWidth: 1))
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        
                        Text(posts.userName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5)
                    {
                        if posts.userId == userId   // if this is my post then only I can delete it
                        {
                            Button(action: deletePost)
                            {
                                Image(systemName: "trash.fill")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        
                        Text(posts.postDate.timeAgoDisplayed())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(posts.postName)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .frame(alignment: .leading)
                    .padding()
                
                Text(posts.postDescription)
                    .font(.subheadline)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack(spacing: 10)
                    {
                        ForEach(0..<posts.postImage.count)
                        { i in
                            WebImage(url: URL(string: self.posts.postImage[i]))
                                .resizable()
                                .frame(width: 200, height: 200)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                }
                
                HStack
                {
                    Button(action: didLike)
                    {
                        if likePressed
                        {
                            Text("\(likes) likes")
                                .padding(10)
                                .background(Color.secondary.opacity(0.5))
                                .cornerRadius(30)
                        }
                        else
                        {
                            Text("\(likes) likes")
                                .padding(10)
                        }
                    }
                    
                    Button(action: didDislike)
                    {
                        if dislikePressed
                        {
                            Text("\(dislikes) dislikes")
                                .padding(10)
                                .background(Color.secondary.opacity(0.5))
                                .cornerRadius(30)
                        }
                        else
                        {
                            Text("\(dislikes) dislikes")
                                .padding(10)
                        }
                        
                    }
                    
                    Spacer()
                    
                    Text("Price: $\(posts.postPrice)")
                        .foregroundColor(.primary)
                    
                }
                .font(Font.subheadline.weight(.bold))
                .foregroundColor(Color(UIColor.systemBlue))
                
                HStack
                {
                    Button(action: {
                        // when bought
                        self.buttonText = "Sold"
                        self.buttonColor = UIColor.gray
                    })
                    {
                        Text(self.buttonText)
                            .padding()
                            .lineLimit(1)
                            .frame(width: UIScreen.main.bounds.width / 3.5)
                            .foregroundColor(.white)
                            .background(Color(self.buttonColor))
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Text("Message")
                            .padding()
                            .lineLimit(1)
                            .frame(width: UIScreen.main.bounds.width / 3.5)
                            .foregroundColor(.white)
                            .background(Color(self.buttonColor))
                            .cornerRadius(20)
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            .onAppear()
            {
                if posts.postLike.contains(userId)
                {
                    likePressed = true
                    self.likes = posts.postLike.count
                }
                
                if posts.postDislike.contains(userId)
                {
                    dislikePressed = true
                    self.dislikes = posts.postDislike.count
                }
            }
        }
    }
    
    // if post is liked and click like again will remove the like, same with dislike
    // if post is disliked and click like then dislike will remove and like will add, vice versa
    
    func didLike()
    {
        if likePressed
        {
            postObserver.removeLikeDislike(postId: posts.id, userId: userId, like: true, dislike: false)
            likePressed = false
            likes -= 1
        }
        else if dislikePressed
        {
            postObserver.removeLikeDislike(postId: posts.id, userId: userId, like: false, dislike: true)
            dislikePressed = false
            dislikes -= 1
            
            postObserver.addLikeDislike(postId: posts.id, userId: userId, like: true, dislike: false)
            likePressed = true
            likes += 1
        }
        else
        {
            postObserver.addLikeDislike(postId: posts.id, userId: userId, like: true, dislike: false)
            likePressed = true
            likes += 1
        }
    }
    
    func didDislike()
    {
        if dislikePressed
        {
            postObserver.removeLikeDislike(postId: posts.id, userId: userId, like: false, dislike: true)
            dislikePressed = false
            dislikes -= 1
        }
        else if likePressed
        {
            postObserver.removeLikeDislike(postId: posts.id, userId: userId, like: true, dislike: false)
            likePressed = false
            likes -= 1
            
            postObserver.addLikeDislike(postId: posts.id, userId: userId, like: false, dislike: true)
            dislikePressed = true
            dislikes += 1
        }
        else
        {
            postObserver.addLikeDislike(postId: posts.id, userId: userId, like: false, dislike: true)
            dislikePressed = true
            dislikes += 1
        }
    }
    
    func deletePost()
    {
        // delete the post
        let database = Database.database().reference()
        database.child("posts").child(posts.id).setValue(nil)
        
        // delete the images
        let storage = Storage.storage().reference()
        for i in 0..<posts.postImage.count
        {
            storage.child("ImagesOfPosts/\(posts.userId)/\(posts.id)/image\(i).jpeg").delete { error in
                if error != nil {
                    print("Error deleting image")
                } else {
                    print("deleting images successful")
                }
            }
        }
        
        postDeleted = true
    }
}

