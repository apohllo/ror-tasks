# Test driven development (TDD) of the model layer

## Introduction

Test Driven Development is relatively recent proposal for the software quality
problem. Its basic idea is as follows: instead of testing software that is
already written, write tests up-front. This approach has the following
consequences:

* The tests are written down, so the errors are reproducible. This contrasts
  with quite popular approach (especially in the case of web-applications),
  where testing is done only manually.
* Writing tests allows to concentrate on the expected behavior of the system.
  During implementation the developer is more concerned with solving the
  particular programming problem. Running tests after small changes in the
  source code helps in focusing on the problem at hand.
* Well written tests are simple and easy to understand. 
  If the tests get complicated before any implementation has been written, 
  it means that the implementation would be even less easy to understand. 
  This is a signal that the tested system has two many responsibilities.
* When the implementation is written and all tests pass, its rather safe to
  start refactoring. The resulting system will be functionally equivalent to the
  primary version, but (hopefully) simpler.

## How to write good tests?

Assuming that we opted-in for TDD the next question is: how to write good test?
If TDD is a remedy for software development problem, writing tests should be
easier than writing the system implementation. But this is not always the case. 

What principles should be followed when the tests are written? 

First of all the tests should not be written in vacuum. Definitely the first
tests that should be written are acceptance tests, because they clearly show
what is the value of the system and they assure, that the promised value is
actually delivered by the system. So the first step is the conversion of the users
stories into acceptance tests. When using tools such as Cucumber, this can be
even the same process, i.e. system specification IS the acceptance test.

Such tests define the high-level expectations imposed on the system. But making
this test pass is not immediate - the system still has to be written. 
Depending on the number of responsibilities it might cover tens or hundreds of
classes. In the "old" approach one would start designing the system, using UML
diagrams and the like. In TDD the design is mostly replaced by writing the
tests. This is the moment when unit tests come into play. Acceptance tests allow
for identifying the key entry points of the system - that is the elements the
external actors of the system play with. So at first the unit tests are written
for these classes. 

Writing the tests for the "entry" classes allows for the identification of the
other classes that cooperate with them. For sure this process is not straight
forward and since we ceased to design the classes on paper, we have to 
carefully design these unit tests. We should also note, that this process is
iterative. Specifying the classes cooperating with the entry classes, we may
identify further classes, that are required for the implementation. This process
continues until there are no more cooperating classes to define. This
requirement is further verified with the acceptance tests.

The second requirement for good tests is combined with the expectation,
that the emerging classes are implemented according to the "traditional"
requirements for object oriented systems, that is:

* they fulfill single responsibility principle
* the classes are loosely coupled
* the classes are highly cohesive
* they fulfill the law of Demeter
* they lack duplication

First of all we will explain these principles and then we will show testing
techniques together with implementation techniques that help to fulfill these
principles. 

### Single responsibility principle (SRP)

This principle says that a class should have only one responsibility. What does
it mean in practice? It means, that the class should not understand messages
that could be separated into distinct modules. For instance if you have a class
that is responsible for storing and retrieving data of a blog post from the 
database, it should no be responsible for parsing the data in order to spot 
mentions or hashtags before being stored, nor should it be
responsible for converting the data into JSON when this is needed by the
presentation layer. 

This is a bit surprising for many Rails developers because Rails implicitly
encourages developers to pack many responsibilities into classes in the model
layer. "Fat model, skinny controllers" - do not put any logic into controller,
put everything into the model layer. That is ok, unless you think that the model
layer is everything that inherits from ActiveRecord::Base. If you follow that
"method", then you will end up with classes called "feature envy". They have so
many responsibilities, that it is hard to say which of them is the primary. This is
clearly wrong. The code is hard to understand and what is more important - it is
hard to maintain. 

Getting back to example - definitely there should be a separate class
responsible for parsing the body of the post and separate class for converting
the result into JSON. But why? Because it is much easier to reuse such classes
and it is much easier to understand and maintain them. If it turns out that the
we have to parse the mentions not only from blog posts but also from comments,
probably we won't need to change the parser. In the opposite situation we will
end-up with copy of the parsing method in the comment class, which is
very bad.

This principle is much easier to fulfill if you look at your tests as a
specification of behavior and you write your tests before you implement the
classes. Whenever you wish to add some new code into the class, write a test
first. Think for a while if the new tests defines new usage scenario of the
class or is rather a new responsibility. If the second - move the test to a
separate specification file and write new class for that specification.

### Loose coupling of the classes

In all cases make as little assumptions about the cooperating classes as
possible. If it is possible, avoid any assumptions (e.g. the existence of such
cooperators). For instance if you are processing some data (e.g. compute the
total value of several items) don't make any assumptions where does the data
come from. So if you have two implementations, one which assumes that the data
order items are stored in some data repository and the other, where it only
accepts the data to be processed, the second is definitely better (less coupled)
than the first.

If you do not use mocks you can check if you are going the right way, by
explicitly requiring the classes that cooperate with the class that the test is
written for. Do not require all the classes that are parts of the application.
If you see that there are many such classes, then it is a signal (quite
superficial), that the classes are not loosely coupled. 

If you use mocks or stubs, you will figure out that something is going wrong if
you will have to mock many methods for each test. If this is the case, start
thinking which calls are really needed and which data could be provided as the
method parameter. Maybe some data is not needed at all? 

Regarding Rails -- look into your controller class. Look at the most
sophisticated action. Do you need to interact with all these objects? Maybe you
could pass the data to one meaningful method (e.g. apply_user_restrictions)
instead of calling the objects several times (e.g. checking each restriction:
status, role, login time separately)? 

### High cohesion of the classes

### Law of Demeter

### Avoiding duplication

## Testing and implementation techniques

### delegation

### inheritance

### dependency injection

## Exercises

1. Switch to the `master` branch in your respository (make sure all your 
   changes are commited to the current branch before creating the new one or
   saved using stash):

   `git checkout master`


2. Pull changes from my `master` branch:

   `git pull apohllo master`

3. Implement the rest of the exercise in the respective branches (each part has
  its own branch).


### Part 1 - unit tests

Consider the following application - a virtual wallet allowing for buying and
selling stock in several currencies. 

A user:
* can supply arbitrary amount of many in any of the defined currencies
* can convert available money from one currency to another according to a currency 
  exchange table
* can buy and sell stocks according to stock exchange rates
* can demand money to be transfered back to his/her bank account

Consider what classes are needed to implement such an application. Select one of
these class, write RSpec tests for this class and implement the class according
to the tests. At least 10 specs should be defined.

The implementation should be stored in `wallet` directory in the main directory
of this project. It should be developed in a separate git branch called `project`.

### Part 2 - mocks and stubs

The implementation of the application requires access to external services, such as
the stock exchange service, bank account service and currency exchange service.

Write the unit tests and implementation of the main class (e.g. a `Wallet`) 
for the following scenarios:
* the user sends money from his/her bank account to the virtual wallet
* the user requests a money to be transfered back to his/her bank account
* the user changes some amount of money from one currency to another
* the user buys some stock
* the user sells some stock

The `Wallet` should contact the cooperating services in order to accomplish the
scenarios. E.g. it should consult the current exchange rate between two
currencies or the current price of the stock. The services in the tests should be
stubbed/mocked. Listen to your tests. If you think that the `Wallet` class has
many responsibilities, move them to separate classes. Think of decoupling and
cohesion.

The implementation should be constistent with the implementation form the
part 1. But you can start in a separate branch called `service-mocks` (based on
the part 1 implementation) in order to separate the changes required for this
task. If everything works as expected, you can merge this branch with the
`project` branch.
