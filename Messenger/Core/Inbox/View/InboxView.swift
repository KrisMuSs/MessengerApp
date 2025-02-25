

import SwiftUI

struct InboxView: View {
    
    @State private var showNewMessage = false
    @StateObject var viewModel = InboxViewModel()

    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ActiveNowView()
                
                List {
                    ForEach(0 ... 10, id: \.self){ message in
                        InboxRowView()
                    }
                }
                .listStyle(PlainListStyle())
                // Решает конфликт с неотображением списка в ScrollView. Видимо проблема
                // в том, что список сам по себе является прокруткой (Scroll)
                .frame(height: UIScreen.main.bounds.height - 120)
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            // Открытие экрана создания нового сообщения. Открывается поверх текущего интерфейса
            .fullScreenCover(isPresented: $showNewMessage, content: {
                NewMessageView()
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    HStack{
                        NavigationLink(value: user) {
                            CircularProfileImageView(user: user, size: .xSmall)
                        }
                        
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewMessage.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    }

                }
                
            }
        }
    }
}
#Preview {
    InboxView()
}
