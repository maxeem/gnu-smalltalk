Object subclass: Philosophers [
    | forks philosophers eating randy |

    Philosophers class >> new: quantity [
        ^ super new initialize: quantity
    ]

    initialize: n [
        "Create semaphores and philosophers"
        eating := Semaphore new.
        n - 1 timesRepeat: [ eating signal ].  "limit simultaneous eaters"
        randy := Random new.
        forks := (1 to: n) collect: [ :each | Semaphore forMutualExclusion ].
        philosophers := (1 to: n) collect: [ :each | self philosopher: each ].
        ^ self
    ]

    philosopher: n [
        | philosopherCode leftFork rightFork status |

        leftFork := forks at: n.
        rightFork := forks at: (n \\ forks size) + 1.
        status := 'Philosopher ', n printString, ': '.

        philosopherCode := [
            [ true ] whileTrue: [
                "Thinking"
                stdout nextPutAll: status, 'thinks'; nl; flush.
                (Delay forSeconds: ((randy next * 3) floor) + 1) wait.

                "Hungry - request to eat"
                eating wait.
                leftFork wait.
                rightFork wait.

                stdout nextPutAll: status, 'eats'; nl; flush.
                (Delay forSeconds: ((randy next * 2) floor) + 1) wait.

                "Done eating"
                rightFork signal.
                leftFork signal.
                eating signal.
            ]
        ].

        ^ philosopherCode forkAt: Processor userBackgroundPriority
    ]

    dine [
        stdout nextPutAll: 'Dining philosophers started...'; nl; flush.
        philosophers do: [ :p | p resume ].
    ]
]

"--- Run with 5 philosophers ---"
(Philosophers new: 5) dine.
