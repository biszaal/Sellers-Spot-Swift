import Foundation

struct PostDetails: Identifiable
{
    var id: String
    var userId: String
    var postName: String
    var postImage: [String?]
    var postDescription: String
    var postCategory: String
    var postPrice: Float
    var postLocation: String
    var postDate: Date
    var postLike: [String]
    var postDislike: [String]
    var postSold: Bool
}
