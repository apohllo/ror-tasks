# Understanding ActiveRecord #

Prerequisites:
* [ActiveRecord migrations](http://guides.rubyonrails.org/migrations.html)
* [ActiveRecord validations and callbacks](http://guides.rubyonrails.org/active_record_validations_callbacks.html)
* [ActiveRecord associations](http://guides.rubyonrails.org/association_basics.html)
* [ActiveRecord queries](http://guides.rubyonrails.org/active_record_querying.html)
* [Rails API](http://api.rubyonrails.org/)

## Introduction

*ActiveRecord* (AR in short) is the Rails ORM (Object-Relational Mapper). It is
used to simplify the access to the database, by hiding SQL-commands and data
conversion behind an object-oriented interface. There is a lot of references
describing AR (e.g. [Rails API](http://api.rubyonrails.org/), 
[Rails Guides](http://guides.rubyonrails.org) devote much space to AR), so this
introduction will only cover basic aspects of AR as well as some advanced
topics, that are not covered in Rails documentation.

### CRUD 

The first feature of ActiveRecord is CRUD interface for the persistence layer.

#### Definition

```ruby
# schema migration
class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.references :author
      # same as
      # t.integer :author_id

      t.timestamps
    end
  end
end

# class definition
class Book < ActiveRecord::Base
end
```

AR allows to define database schema changes as schema migrations, i.e. pieces of
Ruby code that describe how the schema have to change if the migration is
applied.

On the class part, the definition is very short, as the only requirement is
inheriting from the `ActiveRecord::Base` class.

#### Create

```ruby
book = Book.new(:title => 'Ruby')
book.save
# or
Book.create(:title => 'Ruby')

# In the controller context
if Book.create(params[:book])
  # success
else
  # failure
end

# params[:book] looks like
{ :title => 'Ruby' }
```

Creation of DB records might be achieved by instantiating Ruby objects of
classes that inherit from AR::Base and calling their `save` method or by calling
`create` method directly on the class. Both the constructor and the `create`
method accept a hash of key-value pairs, that describe the values of the record
columns. Appropriate conversion (from Ruby `String`) are performed on-the-fly.

**WARNING!**

The creation (and update) of objects via mass-assignment (i.e. passing a hash
of values to `new` or `create` methods) is potentially dangerous, since an
attacker might provide additional key-value pairs, that will grant him
administrator privileges and similar. This problem was partially solved by
introducing `attr_protected` macro in older versions of Rails. In the most
recent version of Rails the black-list approach was changed to white-list
approach so the developer has to define all mass-assignable attributes via
`attr_accessible` macro. In the next (4.0) version of Rails this problem was
further reduced by introduction of [strong-parameters
mechanism](https://github.com/rails/strong_parameters) that operates on the
controller level.

#### Read

```ruby
# find by id
book = Book.find(1)
book.title          #=> 'Ruby'
# or
book = Book.find_by_id(1)

# find by title
book = Book.find_by_title('Ruby')
# or
book = Book.where(:title => 'Ruby')
```

By default all tables in the DB have a surrogate primary key called `id`. It
uniquely identifies each object stored in the DB. Issuing `find` on the class
returns the object with the `id` passed as its argument.

The values of the columns are accessed via methods that are defined dynamically
and by default are the same as the names of the columns.

#### Update

```ruby
book = Book.find(1)
book.title = 'Ruby for beginners'
book.save
# or
Book.update_attributes(:title => 'Ruby for beginners')

# In the controller context
if Book.update_attributes(params[:book])
  # success
else
  # failure
end

# params[:book] looks like
{ :title => 'Ruby for beginners' }
```

Update of the values might be performed in several ways. The most popular is via
an accessor and call to `save` or via call to `update_attributes` method, which
works similar to the `create` method. Same as with `new` and `create`,
`update_attributes` is subject to the mass-assignment problem.

#### Destroy

```ruby
book = Book.find(1)
book.destroy

book.title = 'Ruby for beginners' #=> error
Book.find(1)                      #=> error
Book.find_by_id(1)                #=> nil
```

Destroy call deletes given row from a database table. To make the mechanism less
error prone, the object that was destroyed is frozen, so any changes to it will
raise an exception.

### Associations 

TODO

### Query language

Besides simple CRUD-like access, fetching the data from the persistence layer
often requires more sophisticated capabilities. This is why SQL and
relation-algebra were defined. AR simplifies construction of the SQL queries by
hiding them behind object-oriented query language, which on the one hand exposes
many of the SQL-capabilities and on the other allows for more flexible query
construction.

First of all, thanks to associations we do not have to write complex joins,
since they are added automatically, with appropriate join-conditions. What is
more we can easily overcome the *n+1 query problem*, by calling `includes` on
the constructed query. AR will transform the n+1 queries into appropriate number
(2 or more) queries which will be much more efficient. We also have access to
features such as optimistic and pessimistic locking and aggregate functions.

The short description of the methods useful for building the queries is as
follows:

* `where` - defines the query condition(s)
* `order` - defines the query order
* `select` - defines the fields that will be returned (all by default)
* `limit` - defines the maximal number of results
* `offset` - defines the results offset
* `includes` - eagerly loads associations
* `group` - groups results by given attribute
* `having` - defines the query condition(s) in case the results are grouped

TODO

* migrations
* inheritance
* validations
* callbacks
* pagination
* testing + infinite protocol of AR
* security (SQL-injection, `attr_accessible`, etc.)
* nullDB

## Exercises

Before starting writing the exercises create and switch to `task-4` branch:

  `git checkout -b task-4`
  
and install all the required libraries:

  `bundle`

There is a `Rakefile` in the main directory that defines the following tasks:

* `db:migrate` - migrate the database schema
* `db:clear` - delete the database (and migrate)
* `test` - run tests

So if you want to run the migrations type:

  `rake db:migrate`

and the migrations will be invoked.

The tests should be placed in `test` directory. Read the `test/book.rb`
test to see how you can interact with the environment. You can use
fixtures which must be placed in `test/fixtures` directory. The name of a file
must be the same as the name of the table in the database and end with `.yml`
(e.g.  `test/fixtures/books.yml`).

To load the fixtures at each test you have to use the `TestHelper` module.
It has to be included in the test definition (see `test/book.rb` for details).
In most of the tests you will need more than one class. You can create a file
that will require all model files to simplify the test set up.


### Migrations

Write migrations that will define tables for the following models:

  * `User` with the following fields:
    * `name` - the name of the user
    * `surname` - the surname of the user
    * `email` - the e-mail address of the user
    * `password` - the encrypted password of the user
    * `failed_login_count` - the number of times given user failed to log into
      the system (starts with 0)
  * `TodoList` with the following fields:
    * `title` - the title of the TodoList (e.g. prive, work, etc.)
    * `user_id`  - the id of the owner of the list
  * `TodoItem` with the following fields:
    * `title` - the title of the item
    * `description` - the description of the item
    * `date_due` - the date the item has to be completed
    * `todo_list_id` - the list this item belongs to
  Select the appropriate column types and indices for the tables.

### Definition and associations

Define the classes and their associations:

  * a `User` has many `TodoList`s
  * a `User` has many `TodoItem`s through `TodoList`s
  * a `TodoList` belongs to a `User`
  * a `TodoList` has many `TodoItem`s
  * a `TodoItem` belongs to a `TodoList`

### Validations

Define validations for the following classes:

  * `User`
    * should have a non-empty `name` up to 20 characters long
    * should have a non-empty `surname` up to 30 characters long
    * should have a valid `email` address
    * should accepts the `terms of the service`
    * should have a non-empty `password` that is at leas 10 characters long
    * should have confirmed his/her `password`
    * should have non-empty integer `failed_login_count`
  * `TodoList`
    * should have a non-empty `title`
    * should have a non-empty `user` it belongs to
  * `TodoItem`
    * should have a non-empty `title` which is 5 up to 30 characters long
    * should have a non-empty list it belongs to
    * should have a description up to 255 characters long that might be empty
    * should have a due date in dd/mm/yyyy format, that might be empty

Write tests that will show the validations are defined correctly.

### Query language

Write tests for and implement the following data access methods:

  * `User`
    * find user by `surname`
    * find user by `email`
    * find user by prefix of his/her `surname`
    * authenticate user using `email` and `password` (should use password encryption)
    * find suspicious users with more than 2 `failed_login_count`s
    * group users by number of failed login attempts
  * `TodoList`
    * find list by prefix of the `title`
    * find all lists that belong to a given `User`
    * find list by `id` eagerly loading its `ListItem`s
  * `TodoItem`
    * find items with a specific word in a description (not just a substring)
    * find items with description exceeding 100 characters
    * paginate items with 5 items per page and order them by title
    * find all items that belong to a given user (use eager loading)
    * find items that belong to a specific user that are due to midnight of a
      specific day
    * find items that are due for a specific day
    * find items that are due for a specific week
    * find items that are due for a specific month
    * find items that are overdue (what about the current date?)
    * find items that are due in the next *n* hours

Each finder method should be available in the appropriate class interface and
expressed in domain-specific language (e.g. `find_suspicious_users`). Do not use
generic AR finders in the tests. Make sure the methods are SQL-injection proof.
