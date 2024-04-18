import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    @Binding var isShowing: Bool
    var height: CGFloat = 200
    @ViewBuilder let content: Content
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                
                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: height)
                .background(.white)
                .cornerRadius(16, corners: .topLeft)
                .cornerRadius(16, corners: .topRight)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
    }
}
