import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet var noButton: UIButton! // аутлет для того, чтоб выключать кнопку
    @IBOutlet var yesButton: UIButton! // аутлет для того, чтоб выключать кнопку
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(deligate: self)
        statisticService = StatisticService()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let result = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return result
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor // теперь края сбрасывают цвет
        yesButton.isEnabled = true // включаем кнопку
        noButton.isEnabled = true // включаем кнопку
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false // выключаем кнопку
        noButton.isEnabled = false // выключаем кнопку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
          // идём в состояние "Результат квиза"
            statisticService?.store(game: GameResult(correct: correctAnswers, total: questionsAmount, date: Date()))
            alertPresenter?.presentAlert(modelPr: AlertModel(
                title: "Этот раунд окончен",
                message:
                """
                Ваш результат \(correctAnswers)/10\n
                Колличетво сыграных квизов: \(statisticService?.gamesCount ?? 0)\n
                Рекорд: \(statisticService?.bestGame.correct ?? 0)/10  (\(statisticService?.bestGame.date.dateTimeString ?? "-"))\n
                Средняя точность: \(statisticService?.totalAccuracy ?? 0)%
                """,
                buttonTitle: "Сыграть еще раз", comletion: nil)
            )
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}

// MARK: - AlertDeligate

extension MovieQuizViewController: AlertDeligate {
    func didReceiveResultAlert() { // метод делегата для алерта
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
    
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
