//
//  AcademicsView.swift
//  Campus
//
//  Created by Drake Geeteh on 5/19/24.
//
// Signed User View

import Foundation
import SwiftUI

struct AcademicsView: View {
@StateObject var taskViewModel = TaskViewModel()
@StateObject var courseViewModel = CourseViewModel()
@State private var showingSignOutConfirmation: Bool = false
@Binding var isSignedIn: Bool


var body: some View {
    NavigationView {
        ScrollView {
            VStack(alignment: .leading) {
            
                
                
                Text("Your Calendar")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text("Fall 2024 Semester")
                    .font(.subheadline)
                    .foregroundColor(.white)

                GroupBox {
                    CalendarView()
                        .environmentObject(taskViewModel)
                }
                
                EmptySpacer(padding:0)
                HStackImageSet()
                EmptySpacer(padding:0)
                
                Text("Your Courses")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text("Provided by Canvas")
                    .font(.subheadline)
                    .foregroundColor(.white)

                GroupBox {
                    CourseGradesView()
                        .environmentObject(courseViewModel)
                }
                
                EmptySpacer(padding:0)
                                
                Text("Fall 2024 OSU Academic Calendar")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text("Add/Drop Deadlines, Holidays, and More")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                GroupBox {
                    ScrollView {
                        AcademicScheduleView()
                    }
                }
                .frame(height:400)
                
                EmptySpacer(padding:0)
                
                Text("A Drake Geeteh Production")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemGray))
                    .padding(.bottom, 20)
                    .frame(maxWidth:.infinity)
                
            }
            .padding()
        }
        .navigationBarTitle("Academics")
                    .navigationBarItems(trailing: Button(action: {
                        showingSignOutConfirmation = true
                    }) {
                        Image(systemName: "door.left.hand.open")
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                    })
                    .overlay(
                        Group {
                            if showingSignOutConfirmation {
                                CustomConfirmationDialog(isPresented: $showingSignOutConfirmation, isSignedIn: $isSignedIn)
                            }
                        }
                    )
    }
    .colorScheme(.dark)
    .accentColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
}
}

struct CalendarView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var currentDate = Date()
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                }
                Spacer()
                Text(dateFormatter.string(from: currentDate))
                    .font(.title)
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                }
            }
            .padding()
            
            let days = generateDaysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .padding(.bottom, 10)
                }
                ForEach(days, id: \.self) { day in
                    if day == 0 {
                        Color.clear
                            .frame(height: 40)
                            .padding(2)
                    } else {
                        NavigationLink(destination: DayDetailView(day: day, date: getDate(for: day)).environmentObject(taskViewModel)) {
                            GeometryReader { geometry in
                                ZStack(alignment: .topTrailing) {
                                    Text("\(day)")
                                        .frame(width: geometry.size.width, height: geometry.size.width)
                                        .background(Color.black.opacity(0.3))
                                        .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                                        .cornerRadius(10)
                                        .padding(2)
                                    
                                    let date = getDate(for: day)
                                    let uncompletedTaskCount = taskViewModel.tasksByDate[date]?.filter { !$0.completed }.count ?? 0
                                    if uncompletedTaskCount > 0 {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                Text("\(uncompletedTaskCount)")
                                                    .foregroundColor(.white)
                                                    .font(.caption)
                                            )
                                            .offset(x: 5, y: -5)
                                    }
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                            
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? Date()
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? Date()
    }
    
    private func generateDaysInMonth() -> [Int] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {
            return []
        }
        var days = Array(repeating: 0, count: calendar.component(.weekday, from: firstOfMonth()) - 1)
        days += range.map { $0 }
        return days
    }
    
    private func firstOfMonth() -> Date {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components) ?? Date()
    }
    
    private func getDate(for day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
}

struct DayDetailView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    let day: Int
    let date: Date
    @State private var showingAddTaskView = false
    
    private var tasksForDay: [Task] {
        taskViewModel.tasksByDate[date]?.filter { Calendar.current.isDate($0.date, inSameDayAs: date) } ?? []
    }
    
    var body: some View {
        VStack {
            Text("Tasks for \(formattedDate())")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            List {
                ForEach(tasksForDay) { task in
                    TaskRow(task: task)
                }
            }
            
            Button(action: {
                showingAddTaskView = true
            }) {
                Text("Add Custom Task")
                    .padding()
                    .background(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView(date: date, taskViewModel: taskViewModel)
            }
            
            Spacer()
        }
        .navigationTitle("Day Details")
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct TaskRow: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    let task: Task
    
    var body: some View {
        HStack {
            Button(action: {
                taskViewModel.markTaskAsComplete(task)
            }) {
                HStack {
                    Text(task.title)
                        .strikethrough(task.completed, color: .black)
                    Spacer()
                    if task.completed {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
            }
            
            Button(action: {
                taskViewModel.deleteTask(task)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}


struct TaskItemView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    let task: Task

    var body: some View {
        HStack {
            Button(action: {
                taskViewModel.markTaskAsComplete(task)
            }) {
                HStack {
                    Text(task.title)
                        .strikethrough(task.completed, color: .black)
                    Spacer()
                    if task.completed {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
            }

            Button(action: {
                taskViewModel.deleteTask(task)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}



struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var taskTitle = ""
    let date: Date
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Title")) {
                    TextField("Enter task title", text: $taskTitle)
                }
                
                Button(action: addTask) {
                    Text("Save")
                }
            }
            .navigationTitle("Add Task")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addTask() {
        let newTask = Task(id: UUID(), title: taskTitle, date: date, completed: false)
        taskViewModel.addTask(newTask)
        presentationMode.wrappedValue.dismiss()
    }
}

class TaskViewModel: ObservableObject {
    @Published var tasksByDate: [Date: [Task]] = [:] {
        didSet {
            saveTasks()
        }
    }
    
    init() {
        loadTasks()
    }
    
    func addTask(_ task: Task) {
        let date = stripTime(from: task.date)
        
        if tasksByDate[date] == nil {
            tasksByDate[date] = [task]
        } else {
            tasksByDate[date]?.append(task)
        }
    }
    
    func markTaskAsComplete(_ task: Task) {
        let date = stripTime(from: task.date)
        if let index = tasksByDate[date]?.firstIndex(where: { $0.id == task.id }) {
            tasksByDate[date]?[index].completed.toggle()
        }
    }
    
    func deleteTask(_ task: Task) {
        let date = stripTime(from: task.date)
        tasksByDate[date]?.removeAll { $0.id == task.id }
    }
    
    private func saveTasks() {
        var tasksToSave: [Date: [Task]] = [:]
        tasksByDate.forEach { (date, tasks) in
            tasksToSave[date] = tasks
        }
        
        if let encoded = try? JSONEncoder().encode(tasksToSave) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Date: [Task]].self, from: savedTasks) {
            self.tasksByDate = decoded
        }
    }
    
    private func stripTime(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? date
    }
}


struct CourseGradesView: View {
@EnvironmentObject var courseViewModel: CourseViewModel


var body: some View {
    VStack(alignment: .leading) {
        ForEach(courseViewModel.courses) { course in
            NavigationLink(destination: CourseDetailView(course: course)) {
                HStack {
                    Text(course.name)
                        .font(.headline)
                    Spacer()
                    Text(course.grade)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 5)
            }
            
        }
    }
    .padding()
}
}

struct CourseDetailView: View {
let course: Course


var body: some View {
    VStack(alignment: .leading) {
        HStack {
            Text("Course:")
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                .font(.headline)
            Text(course.name)
                .font(.subheadline)
        }
                    
        HStack {
            Text("Professor:")
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                .font(.headline)
            Text(course.professor)
                .font(.subheadline)
        }
                    
        HStack {
            Text("Syllabus:")
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
                .font(.headline)
            Text(course.syllabus)
                .font(.subheadline)
        }
        EmptySpacer(padding:0)
        Text("Assignments Due:")
            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            .font(.headline)
        
        List(course.assignments) { assignment in
            HStack {
                Text(assignment.title)
                Spacer()
                Text(assignment.dueDate)
                    .foregroundColor(.gray)
            }
        }

        Spacer()
    }
    .padding()
    .navigationTitle(course.name)
}
}

class CourseViewModel: ObservableObject {
@Published var courses: [Course] = [
Course(id: UUID(), name: "CS3443 Computer Systems", grade: "94.5%", professor: "Dr. Smith", syllabus: "CS3443_Syllabus.pdf", assignments: [
Assignment(id: UUID(), title: "Assignment 1", dueDate: "11:59pm, Monday, September 23"),
Assignment(id: UUID(), title: "Assignment 2", dueDate: "11:59pm, Tuesday, September 24")
]),
Course(id: UUID(), name: "CS3353 Data Structures and Algorithm Analysis I", grade: "95.13%", professor: "Dr. Johnson", syllabus: "CS3353_Syllabus.pdf", assignments: [
Assignment(id: UUID(), title: "Assignment 1", dueDate: "11:59pm, Monday, September 23"),
Assignment(id: UUID(), title: "Assignment 2", dueDate: "11:59pm, Tuesday, September 24")
]),
Course(id: UUID(), name: "STAT4033 Engineering Statistics", grade: "92.2%", professor: "Dr. Lee", syllabus: "STAT4033_Syllabus.pdf", assignments: [
Assignment(id: UUID(), title: "Assignment 1", dueDate: "11:59pm, Monday, September 23"),
Assignment(id: UUID(), title: "Assignment 2", dueDate: "11:59pm, Tuesday, September 24")
])
]
}

// formatted with llm
struct AcademicScheduleView: View {
    var body: some View {
        VStack(alignment: .leading) {
                Group {
                    Text("August 5-16")
.font(.headline)
.foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
Text("Fall pre-session (two weeks)")


            Spacer(minLength: 25)

            Text("Tuesday, August 13")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Instructors may begin submitting final grades for fall pre-session classes")

            Spacer(minLength: 25)

            Text("Monday, August 19")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            HStack {
                Text("Late enrollment fee (assessed if initial enrollment occurs on or after this date)")
                Link("[details]*", destination: URL(string: "http://catalog.okstate.edu/university-academic-regulations/#UAR-5.9")!)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            }

            Spacer(minLength: 25)

            Text("Monday, August 19")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Class work begins")

            Spacer(minLength: 25)

            Text("Monday, August 26")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            HStack {
                Text("100% Refund, Nonrestrictive Drop/Add Deadline")
                Link("[details]*", destination: URL(string: "https://registrar.okstate.edu/academic_calendar/drop_add_withdraw_deadline_details.html")!)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            }
        }

        Spacer(minLength: 25)

        Group {
            Text("Friday, August 30")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            HStack {
                Text("Partial Refund, Restrictive Drop/Add Deadline")
                Link("[details]*", destination: URL(string: "https://registrar.okstate.edu/academic_calendar/drop_add_withdraw_deadline_details.html")!)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            }

            Spacer(minLength: 25)

            Text("Monday, September 2")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("University Holiday")

            Spacer(minLength: 25)

            Text("Friday, September 13")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            HStack {
                Text("Excessive absence alerts due from instructors")
                Link("[details]*", destination: URL(string: "https://registrar.okstate.edu/banner_faculty/banner_progress_report_academic_alert_system_faculty.html")!)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            }

            Spacer(minLength: 25)

            Text("Tuesday, September 24")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Instructors may begin submitting six-week grades")

            Spacer(minLength: 25)

            Text("Wednesday, October 2 (noon)")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Six week grades due by noon from faculty")

            Spacer(minLength: 25)

            Text("Tuesday, October 8")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Instructors may begin submitting final grades for sessions that end the first eight weeks")
        }

        Spacer(minLength: 25)

        Group {
            Text("Friday, November 1")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Deadline to file graduation application (for name to appear in the fall commencement program)")

            Spacer(minLength: 25)

            Text("Friday, November 8")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            HStack {
                Text("W Drop/Withdrawal Deadline")
                Link("[details]*", destination: URL(string: "https://registrar.okstate.edu/academic_calendar/drop_add_withdraw_deadline_details.html")!)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            }

            Spacer(minLength: 25)

            Text("Monday-Wednesday, November 25-27")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Students’ Fall Break (No Classes)")

            Spacer(minLength: 25)

            Text("Thursday-Friday, November 28-29")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("University Holiday")

            Spacer(minLength: 25)

            Text("Monday, December 2")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            HStack {
                Text("Assigned W or F Drop/Withdrawal Deadline")
                Link("[details]*", destination: URL(string: "https://registrar.okstate.edu/academic_calendar/drop_add_withdraw_deadline_details.html")!)
                    .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            }

            Spacer(minLength: 25)

            Text("Monday-Friday, December 2-6")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Pre-Finals Week")

            Spacer(minLength: 25)

            Text("Tuesday, December 3")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Instructors may begin submitting final grades for all fall classes")

            Spacer(minLength: 25)

            Text("Friday, December 6")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Class work ends")

            Spacer(minLength: 25)

            Text("Monday-Friday, December 9-13")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Finals Week")

            Spacer(minLength: 25)

            Text("Friday, December 13")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Graduate Commencement")

            Spacer(minLength: 25)

            Text("Saturday, December 14")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Undergraduate Commencement")

            Spacer(minLength: 25)

            Text("Wednesday, December 18 (12:00 pm)")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Final grades due electronically from faculty")

            Spacer(minLength: 25)

            Text("Friday, December 20")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("Final grades for all fall courses available on official transcripts")

            Spacer(minLength: 25)

            Text("Monday, December 23 - Wednesday, January 1")
                .font(.headline)
                .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            Text("University Holiday")
        }
    }
}
}

struct HStackImageSet: View {
// Array of image filenames
private let imageFileNames = [
"Students on Campus 2022 - 1",
"Old Central 2024 - 4",
"McKnight Center - Summer 2021 - 4",
"McKnight Center - Summer 2021 - 3",
"Library Details - 6",
"Campus Photos - Fall 2020 - 4",
"Campus Fall 2022 - 1",
"Campus buildings at evening - 6",
"Campus buildings at evening - 2"
]


@State private var imageFilenames: [String] = []

var body: some View {
        HStack {
            ForEach(imageFilenames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(1)
            }
        }
        .onAppear {
            loadRandomImages()
        }
        .frame(maxWidth: .infinity, alignment: .center)

}

private func loadRandomImages() {
        var uniqueIndices: Set<Int> = []
        
        // Generate 3 unique random indices
        while uniqueIndices.count < 3 {
            uniqueIndices.insert(Int.random(in: 0..<imageFileNames.count))
        }
        
        // Load the corresponding filenames
        imageFilenames = uniqueIndices.map { imageFileNames[$0] }
    }
}

struct CustomConfirmationDialog: View {
@Binding var isPresented: Bool
@Binding var isSignedIn: Bool


var body: some View {
    VStack(spacing: 20) {
        Text("Sign Out")
            .font(.headline)
            .foregroundColor(.white)
        
        Text("Are you sure you want to sign out?")
            .font(.subheadline)
            .foregroundColor(.white)
        
        HStack {
            Button("Cancel") {
                isPresented = false
            }
            .padding()
            .fontWeight(.bold)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Sign Out") {
                isSignedIn = false
                UserDefaults.standard.set(false, forKey: "isSignedIn")
                isPresented = false
            }
            .padding()
            .fontWeight(.bold)
            .foregroundColor(Color(hue: 0.067, saturation: 1.0, brightness: 0.986))
            .cornerRadius(8)
        }
    }
    .padding()
    .background(.black)
    .cornerRadius(12)
    .shadow(radius: 20)
    .frame(maxWidth: 300)
    .transition(.scale)
    .animation(.easeInOut, value: isPresented)
}
}

struct Course: Identifiable {
let id: UUID
let name: String
let grade: String
let professor: String
let syllabus: String
let assignments: [Assignment]
}

struct Assignment: Identifiable {
let id: UUID
let title: String
let dueDate: String
}

struct Task: Identifiable, Codable {
let id: UUID
let title: String
let date: Date
var completed: Bool
}





