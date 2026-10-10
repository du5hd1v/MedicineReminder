import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: MedicineStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    hero
                    stats
                    schedule
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .toolbar {
                Button { store.resetSampleData() } label: { Image(systemName: "arrow.clockwise") }
                    .accessibilityLabel("Reset demo data")
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("DoseMate")
                        .font(.system(.title, design: .rounded, weight: .black))
                    Text("Stay on time, stay healthy")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
                    .background(.teal.gradient, in: RoundedRectangle(cornerRadius: 18))
            }

            ProgressView(value: store.progressToday)
                .tint(.teal)

            Text("\(store.completedTodayCount) of \(store.todaysMedicines.count) medicines taken today")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 7)
    }

    private var stats: some View {
        HStack(spacing: 12) {
            StatTile(title: "Active", value: "\(store.todaysMedicines.count)", icon: "bell.fill", color: .teal)
            StatTile(title: "Taken", value: "\(store.totalTakenCount)", icon: "checkmark.seal.fill", color: .green)
        }
    }

    private var schedule: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.headline)

            if store.todaysMedicines.isEmpty {
                ContentUnavailableView("No active medicines", systemImage: "bell.slash", description: Text("Add a medicine to start reminders."))
            } else {
                ForEach(store.todaysMedicines) { medicine in
                    NavigationLink { MedicineDetailView(medicineID: medicine.id) } label: {
                        MedicineCardView(medicine: medicine) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { store.markTaken(medicine) }
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) { store.delete(medicine) } label: { Label("Delete", systemImage: "trash") }
                    }
                }
            }
        }
    }
}

struct StatTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.13), in: Circle())
            VStack(alignment: .leading) {
                Text(value).font(.title3.bold())
                Text(title).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
