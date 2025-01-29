import SwiftUI

struct AccountView: View {
    @Binding var userId: String?
    @Binding var isLoggedIn: Bool
    @Binding var firstName: String?
    @Binding var lastName: String?
    @Binding var email: String?
    @Binding var profilePicture: UIImage?

    @State private var showDeleteAlert = false // State to handle confirmation

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Your Apple Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if let profilePicture = profilePicture {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                        .padding(.bottom, 10)
                }

                if let firstName = firstName, let lastName = lastName {
                    Text("\(firstName) \(lastName)")
                        .font(.headline)
                        .padding(.bottom, 2)
                }

                if let email = email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }

                if let userId = userId {
                    Text("User ID: \(userId)")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }

                Spacer()

                VStack(alignment: .center) {
                    Text("Your Stats")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text("No stats available yet!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .italic()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color(UIColor.systemGray3))
                .cornerRadius(10)
                .padding(.bottom, 20)

                Spacer()

                // Log Out Button
                Button(action: logOut) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.top, 10)

                // Account Deletion Button
                Button(action: { showDeleteAlert = true }) {
                    Text("Delete Account")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteAccount()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
    }

    // Log out function
    private func logOut() {
        KeychainHelper.deleteUserId()
        userId = nil
        isLoggedIn = false
    }

    // Account deletion function
    private func deleteAccount() {
        // Here you would also call the backend to delete the user account from the database
        KeychainHelper.deleteUserId()
        userId = nil
        isLoggedIn = false
    }
}
