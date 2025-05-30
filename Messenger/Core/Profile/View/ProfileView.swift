

import SwiftUI
import PhotosUI


struct ProfileView: View {
    @State var viewModel = ProfileViewModel()
    let user: User
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.selectedItem) {
                if let profileImage = viewModel.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    CircularProfileImageView(user: user, size: .xLarge)
                }
            }
            Text(user.fullname)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .onAppear {
            viewModel.configure(with: user)
        }
        
        
        //list
        List{
            Section{
                ForEach(SettingOptionsViewModel.allCases){ option in
                    HStack {
                        Image(systemName: option.imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(option.imageBackgroundColor)
                        
                        Text(option.title)
                            .font(.subheadline)
                    }

                }
            }
            
            Section{
                Button("Log Out"){
                    AuthService.shared.signOut()
                }
                
                Button("Delete Account"){
                    
                }
            }
            .foregroundStyle(.red)
        }
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
