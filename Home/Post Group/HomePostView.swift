import SwiftUI
import SDWebImageSwiftUI

struct HomePostView: View
{
    @ObservedObject var postObserver = PostObserver()
    
    @State var posts = [PostDetails]()
    
    @State var postDeleted: Bool = false
    @State var isIpad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    @Binding var selectedTab: Int
    @Binding var searchTextField: String
    @Binding var showSearchBar: Bool
    
    var body: some View
    {
        NavigationView
        {
            ScrollView(showsIndicators: false)
            {
                if !posts.isEmpty
                {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: self.isIpad ? 2 : 1), alignment: .leading)
                    {
                        ForEach(posts)
                        { post in
                            NavigationLink(
                                destination:
                                    VStack
                                    {
                                        EachPost(post: post, selectedTab: self.$selectedTab, postDeleted: self.$postDeleted)
                                        
                                        Spacer(minLength: 0)
                                            
                                            .navigationBarTitle("", displayMode: .inline)
                                    }
                                    
                                    .onAppear()
                                    {
                                            self.showSearchBar = false
                                    }
                                    .onDisappear()
                                    {
                                            self.showSearchBar = true
                                    }
                            )
                            {
                                HStack(alignment: .top, spacing: 20)
                                {
                                    ZStack(alignment: .bottomTrailing)
                                    {
                                        WebImage(url: URL(string: post.postImage[0] ?? ""))
                                            .resizable()
                                            .frame(width: 150, height: 200)
                                            .aspectRatio(contentMode: .fill)
                                            .cornerRadius(10)
                                        
                                        if post.postSold
                                        {
                                            Text("Sold")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)
                                                .colorInvert()
                                                .padding(.horizontal)
                                                .background(Color.red)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10)
                                    {
                                        Text(String(post.postName))
                                            .lineLimit(2)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer(minLength: 0)
                                        
                                        HStack
                                        {
                                            Image(systemName: "mappin.and.ellipse")
                                            Text(post.postLocation)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        
                                        HStack
                                        {
                                            VStack(alignment: .leading, spacing: 5)
                                            {
                                                Text("\(post.postLike.count + post.postDislike.count) Ratings")
                                                    .font(.caption2)
                                                
                                                HStack
                                                {
                                                    
                                                    ForEach(getRating(postLike: post.postLike.count, postDislike: post.postDislike.count), id: \.self)
                                                    { eachRate in
                                                        if (eachRate == 1.0)
                                                        {
                                                            Image(systemName: "star.fill")
                                                        } else if (eachRate == 0.5)
                                                        {
                                                            Image(systemName: "star.leadinghalf.fill")
                                                        } else
                                                        {
                                                            Image(systemName: "star")
                                                        }
                                                    }
                                                }
                                                .font(.caption2)
                                                .foregroundColor(.yellow)
                                                
                                                Spacer(minLength: 0)
                                                
                                                Text("Rs. " + String(post.postPrice))
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)
                                            }
                                            
                                            Spacer(minLength: 0)
                                            
                                            Text(post.postDate.timeAgoDisplayed())
                                                .padding(10)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(height: 50)
                                    }
                                    .padding(.vertical)
                                }
                                .frame(height: 200, alignment: .leading)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.largeTitle)
                }
            }
            
            .navigationTitle("")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear
        {
            // fetching user details
            postObserver.fetchData(searchValue: searchTextField, posts: posts)
            { newPost in
                self.posts.append(contentsOf: newPost)
            }
        }
    }
    
    func getRating(postLike: Int, postDislike: Int) -> [Float]
    {
        var totalReaction: Int = postLike + postDislike
        
        totalReaction = (totalReaction == 0) ? 1 : totalReaction // preventing denominator from becoming 0
        
        let rating: Float = (Float(postLike) / Float(totalReaction)) * 5
        
        let roundedNumber: Int = Int(rating.rounded())
        
        let nonRoundedNumber: Float = rating - Float(roundedNumber)
        
        var ratingArray: [Float] = [0, 0, 0, 0, 0]
        
        for i in 0..<roundedNumber {
            ratingArray[i] = 1
        }
        
        if (nonRoundedNumber != 0) {
            ratingArray[roundedNumber] = 0.5
        }
        
        return ratingArray
    }
}
