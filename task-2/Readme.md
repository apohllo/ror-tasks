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

Imagine how complicated would be this scenario, if we have to use the real
database implementation. For instance, we would have to add a special option
for the database to produce invalid results. This would have to implemented in
the database, but the purpose of that option would be limited only to testing -
very bad idea. In contrast - in the above code we only change the value returned
by the test double and everything works as expected. What is more, the change
that influenced the behavior of the `TodoList` is directly observable, making
the test easy to understand.

### Mocks ###

Mocks are very similar to stubs, i.e. they allow for defining values returned
for particular messages. The primary difference between stubs and mocks is that
mocks provide additional layer of assertions - they are used to check the
*indirect outputs* of the tested class. 

## Exercises ##

## Homework ##
