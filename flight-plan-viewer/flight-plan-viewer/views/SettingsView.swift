//
//  SettingsView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

fileprivate let SIMBRIEF_USER_KEY = "username.simbrief"

struct SettingsView: View {
    @EnvironmentObject var userController: UserController
    
    @AppStorage(SIMBRIEF_USER_KEY) private var simbriefUsername: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Simbrief username", text: $simbriefUsername)
                .autocorrectionDisabled()
                .keyboardType(.alphabet)
            
            Spacer()
            
            Button {
                let defaults = UserDefaults.standard
                
                if simbriefUsername.isEmpty {
                    defaults.removeObject(forKey: SIMBRIEF_USER_KEY)
                } else {
                    defaults.set(
                        simbriefUsername,
                        forKey: SIMBRIEF_USER_KEY
                    )
                }
                
                userController.simbriefUser.refreshPilotId()
            } label: {
                Text("Save")
            }
            
            Divider()
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
