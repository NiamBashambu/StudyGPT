import SwiftUI
import UIKit // Required for hideKeyboard functionality

struct PlusButtonView: View {
    @Binding var studyPlans: [StudyPlanResponse]
    @State private var showDatePicker = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedDay = Calendar.current.component(.day, from: Date())
    @State private var assignmentContent: String = ""
    @State private var assignmentTitle: String = ""
    @State private var assignmentType: String = "Homework"
    let assignmentTypes = ["Homework", "Test", "Project"]
    @State private var isSubmitting: Bool = false
    @State private var errorMessage: String?

    let years = Array(2024...2034)
    let months = Array(1...12)

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                TextField("Assignment Title", text: $assignmentTitle)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                Picker("Assignment Type", selection: $assignmentType) {
                    ForEach(assignmentTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Button(action: { withAnimation { showDatePicker.toggle() } }) {
                    HStack {
                        Text("Due Date: \(formattedSelectedDate())")
                        Spacer()
                        Image(systemName: showDatePicker ? "chevron.up" : "chevron.down")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }

                if showDatePicker {
                    DatePickerComponent()
                        .padding(.top, 8) // Space above the date picker
                }

                TextEditor(text: $assignmentContent)
                    .frame(height: 100)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)

            Button(action: submit) {
                HStack {
                    Spacer()
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Submit").bold()
                    }
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .padding(.top, 8) // Space above the error message
            }

            Spacer(minLength: 40) // Add a minimum spacer to push content downwards
        }
        .padding(.vertical, 30) // Increase vertical padding for more space
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align to top
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea(edges: .bottom) // Extend view to the bottom
        .onTapGesture { hideKeyboard() }
        .padding(.bottom, 40) // Add extra bottom padding
    }

    private func formattedSelectedDate() -> String {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        let date = Calendar.current.date(from: components) ?? Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func daysForMonthYear() -> [Int] {
        let components = DateComponents(year: selectedYear, month: selectedMonth)
        let range = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: components)!)!
        return Array(range)
    }

    private func formatDateForSubmission() -> String {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        let date = Calendar.current.date(from: components) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func clearFields() {
        assignmentTitle = ""
        assignmentContent = ""
        selectedYear = Calendar.current.component(.year, from: Date())
        selectedMonth = Calendar.current.component(.month, from: Date())
        selectedDay = Calendar.current.component(.day, from: Date())
        showDatePicker = false
    }

    private func submit() {
        isSubmitting = true
        let formattedSubmissionDate = formatDateForSubmission()
        let assignment = Assignment(
            title: assignmentTitle,
            dueDate: formattedSubmissionDate,
            type: assignmentType,
            content: assignmentContent
        )

        APIManager.shared.generateStudyPlan(assignments: [assignment]) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success(let studyPlans):
                    self.studyPlans.append(contentsOf: studyPlans)
                    clearFields()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func DatePickerComponent() -> some View {
        HStack {
            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text("\(year)").tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)

            Picker("Month", selection: $selectedMonth) {
                ForEach(months, id: \.self) { month in
                    Text("\(month)").tag(month)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)

            Picker("Day", selection: $selectedDay) {
                ForEach(daysForMonthYear(), id: \.self) { day in
                    Text("\(day)").tag(day)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// Extension to hide the keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
