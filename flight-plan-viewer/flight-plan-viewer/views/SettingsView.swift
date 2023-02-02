//
//  SettingsView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("username.simbrief") private var simbriefUsername: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Simbrief username", text: $simbriefUsername)
            
            Spacer()
            
            Button {
                print("button")
                let defaults = UserDefaults.standard
                
                defaults.set(
                    simbriefUsername,
                    forKey: "username.simbrief"
                )
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
