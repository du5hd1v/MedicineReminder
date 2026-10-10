import Foundation
import SwiftUI

enum MedicineCategory: String, CaseIterable, Codable, Identifiable {
    case tablet = "Tablet"
    case capsule = "Capsule"
    case syrup = "Syrup"
    case injection = "Injection"
    case vitamin = "Vitamin"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .tablet: return "pills.fill"
        case .capsule: return "capsule.fill"
        case .syrup: return "drop.fill"
        case .injection: return "cross.case.fill"
        case .vitamin: return "leaf.fill"
        case .other: return "heart.text.square.fill"
        }
    }

    var color: Color {
        switch self {
        case .tablet: return .teal
        case .capsule: return .indigo
        case .syrup: return .orange
        case .injection: return .red
        case .vitamin: return .green
        case .other: return .purple
        }
    }
}

struct Medicine: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var dosage: String
    var notes: String
    var hour: Int
    var minute: Int
    var category: MedicineCategory
    var supplyCount: Int
    var isActive: Bool
    var createdAt: Date
    var takenDates: [Date]

    init(id: UUID = UUID(), name: String, dosage: String, notes: String, hour: Int, minute: Int, category: MedicineCategory = .tablet, supplyCount: Int = 10, isActive: Bool = true, createdAt: Date = Date(), takenDates: [Date] = []) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.notes = notes
        self.hour = hour
        self.minute = minute
        self.category = category
        self.supplyCount = supplyCount
        self.isActive = isActive
        self.createdAt = createdAt
        self.takenDates = takenDates
    }

    var timeText: String {
        let date = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()
        return date.formatted(date: .omitted, time: .shortened)
    }

    var wasTakenToday: Bool {
        takenDates.contains { Calendar.current.isDateInToday($0) }
    }

    var takenCountThisWeek: Int {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return 0 }
        return takenDates.filter { $0 >= weekStart }.count
    }

    var nextDoseText: String {
        isActive ? "Next dose at \(timeText)" : "Reminder paused"
    }
}
