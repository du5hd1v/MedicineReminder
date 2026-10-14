import SwiftUI

struct AddMedicineView: View {
    @EnvironmentObject private var store: MedicineStore
    @Binding var selectedTab: AppTab
    @State private var name = ""
    @State private var dosage = ""
    @State private var notes = ""
    @State private var reminderTime = Date()
    @State private var category: MedicineCategory = .tablet
    @State private var supplyCount = 10

    init(selectedTab: Binding<AppTab> = .constant(.add)) {
        self._selectedTab = selectedTab
    }

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
            ) {
                saveMedicine()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    private func saveMedicine() {
        hideKeyboard()
        store.addMedicine(
            name: name,
            dosage: dosage,
            notes: notes,
            reminderTime: reminderTime,
            category: category,
            supplyCount: supplyCount
        )
        name = ""
        dosage = ""
        notes = ""
        reminderTime = Date()
        category = .tablet
        supplyCount = 10

        UINotificationFeedbackGenerator().notificationOccurred(.success)

        withAnimation(.easeInOut(duration: 0.25)) {
            selectedTab = .today
        }
    }
}

enum MedicineFormField: Hashable {
    case name
    case dosage
    case notes
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

    @FocusState private var focusedField: MedicineFormField?

    var body: some View {
        Form {
            Section("Medicine") {
                TextField("Name", text: $name)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .dosage }
                    .onTapGesture { focusedField = .name }

                TextField("Dosage", text: $dosage)
                    .focused($focusedField, equals: .dosage)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .notes }
                    .onTapGesture { focusedField = .dosage }

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
                    .focused($focusedField, equals: .notes)
                    .lineLimit(3, reservesSpace: true)
                    .onTapGesture { focusedField = .notes }
            }

            Section {
                Button(action: {
                    dismissKeyboard()
                    onSave()
                }) {
                    Label(buttonTitle, systemImage: "bell.badge.fill")
                        .frame(maxWidth: .infinity)
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || dosage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollContentBackground(.hidden)
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissKeyboard()
                }
        )
        .onTapGesture {
            dismissKeyboard()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
                .fontWeight(.semibold)
                .tint(.teal)
            }
        }
        .navigationTitle(title)
    }

    private func dismissKeyboard() {
        focusedField = nil
        hideKeyboard()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
