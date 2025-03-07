//
//  FormViewModel.swift
//  SimpleFormScreen
//
//  Created by Shrirang Zend on 07/03/25.
//


import SwiftUI

class FormViewModel: ObservableObject {
    @Published var formData = FormData()
    @Published var errorMessage: String?
    @Published var isSubmitting = false
    @Published var isFormValid = false
    @Published var isPasswordVisible = true

    init() {
        validateForm()
    }
    
    func validateForm() {
        isFormValid = !formData.fullName.isEmpty &&
                      formData.email.contains("@") &&
                      formData.password.count >= 6 &&
                      formData.termsAccepted
    }

    func submitForm() {
        guard isFormValid else {
            errorMessage = "Please fill all required fields correctly."
            return
        }

        isSubmitting = true
        errorMessage = nil

        FormAPI.shared.submitForm(formData) { result in
            DispatchQueue.main.async {
                self.isSubmitting = false
                switch result {
                case .success(let message):
                    print(message)
                case .failure(let error):
                    self.errorMessage = "Submission failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

