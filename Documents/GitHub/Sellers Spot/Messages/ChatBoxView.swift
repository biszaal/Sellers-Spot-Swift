import SwiftUI
import Combine

struct ChatBoxView: View
{
    var theirId: String
    var chatId: String
    
    @State var messagesData = [MessagesDataType]()
    
    @State var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var myImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    @State var theirImage: String = ""
    @State var theirName: String = ""
    
    @State var typedMessage: String = ""
    @ObservedObject var messageObserver = MessagesObserver()
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var value: CGFloat = 0
    @State var showSeeMore: Bool = true
    @State var keyboardHeight: CGFloat = 0
    @State var keyboardOn: Bool = false     // check if keyboard is appeared or not
    
    var body: some View
    {
        
        ScrollViewReader
        {   reader in
            
            VStack
            {
                VStack
                {
                    ScrollView(showsIndicators: false)
                    {
                        Button(action:
                                {
                                    batchFetching(seeMore: true)
                                })
                        {
                            Text("See more...")
                                .font(.caption)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(30)
                        }
                        ForEach(self.messagesData, id: \.self)
                        { each in
                            MessageRow(userId: each.userId, message: each.message, userImage: self.theirImage)
                        }
                        
                        .onAppear()
                        {      // scroll to the bottom when open
                            reader.scrollTo(messagesData.last!.id, anchor: .bottom)
                        }
                        
                        Spacer()
                            .frame(height: keyboardHeight)
                    }
                }
                
                HStack
                {
                    
                    TextEditor(text: $typedMessage)
                        .frame(height: 40)
                        .padding(.horizontal, 15)
                        .overlay(Capsule().stroke(Color.secondary, lineWidth: 2))
                        .onReceive(Just(typedMessage))
                        { (newValue: String) in
                            self.typedMessage = String(newValue.prefix(1000))
                        }
                    
                    Button(action:
                            {
                                self.typedMessage = typedMessage.trimmingCharacters(in: .whitespacesAndNewlines) // remove empty spaces
                                if typedMessage != ""
                                {
                                    self.messageObserver.addMessage(chatId: self.chatId, theirId: self.theirId, message: self.typedMessage)
                                }
                                self.typedMessage = ""
                                reader.scrollTo(messagesData.first?.id, anchor: .bottom)
                            })
                    {
                        Text("Send")
                    }
                }
                .navigationBarTitle(self.theirName, displayMode: .inline)
            }
            
            // hide keyboard on drag gesture
            .gesture(DragGesture().onChanged(
                        { _ in
                            if keyboardOn
                            {
                                UIApplication.shared.endEditing()
                            }
                        }))
        }
        .padding()
        
        .onAppear()
        {
            self.batchFetching()
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main)
            { (notification) in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                
                self.keyboardOn = true
                self.keyboardHeight = keyboardFrame.height
            }
            
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
            { (notification) in
                
                self.keyboardOn = false
                self.keyboardHeight = 0
            }
        }
        
    }
    
    func batchFetching(seeMore: Bool? = false)
    {
        //fetching each text messages
        messageObserver.fetchData(chatId: self.chatId, messagesData: self.messagesData)
        { messageData in
            if seeMore!
            {
                self.messagesData.insert(contentsOf: messageData, at: 0)
            }
            else
            {
                self.messagesData.append(contentsOf: messageData)
            }
        }
        
        userObserver.getUserDetails(id: self.theirId)
        { user in
            self.theirName = user.name
            self.theirImage = user.image
        }
    }
}
