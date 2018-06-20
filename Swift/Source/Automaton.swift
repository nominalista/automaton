import RxCocoa
import RxSwift

class Automaton<State, Input> {

    typealias Mapping = (State, Input) -> (State, Observable<Input>?)

    let state: BehaviorRelay<State>
    var replies: Observable<Reply<State, Input>> { return replySubject.asObservable() }

    private var mapping: Mapping

    private let replySubject = PublishSubject<Reply<State, Input>>()
    private let inputSubject = PublishSubject<Input>()
    private var disposable: Disposable?

    init(state: State, mapping: @escaping Mapping) {
        self.state = BehaviorRelay(value: state)
        self.mapping = mapping
        // Starts observing input
        self.disposable = recurReply(from: inputSubject).subscribe(onNext: { [unowned self] reply in
            self.state.accept(reply.toState)
            self.replySubject.onNext(reply)
        })
    }

    // Recurs `inputObservable` to emit inputs and outputs produced from `mapping`.
    private func recurReply(from inputObservable: Observable<Input>) -> Observable<Reply<State, Input>> {
        let replyObservable = inputObservable
                .map { [unowned self] input -> Reply<State, Input> in
                    let fromState = self.state.value
                    let (toState, output) = self.mapping(fromState, input)
                    return Reply(input: input, fromState: fromState, toState: toState, output: output)
                }
                // Shares events for two observers.
                .share(replay: 1, scope: .forever)

        // Recurs successfully mapped replies.
        let successObservable = replyObservable
                .filter { $0.output != nil }
                .flatMap { [unowned self] reply -> Observable<Reply<State, Input>> in
                    let output = reply.output!
                    return self.recurReply(from: output).startWith(reply)
                }

        // Emits replies without output.
        let failureObservable = replyObservable
                .filter { $0.output == nil }

        // `successObservable` and `failureObservable` both emit `Reply<State>`.
        return Observable.merge(successObservable, failureObservable)
    }

    deinit {
        // Stops emission of replies.
        self.replySubject.onCompleted()
        self.disposable?.dispose()
        self.disposable = nil
    }

    func send(input: Input) {
        inputSubject.onNext(input)
    }
}

func maybeCombine<Input>(outputs: Observable<Input>? ...) -> Observable<Input>? {
    let filteredOutputs = outputs.filter { $0 != nil }.map { $0! }
    return filteredOutputs.isEmpty ? nil : Observable.merge(filteredOutputs)
}