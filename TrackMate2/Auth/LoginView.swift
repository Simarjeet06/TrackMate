//
//  LoginView.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 27/07/25.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    var body: some View {
        VStack{
            TextField("E-mail", text: $email)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            
            Button {
                Task{
                    do{
                        try await AuthService.shared.magicLinkLogin(email: email)
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Login")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(.yellow)
                    .clipShape(Capsule())
            }
            .disabled(email.count < 7)

        }
        .padding()
        .onOpenURL { url in
            Task{
                do{
                    try  await AuthService.shared.handleOpenURL(url)
                }
                catch{
                    print(error.localizedDescription)
                }
                }
            }
        }
    }

#Preview {
    LoginView()
}
