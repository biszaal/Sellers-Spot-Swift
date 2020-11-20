import SwiftUI
import SDWebImageSwiftUI

struct MessageRow: View
{
    var userId: String
    var message: String
    var userImage: String
    
    @State var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var myImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        HStack
        {
            if myId == userId
            {
                Spacer()
                
                Text(message)
                    .padding(8)
                    .background(Color(UIColor.systemTeal))
                    .cornerRadius(6.0)
                
                WebImage(url: URL(string: myImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
            }
            else
            {
                WebImage(url: URL(string: userImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle().stroke(Color.blue, lineWidth: 1))
                
                Text(message)
                    .padding(8)
                    .background(Color(UIColor.systemGreen))
                    .cornerRadius(6.0)
                
                Spacer()
                
            }
        }
    }
}
