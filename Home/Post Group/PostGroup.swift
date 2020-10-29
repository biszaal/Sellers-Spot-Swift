//
//  ContentView.swift
//  Tokyo Sellers spot
//
//  Created by Bishal Aryal on 20/9/7.
//

import SwiftUI
import Foundation

struct PostGroup: View
{
    @ObservedObject var postObserver = PostObserver()
    @State var posts = [PostDetails]()
    @State var showSeeMore: Bool = true
    
    @Binding var searchTextField: String
    
    var body: some View
    {
        ScrollView
        {
            Spacer()
                .frame(height: 100)
            
            if posts.isEmpty
            {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.largeTitle)
            }
            else
            {
                ForEach(posts)
                { post in
                    EachPost(post: post)
                }
                
                if showSeeMore
                {
                    Button(action:
                            {
                                batchFetching()
                            })
                    {
                        Text("See more...")
                            .font(.subheadline)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(30)
                    }
                }
            }
        }
        .onAppear()
        {
            batchFetching()
        }
        
        .onChange(of: searchTextField)
        { (_) in
            posts.removeAll()
            batchFetching()
        }
    }
    
    func batchFetching()
    {
        postObserver.fetchData(searchValue: self.searchTextField, posts: self.posts)
        { newPost in
            self.posts.append(contentsOf: newPost)
        }
    }
}
