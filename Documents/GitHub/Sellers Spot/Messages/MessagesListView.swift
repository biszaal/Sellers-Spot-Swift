import SwiftUI
import SDWebImageSwiftUI

struct MessagesListView: View
{
    var message: MessagesDetails
    var body: some View
    {
        HStack(spacing: 12)
        {
            WebImage(url: URL(string: message.userImage))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 12)
            {
                Text(message.userName)
                
                Text(message.message)
                    .font(.caption)
            }
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            VStack
            {
                Text(message.time.timeAgoDisplayed())
                    .font(.caption)
                
                Spacer()
            }
        }
        .padding(.vertical)
    }
}
