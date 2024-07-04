//
//  loginVM.swift
//  SwiftUIDemoApp
//
//  Created by Rafaiy Rehman on 11/06/24.
//

import Foundation
import Combine
import SwiftUI

class LoginVm: ObservableObject {
    let loginUrl:URL = URL(string: "https://restful-booker.herokuapp.com/auth")!
    let token: String = ""

    func loginDetails(userName: String, password: String ) -> AnyPublisher<String?, URLError> {

        var request =  URLRequest(url: loginUrl)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: ["username": userName, "password": password], options: [])

         let publisher = session.dataTaskPublisher(for: request).map(handleResponse).mapError({ $0 }).eraseToAnyPublisher()
        return publisher


    }


    private func handleResponse(_ data: Data?,_ response: URLResponse?) -> String? {
        guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200,httpResponse.statusCode < 300 else {
            return nil
        }
        
        guard let model = try? JSONDecoder().decode(tokenModel.self, from: data) else {
            return nil
        }

        if let _ = model.reason {
            return nil
        } else if let toekn = model.token {
            return toekn
        }
        return nil
    }

}


class SigninHandler: ObservableObject {

    @Published var signinDone: Bool = false

    @AppStorage("token") private var appstoreToken: String?

    private let loginVM = LoginVm()
    private var cancelAble =  Set<AnyCancellable>()


    init() {
        if let appstroeToekn = self.appstoreToken,  !(appstroeToekn.isEmpty) {
            self.signinDone = true
        }
    }

    func performLogin(userName: String, password: String){
        loginVM.loginDetails(userName: userName, password: password)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("error \(error)")
            } receiveValue: { token in
                self.appstoreToken = token
                if let appstroeToekn = self.appstoreToken,  !(appstroeToekn.isEmpty) {
                    self.signinDone = true
                }
            }
            .store(in: &cancelAble)
    }



}



struct tokenModel: Hashable, Codable {
    let reason: String?
    let token: String?
}
