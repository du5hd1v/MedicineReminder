import Combine
import Foundation

@MainActor
final class MedicineStore: ObservableObject {
    @Published var medicines: [Medicine] = [] {
        didSet { save() }
    }

    private let storageKey = "saved_medicines_v2"
    private let oldStorageKey = "saved_medicines"

    init() { load() }

    var todaysMedicines: [Medicine] {
        medicines.filter(\.isActive).sorted { first, second in
            if first.hour == second.hour { return first.minute < second.minute }
            return first.hour < second.hour
        }
    }

    var completedTodayCount: Int { todaysMedicines.filter(\.wasTakenToday).count }

    var progressToday: Double {
        guard !todaysMedicines.isEmpty else { return 0 }
        return Double(completedTodayCount) / Double(todaysMedicines.count)
    }

    var totalTakenCount: Int { medicines.reduce(0) { $0 + $1.takenDates.count } }

    func addMedicine(name: String, dosage: String, notes: String, reminderTime: Date, category: MedicineCategory, supplyCount: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let medicine = Medicine(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            dosage: dosage.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            hour: components.hour ?? 8,
            minute: components.minute ?? 0,
            category: category,
            supplyCount: max(0, supplyCount)
        )
        medicines.append(medicine)
        NotificationManager.shared.scheduleReminder(for: medicine)
    }

    func updateMedicine(_ medicine: Medicine, name: String, dosage: String, notes: String, reminderTime: Date, category: MedicineCategory, supplyCount: Int) {
        guard let index = medicines.firstIndex(where: { $0.id == medicine.id }) else { return }
        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        medicines[index].name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        medicines[index].dosage = dosage.trimmingCharacters(in: .whitespacesAndNewlines)
        medicines[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        medicines[index].hour = components.hour ?? medicines[index].hour
        medicines[index].minute = components.minute ?? medicines[index].minute
        medicines[index].category = category
        medicines[index].supplyCount = max(0, supplyCount)
        NotificationManager.shared.cancelReminder(for: medicines[index])
        if medicines[index].isActive { NotificationManager.shared.scheduleReminder(for: medicines[index]) }
    }

    func markTaken(_ medicine: Medicine) {
        guard let index = medicines.firstIndex(where: { $0.id == medicine.id }) else { return }
        if medicines[index].wasTakenToday {
            medicines[index].takenDates.removeAll { Calendar.current.isDateInToday($0) }
            medicines[index].supplyCount += 1
        } else {
            medicines[index].takenDates.append(Date())
            if medicines[index].supplyCount > 0 { medicines[index].supplyCount -= 1 }
        }
    }

    func toggleActive(_ medicine: Medicine) {
        guard let index = medicines.firstIndex(where: { $0.id == medicine.id }) else { return }
        medicines[index].isActive.toggle()
        if medicines[index].isActive {
            NotificationManager.shared.scheduleReminder(for: medicines[index])
        } else {
            NotificationManager.shared.cancelReminder(for: medicines[index])
        }
    }

    func delete(_ medicine: Medicine) {
        NotificationManager.shared.cancelReminder(for: medicine)
        medicines.removeAll { $0.id == medicine.id }
    }

    func resetSampleData() {
        medicines.forEach { NotificationManager.shared.cancelReminder(for: $0) }
        medicines = Medicine.sampleData
        medicines.forEach { NotificationManager.shared.scheduleReminder(for: $0) }
    }

    private func load() {
        let data = UserDefaults.standard.data(forKey: storageKey) ?? UserDefaults.standard.data(forKey: oldStorageKey)
        guard let data else { medicines = Medicine.sampleData; return }
        do {
            medicines = try JSONDecoder().decode([Medicine].self, from: data)
        } catch {
            medicines = Medicine.sampleData
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(medicines) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

extension Medicine {
    static let sampleData = [
        Medicine(name: "Vitamin C", dosage: "1 tablet", notes: "After breakfast", hour: 8, minute: 30, category: .vitamin, supplyCount: 12),
        Medicine(name: "Allergy Tablet", dosage: "5 mg", notes: "Take with water", hour: 20, minute: 0, category: .tablet, supplyCount: 8),
        Medicine(name: "Cough Syrup", dosage: "10 ml", notes: "Shake bottle before use", hour: 13, minute: 15, category: .syrup, supplyCount: 6)
    ]
}
