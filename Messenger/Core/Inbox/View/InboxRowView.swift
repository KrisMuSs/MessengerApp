

import SwiftUI

struct InboxRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            CircularProfileImageView(user: User.MOCK_USER, size: .medium)

            VStack(alignment: .leading, spacing: 4){
                Text("Head Ledger")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Some text message for now")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
        //Вычисляем ширину экрана и задаем максимальную ширину frame на 100 единиц меньше ширины экрана.
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            HStack{
                Text("Yesterday")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        .frame(height: 72)
    }
}

#Preview {
    InboxRowView()
}
