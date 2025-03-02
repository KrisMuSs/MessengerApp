
import SwiftUI

struct NewMessageView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = NewMessageViewModel()
    @EnvironmentObject var inboxViewModel: InboxViewModel
    
    @Binding var selectedUser: User?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView{
                TextField("To: ", text: $searchText)
                    .frame(height: 40)
                    .padding(.leading)
                    .background(Color(.systemGroupedBackground))
                
                Text("CONTACT")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ForEach(viewModel.users) { user in
                    VStack {
                        HStack {
                            CircularProfileImageView(user: user, size: .small)
                                
                            
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                
                            
                            Spacer()
                        }
                        .padding(.leading)
                        Divider()
                            .padding(.leading, 40)
                        
                    }
                    .onTapGesture {
                        selectedUser = user
                        inboxViewModel.markMessageAsRead(for: user.uid ?? "")
                        dismiss()

                        
                    }
                }
                
                
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

//#Preview {
//    NewMessageView(selectedUser: .constant(User.MOCK_USER))
//}
