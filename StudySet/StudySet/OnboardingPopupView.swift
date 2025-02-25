import SwiftUI

struct OnboardingPopupView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    @Environment(\.colorScheme) var colorScheme // Detect color scheme

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary) // Adaptive secondary color
                            .padding()
                    }
                }
                .padding(.trailing)
                
                TabView(selection: $currentPage) {
                    OnboardingSlideView(imageName: "slide1", title: "Welcome to StudyPlanGPT", description: "A tool for all your studying needs!")
                        .tag(0)
                    OnboardingSlideView(imageName: "slide2", title: "What you will do", description: "Add your assignments in detail to make sure you get the most out of the app.")
                        .tag(1)
                    OnboardingSlideView(imageName: "slide3", title: "What we will do", description: "Create a studying plan based off your indepth detailing of your assignment")
                        .tag(2)
                    OnboardingSlideView(imageName: "slide4", title: "You're ready!", description: "Get ready to improve your studying!")
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 450)
                
                Spacer()
            }
            .background(Color(.systemBackground)) // System background color
            .cornerRadius(20)
            .shadow(color: colorScheme == .dark ? .clear : .gray, radius: 20) // Adjust shadow for dark mode
            .padding()
            .frame(maxWidth: 600)
        }
    }
}

struct OnboardingSlideView: View {
    let imageName: String
    let title: String
    let description: String
    @Environment(\.colorScheme) var colorScheme // Detect color scheme

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.primary) // Adaptive primary color
                .padding(.top, 50)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary) // Explicit primary color
                .padding()
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary) // Secondary color for description
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.bottom, 50)
    }
}
