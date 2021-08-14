import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct EachNotification: View
{
    var notification: NotificationDetails
    
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var postImage: String = ""
    @State var user: UserData = UserData(id: "", name: "", email: "", image: "")
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 5)
        {
            HStack(alignment: .center, spacing: 5)
            {
                WebImage(url: URL(string: user.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 5)
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: 10)
                {
                    Text(user.name + " " + notification.event + " on your post.")
                        .font(.body)
                    
                    Text(notification.time.timeAgoDisplayed())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 0)
                
                WebImage(url: URL(string: postImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(5)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width / 1.1, height: 100)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        
        .onAppear()
        {
            userObserver.getUserDetails(id: notification.uid)
            { user in
                self.user = user
            }
            
            getPostImage(postId: notification.postId)
            { imageURL in
                postImage = imageURL
            }
        }
    }
    
    func getPostImage(postId: String, completionHandler: @escaping (_ notif: String) -> ())
    {
        var returnValue = ""
        
        let ref = Database.database().reference()
        let query = ref.child("posts").child(postId).child("postImage")
        
        query.observeSingleEvent(of: .value, with: { snap in
            let value = snap.value as? [String] ?? []
            returnValue = value[0]
            
            return completionHandler(returnValue)
        })
    }
}
