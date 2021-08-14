import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import SDWebImageSwiftUI

struct UserDetailsView: View
{
    @ObservedObject var user = UserDataObserver()
    
    @State var loggedIn: Bool = UserDefaults.standard.bool(forKey: "status")
    @State var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    var body: some View
    {
        VStack
        {
            VStack(spacing: 20)
            {
                WebImage(url: URL(string: self.userImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                    Text(username)
                        .font(.title)
            }
            
            Spacer()
            
            //LogOut Button
            Section
            {
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()   // google log out
                    
                    LoginManager().logOut() //facebook log out
                    
                    UserDefaults.standard.set(false, forKey: "status")
                    UserDefaults.standard.set("", forKey: "userId")
                    UserDefaults.standard.set("", forKey: "username")
                    UserDefaults.standard.set("", forKey: "userImage")
                    UserDefaults.standard.set("", forKey: "userEmail")
                    
                    NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                    
                })
                {
                    Text("Logout")
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
        }
    }
    
}
