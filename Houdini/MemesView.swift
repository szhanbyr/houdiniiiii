import SwiftUI

struct MemesView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Image("memes")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .opacity(0.8)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 150)
                Text("Meme")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            .cornerRadius(10)
            .shadow(radius: 5)
            ZStack {
                Image("motivation")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .opacity(0.8)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 150)
                Text("Motivation")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            ZStack {
                Image("help")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .opacity(0.8)
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.clear, .white]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 150)
                Text("Mental help")
                    .foregroundColor(.black)
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct MemesView_Previews: PreviewProvider {
    static var previews: some View {
        MemesView()
    }
}
