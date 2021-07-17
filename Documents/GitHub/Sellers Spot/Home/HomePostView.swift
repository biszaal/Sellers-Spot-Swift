import SwiftUI
import SDWebImageSwiftUI

struct HomePostView: View
{
    let layout: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    @ObservedObject var postObserver = PostObserver()
    
    @State var posts = [PostDetails]()
    @State var selectedPhoto: String = ""
    @State var productSold: Bool = true
    
    @Binding var selectedTab: Int
    @Binding var searchTextField: String
    @Binding var showSearchBar: Bool
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                if !posts.isEmpty
                {
                    LazyVGrid(columns: layout, spacing: 20)
                    {
                        ForEach(posts)
                        { post in
                            NavigationLink(
                                destination:
                                    VStack
                                    {
                                        EachPost(selectedPhoto: self.$selectedPhoto, post: post, selectedTab: self.$selectedTab)
                                        
                                        Spacer(minLength: 0)
                                            
                                            .navigationBarTitle("", displayMode: .inline)
                                    }
                                    
                                    .onAppear()
                                    {
                                        withAnimation
                                        {
                                            self.showSearchBar = false
                                        }
                                    }
                                    .onDisappear()
                                    {
                                        withAnimation
                                        {
                                            self.showSearchBar = true
                                        }
                                    }
                            )
                            {
                                VStack(alignment: .leading)
                                {
                                    ZStack(alignment: .bottomTrailing)
                                    {
                                        WebImage(url: URL(string: post.postImage[0]!))
                                            .resizable()
                                            .frame(height: UIScreen.main.bounds.height / 8)
                                            .cornerRadius(10)
                                        
                                        if post.postSold
                                        {
                                            Text("Sold")
                                                .font(.body)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)
                                                .colorInvert()
                                                .padding(.horizontal)
                                                .background(Color.red)
                                                .cornerRadius(10)
                                        }
                                        
                                        
                                    }
                                    
                                    Text(String(post.postName))
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                    
                                    Text("$" + String(post.postPrice))
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.largeTitle)
                }
            }
            .padding(.horizontal)
            
            .navigationTitle("")
        }
        
        .onAppear
        {
            // fetching user details
            postObserver.fetchData(searchValue: searchTextField, posts: posts)
            { newPost in
                self.posts.append(contentsOf: newPost)
            }
        }
    }
}
