import SwiftUI

struct advice: View {
    
    @State private var isShowing = false
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea(.all)
            
            ScrollView{
                Text("Dream Crafters")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                
                Text("We all care about your health")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                
                
            }
            
            BottomSheetView(isShowing: $isShowing, height: 300) {
                Text("Have some slepp")
            }
        }
    }
}

#Preview {
    advice()
}
