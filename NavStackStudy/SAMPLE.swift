//
//  SAMPLE.swift
//  NavStackStudy
//
//  Created by 長内幸太郎 on 2025/06/11.
//

import Foundation
import RealmSwift
import SwiftUI

// ここはAIにこのプロジェクトの基本設計を伝えるファイルです

// たとえばArticleの画面郡はこのように作ってください

/// Articleに対する、CRUD, つまりList,Detail,Create,Edit,Deleteに1つのNavigationViewを作ります
/// （一部ではCreateがAddになってしまっています、そのうち直す）
/// ベースであって、イレギュラーはたくさんあります、あとちゃんとできていない部分もある
struct ArticleNavigationView: View {
    @StateObject var router = NavigationRouter<Route>()
    @StateObject var navigationViewModel: ArticleNavigationViewModel
    // Modalならdismissを持つ
    var dismiss: EmptyClosure

    private var repository = ArticleRepository()

    // これもテンプレートです、これで各画面を順不同で表示できます
    var body: some View {
        NavigationStack(path: $router.path) {
            view(route: .root)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .navigationDestination(for: Self.Route.self) { route in
                    view(route: route)
                }
        }
        .environmentObject(router)
        .environmentObject(navigationViewModel)
    }

}
extension ArticleNavigationView {
    /// NavigationViewにRouteを一つ持つ
    enum Route: Hashable {
        case root   // rootはないことも多い
        case list
        case detail
        case create
        case edit
        case delete
    }

    /// Routeの各ケースに対するViewを定義
    @MainActor
    @ViewBuilder
    func view(route: Route) -> some View {
        switch route {
        case .root:
            ArticleView()
        case .list:
            ArticleListView()
        case .detail:
            ArticleDetailView()
        case .create:
            CreateArticleView()
        case .edit:
            EditArticleView()
        case .delete:
            DeleteArticleView()
        }
    }
}

/// 画面
struct ArticleView: View {
    @EnvironmentObject var router: NavigationRouter<ArticleNavigationView.Route>
    @EnvironmentObject var navigationViewModel: ArticleNavigationViewModel

    var body: some View {
        Button {
            router.push(.list)
        } label: {
            Text("next")
        }
    }
}
struct ArticleListView: View {
    @EnvironmentObject var router: NavigationRouter<ArticleNavigationView.Route>
    @EnvironmentObject var navigationViewModel: ArticleNavigationViewModel

    var body: some View {
        Button {
            router.push(.detail)
        } label: {
            Text("next")
        }
    }
}
struct ArticleDetailView: View {
    @EnvironmentObject var router: NavigationRouter<ArticleNavigationView.Route>
    @EnvironmentObject var navigationViewModel: ArticleNavigationViewModel
    // この画面からModalを表示するとしたら、このようにする
    @StateObject private var modalCoordinator = ModalCoordinator()

    // この構成を取ることが多い, headerとcontent
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                content
            }

            // どうしてZStackがあるかといえば、このような.hoeg {}を大量に見やすく入れるためです
            modals
        }
    }

    var header: some View {
        VStack {
            Spacer()

            ZStack {
                dismissButton(colored: false) {
                    dismiss()
                }
                titleView(title: "ArticleDetail")
            }
        }
        .frame(height: DeviceHeights.headerTotalHeight)
        .frame(maxWidth: .infinity)
    }

    var content: some View {
        // 省略
        EmptyView()
    }

    /// modalへの起点, alertもこのようにしています
    @ViewBuilder
    var modals: some View {
        ZStack {}
            .fullScreenCover(isPresented: $modalCoordinator.showingEmployee) {
                EmployeeNavigationView()
            }

        ZStack {}
            .fullScreenCover(isPresented: $modalCoordinator.showingSomething2) {
                // Something View
                EmptyView()
            }
    }

    /// Modal表示するためのフラグ管理
    class ModalCoordinator: ObservableObject {
        @Published var showingEmployee: Bool = false
        @Published var showingSomething2: Bool = false
    }
}
struct CreateArticleView: View {
    var body: some View {
        EmptyView()
    }
}
struct EditArticleView: View {
    var body: some View {
        EmptyView()
    }
}
struct DeleteArticleView: View {
    var body: some View {
        EmptyView()
    }
}

/// NavigationViewに対して、1つNavigationViewModelを作る
/// この子画面でこれを使い回す
struct ArticleNavigationViewModel: ObservableObject {

}

/// Modelは2種類、画面用と、Realm用
struct Article: Identifiable, Sendable, Hashable {
    var id: String = UUID().uuidString
    var title: String = ""
    var content: String = ""
}
struct ArticleRM: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var content: String = ""
}
/// Modelに対してRepositoryを作ります
/// actor境界に注意する
actor ArticleRepository {
    // 省略
}

// MARK: - ViewModelとDependencyの注入例
// Viewのinitで StateObject を直接初期化せず、Dependency を使って値を注入する
struct SampleAddView: View {
    @StateObject var viewModel: SampleAddViewModel = .init()

    class Dependency {
        var isFirstAppear: Bool = true
        var problem: Problem?

        init(problem: Problem? = nil) {
            self.problem = problem
        }
    }
    var dependency: Dependency?

    init(dependency: Dependency?) {
        self.dependency = dependency
    }

    func inject(dependency: Dependency) {
        if let problem = dependency.problem {
            viewModel.problem = problem
        }
    }

    var body: some View {
        EmptyView()
            .onAppear {
                if let dependency, dependency.isFirstAppear {
                    inject(dependency: dependency)
                    self.dependency?.isFirstAppear = false
                }
            }
    }
}

@MainActor
class SampleAddViewModel: ObservableObject {
    @Published var problem: Problem = .init()
}

//MARK: -

struct EmployeeNavigationView: View {
    @StateObject var router = NavigationRouter<Route>()
    @StateObject var navigationViewModel: EmployeeNavigationViewModel
}
class EmployeeNavigationViewModel: ObservableObject {

}


extension EmployeeNavigationView {
    enum Route: Hashable {
        case root   // rootはないことも多い
    }
    @MainActor
    @ViewBuilder
    func view(route: Route) -> some View {
        switch route {
        case .root:
            EmployeeView()
        }
    }
}
struct EmployeeView: View {
    @EnvironmentObject var router: NavigationRouter<EmployeeNavigationView.Route>
    @EnvironmentObject var navigationViewModel: EmployeeNavigationViewModel

    var body: some View {
        Text("EmployeeView")
    }
}

@MainActor
fileprivate class NavigationRouter<V: Hashable>: ObservableObject {
    @MainActor @Published var path = NavigationPath()

    /// push遷移
    @MainActor
    func push(_ viewType: V) {
        path.append(viewType)
    }

    @MainActor
    func pop(_ k: Int = 1) {
        path.removeLast(k)
    }

    @MainActor
    func popToRoot() {
        path = .init()
    }

}
