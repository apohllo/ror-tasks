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

There are two modules of RSpec that are particularly important for writing unit
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
values of the variables in different contexts. E.g. if we initialize the
`TodoList` with some items we might use the following definitions:

```ruby
describe TodoList do
  let(:list)  { TodoList.new(items) }
  let(:items) { [] }                    # an empty list of items

  # in this context the TodoList is initialized with an empty list of items

  describe "with one item" do
    let(:items)   { ["Buy toilet paper"] }

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

There is one special variable, which is called `subject` - this is the variable
containing the object under testing. By default this is the instance of the
class under testing obtained by calling the constructor of the class without any
arguments. In many circumstances this is not enough, so we can define the
subject explicitly:

```ruby
describe TodoList do
  # The subject variable is equal to TodoList.new
end

describe TodoList do
  subject       { TodoList.new(items) } # user-defined subject
  let(:items)   { [] }
end
```

The primary difference between `let` and `subject` is that we do not have to 
pass the name of the variable - with this respect the syntax is the same. The
value of the variable is the value of the passed block of code. But subject has
special purpose in tests - we may write concise tests for the subject. This will
be shown later.

In the recent version of RSpec an extension for the `subject` macro was
introduced - it also accepts the name of the variable. In such a case, there are
two variables - `subject` and the other whose name is defined in the call. This
is motivated by the fact, that tests with `subject` variable name are less
meaningful. E.g. `subject.should_not be_empty` is less meaningful than
`list.should_not be_empty`. Still in the second scenario we want an indication
of the object under testing, that is why it is available as the `subject`.
This problem will be covered in the following examples.

### Tests ###

The tests in RSpec are defined using `it` key-word, e.g.

```ruby
describe TodoList do
  subject     { TodoList.new(items) }
  let(:items) { [] }
  
  it "is empty" do
    subject.should be_empty
  end
end
```

This tests states that a new `TodoList.new` should respond to `empty?` call with
`true` value. This is verified by `.should be_empty` call. Although it might not
be obvious how this is achieved (it is covered in the section regarding
*expectations*), the example is easy to read and understand. We can read it as
follows: "A (fresh) TodoList is empty". What is more, we can obtains such a
description automatically by running RSpec (we will show that later). 

The syntax of `it` is as follows - it accepts the name of the test ("is empty")
followed by a block of code defining the test. The tests contains expectations
concerning the subject under the test.

For short tests (like the one above) the syntax might be abbreviated:

```ruby
describe TodoList do
  subject     { TodoList.new(items) }
  let(:items) { [] }
  
  it { should be_empty }
end
```

The semantics of the test is the same, but its definition is shorter. What is
more, we omitted the `subject` variable, however the test relies on its proper
definition. 

If we want to mix verbose and concise style tests it is a good idea to give 
the subject a different name, which reflects its "nature", e.g. 

```ruby
describe TodoList do
  subject(:list)      { TodoList.new(items) }
  let(:items)         { [] }
  
  it { should be_empty }

  it "is not empty when an item is added" do
    list << "Buy toilet paper"
    list.should_not be_empty
  end
end
```

In this case the object under testing is available both as `subject` and `list`.
The first variable is used in the concise test, while the second in the verbose
one. Although it is perfectly legal to reference the `subject` in the second
case, the test is less explicit and less meaningful (see 
[better specs](https://github.com/andreareginato/betterspecs/issues/7) for a
discussion of this problem). 

### Expectations ###

As it was shown above, the primary feature of RSpec is the set of macros, that
allows for writing tests using a Domain Specific Language (DSL). Such tests are
easy to read and understand. What is more we can obtain the documentation of the
class under testing automatically. But the second feature of RSpec, which is well
connected with previous one, is the set of defined *expectations*. The
expectations are macros used to define the expected behavior of the objects
under testing. 

The [documentation of RSpec
expectations](http://rubydoc.info/gems/rspec-expectations/frames) gives
comprehensive list of them. Here we only introduce several important and most 
commonly used expectations.

**Equivalence** expectation is used to check the equivalence of two objects. 
It uses Ruby equivalence method `==` to check if the objects are "the same",
e.g.:

```ruby
describe TodoList do
  subject(:list)      { TodoList.new(items) }
  let(:items)         { [] }
  
  it "has 0 size" do
    list.size.should == 0
  end
end
```

The above tests check if the result of `size` call is the same as zero.

**Predicate** expectation is used to check if the object possess given feature.
This expectation uses the common Ruby idiom of methods that end with a question
mark, i.e. `empty?`. To write expectation testing such features, we have to
remove the question mark and prepend the name of the method with `be_`, so
`empty?` becomes `be_empty`. This feature was illustrated earlier.

**Exception** expectations are used to check if given exception is raised in the
given (erroneous) context. This is particularly important for writing quality 
unit tests. As it was stated at the beginning, good unit test cover typical,
unusual and error conditions. Exception expectations are used to write the last
type of tests. E.g. we can throw an error if the argument passed to the
`TodoList` is `nil`:


```ruby
describe TodoList do
  it "raises exception when invalid argument is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(InvalidArgument)
  end
end
```

The `InvalidArgument` exception is not available in Ruby, so it must be defined
in our system. The expectations concerning errors should be specific - passing
Exception as the expected error will result in tests, that do not define any
behavior. If there is any kind of error, the expectation will be met, which
is wrong. So we have to devise specific types of exceptions for different types
of errors that might be produced by our system. And the we should check that
proper exceptions are raised in specific erroneous contexts.

## Exercises ##

1. Register at github.
2. Fork this project.
3. Clone **your project** to the lab computer.
4. Create and switch to `task-1` branch in git.
5. Change directory to `task-1`
6. Update project dependencies

  `bundle`

7. Look at the [source code of the test definition](spec/todo_list.rb)
8. Run the tests with:

  `rspec spec/todo_list.rb --format doc --color`

9. Implement the [TodoList](lib/todo_list.rb) in order to fulfil the
  test requirements.
10. Write the following test definitions:
  * accessing the items by index
  * iterating over the items
  * toggling the state of an item
  * returning of completed items
  * returning of uncompleted items
  * removal of an individual item
  * removal of all completed items
  * reversing order of two items
  * reversing the order of all items
  * sorting the items by name
  * conversion of the list to text with the following format
    * `- [ ] Uncompleted item`
    * `- [x] Completed item`
11. Expand the implemented tests for typical, unusual and erroneous conditions.
12. Implement the `TodoClass` according to the defined tests.
13. Upload your changes to your github repository.
