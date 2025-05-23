

import SwiftUI

struct InboxRowView: View {
    let message: Message
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            CircularProfileImageView(user: message.user, size: .medium)

            VStack(alignment: .leading, spacing: 4){
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
        //Вычисляем ширину экрана и задаем максимальную ширину frame на 100 единиц меньше ширины экрана.
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            HStack{
                Text(message.timestampString)
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        .frame(height: 72)
        .swipeActions {
                   Button(role: .destructive) {
                       ChatService(chatPartner: message.user!).deleteChat()
                   } label: {
                       Label("Delete", systemImage: "trash")
                   }
               }
    }
}
