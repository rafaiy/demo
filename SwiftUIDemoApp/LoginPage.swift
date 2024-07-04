//
//  LoginPage.swift
//  SwiftUIDemoApp
//
//  Created by Rafaiy Rehman on 06/06/24.
//

import SwiftUI
import Combine

struct LoginPage: View {
    @State private var emailTextField: String = ""
    @State private var passwordTextField: String = ""
    @State private var rememberMeChecked: Bool = false

    @FocusState private var isEmailTextFieldFocused: Bool
    @FocusState private var isPasswordFocused: Bool

    var signinHandler: SigninHandler

    var body: some View {
            ZStack {
                Image("AppBgimage")
                    .resizable()
                    .ignoresSafeArea()
                ZStack {

                    Rectangle()
                        .frame(width: 300, height: 375)
                        .clipShape(.rect(cornerRadius: 20))
                        .foregroundStyle(.white.opacity(0.2))


                    VStack (alignment: .center, spacing: 20){

                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.bottom, 10)

                        // email text field
                        emailTextFieldView

                        // password text field
                        passwordTextFieldView

                        // remember me stack && forgot password
                        HStack (spacing: 50) {
                            HStack {
                                Button(action: {
                                    rememberMeChecked.toggle()
                                }, label: {
                                    Image(systemName:  !rememberMeChecked ? "square" : "checkmark.square.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                })

                                Text("Remember me")
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                            }

                            Button(action: {

                            }, label: {
                                Text("Forgot Password?")
                                    .font(.caption2)
                            })

                        }.accentColor(.white)

                        // Login button
                        loginButtonView
                    }
                }
                .onTapGesture {
                    isEmailTextFieldFocused = false
                    isPasswordFocused = false
                    print("dismiss done ")
                }

            }
    }

    private var emailTextFieldView: some View {
        HStack {
            Image(systemName: "mail.fill")
                .frame(width: 25)
                .foregroundStyle(.white)
            TextField("Email ID", text: $emailTextField)
                .focused($isEmailTextFieldFocused)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .frame(width: 210)
            .padding(.bottom, 10)

        }.overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 2)
                .clipShape(.rect(cornerRadius: 2))
                .foregroundStyle(.white)
        }

    }


   private  var passwordTextFieldView: some View {
        HStack {
            Image(systemName: "lock.fill")
                .frame(width: 25)
                .foregroundStyle(.white)
            SecureField("Password", text: $passwordTextField)
                .focused($isPasswordFocused)
                .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .frame(width: 210)
            .padding(.bottom, 10)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 2)
                .clipShape(.rect(cornerRadius: 2))
                .foregroundStyle(.white)
        }
    }


    private var loginButtonView: some View {
        Rectangle()
            .frame(width: 250, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundStyle(.white.opacity(0.2))
            .overlay {
                Text("LOGIN")
                    .font(.headline)
                    .foregroundStyle(.white)
            }.onTapGesture {
                print("username \(emailTextField)")
                print("passsword \(passwordTextField)")
                isEmailTextFieldFocused = false
                isPasswordFocused = false
                signinHandler.performLogin(userName: emailTextField, password: passwordTextField)
            }
    }


}

#Preview {
    LoginPage(signinHandler: SigninHandler())
}



//// generic example
//class TestClass {
//
//    protocol Vehicle {
//        associatedtype Item
//        mutating func additem(_ item: Item)
//    }
//
//
//    struct Car<Element>: Vehicle {
//
//        mutating func additem(_ item: Element.Type) {
//
//        }
//        
//        typealias Item = Element.Type
//
//    }
//
//
//
//}
