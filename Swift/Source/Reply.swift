import RxSwift

struct Reply<State, Input> {

    var input: Input
    var fromState: State
    var toState: State
    var output: Observable<Input>?
}