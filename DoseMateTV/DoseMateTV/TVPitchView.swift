import SwiftUI

struct TVPitchView: View {
    private let slides = [
        PitchSlide(title: "Problem", body: "Families often manage medicine schedules for elders, parents, and children using memory, paper notes, or phone alarms that only one person can see.", icon: "exclamationmark.triangle.fill", color: .orange),
        PitchSlide(title: "Solution", body: "DoseMate TV turns the living-room Apple TV into a shared medicine board, making doses visible to the whole household.", icon: "tv.fill", color: .teal),
        PitchSlide(title: "Target Market", body: "Families with elders, caregivers, shared apartments, and busy students who want a simple at-home reminder system.", icon: "person.3.fill", color: .blue),
        PitchSlide(title: "Revenue Model", body: "Freemium household dashboard with premium iCloud sync, caregiver alerts, refill tracking, and pharmacy partner offers.", icon: "dollarsign.circle.fill", color: .green),
        PitchSlide(title: "Go To Market", body: "Launch with the iOS DoseMate app, then promote the tvOS dashboard as a companion for family health routines.", icon: "chart.line.uptrend.xyaxis", color: .purple)
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color(red: 0.03, green: 0.17, blue: 0.20)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            TabView {
                ForEach(slides) { slide in
                    VStack(spacing: 28) {
                        Image(systemName: slide.icon)
                            .font(.system(size: 86))
                            .foregroundStyle(slide.color)

                        Text(slide.title)
                            .font(.system(size: 58, weight: .black, design: .rounded))
                            .foregroundStyle(.white)

                        Text(slide.body)
                            .font(.title.weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.76))
                            .frame(maxWidth: 980)
                    }
                    .padding(80)
                }
            }
            .tabViewStyle(.page)
        }
        .navigationTitle("Investor Pitch")
    }
}

struct PitchSlide: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    let icon: String
    let color: Color
}

