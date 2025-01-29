import Foundation
import SwiftData

struct Assignment: Codable {
    let title: String
    let dueDate: String
    let type: String
    let content: String
}

struct StudyPlanResponse: Codable, Identifiable {
    let id = UUID().uuidString // Generates a unique ID for each study plan
    let title: String
    let studyPlan: [String] // Change this to an array of strings
    let dueDate: String
    let type: String
}

class APIManager {
    static let shared = APIManager()
    
    func generateStudyPlan(assignments: [Assignment], completion: @escaping (Result<[StudyPlanResponse], Error>) -> Void) {
        guard let url = URL(string: "http://64.225.19.241/generate-plan") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(["assignments": assignments])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for status code and ensure it's 200 OK
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected status code: \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Decode the response based on the expected structure
                let studyPlans = try JSONDecoder().decode([StudyPlanResponse].self, from: data)
                completion(.success(studyPlans))
            } catch {
                // Print the raw data for debugging in case of decoding failure
                print("Failed to decode: \(String(data: data, encoding: .utf8) ?? "No Data")")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
