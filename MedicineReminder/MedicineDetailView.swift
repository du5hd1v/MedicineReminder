import SwiftUI

struct MedicineDetailView: View {
    @EnvironmentObject private var store: MedicineStore
    @Environment(\.dismiss) private var dismiss
    let medicineID: UUID
    @State private var isEditing = false
    @State private var showDeleteConfirm = false

    private var medicine: Medicine? { store.medicines.first { $0.id == medicineID } }

    var body: some View {
        Group {
            if let medicine {
                List {
                    Section {
                        HStack(spacing: 14) {
                            Image(systemName: medicine.category.icon)
                                .font(.title)
                                .foregroundStyle(medicine.category.color)
                                .frame(width: 58, height: 58)
                                .background(medicine.category.color.opacity(0.14), in: RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(medicine.name).font(.title3.bold())
                                Text(medicine.nextDoseText).foregroundStyle(.secondary)
                            }
                        }
                    }

                    Section("Dose") {
                        Label(medicine.dosage, systemImage: "cross.case")
                        Label(medicine.category.rawValue, systemImage: medicine.category.icon)
                        Label("\(medicine.supplyCount) doses left", systemImage: medicine.supplyCount <= 3 ? "exclamationmark.triangle.fill" : "shippingbox.fill")
                            .foregroundStyle(medicine.supplyCount <= 3 ? .red : .primary)
                    }

                    Section("Progress") {
                        Label(medicine.wasTakenToday ? "Taken today" : "Not taken today", systemImage: medicine.wasTakenToday ? "checkmark.circle.fill" : "circle")
                        Label("\(medicine.takenCountThisWeek) taken this week", systemImage: "chart.bar.fill")
                        Button { store.markTaken(medicine) } label: {
                            Label(medicine.wasTakenToday ? "Undo Taken" : "Mark Taken", systemImage: medicine.wasTakenToday ? "arrow.uturn.backward" : "checkmark")
                        }
                    }

                    Section("Notes") {
                        Text(medicine.notes.isEmpty ? "No notes added." : medicine.notes)
                            .foregroundStyle(medicine.notes.isEmpty ? .secondary : .primary)
                    }

                    Section("Reminder") {
                        Button { store.toggleActive(medicine) } label: {
                            Label(medicine.isActive ? "Turn Reminder Off" : "Turn Reminder On", systemImage: medicine.isActive ? "bell.slash" : "bell")
                        }
                    }

                    Section {
                        Button(role: .destructive) { showDeleteConfirm = true } label: {
                            Label("Delete Medicine", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle("Details")
                .toolbar { Button("Edit") { isEditing = true } }
                .sheet(isPresented: $isEditing) { EditMedicineView(medicine: medicine) }
                .confirmationDialog("Delete this medicine?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) { store.delete(medicine); dismiss() }
                    Button("Cancel", role: .cancel) {}
                }
            } else {
                ContentUnavailableView("Medicine removed", systemImage: "trash")
            }
        }
    }
}

struct EditMedicineView: View {
    @EnvironmentObject private var store: MedicineStore
    @Environment(\.dismiss) private var dismiss
    let medicine: Medicine
    @State private var name: String
    @State private var dosage: String
    @State private var notes: String
    @State private var reminderTime: Date
    @State private var category: MedicineCategory
    @State private var supplyCount: Int

    init(medicine: Medicine) {
        self.medicine = medicine
        _name = State(initialValue: medicine.name)
        _dosage = State(initialValue: medicine.dosage)
        _notes = State(initialValue: medicine.notes)
        _category = State(initialValue: medicine.category)
        _supplyCount = State(initialValue: medicine.supplyCount)
        let date = Calendar.current.date(from: DateComponents(hour: medicine.hour, minute: medicine.minute)) ?? Date()
        _reminderTime = State(initialValue: date)
    }

    var body: some View {
        NavigationStack {
            MedicineFormView(title: "Edit Medicine", buttonTitle: "Update Medicine", name: $name, dosage: $dosage, notes: $notes, reminderTime: $reminderTime, category: $category, supplyCount: $supplyCount) {
                store.updateMedicine(medicine, name: name, dosage: dosage, notes: notes, reminderTime: reminderTime, category: category, supplyCount: supplyCount)
                dismiss()
            }
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Back") { dismiss() } } }
        }
    }
}
