//
//  ContentView.swift
//  Messenger
//
//  Created by Артем Мерзликин on 11.02.2025.
//

import SwiftUI

struct ContentView: View{
    @StateObject var viewModel = ContentViewModel()
    var body: some View {
        
        Group{
            // Если userSession != nil значит кто-то зашел в систему
            if viewModel.userSession != nil {
                InboxView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
