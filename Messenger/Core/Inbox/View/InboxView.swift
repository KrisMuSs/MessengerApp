

import SwiftUI

struct InboxView: View {
    
    @State private var showNewMessage = false
    @StateObject var viewModel = InboxViewModel()
    // Переменная запомнит пользователя, которого мы тапнули, для того, чтобы перейти на другое представление
    // через главный экран, а не поверх открытое представление
    @State private var selectedUser: User?
    @State private var showChat = false
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack{
                List {
                    ActiveNowView()
                        .environmentObject(viewModel)  // Передаем inboxViewModel в дочернее представление
                        .listRowSeparator(.hidden) // Скрываем разделители
                        .listRowInsets(EdgeInsets()) // Убираем стандартные отступы
                        .padding(.vertical)
                        .padding(.horizontal, 4)
                    
                    ForEach(viewModel.recentMessages){ message in
                        HStack{
                            if viewModel.isNotRead[message.chatPartnerId] == true {
                                Circle()
                                    .foregroundStyle(.blue)
                                    .frame(width: 7, height: 7)
                                    .padding(.trailing, 8)
                            }
                            ZStack{
                                // Для того, чтобы убрать стрелку от NavigationLink ( используем ZStack, EmptyView и opacity(0.0))
                                NavigationLink(value: message) {
                                    EmptyView()
                                }.opacity(0.0)
                                InboxRowView(message: message)
                                    //.background(viewModel.isNotRead[message.chatPartnerId] == true ? Color.red : Color.clear)
                                    .onTapGesture {
                                        // Сбрасываем статус непрочитанного сообщения при переходе в чат
                                        viewModel.markMessageAsRead(for: message.chatPartnerId)
                                        selectedUser = message.user
                                        showChat = true
                                    }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())

            // При выборе пользователя появляется чат
            .onChange(of: selectedUser, perform: { newValue in
                // Если у выбранного пользователя есть значение, то чат будет отображаться
                showChat = newValue != nil
            })
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    
                    ChatView(user: user)
                }
            })
            .navigationDestination(for: Route.self, destination: { route in
                // Когда мы нажимаем NavigationLink(value: Route.profile(user)), в NavigationStack добавляется Route.profile(user)
               // navigationDestination(for: Route.self, destination:) перехватывает это значение и проверяет, какой case в Route пришёл
               // NavigationLink передает Route.profile или Route.chatView
                    switch route{
                    case .profile(let user):
                        ProfileView(user: user)
                    case .chatView(let user):
                        ChatView(user: user)
                    }
                
            })
            // Если selectedUser = nil, то мы не хотим показывать чат. (дополнительная осторожность)
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            // Открытие экрана создания нового сообщения. Открывается поверх текущего интерфейса
            .fullScreenCover(isPresented: $showNewMessage, content: {
                NewMessageView(selectedUser: $selectedUser)
                    .environmentObject(viewModel)  // Передаем inboxViewModel в дочернее представление
                
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    HStack{
                        if let user {
                            NavigationLink(value: Route.profile(user)) {
                                CircularProfileImageView(user: user, size: .xSmall)
                            }
                        }
                        
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewMessage.toggle()
                        selectedUser = nil
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
