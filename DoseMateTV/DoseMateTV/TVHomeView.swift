import SwiftUI

struct TVHomeView: View {
    private let members = FamilyMember.samples
    private let plans = TVDosePlan.samples

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.03, green: 0.08, blue: 0.13), Color(red: 0.01, green: 0.18, blue: 0.22), Color(red: 0.04, green: 0.05, blue: 0.12)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 42) {
                        header
                        familyRow
                        doseTimeline
                        platformFeatures
                    }
                    .padding(.horizontal, 76)
                    .padding(.vertical, 58)
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 12) {
                Text("DoseMate TV")
                    .font(.system(size: 64, weight: .black, design: .rounded))
                Text("A shared medicine dashboard for families on Apple TV.")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.72))
            }

            Spacer()

            NavigationLink {
                TVPitchView()
            } label: {
                Label("Pitch", systemImage: "play.rectangle.fill")
                    .font(.title3.weight(.bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)
        }
        .foregroundStyle(.white)
    }

    private var familyRow: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Family Today")
                .sectionTitle()

            HStack(spacing: 24) {
                ForEach(members) { member in
                    NavigationLink {
                        MemberScheduleView(member: member)
                    } label: {
                        MemberFocusCard(member: member)
                    }
                    .buttonStyle(.card)
                }
            }
        }
    }

    private var doseTimeline: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Next Doses")
                    .sectionTitle()
                Spacer()
                Text("Select a family card for full schedule")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.74))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 22), count: 3), spacing: 22) {
                ForEach(members.flatMap(\.medicines).prefix(6)) { medicine in
                    MedicineFocusCard(medicine: medicine, color: medicine.isUrgent ? .red : .teal)
                }
            }
        }
    }

    private var platformFeatures: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("tvOS Prototype Features")
                .sectionTitle()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 22), count: 4), spacing: 22) {
                ForEach(plans) { plan in
                    FeatureCard(plan: plan)
                }
            }
        }
    }
}

struct MemberFocusCard: View {
    let member: FamilyMember

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(member.color)
                Spacer()
                Text("\(Int(member.progress * 100))%")
                    .font(.title2.bold())
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(member.name)
                    .font(.title.bold())
                Text(member.role)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.66))
            }

            ProgressView(value: member.progress)
                .tint(member.color)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, minHeight: 210, alignment: .leading)
        .padding(26)
        .background(.white.opacity(0.11), in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}

struct MemberScheduleView: View {
    let member: FamilyMember

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, member.color.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 34) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(member.name)
                        .font(.system(size: 62, weight: .black, design: .rounded))
                    Text("\(member.completedCount) of \(member.medicines.count) medicines completed today")
                        .font(.title2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.72))
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 24), count: 3), spacing: 24) {
                    ForEach(member.medicines) { medicine in
                        MedicineFocusCard(medicine: medicine, color: member.color)
                    }
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .padding(80)
        }
        .navigationTitle(member.name)
    }
}

struct MedicineFocusCard: View {
    let medicine: TVMedicine
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: medicine.isTaken ? "checkmark.circle.fill" : medicine.icon)
                    .font(.system(size: 46))
                    .foregroundStyle(medicine.isTaken ? .green : color)
                Spacer()
                if medicine.isUrgent && !medicine.isTaken {
                    Text("Soon")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(.red, in: Capsule())
                }
            }

            Text(medicine.time)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text(medicine.name)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(medicine.dosage)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.64))
        }
        .frame(maxWidth: .infinity, minHeight: 230, alignment: .leading)
        .padding(24)
        .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(medicine.isUrgent && !medicine.isTaken ? .red : .white.opacity(0.10), lineWidth: medicine.isUrgent && !medicine.isTaken ? 3 : 1)
        )
    }
}

struct FeatureCard: View {
    let plan: TVDosePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: plan.icon)
                .font(.system(size: 42))
                .foregroundStyle(plan.color)
            Text(plan.title)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(plan.subtitle)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.65))
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, minHeight: 210, alignment: .topLeading)
        .padding(24)
        .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 22))
    }
}

extension Text {
    func sectionTitle() -> some View {
        self.font(.title.bold()).foregroundStyle(.white)
    }
}

