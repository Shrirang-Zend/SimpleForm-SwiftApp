//
//  FormAPI.swift
//  SimpleFormScreen
//
//  Created by Shrirang Zend on 07/03/25.
//


import Foundation

class FormAPI {
    static let shared = FormAPI()
    private let baseURL = "http://127.0.0.1:8000"

    func submitForm(_ formData: FormData, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/submit") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let encodableData = EncodableFormData(
            fullName: formData.fullName,
            email: formData.email,
            password: formData.password,
            dateOfBirth: dateFormatter.string(from: formData.dateOfBirth),
            gender: formData.gender,
            numPets: formData.numPets,
            monthlySpending: formData.monthlySpending,
            age: formData.age,
            satisfaction: formData.satisfaction,
            accountType: formData.accountType,
            bio: formData.bio,
            termsAccepted: formData.termsAccepted
        )

        do {
            let jsonData = try JSONEncoder().encode(encodableData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("🔍 JSON Sent: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("🔍 Server Response Code: \(httpResponse.statusCode)")
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("🔍 Server Response: \(responseString)")
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: nil)))
                return
            }

            completion(.success("Form submitted successfully!"))
        }.resume()
    }
}

struct EncodableFormData: Codable {
    var fullName: String
    var email: String
    var password: String
    var dateOfBirth: String
    var gender: String
    var numPets: Int
    var monthlySpending: Double
    var age: Int?
    var satisfaction: Double?
    var accountType: String
    var bio: String
    var termsAccepted: Bool
}
