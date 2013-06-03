# Implementation of the persistence layer

## Introduction ##

TODO 

This will cover integration tests, fixtures, nullDB, FactoryGirl (?)

## Exercises

### Git

Before starting the exercises switch to the `task-2` branch, then create and
switch to the `task-5` branch and pull changes from the `apohllo` repository:

```
git checkout task-2
git checkout -b task-5
git pull apohllo master
```

Change directory to `task-5` and install the required libraries:

  `bundle`

There is a Rakefile in the main directory that defines the following tasks:

* `db:migrate` - migrate the database schema
* `db:clear` - delete the database (and migrate)
* `test:spec` - run specs
* `test:int` - run integration tests
* `test:all` - run all test

So if you want to run the migrations type:

  `rake db:migrate`

and the migrations will be invoked.

### Review

First of all look into the specs. They are located in `test/spec` directory.
They are very similar to the specs from `task-2`, with one important 
difference - the `:database` is the same as the `:list`. This is because, 
the `list` inherits from `ActiveRecord` and serves both as a business model 
and as a persistence layer. In order for the specs to run fast, the calls to the
persistence layer are stubbed/mocked. The `spec_helper` uses NullDB to make the
interactions with the DB fast. The configuration is not trivial, so you should
look into that file as well.

Run the specs to check if everything works as expected.

When you get acquainted with the specs, check the integration tests in
`test/integration` directory.  This tests are similar in spirit to tests from
`task-4`. Since these are integration tests, we can use the full API of the
`TodoList` and other cooperating classes. E.g. one of the tests checks if the item
is not stored, if it is empty. This requires call to `TodoItem#valid?` method.
The `test_helper` is almost the same as in `task-4` so you can use fixtures.
However, they are not used in the example.

Before running the tests you have to invoke the migrations. When this is done,
run the integration tests.

At the end look into the implementation of `TodoList` (`lib/todo_list.rb`). You
will find two section - one containing the business model methods, and the
other containing the persistence methods. In this case the persistence layer is
fully integrated with the business layer, however they could be separated.

### Specs

Copy the specs defined in `task-2`. Adjust them according to the example.
Make sure, that all tests pass. There is one important difference - in `task-2`
the persistence layer and the social network layer were provided in the
constructor. This is no longer possible. You can provide the SN layer by adding
attribute writer (check out `item_factory` in `lib/todo_list.rb` as an example).
Some of the tests are better suited for the integration tests. In such a case
move them accordingly.

### Integration tests

Writing specs for the `TodoList` required that many of the database calls were
mocked. Make sure that the integration tests cover all these methods. Write
these tests and implement the required methods in the `TodoList` class (you can
also change `TodoItem` class if it is necessary). Make sure that all theses test
pass as well.

### Project

This exercise showed how you can implement the persistence layer, separating the
slow integration tests from the fast specs. Use the same techniques in the
`Wallet` project.
