import SwiftUI

struct ReferencesView: View {
    @State private var showPopup1 = false
    @State private var showPopup2 = false
    @State private var showPopup3 = false
    
    var body: some View {
        VStack(spacing: 20) {
            SectionButton(color: Color(hex: "EB1D36"), text: "Ielts", isPresented: $showPopup1)
                .onTapGesture {
                    self.showPopup1.toggle()
                }
            SectionButton(color: Color(hex: "EB1D36"), text: "SAT", isPresented: $showPopup2)
                .onTapGesture {
                    self.showPopup2.toggle()
                }
            
            Spacer()
        }
        .padding()
        .padding(.top, 100)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SectionButtonn: View {
    var color: Color
    var text: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            color
                .frame(maxWidth: .infinity, maxHeight: 100)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .sheet(isPresented: $isPresented) {
            PopupView(title: text)
        }
    }
}

struct PopupVieww: View {
    var title: String
    
    var body: some View {
        VStack {
            Text("Popup for \(title)")
                .font(.title)
                .padding()
            
            Spacer()
        }
    }
}
