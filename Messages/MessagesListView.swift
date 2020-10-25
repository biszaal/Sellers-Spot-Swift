import SwiftUI
import SDWebImageSwiftUI

struct MessagesListView: View
{
    var userId: String
    var message: String
    var time: Date
    
    @State var userName: String = ""
    @State var userImage: String = ""
    
    @ObservedObject var userObserver = UserDataObserver()
    
    var body: some View
    {
        HStack(spacing: 12)
        {
            WebImage(url: URL(string: userImage))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 12)
            {
                Text(userName)
                
                Text(message)
                    .font(.caption)
            }
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            VStack
            {
                Text(time.timeAgoDisplayed())
                
                Spacer()
            }
        }
        .padding(.vertical)
        
        .onAppear()
        {
            userObserver.getUserDetails(id: userId)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) // waiting one second so the data can load
            {
                self.userName = userObserver.userDetails.name
                self.userImage = userObserver.userDetails.image
                
            }
        }
    }
}


struct Messages: Identifiable, Equatable
{
    var id: String
    var userOne: String
    var userTwo: String
    var message: String
    var time: Date
}
