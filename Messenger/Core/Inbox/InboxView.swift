

import SwiftUI

struct InboxView: View {
    @State private var showNewMessage = false
    
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
            .fullScreenCover(isPresented: $showNewMessage, content: {
                NewMessageView()
            })
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    HStack{
                        Image(systemName: "person.circle.fill")
                        
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
