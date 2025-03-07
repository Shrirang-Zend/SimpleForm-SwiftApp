//
//  FormView.swift
//  SimpleFormScreen
//
//  Created by Shrirang Zend on 07/03/25.
//


import SwiftUI

struct FormView: View {
    @StateObject private var viewModel = FormViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Full Name", text: $viewModel.formData.fullName)
                        .textContentType(.name)

                    TextField("Email", text: $viewModel.formData.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: viewModel.formData.email) { newValue in
                            viewModel.formData.email = newValue.lowercased()
                        }

                    HStack {
                        if viewModel.isPasswordVisible {
                            TextField("Password", text: $viewModel.formData.password)
                        } else {
                            SecureField("Password", text: $viewModel.formData.password)
                        }
                        Button(action: {
                            viewModel.isPasswordVisible.toggle()
                        }) {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                }

                Section(header: Text("Additional Info")) {
                    DatePicker("Date of Birth", selection: $viewModel.formData.dateOfBirth, displayedComponents: .date)

                    Picker("Gender", selection: $viewModel.formData.gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }

                    Stepper("Number of Pets: \(viewModel.formData.numPets)", value: $viewModel.formData.numPets, in: 0...10)

                    Slider(value: $viewModel.formData.monthlySpending, in: 0...5000, step: 100) {
                        Text("Monthly Spending")
                    }
                    Text("Spending: $\(Int(viewModel.formData.monthlySpending))")

                    Picker("Account Type", selection: $viewModel.formData.accountType) {
                        ForEach(AccountType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.formData.bio)
                            .frame(height: 100)
                            .padding(4)

                        if viewModel.formData.bio.isEmpty {
                            Text("Enter your bio here...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }
                }

                Section {
                    Toggle("Accept Terms & Conditions", isOn: $viewModel.formData.termsAccepted)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Section {
                    Button(action: {
                        viewModel.submitForm()
                    }) {
                        if viewModel.isSubmitting {
                            ProgressView()
                        } else {
                            Text("Submit")
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle("User Form")
            .onChange(of: viewModel.formData, perform: { _ in
                viewModel.validateForm()
            })
        }
    }
}

#Preview {
    FormView()
}
