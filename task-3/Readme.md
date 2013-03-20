# Test driven development (TDD) of the model layer #

## Introduction

TODO

Write few words about (objectives of the TDD):

* where does the test requirements come from
* single responsibility pattern
* law of Demeter
* loose coupling
* high cohesion
* delegation
* inheritance
* dependency injection
* red-green-refactor cycle

## Exercises

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
of this project.

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
stubbed/mocked.

The implementation should be constistent with the implementation form the
part 1.