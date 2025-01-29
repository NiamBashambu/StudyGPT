import SwiftUI
import WebKit

struct AboutView: View {
    @State private var showingPrivacyPolicy = false // State variable to control the privacy policy sheet

    var body: some View {
        ZStack {
           
            VStack(alignment: .leading, spacing: 20) {
    
                
                // Title Section
                Text("About StudyPlanGPT")
                    .font(.largeTitle)
                    .fontWeight(.bold) // Use bold weight for emphasis
                    .padding(.bottom, 10) // Add bottom padding for spacing below

                // Welcome Text
                Text("Welcome to StudyPlanGPT!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20) // Increase bottom padding for better separation

                Divider() // Adds a divider for separation

                // Bullet Point List for Features
                VStack(alignment: .leading, spacing: 10) { // Increased spacing for better readability
                    Text("• Write out your assignments")
                    Text("• Look at the due dates")
                    Text("• Receive personalized tips and recommendations")
                    Text("• Enhance your test performance and take your studying to the next level")
                }
                .font(.body)
                .padding(.horizontal) // Add horizontal padding for bullet points

                Divider() // Another divider for visual separation

                // Logo Section
                HStack {
                    Spacer()
                    Image("bci_logo") // Replace with your logo image name
                        .resizable()
                        .aspectRatio(contentMode: .fill) // Fill the frame without black bars
                        .frame(width: 150, height: 150)
                        .clipShape(Circle()) // Make the logo circular
                        .clipped() // Clip any overflow outside the frame
                    Spacer()
                }
                .padding(.bottom, 20)

                // Creator Information
                Text("Created by Niam Bashambu")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Spacer()

                // Privacy Policy Button
                Button(action: {
                    showingPrivacyPolicy.toggle() // Show the privacy policy sheet
                }) {
                    Text("Privacy Policy")
                        .font(.body)
                        .foregroundColor(Color.blue.opacity(0.9)) // Increased opacity for visibility
                        .padding(10) // Slightly increased padding
                        .background(Color.blue.opacity(0.4)) // Light background for the button
                        .cornerRadius(8)
                        .shadow(color: Color.blue.opacity(0.2), radius: 3, x: 0, y: 2) // Shadow for depth
                }
                .padding(.top, 20) // Increase spacing above the button
            }
            .padding(20) // Consistent padding around the entire view
            .cornerRadius(12) // Adds rounded corners to the background
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5) // Adds subtle shadow for depth
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPrivacyPolicy) {
            // Popup view with the privacy policy link
            PrivacyPolicyView()
        }
    }
}

// View for the Privacy Policy
struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view

    var body: some View {
        NavigationView {
            VStack {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                // WebView to display the privacy policy
                WebView(url: URL(string: "https://belviderelabsllc.netlify.app/Privacy%20Policy%20for%20StudyPlan%20GPT.pdf")!)
                    .edgesIgnoringSafeArea(.all)

                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the privacy policy sheet
                }) {
                    Text("Close")
                        .font(.body)
                        .foregroundColor(Color.red.opacity(0.9)) // Increased opacity for visibility
                        .padding(10) // Slightly increased padding
                        .background(Color.red.opacity(0.1)) // Light background for the button
                        .cornerRadius(8)
                        .shadow(color: Color.red.opacity(0.2), radius: 3, x: 0, y: 2) // Shadow for depth
                }
                .padding()
            }
        }
    }
}

// WebView to display a PDF document
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
