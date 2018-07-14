# Automaton

The Automaton is a new framework, created for easy state management.

# About 

Model View Automaton (MVA) is composed from three components as any other popular pattern (MVC, MVVM, MVP, etc.).

* **Model** - is a place where your data objects are located. This is also a group of objects that contains database interfaces, server communication code, parsers and many others.

* **View** - represents the current state of the app in a visual form. Unlike the traditional approach, it can contain controllers / presenters / view models for communication with other layers.

* **Automaton** - is the core of your app behavior. It contains reactive automaton, mappers, inputs and (as suggested) state objects.

## Reactive Automaton

It's a deterministic finite state automaton ([Mealy machine](https://en.wikipedia.org/wiki/Mealy_machine) specifically), which in human language means - based on current **state** and accepted **input**, it generates new **state** and the **output**.

So there are 4 important objects to remember:

1. **Automaton** - represents the operation algorithm.
2. **State** - state of our application.
3. **Input** - an action that can be send.
4. **Mapper** - used by algorithm to transform (State, Input) into (State, Output).

# Usage

For now there are two implementations: [Kotlin](Kotlin) and [Swift](Swift). Go there to see implementation details in your favorite language.

# Examples

* [Lessons](https://github.com/Nominalista/Lessons) - very simple app for playing videos. Written in Swift.
* [Expenses](https://github.com/Nominalista/Expenses) - more complex app for tracking budget. Written in Kotlin.

# Authors

Yasuhiro Inami ([@inamy](https://github.com/inamiy/)) is the original author of this idea presented on [iOS Conf SG](https://youtu.be/Oau4JjJP3nA). I tweaked it a little bit in order to make a genuine pattern.
