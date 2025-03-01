import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getReviews()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        return reviewsView
    }
    
    //захватывается reviewsView как слабая ссылка.
    //Хотя это и предотвращает утечку, лучше ослаблять self (то есть контроллер), так как reviewsView является его свойством, а не самостоятельным объектом.
    //Это позволит избежать возможных проблем, если reviewsView вдруг изменится или переинициализируется.
    func setupViewModel() {
        viewModel.onStateChange = { [weak self] _ in
            self?.reviewsView.tableView.reloadData()
        }
    }

}
