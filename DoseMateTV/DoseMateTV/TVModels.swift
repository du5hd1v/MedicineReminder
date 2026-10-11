import Foundation
import SwiftUI

struct FamilyMember: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let color: Color
    let medicines: [TVMedicine]

    var completedCount: Int { medicines.filter(\.isTaken).count }
    var progress: Double {
        guard !medicines.isEmpty else { return 0 }
        return Double(completedCount) / Double(medicines.count)
    }
}

struct TVMedicine: Identifiable {
    let id = UUID()
    let name: String
    let dosage: String
    let time: String
    let icon: String
    let isTaken: Bool
    let isUrgent: Bool
}

struct TVDosePlan: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

extension FamilyMember {
    static let samples: [FamilyMember] = [
        FamilyMember(
            name: "Amma",
            role: "Parent",
            color: .teal,
            medicines: [
                TVMedicine(name: "Blood Pressure", dosage: "1 tablet", time: "7:30 AM", icon: "heart.fill", isTaken: true, isUrgent: false),
                TVMedicine(name: "Vitamin D", dosage: "1 capsule", time: "12:00 PM", icon: "sun.max.fill", isTaken: false, isUrgent: false),
                TVMedicine(name: "Night Tablet", dosage: "5 mg", time: "8:00 PM", icon: "moon.fill", isTaken: false, isUrgent: true)
            ]
        ),
        FamilyMember(
            name: "Thaththa",
            role: "Parent",
            color: .indigo,
            medicines: [
                TVMedicine(name: "Diabetes Care", dosage: "500 mg", time: "8:00 AM", icon: "cross.case.fill", isTaken: true, isUrgent: false),
                TVMedicine(name: "Cholesterol", dosage: "1 tablet", time: "9:00 PM", icon: "pills.fill", isTaken: false, isUrgent: true)
            ]
        ),
        FamilyMember(
            name: "Me",
            role: "Student",
            color: .orange,
            medicines: [
                TVMedicine(name: "Allergy Tablet", dosage: "10 mg", time: "6:00 PM", icon: "leaf.fill", isTaken: false, isUrgent: false),
                TVMedicine(name: "Cough Syrup", dosage: "10 ml", time: "9:30 PM", icon: "drop.fill", isTaken: false, isUrgent: false)
            ]
        )
    ]
}

extension TVDosePlan {
    static let samples: [TVDosePlan] = [
        TVDosePlan(title: "Family View", subtitle: "One TV screen for everyone at home", icon: "person.3.fill", color: .teal),
        TVDosePlan(title: "Remote Friendly", subtitle: "Large focus cards designed for Apple TV", icon: "appletvremote.gen4.fill", color: .blue),
        TVDosePlan(title: "Care Alerts", subtitle: "Urgent medicine doses stand out clearly", icon: "bell.badge.fill", color: .red),
        TVDosePlan(title: "Market Value", subtitle: "Useful for families, elders, and shared living", icon: "chart.line.uptrend.xyaxis", color: .green)
    ]
}
