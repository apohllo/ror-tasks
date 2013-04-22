# Understanding ActiveRecord #

Prerequisites:
* [ActiveRecord migrations](http://guides.rubyonrails.org/migrations.html)
* [ActiveRecord validations and callbacks](http://guides.rubyonrails.org/active_record_validations_callbacks.html)
* [ActiveRecord associations](http://guides.rubyonrails.org/association_basics.html)
* [ActiveRecord queries](http://guides.rubyonrails.org/active_record_querying.html)

## Introduction ##

TODO

Write about:

* CRUD
* query language
* migrations
* associations
* inheritance
* validations
* callbacks
* pagination
* plugins
* testing + infinite protocol of AR
* security (SQL-injection, `attr_accessible`, etc.)
* nullDB

## Exercises

1. Write migrations that will define tables for the following models:

** `User` with the following fields:
*** `name` - the name of the user
*** `surname` - the surname of the user
*** `email` - the e-mail address of the user
*** `password` - the encrypted password of the user
** `TodoList` with the following fields:
*** `title` - the title of the TodoList (e.g. prive, work, etc.)
*** `user_id`  - the id of the owner of the list
** `TodoItem` with the following fields:
*** `title` - the title of the item
*** `description` - the description of the item
*** `date_due` - the date the item has to be completed
*** `todo_list_id` - the list this item belongs to

Select the appropriate column types and indices for the tables.

* extensive list of query language examples
* associations (with `:through` and `:polymorphic`)
* validations
