require 'rr'

# https://gist.github.com/stevenharman/1886816
def stub_module(full_name, &block)
  stub_class_or_module(full_name, Module)
end

def stub_class(full_name, &block)
  stub_class_or_module(full_name, Class)
end

def stub_class_or_module(full_name, kind, &block)
  full_name.to_s.split(/::/).inject(Object) do |context, name|
    begin
      context.const_get(name)
    rescue NameError
      # may want to be able to pass arbitrary number of params
      # to stubbed Class, so for kind == Class, use:
      # context.const_set(name, kind.new{def initialize(*args); end })
      context.const_set(name, kind.new)
    end
  end
end

RSpec.configure do |config|
  config.mock_with :rr
end

