import SwiftUI
import Firebase
import GoogleSignIn

struct UserDetailsView: View
{
    var body: some View
    {
        List
        {
            Button(action: {
                
                try! Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                
                NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
            })
            {
                Text("Logout")
                    .foregroundColor(Color(UIColor.systemRed))
            }
        }
    }
    
}
