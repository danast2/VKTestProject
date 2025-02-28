import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void
    
    //новые свойства:
    let avatarImage: UIImage?
    let userName: String
    let ratingImage: UIImage

    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.avatarImageView.image = avatarImage
        cell.userNameLabel.text = userName
        cell.ratingImageView.image = ratingImage
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?

    fileprivate let avatarImageView = UIImageView()
    fileprivate let userNameLabel = UILabel()
    fileprivate let reviewTextLabel = UILabel()
    fileprivate let ratingImageView = UIImageView()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        avatarImageView.frame = layout.avatarFrame
        userNameLabel.frame = layout.userNameFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        ratingImageView.frame = layout.ratingFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
    }

}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setupAvatarImageView()
        setupUserNameLabel()
        setupReviewTextLabel()
        setupRatingImageView()
        setupCreatedLabel()
        setupShowMoreButton()
    }
    
    func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        userNameLabel.font = .username
        userNameLabel.textColor = .label
    }
    
    func setupRatingImageView() {
       contentView.addSubview(ratingImageView)
       ratingImageView.contentMode = .scaleAspectFit
   }


    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
    }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы
    
    private(set) var avatarFrame = CGRect.zero
    private(set) var userNameFrame = CGRect.zero
    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var ratingFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right
        var maxY = insets.top
        var showShowMoreButton = false

        // Располагаем аватар
        avatarFrame = CGRect(origin: CGPoint(x: insets.left, y: maxY), size: Self.avatarSize)

        // Располагаем имя пользователя
        userNameFrame = CGRect(
            x: avatarFrame.maxX + avatarToUsernameSpacing,
            y: maxY + 8,
            width: width - avatarFrame.width - avatarToUsernameSpacing,
            height: 20
        )
        
        maxY = avatarFrame.maxY + usernameToRatingSpacing

        // Располагаем рейтинг
        ratingFrame = CGRect(x: insets.left, y: maxY, width: 80, height: 16)
        maxY += ratingFrame.height + ratingToTextSpacing

        // Текст отзыва
        if !config.reviewText.isEmpty() {
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

            reviewTextLabelFrame = CGRect(
                x: insets.left,
                y: maxY,
                width: width,
                height: min(currentTextHeight, actualTextHeight)
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        // Кнопка "Показать полностью..."
        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                x: insets.left,
                y: maxY,
                width: Self.showMoreButtonSize.width,
                height: Self.showMoreButtonSize.height
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        // Дата создания отзыва
        createdLabelFrame = CGRect(
            x: insets.left,
            y: maxY,
            width: width,
            height: 16
        )
        
        return createdLabelFrame.maxY + insets.bottom
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
