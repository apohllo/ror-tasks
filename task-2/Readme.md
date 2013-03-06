# Stubs and mocks with RR (Ruby double)#

Prerequisites:
* [Ruby Double (rr)](http://rubydoc.info/github/btakita/rr/frames/)
* [Test double](http://xunitpatterns.com/Test%20Double.html)

## Introduction ##

One of the primary assumptions about unit tests in TDD is that the class should
be tested in isolation. This means that the test should not involve testing the
behavior of other classes, that in normal circumstances would cooperate with the
class under testing. This is motivated by two assumptions, one that the
resulting unit test will define only the behavior of the class under testing,
which helps in fulfilling *single responsibility pattern* and
the other, that the resulting class will be lest coupled with the other
cooperating classes. The side effect of this approach are faster unit tests,
which greatly improve developer experience and efficiency.

To achieve this goal unit tests should be written using test doubles, i.e.
objects that are not direct instances of the cooperating classes, but only
behave like the objects that would normally cooperate with the tested class.
There are several types of test doubles, but we will cover only three types of
them: 
* stubs
* mocks
* fakes

### Stubs ###

Stubs are usually used to provide *indirect inputs* for the class under testing.
Generally we can divide the data that is needed for testing the class as direct
and indirect input. The direct input is the data that is passed to the methods
of the instance of the class (or the class itself) in the test, e.g.

```ruby
describe TodoList do
  subject(:list)  { TodoList.new }

  it "accepts new item" do
    list << "Buy toilet paper"
    list.should_not be_empty
  end
end
```

The argument of the `<<` operator is the direct input of the test. The direct
input is directly observable in the definition of the test. In contrast, the
indirect input is not observable in the test definition. For instance - if the
addition of an item to the `TodoList` would result in calling of the database,
the result provided by the database (e.g. a `true`/`false` value indicating that
the data was successfully written on the disk) would become the indirect input
of the test. Such indirect input is useful for defining alternative
scenarios of the behavior of the class, especially with erroneous conditions.

Let us assume, that the `TodoList` calls the database to store a new item.
Calling the database in unit tests leads to slow tests and incurs the TDD
process. So in most of the cases we wish to avoid it. We can resolve the problem
by providing the test double of the database layer. But this requires that we
can configure the class under testing to accept alternative cooperating objects.
This process is called *dependency injection* (DI).

```ruby
describe TodoList do
  subject(:list)    { TodoList.new(db: database) }
  let(:description) { "Buy toilet paper" }
  let(:database)    { stub!.add_todo_item(description) { true }.subject }

  it "accepts new item" do
    list << description
    list.should_not be_empty
  end

  context "with failing database" do
    before do
      stub(database).add_todo_item(description) { false }
    end

    it "doesn't accept new item" do
      list << description
      list.should be_empty
    end
  end
end
```

In the example we have taken a simple approach towards dependency injection -
the cooperating object is provided in the constructor of the class. In some
languages (like Java) dependency injection involves sophisticated frameworks. In
Ruby much of their behavior might be achieved using standard programming
techniques. 

The database used by the `TodoList` is provided as the `db:` option of the
constructor (I use new syntax for hashes in Ruby 1.9; the code is the same as 
`:db =>` in Ruby 1.8). The database provided for the list is not the real
database - it is its test double, namely a stub. The purpose of this stub is to
provide the indirect input for the `TodoList`, i.e. it returns `true` or `false`
when the call to `add_todo_item` is invoked. 

The syntax of Ruby double (rr) is very convenient - we use `stub!` to create new
object which is a stub and `stub(object)` to add new stubbed method to an
existing object. What comes after `stub!` and `stub` is the normal call of the
method, we wish to stub, i.e. call which defines the arguments that have to be
provided in order for the value to be returned (i.e. the indirect input of the 
test). The returned value is provided
in the block which comes after the method call. Because the result of that call
is not the stubbed object, if we use `stub!`, we have to call `subject` on the
result. This gives us the object that is stubbed (i.e. the test double).

In the above example we also use the RSpec `before` hook - this is the block of
code that is called before each test (there is also an `after` hook which is
usually used to perform some cleaning, e.g. closing of the DB connections, etc.). 
It is used to change the result of the `add_todo_item` in the context with 
the failing database.

To sum up: the definition of the test with the stubbed database allows for
providing the indirect inputs for the tested class. Although in both tests the
*direct* input of the method (i.e. the description of the task) is the same, the
result of that call is expected to be different, since the *indirect* input of
the test (i.e. the value returned by the database) is different.

Imagine how complicated this scenario would be, if we have to use the real
database implementation. For instance, we would have to add a special option
for the database to produce invalid results. This would have to be implemented in
the database, but the purpose of that option would be limited only to testing -
a very bad idea. In contrast - in the above code we only change the value returned
by the test double and everything works as expected. What is more, the change
that influenced the behavior of the `TodoList` is directly observable, making
the test easy to understand.

### Mocks ###

Mocks are very similar to stubs, i.e. they allow for defining values returned
for particular messages. The primary difference between stubs and mocks is that
mocks provide additional layer of assertions - they are used to check the
*indirect outputs* of the tested class. This is achieved by *requiring* that
particular messages will be sent to the cooperating objects or by requiring that
particular messages *will not* be sent. Although mocks also provide the indirect
inputs for the test, they primary intent is checking what messages are sent by
the tested class (i.e. what outputs are produced). So the test will fail not
only when a direct result of the test (i.e. the value returned by the method
called in the test) is invalid, but also when the tested object have not
invoked a particular call.

To illustrate the difference and the importance of mocks let us assume that we
wish to spam social networks whenever new item is added to our `TodoList` (this
example is adopted from [Objects on Rails](http://objectsonrails.com) by Avdi 
Grim). But unlike in the database example, we do not want to depend on the
result of spamming a social network. This would definitely slowed down our
application, so this call is probably asynchronous. We just want to make sure
the particular message is sent to the component responsible for twitting. As a
result, we cannot check if the message was sent by inspecting the direct result
of adding a new item to the list. We have to use mocks:

```ruby
describe TodoList do
  subject(:list)        { TodoList.new(social_network: network) }
  let(:description)     { "Buy toilet paper" }
  let(:add_prefix)      { "I am going to " }
  let(:complete_suffix) { " is done" }
  let(:network)         { mock!.spam(prefix + description) { true }.subject }

  it "spams the social network when an item is added" do
    list << description
  end

  it "spams the social network when an item is completed" do
    mock(network).spam(description + complete_suffix) { true }

    list << description
    list.complete(0)
  end
end
```

In these tests we require that whenever an item is added to the `TodoList` a
message with a prefix `I am going to ` is sent to our social network. What is
more, we require that a similar message (with ` is done` suffix) is sent, when
we complete particular item on the `TodoList`.

As you can see, the syntax of mocks is the same as the syntax of stubs. We can
use `mock!` to create new object with a mocked method and `mock` to add a new
mocked method to an existing object. After `mock!` and `mock` comes the name of
the method with the proper arguments. The result of the method is provided in
block. 

The difference between stubs and mocks might be observed in the tests
definitions: in case of mocks we do not have to write assertions concerning the
direct result of the method call, for the test to be valid. The test will fail
if the mocked method was not invoked by the tested object. So the creation of a 
assertion verifying its behavior is an implicit result of mocking the method.

The same behavior cannot be achieved with stubs - since the value returned by
the social network is ignored, we will not be able to add an assertion on the
direct result of the method call (or some other assertion checking the state of
the `TodoList`, like in the database example). We would have to check that the
cooperating object has changed its state (e.g. contains a new item in its
queue), but this would be cumbersome and does not work in all scenarios. This is
exactly the purpose of a mock - to verify that the message was sent.

As a final remark, we should note, that mocks allow for defining how many times
given method is called. By default it is required that the method is called
once. Adding `times` to the method chain allows us to specify different number
of calls.

```ruby
mock(network).spam("Whaaaa!").times(2) { true }
```

The above code requires that the social network will be spammed with the
`Whaaaa!` message two times. This assertion will fail both if the number of
messages is lower or higher than specified. We can also require that a
particular message is not sent to the cooperating object, by providing
`times(0)`. Since this is quite popular scenario it is abbreviated as
`dont_allow` macro:

```ruby
mock(network).spam("Whaaaa!").times(0)  # the same as:
dont_allow(network).spam("Whaaaa!")
```

In the above example we also skipped the definition of the result of the call.
This is fairly legal - in such a case the result will be nil and we might assume
that it is ignored by the tested object.

### Fakes ###

## Exercises ##

## Homework ##
