import SwiftUI
import StoreKit
import SafariServices

struct SettingsView: View {
    @AppStorage("cupSize") private var cupSize: Double = 250
    @AppStorage("userWeight") private var weight: Double = 70
    @AppStorage("userGender") private var gender: Int = 1
    @AppStorage("userActivityLevel") private var activityLevel: ActivityLevel = .medium
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("reminderInterval") private var reminderInterval: Int = 60
    @AppStorage("reminderEnabled") private var reminderEnabled: Bool = true
    
    @State private var showResetAlert = false
    @State private var showPermissionAlert = false
    @State private var showPrivacyPolicy = false
    
    let cupSizes = [200.0, 250.0, 300.0]
    let reminderOptions = [60, 120, 180, 240] // minutes: 1, 2, 3, 4 hours
    
    var body: some View {
        NavigationView {
            ZStack {
                WaterGradientBackground()
                
                ScrollView {
                    VStack(spacing: 28) {
                        GlassCard {
                            SectionHeader(icon: "person.fill", title: "User Info")
                            VStack(spacing: 18) {
                                HStack {
                                    Text("Weight (kg)")
                                    Spacer()
                                    TextField("Weight", value: $weight, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 80)
                                }
                                Picker("Gender", selection: $gender) {
                                    Text("Male").tag(1)
                                    Text("Female").tag(0)
                                }
                                .pickerStyle(.segmented)
                                Picker("Activity Level", selection: $activityLevel) {
                                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(.menu)
                                Text("Your daily activity level (affects your water norm)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        GlassCard {
                            SectionHeader(icon: "cup.and.saucer", title: "Cup Settings")
                            HStack {
                                Text("Cup Size (ml)")
                                Spacer()
                                TextField("Cup Size", value: $cupSize, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                            }
                        }
                        
                        GlassCard {
                            SectionHeader(icon: "bell.fill", title: "Notifications")
                            VStack(spacing: 18) {
                                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                                if notificationsEnabled {
                                    Picker("Reminder Interval", selection: $reminderInterval) {
                                        Text("30 minutes").tag(30)
                                        Text("1 hour").tag(60)
                                        Text("2 hours").tag(120)
                                        Text("3 hours").tag(180)
                                    }
                                    .pickerStyle(.menu)
                                }
                            }
                        }
                        
                        GlassCard {
                            SectionHeader(icon: "info.circle", title: "About")
                            VStack(spacing: 18) {
                                Button(action: {
                                    withAnimation(.spring()) { showPrivacyPolicy = true }
                                }) {
                                    HStack {
                                        Image(systemName: "lock.shield")
                                            .foregroundColor(.blue)
                                        Text("Privacy Policy")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(AnimatedButtonStyle())
                                
                                Button(action: {
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        SKStoreReviewController.requestReview(in: scene)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text("Rate App")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(AnimatedButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 18)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .alert("Reset all data?", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) {
                    resetAll()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("All your data will be reset to default values.")
            }
            .alert("No notification permission", isPresented: $showPermissionAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please allow notifications in system settings.")
            }
            .onChange(of: notificationsEnabled) { enabled in
                if enabled {
                    NotificationManager.shared.requestAuthorization { granted in
                        if granted {
                            NotificationManager.shared.scheduleNotifications(interval: reminderInterval)
                        } else {
                            notificationsEnabled = false
                            showPermissionAlert = true
                        }
                    }
                } else {
                    NotificationManager.shared.removeAllNotifications()
                }
            }
            .onChange(of: reminderInterval) { newValue in
                if notificationsEnabled {
                    NotificationManager.shared.scheduleNotifications(interval: newValue)
                }
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: URL(string: "https://www.termsfeed.com/live/c10c576b-6a11-47bd-b505-7bdd51558af7")!)
            }
        }
    }
    
    private func resetAll() {
        cupSize = 250
        weight = 70
        gender = 1
        activityLevel = .medium
        notificationsEnabled = true
        reminderInterval = 60
        reminderEnabled = true
        NotificationManager.shared.removeAllNotifications()
    }
}

struct SectionHeader: View {
    let icon: String
    let title: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
            Text(title)
                .font(.title3).bold()
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.bottom, 2)
    }
}

struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(20)
        .background(
            BlurView(style: .systemUltraThinMaterial)
                .background(Color.white.opacity(0.15))
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.blue.opacity(0.08), radius: 16, x: 0, y: 8)
    }
}

struct WaterGradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.85, green: 0.95, blue: 1.0), Color(red: 0.7, green: 0.85, blue: 1.0)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
} 
