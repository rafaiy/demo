//
//  LandingView.swift
//  SwiftUIDemoApp
//
//  Created by Rafaiy Rehman on 11/06/24.
//

import SwiftUI

struct LandingView: View {
    @ObservedObject private var signinHandler = SigninHandler()

    var body: some View {
        if signinHandler.signinDone {
            ListingVC()
        } else {
            LoginPage(signinHandler: signinHandler)
        }
    }
}

#Preview {
    LandingView()
}
