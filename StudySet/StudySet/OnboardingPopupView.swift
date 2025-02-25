import SwiftUI

struct OnboardingPopupView: View {
    @Binding var isPresented: Bool // Control when the popup is shown/hidden
    @State private var currentPage = 0 // Track the current slide index

    var body: some View {
        ZStack {
            // Background with semi-transparent dark color
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all) // Covers the entire screen
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isPresented = false // Close the popup with animation
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.trailing)
                
                TabView(selection: $currentPage) { // Bind the currentPage state to TabView
                    OnboardingSlideView(imageName: "slide1", title: "Welcome to StudyPlanGPT", description: "A tool for all your studying needs!")
                        .tag(0) // Assign tag to identify the page
                    OnboardingSlideView(imageName: "slide2", title: "What you will do", description: "Add your assignments in detail to make sure you get the most out of the app.")
                        .tag(1)
                    OnboardingSlideView(imageName: "slide3", title: "What we will do", description: "Create a studying plan based off your indepth detailing of your assignment")
                        .tag(2)
                    OnboardingSlideView(imageName: "slide4", title: "You're ready!", description: "Get ready to improve your studying!")
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Add dots at the bottom
                .frame(height: 450) // Adjust the height to give enough space for the dots
                
                Spacer()
            }
            .background(Color.white) // White background for the popup
            .cornerRadius(20) // Rounded corners for the popup
            .shadow(radius: 20) // Add shadow for a floating effect
            .padding()
            .frame(maxWidth: 600) // Optional: restrict the max width for the popup
        }
    }
}

struct OnboardingSlideView: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName) // Replace with your slide image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 50)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer() // Push content to the top
        }
        .padding(.bottom, 50) // Padding at the bottom for better spacing
    }
}
