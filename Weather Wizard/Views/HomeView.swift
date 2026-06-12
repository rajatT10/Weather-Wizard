import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                LoadingView()
                
            case .loaded(let data):
                ZStack {
                    // GPU-accelerated animated particles
                    AnimatedBackgroundView(condition: data.condition)
                    
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            // Header displays locations and temp (75% height)
                            WeatherHeaderView(data: data)
                                .frame(maxHeight: .infinity)
                            
                            // Cards display detailed indexes (25% height)
                            WeatherCardsView(data: data)
                                .padding(.horizontal, 16)
                                .padding(.bottom, geometry.safeAreaInsets.bottom + 12)
                                .frame(height: geometry.size.height * 0.25)
                        }
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                
            case .error(let error):
                ErrorOverlay(error: error) {
                    Task {
                        await viewModel.refresh()
                    }
                }
                .transition(.opacity)
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.5), value: viewModel.state)
    }
}
