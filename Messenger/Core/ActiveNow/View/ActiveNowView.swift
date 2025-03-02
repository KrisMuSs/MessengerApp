

import SwiftUI

struct ActiveNowView: View {
    @StateObject var viewModel = ActiveNowViewModel()
    @EnvironmentObject var inboxviewModel: InboxViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 32) {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(value: Route.chatView(user)){
                        VStack{
                            ZStack(alignment: .bottomTrailing){
                                CircularProfileImageView(user: user, size: .medium)
                                ZStack{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 18, height: 18)
                                    
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 12, height: 12)
                                    
                                    
                                }
                            }
                            Text(user.firstName)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        // Сбрасываем статус непрочитанного сообщения при переходе в чат
                        inboxviewModel.markMessageAsRead(for: user.id)
                    })
                }
            }
            .padding()
        }
    }
}
