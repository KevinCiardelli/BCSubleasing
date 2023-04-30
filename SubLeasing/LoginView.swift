//
//  LoginView.swift
//  FinalProject
//
//  Created by Kevin Ciardelli on 4/26/23.
//

import SwiftUI
import Firebase



struct LoginView: View {
    enum Field {
        case email, password
    }

    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage  = ""
    @State private var buttonsDisabled = true
    @State private var path = NavigationPath()
    @FocusState private var focusField: Field?
    @State private var presentSheet = false

    var body: some View {
        ZStack{
            VStack {
                NavigationStack (path: $path) {
                    Image("LoginLogo")
                        .resizable()
                        .cornerRadius(25)
                        .shadow(radius: 25)
                        .scaledToFit()
                        .padding()
                    
                    Group {
                        TextField("E-mail", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .submitLabel(.next)
                            .autocorrectionDisabled()
                            .focused($focusField, equals: .email) // this field is bound to the .email case
                            .onSubmit {
                                focusField = .password
                            }
                            .onChange(of: email) { _ in
                                enableButtons()
                            }
                        SecureField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .submitLabel(.done)
                            .focused($focusField, equals: .password) // this field is bound to the .password case
                            .onSubmit {
                                focusField = nil // will dismiss the keyboard
                            }
                            .onChange(of: password) { _ in
                                enableButtons()
                            }
                    }
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button {
                            register()
                        } label: {
                            Text("Sign Up")
                        }
                        .padding(.trailing)
                        Button {
                            login()
                        } label: {
                            Text("Log In")
                        }
                        .padding(.leading)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("BC"))
                    .font(.title2)
                    .padding(.top)
                    .navigationBarTitleDisplayMode(.inline)
                }
                
                .alert(alertMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                }
                .navigationDestination(for: String.self) { view in
                    if view == "ListView" {
                        ListView()
                    }
                }
                .onAppear {
                    // if logged in when app runs, navigate to the new screen & skip login screen
                    if Auth.auth().currentUser != nil {
                        print("🪵 Login Successful!")
                        presentSheet = true
                    }
                }
                .fullScreenCover(isPresented: $presentSheet) {
                    ListView()
                }
                Spacer()
            }
        }
    }
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result,
            error in
            if let error = error{
                print("Registration ERROR: \(error.localizedDescription)")
                alertMessage = "Registration ERROR: \(error.localizedDescription)"
                showingAlert = true
            }
            else {
                print("Goods")
                presentSheet = true
            }
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error{
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            }
            else {
                print("Goods")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

