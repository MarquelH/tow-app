//
//  RegistrationView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/30/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct LoginView: View {
    
    @State var isLoginMode = true
    @Binding var isLoggedIn: Int
    @Binding var user: User
    @State var email = ""
    @State var password = ""
    @State var phoneNumber = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var loginStatusMessage = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    var loginViewModel = LoginViewModel()
    let mikesEmail = "mike@gmail.com"
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label:
                            Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color.red)
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3))
                        }
                    }
                    
                    Group {
                        if !isLoginMode {
                            TextField("First Name", text: $firstName)
                                .disableAutocorrection(true)
                            TextField("Last Name", text: $lastName)
                                .disableAutocorrection(true)
                            TextField("Phone Number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                        }
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleEntryAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In": "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(
                            LinearGradient(colors: [
                                Color.red,
                                Color.red.opacity(0.5)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                    }
                    
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $shouldShowImagePicker, onDismiss: nil) {
           ImagePicker(image: $image)
        }
    }
    
    private func handleEntryAction() {
        if isLoginMode {
            loginViewModel.loginUserAndGetData(email: email, password: password) { loggedInUser in
                if loggedInUser.userUID != nil && loggedInUser.userEmail != nil && loggedInUser.profileImageUrl != nil {
                    self.user = loggedInUser
                    //Switch the app to mike's interface if it's him
                    if loggedInUser.userEmail == mikesEmail {
                        self.isLoggedIn = 2
                    } else {
                        self.isLoggedIn = 1
                    }
                    print("ISLOGGEDIN IS TRUE")
                } else {
                    print("UH OH")
                }
            }
        } else {
            loginViewModel.createNewAccountAndStoreData(image: self.image, email: email, password: password, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName) { newUser in
                if newUser.userUID != nil && newUser.userEmail != nil && newUser.profileImageUrl != nil && newUser.phoneNumber != nil && newUser.lastName != nil && newUser.firstName != nil {
                    self.user = newUser
                    //Switch the app to mike's interface if it's him
                    if newUser.userEmail == mikesEmail {
                        self.isLoggedIn = 2
                    } else {
                        self.isLoggedIn = 1
                    }
                    print("ISLOGGEDIN IS TRUE FROM CREATION : \(self.user)")
                } else {
                    print(newUser)
                    print("DIDNT GET ENOUGH CREDENTIALS")
                }
            }
        }
    }
}
