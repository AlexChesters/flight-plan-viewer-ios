//
//  MainView.swift
//  flight-plan-viewer
//
//  Created by Alex Chesters on 02/02/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SimbriefView()
                .tabItem {
                    Text("Simbrief")
                }
            SettingsView()
                .tabItem {
                    Text("Settings")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
