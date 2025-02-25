import SwiftUI

struct HomeView: View {
    @Binding var studyPlans: [StudyPlanResponse]
    @Binding var selectedTab: Int
    @State private var errorMessage: String?
    @State private var selectedPlan: StudyPlanResponse?
    @State private var showingStudyPlan = false
    @State private var showOnboarding = false // Local flag to control the popup animation

    // Persisted flag that indicates if onboarding was completed
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        ZStack {
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
                    PopupView(studyPlan: plan, selectedTab: $selectedTab)
                }
            }

            // Onboarding overlay: Only show if the onboarding hasn't been completed.
            if showOnboarding && !hasCompletedOnboarding {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                OnboardingPopupView(isPresented: $showOnboarding)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            // Dismiss the onboarding and mark it as completed.
                            showOnboarding = false
                            hasCompletedOnboarding = true
                        }
                    }
            }
        }
        .onAppear {
            // When the view appears, check if onboarding has already been completed.
            if !hasCompletedOnboarding {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOnboarding = true
                }
            }
        }
    }

    private func createPlanRow(for plan: StudyPlanResponse) -> some View {
        Button(action: {
            selectedPlan = plan // Show the popup for the selected plan
        }) {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: iconForAssignmentType(plan.type))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorForAssignmentType(plan.type))
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(colorForAssignmentType(plan.type), lineWidth: 2)
                    )

                VStack(alignment: .leading) {
                    Text(plan.title)
                        .font(.headline)
                        .foregroundColor(Color.primary)

                    Text("Due Date: \(plan.dueDate)")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)

                    Text("Type: \(plan.type)")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)

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
        .buttonStyle(PlainButtonStyle())
    }

    private func showStudyPlanPreview(_ studyPlan: [String], maxLines: Int) -> some View {
        VStack(alignment: .leading) {
            ForEach(studyPlan.prefix(maxLines), id: \.self) { step in
                Text(step)
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(Color.primary)
            }
            if studyPlan.count > maxLines {
                Text("...")
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxHeight: 80)
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
