import SwiftUI
import AVFoundation

struct bio_rythms: View {
    var body: some View {
        AudioPlayerView(audioFileName: "kz_meditation", player: AudioPlayerViewModel(path: "kz_meditation"), expandSheet: .constant(true), animation: Namespace().wrappedValue)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    bio_rythms()
}
