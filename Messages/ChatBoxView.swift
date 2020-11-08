import SwiftUI

struct ChatBoxView: View
{
    var chatId: String
    
    @State var messagesData = [MessagesDataType]()
    
    @State var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var theirId: String = ""
    @State var myImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    @State var theirImage: String = ""
    @State var theirName: String = ""
    
    @State var typedMessage: String = ""
    @ObservedObject var messageObserver = MessagesObserver()
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var value: CGFloat = 0
    @State var showSeeMore: Bool = true
    @State var openingViewFirstTime: Bool = false
    @State var keyboardHeight: CGFloat = 0
    
    
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
                            MessageRow(theirImage: self.theirImage, theirId: each.id, message: each.message)
                        }
                        
                        .onAppear()
                        {
                            if openingViewFirstTime
                            {       // scroll to the bottom when open
                                reader.scrollTo(messagesData.last!.id, anchor: .bottom)
                                openingViewFirstTime = false
                            }
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
                    
                    Button(action:
                            {
                                
                                self.messageObserver.addMessage(chatId: self.chatId, theirId: self.theirId, message: self.typedMessage)
                                self.typedMessage = ""
                                reader.scrollTo(messagesData.last?.id, anchor: .bottom)
                            })
                    {
                        Text("Send")
                    }
                }
                .navigationBarTitle(self.theirName, displayMode: .inline)
            }
        }
        .padding()
        
        .onAppear()
        {
            openingViewFirstTime = true
            self.batchFetching()
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main)
            { (notification) in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                
                self.keyboardHeight = keyboardFrame.height
            }
            
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
//            { (notification) in
//
//                self.keyboardHeight = 0
//            }
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
            } else
            {
                self.messagesData.append(contentsOf: messageData)
            }
        }
        
        messageObserver.fetchList(chatId: self.chatId)
        { message in
            let tempId = message.userOne
            self.theirId = tempId == myId ? message.userTwo : tempId
            
            userObserver.getUserDetails(id: self.theirId)
            { user in
                self.theirImage = user.image
                self.theirName = user.name
            }
        }
    }
}
