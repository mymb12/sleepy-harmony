import SwiftUI
import UserNotifications

struct ContentView: View {
    
    var body: some View {
        TabView{
            
            bio_rythms()
                .tabItem { Label("Home", systemImage: "house") }
            
            SingleLineLollipop(isOverview: false)
                .tabItem { Label("Charts", systemImage: "chart.pie.fill") }
            
            about_us()
                .tabItem { Label("Us", systemImage: "info.circle") }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            checkForPermission()
        }
    }
}

#Preview {
    ContentView()
}

let ND = ["Создайте регулярный график сна":"Ложитесь и вставайте каждый день в одно и то же время, даже по выходным. Это поможет вашему организму установить циркадианный ритм",
                                           "Создайте комфортную атмосферу для сна":"Обеспечьте темную, тихую и прохладную спальню. Используйте удобную постель и подушки.",
                                           "Избегайте крупных приемов пищи и алкоголя перед сном":"Попытайтесь не употреблять пищу и напитки, содержащие кофеин, алкоголь и слишком много сахара, перед сном.",
                                           "Практикуйте расслабляющие техники":"Медитация, глубокое дыхание и йога могут помочь уменьшить стресс и успокоить ум перед сном."
]

let NDIdentifier = ["Создайте регулярный график сна", "Создайте комфортную атмосферу для сна", "Практикуйте расслабляющие техники"]

func checkForPermission() {
    let notificationCentre = UNUserNotificationCenter.current()
    notificationCentre.getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .notDetermined:
            notificationCentre.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                if didAllow {
                    let id = Int.random(in: 0..<NDIdentifier.count)
                    dispatchNotification(hours: 17, minute: 20, Title:  NDIdentifier[id], Body: ND[NDIdentifier[id]] ?? "")
                }
            }
        case .denied:
            return
        case .authorized:
            let id = Int.random(in: 0..<NDIdentifier.count)
            dispatchNotification(hours: 12, minute: 20, Title:  NDIdentifier[id], Body: ND[NDIdentifier[id]] ?? "")
        default :
            return
        }
    }
}

func dispatchNotification(hours: Int, minute: Int, Title: String, Body: String) {
    let identifier = "defaulf-notification"
    let title = Title
    let body = Body
    let hour = hours
    let minutes = minute
    let isDaily = true
    
    let notificationCentre = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    let calendar = Calendar.current
    var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
    dateComponents.hour = hour
    dateComponents.minute = minutes
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    notificationCentre.removePendingNotificationRequests(withIdentifiers: [identifier])
    notificationCentre.add(request)
}
