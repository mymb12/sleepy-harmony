import SwiftUI
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    
    var audioPlayer: AVAudioPlayer?
    
    var isPlaying = false
    var totalTime: TimeInterval = 0.0
    var currentTime: TimeInterval = 0.0
    
    init(path: String) {
        
        if let sound = Bundle.main.path(forResource: path, ofType: "mp3") {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                audioPlayer?.prepareToPlay()
                totalTime = audioPlayer?.duration ?? 0.0
            } catch {
                print("AVAudioPlayer could not be instantiated.")
            }
        } else {
            print("Audio file could not be found.")
        }
        
    }
    
    func playAudio(){
        audioPlayer?.play()
        isPlaying = true
        print("music is playing")
    }
    
    func stopAudio(){
        audioPlayer?.pause()
        isPlaying = false
        print("music stopped")
    }
    
    func updateProgress(){
        currentTime = audioPlayer!.currentTime
        //print("current time was updated: \( Int(currentTime) )")
    }
    
    func seekAudio(time: TimeInterval){
        audioPlayer?.currentTime = time
    }
    
    func timeString(time: TimeInterval) -> String{
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader{ [self] in
            let size = $0.size
            let spacing = size.height * 0.04
            
            VStack(spacing: spacing){
                VStack(spacing: spacing){
                    HStack(alignment: .center, spacing: 15){
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Forest Sound")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("mansur")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button{
                            
                        }label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background{
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    
                    
                    Slider(value: Binding(get: {
                        self.currentTime
                    }, set: { [self] newValue in
                        seekAudio(time: newValue)
                    }), in: 0...self.totalTime)
                    .foregroundColor(.white)
                    
                    HStack{
                        Text(timeString(time: self.currentTime))
                        Spacer()
                        Text(timeString(time: self.totalTime))
                    }
                }
                .frame(height: size.height / 2.5, alignment: .bottom)
                
                
                HStack(spacing: size.width * 0.18){
                    Button{
                        self.currentTime = 0.0
                        self.audioPlayer?.currentTime = self.currentTime
                    }label: {
                        Image(systemName: "backward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    Button{ [self] in
                        if isPlaying{
                            stopAudio()
                        }else{
                            playAudio()
                        }
                    }label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    
                    Button{
                        self.currentTime = self.totalTime
                        self.audioPlayer?.currentTime = self.currentTime
                    }label: {
                        Image(systemName: "forward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
            }
            .padding(.top)
        }
        
        
    }
}

struct AudioPlayerView: View {
    
    var audioFileName: String
    var player: AudioPlayerViewModel
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @State private var animationContent: Bool = false
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack{
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        Image("mm")
                            .blur(radius: 55)
                        //.opacity(animationContent ? 1 : 0)
                    })
                
                VStack(spacing: 15){
                    Spacer()
                    
                    GeometryReader{
                        let size = $0.size
                        Image("mm")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.width)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .frame(width: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    player.PlayerView(size)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0  ? 10  : 0) )
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .ignoresSafeArea(.container, edges: .all)
        }
        
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            player.updateProgress()
        }
    }
    
    
}

extension View {
    var deviceCornerRadius: CGFloat{
        
        let key = "_displayCornerRadius"
        
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen{
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}

#Preview {
    AudioPlayerView(audioFileName: "", player: AudioPlayerViewModel(path: ""), expandSheet: .constant(true), animation: Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}
