//
//  OnChange.swift
//
//  Created by Timothy Rascher on 9/29/22.
//

import Foundation
import Combine

extension Publishers {
    public struct OnChange<UpStream> where UpStream: Publisher, UpStream.Output: Equatable {
        public typealias Output = UpStream.Output
        public typealias Failure = UpStream.Failure
        private let upStream: UpStream
        
        public init(_ upStream: UpStream) {
            self.upStream = upStream
        }
    }
}
extension Publishers.OnChange: Publisher {
    public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
        let subscription = Sub(self, subscriber)
        subscriber.receive(subscription: subscription)
    }
}
public extension Publishers.OnChange {
    class Sub<S> where S: Subscriber, S.Input == Output, S.Failure == Failure {
        private let publisher: Publishers.OnChange<UpStream>
        private let subscriber: S
        private var upStreamSub: Subscription?
        private var lastDemand: Subscribers.Demand?
        private var lastValue: Input?
        
        fileprivate init(_ publisher: Publishers.OnChange<UpStream>, _ subscriber: S) {
            self.publisher = publisher
            self.subscriber = subscriber
            publisher.upStream.subscribe(self)
        }
    }
}
extension Publishers.OnChange.Sub: Subscription {
    public func request(_ demand: Subscribers.Demand) {
        lastDemand = demand
        guard let upStreamSub = upStreamSub else { return }
        upStreamSub.request(demand)
    }
    public func cancel() {
        upStreamSub?.cancel()
    }
}
extension Publishers.OnChange.Sub: Subscriber {
    public typealias Input = UpStream.Output
    public typealias Failure = UpStream.Failure
    public func receive(subscription: Subscription) {
        upStreamSub = subscription
        guard let demand = lastDemand else { return }
        subscription.request(demand)
    }
    private var demand: Subscribers.Demand { lastDemand ?? .none }
    public func receive(_ input: UpStream.Output) -> Subscribers.Demand {
        if let lastValue = lastValue {
            if lastValue == input { return demand }
        }
        lastValue = input
        let demand = subscriber.receive(input)
        lastDemand = demand
        return demand
    }
    public func receive(completion: Subscribers.Completion<UpStream.Failure>) {
        subscriber.receive(completion: completion)
    }
}

public extension Publisher where Output: Equatable {
    func onChange() -> Publishers.OnChange<Self> {
        Publishers.OnChange(self)
    }
}
