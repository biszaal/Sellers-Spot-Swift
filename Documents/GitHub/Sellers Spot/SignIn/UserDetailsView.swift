import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKLoginKit

struct UserDetailsView: View
{
        @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        List
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
