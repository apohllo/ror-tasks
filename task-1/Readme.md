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

The unit tests are used to test behavior of a given class. Sometimes they are called
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
So the test written for a controller might be a unit test, assuming that it 
does not interact with the model layer (this will be covered in the following
tasks).

### Integration tests ###

The integration tests are used to test the behavior of the selected aspect of
the code when the classes interact with each other. In this sense it is an
opposite of unit tests, where the classes are tested in isolation. Integration
tests usually spot problems that arise in interaction between different parts
of the system, such as invalid arguments passed to the methods or invalid
sequences of calls. 

Because the integration tests usually involve external systems such as the
database or external web-services, they run much slower than the unit tests.
This is why unit tests are used to define the expected behavior of the system,
while integration tests are used mostly to spot the errors. In practice unit
tests are run whenever new piece of code is implemented, while integration
tests, depending on the complexity of the system, are run when the code is
passed to the shared repository or (at least part of them) on a server dedicated
only to run integration tests. This is particularly important for code which is
written by many developers, when many parallel changes are contributed to the
shared repository.

### Acceptance tests ###

The acceptance tests are tests developed to satisfy the exact requirements of
the client. For instance if the client delivers a specification of the system
behavior, this specification should be base for the acceptance tests. The most
important feature of acceptance tests is its language - it should be the client
language, not the language used by the developers. The acceptance tests should
be understandable for the client without clarification. As a result it should
cover sentences such as 'When I click the "Ok" button, a green message appears'.

This can be achieved using regular RSpec tests or test-frameworks dedicated for
writing acceptance tests, such as [Cucumber](http://cukes.info/). 
In Cucumber the definition of the
test is written in semi-structured English (or several other languages) and
follows Given-When-Then pattern, which allows to state the pre-conditions, the
conditions and the expected results of the system behavior. As such it allows
the non-technical participants of the project, to understand and even write the
specification. 

A different way of specifying acceptance tests is using the browser and
frameworks such as Selenium for recording the expected behavior of the system.
In the recording phase a user clicks through the interface and provides the
required data. She also defines the expected behavior of the system (such as
appearance of a text message, and the like. 
In the testing phase the test is run automatically by replying the interaction 
with the browser and by checking the defined conditions. 

Such tests are similar to the integration tests, since usually they cover many
classes of the system. The difference is that, they are taking the user
perspective, so in many cases they will not cover all invalid data that might be
supplied to the system. It should be also noted, that the acceptance tests run
with Selenium are very slow, so they are usually run only when the new release
of the system is prepared.

### Performance tests ###

The performance tests are written in order to measure and improve the
performance of the system. They usually concentrate on the critical features of
the systems, i.e. these which are most frequently called and these that are the
slowest. In most cases such test report the time to run given test. Less
frequently they report the memory consumption or other performance related 
measures (e.g. the number of opened files or sockets, etc.). Their purpose is
to ensure that given feature will not run for too much time. They also ensure
that changes made to the system will not incur its performance. 

It should be noted that performance testing unlike other types of tests, are 
environment dependant so they are usually run on a dedicated system (as much
similar to the production system as possible) in order to get reproducible and
reliable results. What is more the results of these tests are archived in order
to compare previous results with the current performance.

### Regression tests ###

The last type of tests are regression tests. This tests are written whenever an
error is spotted in a running application (either in staging or in production
environment). These tests are similar to integration tests, since they cover the
interaction between different pieces of the system. The primary difference is
that they usually cover very unusual scenarios. It is due to the fact, that when
the scenario is typical, it becomes the part of the unit test (i.e. part of the
specification of the system or a given class). But in both cases the original
scenario that triggered the error should be registered in form of a test and
never removed. This will ensure that the problem will not appear in the future.

Regression test, like acceptance tests are usually run when the new version of
the system is publicly released.

## RSpec unit tests ##

There are two modules of RSpec that particularly important for writing unit
tests:
* RSpec core 
* RSpec expectations

The core module of RSpec defines the following important concepts:
* the *class* under testing
* the set of *variables* used in the tests (they might be re-defined for different
  contexts)
* the set of *tests*

### Class ###

The **class** under testing is introduced using the `describe` key-word, e.g.

```ruby
describe TodoList do
  # the specification of the TodoList
end
```

The same key-word is used to define sub-contexts, e.g. a `TodoList` with one
item:

```ruby
describe TodoList do
  describe "with one item" do
    # the specification of the TodoList with one item
  end
end
```

The `describe` key-word is aliased as `context` so the above example might be
described as follows:

```ruby
describe TodoList do
  context "with one item" do
    # the specification of the TodoList with one item
  end
end
```

### Variables ###

The set of **variables** used in the test is introduced using the `let`
key-word. This construction is particularly useful, when we need different
values of the variables in different contexts. E.e. if we initialize the
TodoList with some items we might use the following definitions:

```ruby
describe TodoList do
  let(:list)  { TodoList.new(items) }
  let(:items) { [] }                    # an empty list of items

  # in this context the TodoList is initialized with an empty list of items

  describe "with one item" do
    let(:items)   { ["But toilet paper"] }

    # in this context the TodoList is initialized with a list of items
    # containing one element
  end
end
```

The syntax of the `let` macro is as follows - the argument is a symbol, i.e. the
name of the variable. It also accepts a block of code `{ ... }` which is used to
initialize the variable. This results in a local variable which might be used in
any place in the given context, even for defining other variables 
(e.g. in `TodoList.new(items)`). 

If the variable is redefined in the different context (especially a sub-context), 
the new value is used. As a result we does not have to define all the variables,
but only these that are different from the surrounding context (as in the
example above). 

### Tests ### 
