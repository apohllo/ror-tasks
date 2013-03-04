# Introduction to unit testing with Rspec #

Prerequisites:

* [RSpec core](http://rubydoc.info/gems/rspec-core/frames)
* [RSpec expectations](http://rubydoc.info/gems/rspec-expectations/frames)
* [Better specs](http://betterspecs.org/)
* [The better RSpec](http://blog.bandzarewicz.com/blog/2011/09/27/krug-the-perfect-rspec/)

## Introduction ##

This task covers the introduction to [Rspec](http://rspec.info/) - 
one of the most popular testing frameworks for Ruby. 
We will start with writing unit tests. Generally tests might be split into
several groups:
* unit tests
* integration tests
* acceptance tests
* performance tests
* regression tests

Each type of test has its own purpose, but in some cases the coverage of one
type intersects with another. So this taxonomy is not mutually exclusive.

### Unit tests ###

Unit tests are used to test behavior of a given class. Sometimes they are called
specs, since a well written unit-test defines the expected behavior of a given
class. As such unit tests should cover the public interface of the class, i.e.
all the methods that are publicly available. But in Test Driven Development
(TDD), the interface exposed by the class is a result of the tests, because
the tests are written prior to the implementation. As a result, the tests should
cover all aspects of the expected behavior of the class.

It should be noted, that although tests are very important for writing quality
code, they will never define the full behavior of the class. They are only an
approximation of the definition. As such they should check three types of
conditions:
* typical conditions
* unusual conditions
* error conditions

Usually developers only think about the first case - they check if the result of
a method is valid, if the arguments are valid, e.g. if a calculator returns 4
when it should add 2 to 2. But this is not enough - when writing quality code
we should also define how the class behaves, when the arguments are unusual and
when an error should be reported. So the proper test for a calculator covers 
also negative arguments (as an unusual condition) and what happens when we
divide by zero (as an error condition). 

In the context of Rails, we usually think of unit tests as tests covering the
model layer (in fact Rails imposes such an interpretation). However unit test
are all tests that check or define the behavior of a given class *in isolation*.
So the test written for a controller might be unit tests, assuming that it 
does not interact with the model layer (this will be covered in the following
tasks).

### Integration tests ###

### Acceptance tests ###

### Performance tests ###

### Regression tests ###
