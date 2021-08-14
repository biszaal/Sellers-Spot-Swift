
struct UserData: Identifiable
{
    var id: String
    var name: String
    var email: String
    var image: String
}

struct RatingData: Identifiable
{
    var id: String
    var rate: Int
    var comment: String
}
