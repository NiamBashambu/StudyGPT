import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var userId: String?
    
    // New: User Details
    @Binding var firstName: String?
    @Binding var lastName: String?
    @Binding var email: String?
    @Binding var profilePicture: UIImage? // Placeholder for user's image

    var body: some View {
        ZStack {
            // Background Gradient for visual appeal
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                // Logo or title image (optional)
                Image("YourLogo") // Replace with your logo asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 30)

                // Header with title
                Text("StudyPlanGPT")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .foregroundColor(.white)

                // Card for the Sign In Button
                VStack(spacing: 20) {
                    SignInWithAppleButton(
                        onRequest: { request in
                            // Configure the request
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                handleAuthorization(authResults: authResults)
                            case .failure(let error):
                                print("Sign in failed: \(error.localizedDescription)")
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white) // Ensure visibility on dark mode
                    .frame(height: 50)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                    // Additional visual elements can go here
                    Text("Sign in with Apple to continue")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 5)

                    // Optional tagline or description
                    Text("Your personalized study assistant")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 10)
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.1)) // Subtle background
                .cornerRadius(15)
                .shadow(radius: 10)

                Spacer()
            }
            .padding()
        }
    }
    
    private func handleAuthorization(authResults: ASAuthorization) {
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            userId = appleIDCredential.user
            firstName = appleIDCredential.fullName?.givenName // Capture first name
            lastName = appleIDCredential.fullName?.familyName // Capture last name
            email = appleIDCredential.email // Capture email (if provided)
            // You may need to fetch the profile picture separately, as it's not directly available here.
            
            isLoggedIn = true

            // Save the user ID in Keychain for future sessions
            if let userId = userId {
                KeychainHelper.saveUserId(userId)
            }
            
            print("Successfully logged in with user ID: \(userId ?? "")")
        
        default:
            break
        }
    }
}
