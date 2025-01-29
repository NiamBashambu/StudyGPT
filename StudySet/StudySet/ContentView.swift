import SwiftUI

struct ContentView: View {
    @State private var studyPlans: [StudyPlanResponse] = []
    @State private var selectedTab: Int = 0
    @State private var isActive: Bool = false
    @State private var isLoggedIn: Bool = false // Initially false
    @State private var userId: String?
    
    // User Details
    @State private var firstName: String?
    @State private var lastName: String?
    @State private var email: String?
    @State private var profilePicture: UIImage? // Placeholder for profile image

    var body: some View {
        VStack {
            if isActive {
                if isLoggedIn {
                    MainTabView(
                        studyPlans: $studyPlans,
                                                selectedTab: $selectedTab,
                                                userId: $userId,
                                                isLoggedIn: $isLoggedIn, // Pass binding to isLoggedIn
                                                firstName: $firstName,
                                                lastName: $lastName,
                                                email: $email,
                                                profilePicture: $profilePicture
                    )
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, profilePicture: $profilePicture)
                }
            } else {
                SplashView(isActive: $isActive)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
        .animation(.default, value: isActive)
        .onAppear {
            if let storedUserId = KeychainHelper.loadUserId() {
                userId = storedUserId
                isLoggedIn = true
            }
        }
    }
}

// Separate view for the main tab interface
struct MainTabView: View {
    @Binding var studyPlans: [StudyPlanResponse]
    @Binding var selectedTab: Int
    @Binding var userId: String?
    
    // User Details
    @Binding var isLoggedIn: Bool // Add this binding

    @Binding var firstName: String?
    @Binding var lastName: String?
    @Binding var email: String?
    @Binding var profilePicture: UIImage? // Placeholder for profile image

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(studyPlans: $studyPlans, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            PlusButtonView(studyPlans: $studyPlans)
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
                .tag(1)

            DeckListView()
                .tabItem {
                    Label("Study", systemImage: "folder")
                }
                .tag(4)

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(2)

            AccountView(
                userId: $userId,
                isLoggedIn: $isLoggedIn, // Bind to isLoggedIn state
                firstName: $firstName,
                lastName: $lastName,
                email: $email,
                profilePicture: $profilePicture // Pass profile picture
            )
            .tabItem {
                Label("Account", systemImage: "person.circle")
            }
            .tag(3)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
