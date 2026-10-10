import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: MedicineStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        StatTile(title: "Medicines", value: "\(store.medicines.count)", icon: "pills.fill", color: .teal)
                        StatTile(title: "Taken", value: "\(store.totalTakenCount)", icon: "checkmark.seal.fill", color: .green)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                ForEach(store.medicines) { medicine in
                    Section {
                        NavigationLink { MedicineDetailView(medicineID: medicine.id) } label: {
                            HStack {
                                Image(systemName: medicine.category.icon).foregroundStyle(medicine.category.color)
                                VStack(alignment: .leading) {
                                    Text(medicine.name).font(.headline)
                                    Text("\(medicine.takenDates.count) total • \(medicine.takenCountThisWeek) this week")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        if medicine.takenDates.isEmpty {
                            Text("No taken history yet.").foregroundStyle(.secondary)
                        } else {
                            ForEach(medicine.takenDates.sorted(by: >).prefix(5), id: \.self) { date in
                                Label(date.formatted(date: .abbreviated, time: .shortened), systemImage: "checkmark.circle")
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}
