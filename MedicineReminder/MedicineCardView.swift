import SwiftUI

struct MedicineCardView: View {
    let medicine: Medicine
    let onTaken: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: medicine.wasTakenToday ? "checkmark.circle.fill" : medicine.category.icon)
                .font(.title2)
                .foregroundStyle(medicine.wasTakenToday ? .green : medicine.category.color)
                .frame(width: 48, height: 48)
                .background(medicine.category.color.opacity(0.14), in: Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(medicine.name).font(.headline)
                    if !medicine.isActive {
                        Image(systemName: "bell.slash.fill").foregroundStyle(.secondary)
                    }
                }
                Text("\(medicine.dosage) • \(medicine.timeText)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(medicine.category.rawValue) • \(medicine.supplyCount) left")
                    .font(.caption)
                    .foregroundStyle(medicine.supplyCount <= 3 ? .red : .secondary)
            }

            Spacer()

            Button(action: onTaken) {
                Image(systemName: medicine.wasTakenToday ? "arrow.uturn.backward" : "checkmark")
                    .font(.headline)
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(.borderedProminent)
            .tint(medicine.wasTakenToday ? .gray : .teal)
            .accessibilityLabel(medicine.wasTakenToday ? "Undo taken" : "Mark as taken")
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}
