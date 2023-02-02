//
//  SettingsView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var simbriefUsername: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Simbrief username", text: $simbriefUsername)
            
            Spacer()
            
            Button {
                print("button")
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
