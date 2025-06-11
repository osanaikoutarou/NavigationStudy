import SwiftUI

// Navigation for Aa -> Ab -> Ac -> Ad
struct AaNavigationView: View {
    @StateObject var router = NavigationRouter<Route>()

    var body: some View {
        NavigationStack(path: $router.path) {
            view(route: .root)
                .navigationDestination(for: Route.self) { route in
                    view(route: route)
                }
        }
        .environmentObject(router)
    }
}

extension AaNavigationView {
    enum Route: Hashable {
        case root
        case ab
        case ac
        case ad
    }

    @ViewBuilder
    func view(route: Route) -> some View {
        switch route {
        case .root:
            AaView()
        case .ab:
            AbView()
        case .ac:
            AcView()
        case .ad:
            AdView()
        }
    }
}

struct AaView: View {
    @EnvironmentObject var router: NavigationRouter<AaNavigationView.Route>

    var body: some View {
        VStack {
            Text("AaView")
            Button("Go to AbView") {
                router.push(.ab)
            }
        }
    }
}

struct AbView: View {
    @EnvironmentObject var router: NavigationRouter<AaNavigationView.Route>

    var body: some View {
        VStack {
            Text("AbView")
            Button("Go to AcView") {
                router.push(.ac)
            }
        }
    }
}

struct AcView: View {
    @EnvironmentObject var router: NavigationRouter<AaNavigationView.Route>
    @State private var showBa = false

    var body: some View {
        VStack {
            Text("AcView")
            Button("Go to AdView") {
                router.push(.ad)
            }
            Button("Present BaNavigationView") {
                showBa = true
            }
        }
        .fullScreenCover(isPresented: $showBa) {
            BaNavigationView()
        }
    }
}

struct AdView: View {
    var body: some View {
        Text("AdView")
    }
}

// Navigation for Ba -> Bb -> Bc -> Bd
struct BaNavigationView: View {
    @StateObject var router = NavigationRouter<Route>()

    var body: some View {
        NavigationStack(path: $router.path) {
            view(route: .root)
                .navigationDestination(for: Route.self) { route in
                    view(route: route)
                }
        }
        .environmentObject(router)
    }
}

extension BaNavigationView {
    enum Route: Hashable {
        case root
        case bb
        case bc
        case bd
    }

    @ViewBuilder
    func view(route: Route) -> some View {
        switch route {
        case .root:
            BaView()
        case .bb:
            BbView()
        case .bc:
            BcView()
        case .bd:
            BdView()
        }
    }
}

struct BaView: View {
    @EnvironmentObject var router: NavigationRouter<BaNavigationView.Route>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("BaView")
            Button("Go to BbView") {
                router.push(.bb)
            }
            Button("Close") { dismiss() }
        }
    }
}

struct BbView: View {
    @EnvironmentObject var router: NavigationRouter<BaNavigationView.Route>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("BbView")
            Button("Go to BcView") {
                router.push(.bc)
            }
            Button("Close") { dismiss() }
        }
    }
}

struct BcView: View {
    @EnvironmentObject var router: NavigationRouter<BaNavigationView.Route>
    @Environment(\.dismiss) var dismiss
    @State private var showCa = false

    var body: some View {
        VStack {
            Text("BcView")
            Button("Go to BdView") {
                router.push(.bd)
            }
            Button("Present CaNavigationView") {
                showCa = true
            }
            Button("Close") { dismiss() }
        }
        .fullScreenCover(isPresented: $showCa) {
            CaNavigationView()
        }
    }
}

struct BdView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("BdView")
            Button("Close") { dismiss() }
        }
    }
}

// Navigation for Ca -> Cb -> Cc -> Cd
struct CaNavigationView: View {
    @StateObject var router = NavigationRouter<Route>()

    var body: some View {
        NavigationStack(path: $router.path) {
            view(route: .root)
                .navigationDestination(for: Route.self) { route in
                    view(route: route)
                }
        }
        .environmentObject(router)
    }
}

extension CaNavigationView {
    enum Route: Hashable {
        case root
        case cb
        case cc
        case cd
    }

    @ViewBuilder
    func view(route: Route) -> some View {
        switch route {
        case .root:
            CaView()
        case .cb:
            CbView()
        case .cc:
            CcView()
        case .cd:
            CdView()
        }
    }
}

struct CaView: View {
    @EnvironmentObject var router: NavigationRouter<CaNavigationView.Route>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("CaView")
            Button("Go to CbView") {
                router.push(.cb)
            }
            Button("Close") { dismiss() }
        }
    }
}

struct CbView: View {
    @EnvironmentObject var router: NavigationRouter<CaNavigationView.Route>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("CbView")
            Button("Go to CcView") {
                router.push(.cc)
            }
            Button("Close") { dismiss() }
        }
    }
}

struct CcView: View {
    @EnvironmentObject var router: NavigationRouter<CaNavigationView.Route>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("CcView")
            Button("Go to CdView") {
                router.push(.cd)
            }
            Button("Close") { dismiss() }
        }
    }
}

struct CdView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("CdView")
            Button("Close") { dismiss() }
        }
    }
}

// Generic router used by navigation views
@MainActor
fileprivate class NavigationRouter<V: Hashable>: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ viewType: V) {
        path.append(viewType)
    }

    func pop(_ k: Int = 1) {
        path.removeLast(k)
    }

    func popToRoot() {
        path = .init()
    }
}

