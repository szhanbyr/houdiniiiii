import SwiftUI
import Foundation


struct ScheduleView: View {
    @State private var showAddClassSheet = false
    @State private var schedule: [String: [(String, Date, String)]] = [
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": [],
        "Saturday": [],
        "Sunday": []
    ]
    
    var body: some View {
        VStack {
            
            ScrollView {
                ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) { day in
                    VStack(alignment: .leading) {
                        Text(day)
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(schedule[day]?.sorted(by: { $0.1 < $1.1 }) ?? [], id: \.0) { (className, classTime, _) in
                                    VStack {
                                        Text(className)
                                        Text(timeFormatter.string(from: classTime))
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Schedule")
        .padding()
        Button(action: {
            showAddClassSheet.toggle()
        }) {
            Text("Add Class")
                .padding()
                .background(Color(hex: "EB1D36"))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .sheet(isPresented: $showAddClassSheet) {
            AddClassView(schedule: $schedule)
        }
    }
}

struct AddClassView: View {
    @Binding var schedule: [String: [(String, Date, String)]]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDay: String = "Monday"
    @State private var className: String = ""
    @State private var classTime: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Class Details")) {
                    Picker("Day of the Week", selection: $selectedDay) {
                        ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Class Name", text: $className)
                    DatePicker("Class Time", selection: $classTime, displayedComponents: .hourAndMinute)
                }
                
                Button(action: {
                    let newClass = (className, classTime, selectedDay)
                    schedule[selectedDay]?.append(newClass)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Class")
                }
            }
            .navigationTitle("Add Class")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()
