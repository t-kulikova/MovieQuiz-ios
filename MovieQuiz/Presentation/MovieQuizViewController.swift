import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionAmount = 10
    private let questionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQuiz()
    }
    
    // MARK: - IBActions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Methods
    
    private func startQuiz() {
        guard let firstQuestion = questionFactory.requestNextQuestion() else { return }
        
        currentQuestion = firstQuestion
        let firstQuestionViewModel = convert(model: firstQuestion)
        
        show(quiz: firstQuestionViewModel)
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        
        guard let firstQuestion = questionFactory.requestNextQuestion() else { return }
        
        currentQuestion = firstQuestion
        let firstQuestionViewModel = convert(model: firstQuestion)
        
        show(quiz: firstQuestionViewModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(resultOfQuiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let resetQuizAction = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            self.resetQuiz()
        }
        
        alert.addAction(resetQuizAction)
        present(alert, animated: true)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionAmount - 1 {
            let text = correctAnswers == questionAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let quizResultsViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: text,
                buttonText: "Сыграть еще раз"
            )
            
            show(resultOfQuiz: quizResultsViewModel)

        } else {
            currentQuestionIndex += 1
            
            guard let nextQuestion = questionFactory.requestNextQuestion() else { return }
            currentQuestion = nextQuestion
            let nextQuestionviewModel = convert(model: nextQuestion)
            
            show(quiz: nextQuestionviewModel)
        }
    }
    
}
