import SwiftUI

struct HomeView: View {
    @Binding var studyPlans: [StudyPlanResponse]
    @Binding var selectedTab: Int
    @State private var errorMessage: String?
    @State private var selectedPlan: StudyPlanResponse?
    @State private var showingStudyPlan = false
    @State private var showOnboarding = true // Track if onboarding should be shown

   
    var body: some View {
        ZStack {
            // Main HomeView content
            NavigationView {
                
                VStack {
                    List {
                        ForEach(studyPlans) { plan in
                            createPlanRow(for: plan)
                        }
                        .onDelete(perform: deleteStudyPlan)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top)

                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    }

                    // Button to switch to PlusButtonView
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Text("Add Assignment")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                .padding()
                .navigationTitle("Study Plans")
                .sheet(item: $selectedPlan) { plan in
                    PopupView(studyPlan: plan ,selectedTab: $selectedTab)
                }
            }

            // Show OnboardingPopupView if showOnboarding is true
            if showOnboarding {
                Color.black.opacity(0.5) // Dimmed background
                    .edgesIgnoringSafeArea(.all)

                OnboardingPopupView(isPresented: $showOnboarding)
                    .transition(.move(edge: .bottom)) // Animate popup from the bottom
                    .zIndex(1) // Ensure the popup is above other content
            }
        }
        
        .onAppear {
            // Check if it's the user's first launch or other conditions to show onboarding
        }
    }

    private func createPlanRow(for plan: StudyPlanResponse) -> some View {
        Button(action: {
            selectedPlan = plan // Show the popup for the selected plan
        }) {
            HStack(alignment: .top, spacing: 16) {
                // Icon for assignment type
                Image(systemName: iconForAssignmentType(plan.type))
                    .resizable() // Ensure the icon is resizable
                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                    .frame(width: 40, height: 40) // Set a consistent size for all icons
                    .foregroundColor(colorForAssignmentType(plan.type))
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(colorForAssignmentType(plan.type), lineWidth: 2)
                    )
               

                VStack(alignment: .leading) {
                    // Title
                    Text(plan.title)
                        .font(.headline)
                        .foregroundColor(Color.primary)
                

                    // Due Date
                    Text("Due Date: \(plan.dueDate)")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                     
                    // Type
                    Text("Type: \(plan.type)")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                  

                    // Show a longer preview of the study plan
                    showStudyPlanPreview(plan.studyPlan, maxLines: 5)
                   
                }
                .padding(.leading, 10)
            
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorForAssignmentType(plan.type), lineWidth: 2)
                    
            )
        }
        .buttonStyle(PlainButtonStyle())// Use plain button style to avoid default button styling
    }

    private func showStudyPlanPreview(_ studyPlan: [String], maxLines: Int) -> some View {
        VStack(alignment: .leading) {
            // Show up to maxLines of the study plan
            ForEach(studyPlan.prefix(maxLines), id: \.self) { step in
                Text(step)
                    .font(.body)
                    .lineLimit(1) // Limit each step to one line
                    .truncationMode(.tail) // Truncate if the text exceeds one line
                    .foregroundColor(Color.primary) // Use dynamic color
            }

            // If there are more than maxLines, show ellipsis to indicate more content
            if studyPlan.count > maxLines {
                Text("...") // Show ellipsis
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxHeight: 80) // Set a maximum height to prevent overflowing
    }

    func deleteStudyPlan(at offsets: IndexSet) {
        studyPlans.remove(atOffsets: offsets)
    }

    func iconForAssignmentType(_ type: String) -> String {
        switch type {
        case "Homework":
            return "book"
        case "Test":
            return "pencil"
        case "Project":
            return "briefcase"
        default:
            return "questionmark"
        }
    }

    func colorForAssignmentType(_ type: String) -> Color {
        switch type {
        case "Homework":
            return Color.blue
        case "Test":
            return Color.orange
        case "Project":
            return Color.green
        default:
            return Color.gray
        }
    }
}
