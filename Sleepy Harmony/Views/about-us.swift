import SwiftUI

struct about_us: View {
    
    @State private var showCallSheet = false
    @State private var copied = false {
        didSet {
            if copied == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        copied = false
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        let questionItems : [QuestionAnswer] = [
            .init(textOne: "Is sleep important?", textTwo: [.init(textOne: "Yes, it carries such a big role in our life in terms of patience and overall health")])
        
        ]
        
        GeometryReader { geo in
            ZStack {
                Color.background
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    
                    VStack{
                        
                        Text("Help centre")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.top, 5)
                        
                        Image("Contact us img")
                            .resizable()
                            .frame(width: 350, height: 250)
                            .cornerRadius(25)
                            .padding(.top, 1)
                        
                        Group{
                            Text("Contact us")
                                .font(.system(size: 40,weight: .bold, design: .rounded))
                                .frame(width: 360 ,alignment: .leading)
                            Text("We're available from 8AM to 6PM from Monday to Friday and 24/24 the weekend")
                                .padding(.horizontal)
                                .font(.system(size: 19))
                                .foregroundColor(.gray)
                            Button(){
                                showCallSheet.toggle()
                            } label: {
                                ZStack{
                                    Rectangle()
                                        .frame(width: 340, height: 50)
                                        .foregroundColor(Color.buttonBackground)
                                        .cornerRadius(10)
                                    HStack(spacing: 10) {
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 30))
                                        Text("Call our Support Centre")
                                            .font(.system(size: 24, weight: .medium))
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                        }
                        
                        Text("F.A.Q")
                            .font(.system(size: 40,weight: .bold, design: .rounded))
                            .frame(width: 360 ,alignment: .leading)
                        
                        ForEach(questionItems) { item in
                            DisclosureGroup {
                                ForEach(item.textTwo ?? [QuestionAnswer]()) { innterItem in
                                        Text(innterItem.textOne)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .frame(alignment: .leading)
                                }
                            } label : {
                                Text(item.textOne)
                                    .font(.system(size: 25, weight: .bold))
                            }
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(.black)
                        .scaledToFit()
                    }
                }
                
                BottomSheetView(isShowing: $showCallSheet, height: 250) {
                    VStack{
                        Text("Our phone numbers:")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 30)
                            .padding(.leading, 20)
                        
                        Text("+7 778 648 6336")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                            .padding(.trailing, 60)
                            .onTapGesture {
                                UIPasteboard.general.string = "+7 778 648 6336"
                                withAnimation {
                                    copied.toggle()
                                }
                                print("Phone number was copied")
                            }
                        Spacer()
                    }
                }
                
                if copied {
                    Text("Copied to clipboard")
                        .padding()
                        .background(Color.blue.cornerRadius(20))
                        .position(x: geo.frame(in: .local).width/2)
                        .transition(.move(edge: .top))
                        .padding(.top, 30)
                        .animation(Animation.easeInOut(duration: 1))
                }
            }
        }
    }
}

#Preview {
    about_us()
}
