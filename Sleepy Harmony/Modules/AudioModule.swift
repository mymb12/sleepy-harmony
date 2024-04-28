import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool = false
    var timer: Timer?
    
    @Published var currentTime: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.0
    
    func playPause(){
        if isPlaying {
            audioPlayer?.pause()
            timer?.invalidate()
        } else {
            audioPlayer?.play()
            startTimer()
        }
        isPlaying.toggle()
    }
    
    func setAudioPlayer(audioFileName: String) {
        guard let audioURL  = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            duration = audioPlayer?.duration ?? 0.0
        }
        catch {
            print("Error loading audio file: \(error.localizedDescription)" )
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            self?.currentTime = self?.audioPlayer?.currentTime ?? 0.0
        })
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
}

struct AudioModule: View {
    @Namespace private var playerAnimation
    @State private var isPlaying = false
    @State private var showDetails = false
    @State private var showControls = false
    @State private var progress: CGFloat = 0.65
    
    @Binding var meditationInfo: Meditation
    
    @State private var isDraggingSlider = false
    
    @ObservedObject var audioManager = AudioManager.shared
    
    var frame: CGFloat {
        showDetails ? 300 : 75
    }
    
    var body: some View {
        ZStack {
            if showDetails {
                Image(meditationInfo.img)
                    .resizable()
                    .blur(radius: 55)
            }
            
            VStack {
                VStack {
                    HStack{
                        Image(meditationInfo.img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(showDetails ? 25 : 10)
                        .frame(width: frame, height: frame)
                        .padding(.top, showDetails ? 180 : 0)
                    
                    if !showDetails {
                        VStack(alignment: .leading){
                            Text(meditationInfo.name)
                                .font(Font.custom("BEBAS NEUE", size: 25))
                            
                            Text("Sleep Sound")
                                .foregroundColor(.gray)
                        }
                        .font(.title2)
                        .matchedGeometryEffect(id: "Album Title", in: playerAnimation)
                        
                        Spacer()
                        
                        Button{
                            audioManager.playPause()
                            isPlaying.toggle()
                        }label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                                .padding()
                        }
                    }
                }
                
                    if showDetails {
                        VStack{
                            Text(meditationInfo.name)
                                .font(Font.custom("BEBAS NEUE", size: 25))
                            
                            Text("Sleep Sound")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .matchedGeometryEffect(id: "Album Title", in: playerAnimation)
                        .onAppear {
                            audioManager.setAudioPlayer(audioFileName: meditationInfo.name)
                            print(meditationInfo.name)
                        }
                        
                        Slider(value: $audioManager.currentTime, in: 0...audioManager.duration, onEditingChanged: { editing in
                            isDraggingSlider = editing
                            if !editing {
                                audioManager.seek(to: audioManager.currentTime)
                                
                                if isPlaying {
                                    audioManager.playPause()
                                }
                            }
                        })
                        .disabled(audioManager.duration.isZero)
                        .padding()
                        
                        VStack{
                            HStack{
                                Text(FormatterTime(audioManager.currentTime))
                                Spacer()
                                Text(FormatterTime(audioManager.duration))
                            }
                            .font(.title2)
                            .padding()
                            
                            
                            HStack{
                                Button(action: {}){
                                    Image(systemName: "gobackward.15")
                                        .font(.system(size: 35))
                                        .foregroundColor(.white)
                                        .padding()
                                        .onTapGesture {
                                            let newTime = audioManager.currentTime - 15
                                            if newTime < 0 {
                                                audioManager.seek(to: 0)
                                            }else{
                                                audioManager.seek(to: newTime)
                                            }
                                        }
                                }
                                
                                Button(action: {
                                    audioManager.playPause()
                                    isPlaying.toggle()
                                }){
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                
                                
                                Button(action: {}){
                                    Image(systemName: "goforward.15")
                                        .font(.system(size: 35))
                                        .foregroundColor(.white)
                                        .padding()
                                        .onTapGesture {
                                            let newTime = audioManager.currentTime + 15
                                            if newTime > audioManager.duration {
                                                audioManager.seek(to: audioManager.duration)
                                            }else{
                                                audioManager.seek(to: newTime)
                                            }
                                        }
                                }
                            }
                            .padding(.bottom, 250)
                        }
                    }
                }
                .onTapGesture {
                    showControls.toggle()
                    Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { timer in
                        withAnimation(.spring()){
                            showDetails.toggle()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: showDetails ? 900 : 75)
            }
            .onAppear {
                audioManager.setAudioPlayer(audioFileName: meditationInfo.name)
        }
        }
    }
    
    func FormatterTime(_ time: TimeInterval) -> String {
        let min = Int(time) / 60
        let sec = Int(time) % 60
        
        return String(format: "%02d:%02d", min, sec)
    }
}

struct Meditation: Identifiable {
    var id = UUID()
    var name: String
    var img: String
}

struct AudioContentView :View {
    
    @State private var meditations: [Meditation] = [
        .init(name: "KZ Meditation", img: "kz_meditation"),
        .init(name: "RUS Meditation", img: "icon"),
        .init(name: "ENG Meditation", img: "eng_meditation"),
        .init(name: "Music", img: "nn"),
        .init(name: "Music 2", img: "bg_back")
    ]
    
    @State private var selectedMeditation = Meditation(name: "music", img: "nn")
    
    var body: some View{
        
        VStack{
            
            Text("Meditation")
                .font(Font.custom("BEBAS NEUE", size: 50))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.leading)
            
            
            
            List{
                ForEach(meditations) { meditation in
                    HStack{
                        Image(meditation.img)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                        
                        Text(meditation.name)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                    }
                    .onTapGesture {
                        switch meditation.name{
                        case "KZ Meditation": 
                            selectedMeditation.name = "kz_meditation"
                            selectedMeditation.img = "kz_meditation"
                            break
                        
                        case "RUS Meditation":
                            selectedMeditation.name = "rus_meditation"
                            selectedMeditation.img = "icon"
                            break
                        
                        case "ENG Meditation":
                            selectedMeditation.name = "eng_meditation"
                            selectedMeditation.img = "eng_meditation"
                            break
                        
                        case "Music 2":
                            selectedMeditation.name = "bg_music2"
                            selectedMeditation.img = "bg_back"
                            break
                            
                        default:
                            selectedMeditation.name = "bg_music"
                            selectedMeditation.img = "nn"
                        }
                    }
                }
            }
            
            AudioModule(meditationInfo:  $selectedMeditation)
                .padding()
        }
    }
}

#Preview {
    AudioContentView()
}
