import SwiftUI
import WebKit


struct Video: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let thumbnailURL: URL
    let videoURL: URL
}

class VideoViewModel: ObservableObject {
    @Published var videos: [Video] = []

    init() {
        loadVideos()
    }

    func loadVideos() {
        videos = [
            Video(id: UUID(),
                  title: "Gojo",
                  description: "Lobotomy Kaisen",
                  thumbnailURL: URL(string: "https://i.ytimg.com/vi/tFj633m0IXg/hqdefault.jpg?sqp=-oaymwE2CNACELwBSFXyq4qpAygIARUAAIhCGAFwAcABBvABAfgB_gmAAtAFigIMCAAQARgzIGIocjAP&rs=AOn4CLC-m7_txPjjiY7UBiEBhq5US5uw7g")!,
                  videoURL: URL(string: "https://youtu.be/y25k0SImB8Y?si=Wo47Ds4_v8KhMENT")!)
        ]
    }

    func addVideo(title: String, urlString: String, description: String) {
        guard let videoURL = URL(string: urlString),
              let thumbnailURL = URL(string: "https://img.youtube.com/vi/\(videoURL.lastPathComponent)/hqdefault.jpg") else {
            return
        }
        let newVideo = Video(id: UUID(),
                             title: title,
                             description: description,
                             thumbnailURL: thumbnailURL,
                             videoURL: videoURL)
        videos.append(newVideo)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
struct LessonsView: View {
    @ObservedObject var viewModel = VideoViewModel()
    @State private var selectedVideo: Video?
    @State private var showAddVideoPopup = false
    @State private var newVideoTitle = ""
    @State private var newVideoURL = ""
    @State private var newVideoDescription = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.videos) { video in
                            VideoRow(video: video)
                                .onTapGesture {
                                    selectedVideo = video
                                }
                        }
                    }
                    .padding()
                }
                Button(action: {
                    showAddVideoPopup = true
                }) {
                    Text("Add Video")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "EB1D36"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Video Lessons")
            .sheet(item: $selectedVideo) { video in
                VideoDetailView(video: video)
            }
            .sheet(isPresented: $showAddVideoPopup) {
                VStack {
                    Text("Add New Video")
                        .font(.headline)
                    TextField("Video Title", text: $newVideoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("YouTube URL", text: $newVideoURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Video Description", text: $newVideoDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button(action: {
                            viewModel.addVideo(title: newVideoTitle, urlString: newVideoURL, description: newVideoDescription)
                            newVideoTitle = ""
                            newVideoURL = ""
                            newVideoDescription = ""
                            showAddVideoPopup = false
                        }) {
                            Text("Add")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "EB1D36"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct VideoRow: View {
    let video: Video

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: video.thumbnailURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 200)
            }
            Text(video.title)
                .font(.headline)
                .padding([.top, .leading, .trailing])
            Text(video.description)
                .font(.subheadline)
                .padding([.leading, .trailing, .bottom])
                .lineLimit(2)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct VideoDetailView: View {
    let video: Video

    var body: some View {
        VStack {
            WebView(url: video.videoURL)
                .frame(height: 300)
            Text(video.description)
                .padding()
            Spacer()
        }
        .navigationTitle(video.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView()
    }
}
