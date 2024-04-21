import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            
            bio_rythms()
                .tabItem { Label("Home", systemImage: "house") }
            
            advice()
                .tabItem { Label("Advice", systemImage: "lightbulb.max") }
            
            about_us()
                .tabItem { Label("Us", systemImage: "info.circle") }
        }
    }
}

#Preview {
    ContentView()
}
