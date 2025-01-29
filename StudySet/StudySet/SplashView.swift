import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool // Accept the binding for active state

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]), // Adjust the colors as needed
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all) // Fill the entire screen with the gradient

            VStack {
                // Add your logo or splash screen content here
                Image("your_logo") // Replace with your actual logo image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Adjust the size as needed
                    .clipShape(Circle()) // Make the logo circular
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 5) // Add shadow to the logo

                // Optionally, you can add a loading indicator or a welcome message here
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        // Example usage with a dummy binding
        SplashView(isActive: .constant(true))
    }
}
