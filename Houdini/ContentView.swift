import SwiftUI
import GoogleGenerativeAI
import AVFoundation
import NaturalLanguage

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue! & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}


struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: ApiKey.default)
    let speechSynthesizer = AVSpeechSynthesizer()
    let recognizer = NLLanguageRecognizer()

    @State private var response = ""
    @State private var userPrompt = ""
    @State private var isAnimating = false
    @State private var aiResponses: [String] = []
    @State private var showTextField = false
    @State private var showPopover = false
    @State private var selectedResponse: String?
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    NavigationLink(destination: MessengerView()) {
                        CircleView(text: "Messages")
                            .font(.caption)
                    }
                    HStack {
                        NavigationLink(destination: MemesView()) {
                            CircleView(text: "Cool")
                                .font(.caption)
                        }
                        Spacer()
                        NavigationLink(destination: LessonsView()) {
                            CircleView(text: "Lessons")
                                .font(.caption)
                        }
                    }
                    .padding(.bottom, 20)
                    HStack {
                        NavigationLink(destination: ReferencesView()) {
                            CircleView(text: "Resources")
                                .font(.caption)
                        }
                        Spacer()
                        NavigationLink(destination: PortfolioView()) {
                            CircleView(text: "Portfolio")
                                .font(.caption)
                        }
                    }
                    NavigationLink(destination: ScheduleView()) {
                        CircleView(text: "Shedule")
                            .font(.caption)
                    }
                }
                .padding(.all, 25)

                ZStack {
                    if showTextField {
                        VStack {
                            TextField("Enter text", text: $userPrompt, onCommit: generateResponse)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)

                            Button(action: {
                                generateResponse()
                            }, label: {
                                Text("Send")
                            })
                            .padding(.top)

                        }

                        .frame(maxWidth: 120, alignment: .center)
                        .padding(.top, 150)

                    }

                    AnimatedCircleView(isAnimating: $isAnimating, onTap: {
                        withAnimation {
                            self.showTextField.toggle()
                            stopSpeaking()
                        }
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showPopover.toggle()
                        }) {
                            Text("History")
                                .foregroundColor(Color(hex: "EB1D36"))
                        }
                        .padding(.trailing, 20)
                    }
                }
                .popover(isPresented: $showPopover, arrowEdge: .top) {
                    VStack {
                        List(aiResponses, id: \.self) { response in
                            Button(action: {
                                selectedResponse = response
                            }) {
                                VStack(alignment: .leading) {
                                    Text(response)
                                        .foregroundColor(Color(hex: "EB1D36"))
                                        .lineLimit(1)
                                        .foregroundColor(.primary)
                                    if selectedResponse == response {
                                        Text(response)
                                            .foregroundColor(Color(hex: "EB1D36"))
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .frame(width: 300, height: 400) 
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
            }
            .onAppear {
            }
        }
    }

    func generateResponse() {
        response = ""

        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                let newResponse = result.text ?? "No response found"
                aiResponses.append(newResponse)
                speakResponse(newResponse)
                userPrompt = ""

            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
            }
        }
    }

    func speakResponse(_ text: String) {
        recognizer.processString(text)
        guard let lang = recognizer.dominantLanguage?.rawValue else {
            print("Language recognition failed.")
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        utterance.pitchMultiplier = 1.6
        utterance.rate = 0.5

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
            return
        }

        speechSynthesizer.speak(utterance)
    }

    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
}

struct AnimatedCircleView: View {
    @Binding var isAnimating: Bool
    var onTap: () -> Void

    var body: some View {
        Circle()
            .stroke(style: StrokeStyle())
            .foregroundColor(Color(hex: "EB1D36"))
            .frame(width: 25, height: 25)
            .shadow(color: .red, radius: 2, x: 1, y: 2)
            .scaleEffect(isAnimating ? 1.5 : 1)
            .animation(
                isAnimating ?
                .easeInOut(duration: 1).repeatForever(autoreverses: true) :
                    .default,
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
            .onTapGesture {
                onTap()
            }
    }
}

struct CircleView: View {
    var text: String

    var body: some View {
        Circle()
            .fill(Color(hex: "EB1D36"))
            .overlay(
                Text(text)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            )
            .frame(width: 100, height: 100)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
