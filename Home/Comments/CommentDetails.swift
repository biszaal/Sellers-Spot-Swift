import Foundation

struct CommentDetails: Identifiable, Hashable
{
    var id:String
    var userId: String
    var userComment: String
    var commentDate: Date
}
