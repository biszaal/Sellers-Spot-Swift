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
    @ObservedObject var posts = PostObserver()
    @State var numberOfPosts:UInt = 10
    @State var showSeeMore: Bool = true
    
    @State var searchTextField: String = ""
    
    var body: some View
    {
        ScrollView
        {
            Spacer()
                .frame(height: 100)
            
            ForEach(posts.posts)
            { post in
                EachPost(posts: post)
            }
            
            if showSeeMore
            {
                Button(action:
                        {
                            numberOfPosts += 10
                            posts.fetchData(numberOfPosts, searchValue: searchTextField)
                            searchTextField = ""
                        })
                {
                    if searchTextField != ""
                    {
                        Text("Search")
                            .font(.subheadline)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(30)
                    }
                    else if !posts.posts.isEmpty
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
            posts.fetchData(numberOfPosts)
        }
    }
}
