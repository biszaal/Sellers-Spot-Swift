import Foundation

struct PostDetails: Identifiable
{
    var id: String
    var userId: String
    var postName: String
    var postImage: [String?]
    var postDescription: String
    var postPrice: Float
    var postLocation: String
    var postDate: Date
    var postLike: [String]
    var postDislike: [String]
    var postComment: [CommentDetails]
    var postSold: Bool
}

struct CommentDetails: Codable, Hashable
{
    var userId: String
    var comment: String
}
