

import SwiftUI

struct ProfileView: View {
    var body: some View {
        //header
        VStack{
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(Color(.systemGray4))
        }
        
        
        //list
        List{
            Section{
                ForEach(0 ... 5, id: \.self){ option in
                    HStack {
                        Image(systemName: "bell.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.systemPurple))
                        
                        Text("Notification")
                    }

                }
            }
            
            Section{
                Button("Log Out"){
                    
                }
                
                Button("Delete Account"){
                    
                }
            }
            
        }
    }
}

#Preview {
    ProfileView()
}
