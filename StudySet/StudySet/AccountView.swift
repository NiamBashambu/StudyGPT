struct AccountView: View {
    @Binding var userId: String? // User ID passed from ContentView
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            Text("Your Apple Account")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            if let userId = userId {
                Text("User ID: \(userId)")
                    .font(.subheadline)
                    .padding(.bottom, 20)
            }

            Button(action: {
                // Log out action: Clear Keychain and reset login state
                KeychainHelper.deleteUserId()
                userId = nil
                isLoggedIn = false
            }) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }
}