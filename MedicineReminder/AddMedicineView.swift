import SwiftUI

struct AddMedicineView: View {
    @EnvironmentObject private var store: MedicineStore
    @State private var name = ""
    @State private var dosage = ""
    @State private var notes = ""
    @State private var reminderTime = Date()
    @State private var category: MedicineCategory = .tablet
    @State private var supplyCount = 10
    @State private var showSavedMessage = false

    var body: some View {
        NavigationStack {
            MedicineFormView(
                title: "Add Medicine",
                buttonTitle: "Save Medicine",
                name: $name,
                dosage: $dosage,
                notes: $notes,
                reminderTime: $reminderTime,
                category: $category,
                supplyCount: $supplyCount
            ) { saveMedicine() }
            .alert("Medicine saved", isPresented: $showSavedMessage) { Button("OK", role: .cancel) {} }
        }
    }

    private func saveMedicine() {
        store.addMedicine(name: name, dosage: dosage, notes: notes, reminderTime: reminderTime, category: category, supplyCount: supplyCount)
        name = ""; dosage = ""; notes = ""; reminderTime = Date(); category = .tablet; supplyCount = 10
        showSavedMessage = true
    }
}

struct MedicineFormView: View {
    let title: String
    let buttonTitle: String
    @Binding var name: String
    @Binding var dosage: String
    @Binding var notes: String
    @Binding var reminderTime: Date
    @Binding var category: MedicineCategory
    @Binding var supplyCount: Int
    let onSave: () -> Void

    var body: some View {
        Form {
            Section("Medicine") {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                Picker("Type", selection: $category) {
                    ForEach(MedicineCategory.allCases) { item in
                        Label(item.rawValue, systemImage: item.icon).tag(item)
                    }
                }
                Stepper("Supply left: \(supplyCount)", value: $supplyCount, in: 0...365)
            }

            Section("Reminder") {
                DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }

            Section("Notes") {
                TextField("Example: after food", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section {
                Button(action: onSave) {
                    Label(buttonTitle, systemImage: "bell.badge.fill")
                        .frame(maxWidth: .infinity)
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || dosage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle(title)
    }
}
