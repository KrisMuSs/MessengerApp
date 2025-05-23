

import SwiftUI

struct ChatView: View {
    // @StateObject var viewModel = ChatViewModel(user: user) // Возникнет ошибка @StateObject нельзя инициализировать так
    @StateObject var viewModel: ChatViewModel
    let user: User
    
    init(user: User) {
        self.user = user
       // @StateObject требует специальной инициализации через _viewModel и присваиваивание объекта через StateObject(wrappedValue:)
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    var body: some View {
        VStack {
            ScrollView{
                // header
                VStack{
                    CircularProfileImageView(user: user, size: .xLarge)
                    
                    VStack(spacing: 4) {
                        Text(user.fullname)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        
                        Text("Messenger")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                
                // messages
                // когда пользователь прокручивает список, LazyVStack подгружает только те сообщения, которые попадают в область видимости
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        ChatMessageCell(message: message, user: user)
                }
                }
               
            }
            
            // message input view
            
            Spacer()
            ZStack(alignment: .trailing){
                // CircularProfileImageView(user: User.MOCK_USER, size: .xxSmall)
                TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                
                Button {
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
               // Модификатор .disabled(...) делает кнопку неактивной (серой и недоступной для нажатия), если переданное условие - true.
                //.trimmingCharacters(in: .whitespacesAndNewlines) Убирает все пробелы и переносы строк в начале и в конце строки.
                // .isEmpty - Проверяет, пуста ли строка после удаления пробелов и переводов строки.
                .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            }
            .padding()
        }
        .navigationTitle(user.fullname)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
