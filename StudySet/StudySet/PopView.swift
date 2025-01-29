import SwiftUI

struct PopupView: View {
    var studyPlan: StudyPlanResponse
    @Binding var selectedTab: Int
    @Environment(\.dismiss) var dismiss // Use dismiss environment variable
    
    var body: some View {
        NavigationStack { // Use NavigationStack for navigation
            VStack(alignment: .leading) {
                Text(studyPlan.title)
                    .font(.title)
                    .padding(.bottom, 5)
                
                Text("Due Date: \(studyPlan.dueDate)")
                    .font(.subheadline)
                    .padding(.bottom, 5)
                
                Text("Type: \(studyPlan.type)")
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                ScrollView { // Add scrollable view
                    VStack(alignment: .leading) {
                        ForEach(studyPlan.studyPlan, id: \.self) { step in
                            Text(step)
                                .font(.body)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding() // Add padding for the scrollable content
                }
                
                HStack { // Use HStack for buttons
                    Button("Close") {
                        dismiss() // Dismiss the popup
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    
                }
                .padding(.top) // Add padding to the button row
            }
            .padding() // Add padding for the whole view
            .frame(maxWidth: .infinity, alignment: .top) // Align to the top
            .onTapGesture {
                // Dismiss the keyboard when tapping outside input fields
                hideKeyboard()
            }
        }
    }
}
