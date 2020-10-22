import Foundation

struct PostDetails: Identifiable, Equatable
{
    var id: String
    var userId: String
    var userName: String
    var userImage: String
    var postName: String
    var postImage: [String]
    var postDescription: String
    var postPrice: String
    var postLocation: String
    var postDate: Date
    var postLike: [String]
    var postDislike: [String]
}
