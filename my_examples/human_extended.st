"human_extended.st"
"A program which has an extended version of Human class."

Object subclass: Human [
    | name age |
    
    setName: aName [
        name := aName.    
    ]

    getName [
        ^name
    ]

    setAge: anAge [
        age := anAge
    ]

    getAge [
        ^age
    ]

    introduceYourself [
        Transcript show: 'Hello, my name is ', name, ' and I am ',
        age printString, ' years old.'; cr.
    ]

    > aHuman [
        ^age > aHuman getAge
    ]

    < aHuman [
        ^age < aHuman getAge
    ]

    = aHuman [
        ^age = aHuman getAge
    ]
]

Human extend [
    
    | occupation experience |
    
    getOccupation [
        ^occupation
    ]

    setOccupation: anOccupation [
        occupation := anOccupation.
    ]

    getExperience [
        ^experience
    ]

    setExperience: anExperience [
        experience := anExperience    
    ]

    introduceYourself [
        Transcript show: 'Hello, my name is ', name, ' and I am ',
        age printString, ' years old. I am ', occupation; cr.
    ]

    > aHuman [
        ^experience > aHuman getExperience
    ]
    < aHuman [
        ^experience < aHuman getExperience
    ]
    = aHuman [
        ^experience = aHuman getExperience
    ]
]

| me myBrother |
me := Human new.
me setName: 'Maksim A'.
me setOccupation: 'Engineer'.
me setExperience: 1.
me setAge: 40.

myBrother := Human new.
myBrother setName: 'Farid A'.
myBrother setOccupation: 'Engineer'.
myBrother setExperience: 2.
myBrother setAge: 45.

me introduceYourself.
myBrother introduceYourself.

(me < myBrother) printNl.
