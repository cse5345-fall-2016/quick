ExUnit.start

defmodule Exercise1 do

  # Write a function sort2(a, b) which returns a tuple
  # containing {a, b} is a is < b, {b, a} otherwise

  def sort2(a, b) do
  end
  
  use ExUnit.Case
  
  test "sort2" do
    assert sort2(1, 2) == { 1, 2 }
    assert sort2(1, 1) == { 1, 1 }
    assert sort2("dog", "cat") == { "cat", "dog" }
  end
end

defmodule Exercise2 do

  # Write a function sort2a(a, b, comparison_func)
  #
  # The comparison function takes two arguments and returns true
  # if the first is less than the second.
  #
  # sort2a returns a tuple containing {a, b} is a is < b, {b, a} otherwise
  #
  # See the tests for examples of use

  def sort2a(a, b, compare_func) do
  end

  use ExUnit.Case

  test "sort2a" do

    compare_length = fn a, b ->
      String.length(a) < String.length(b)
    end

    assert sort2a("dog", "carrot", &Kernel.</2)    == { "carrot", "dog" }
    assert sort2a("dog", "carrot", compare_length) == { "dog", "carrot" }
  end
end

defmodule Exercise3 do

  # Write a module called Registry that provides 4 functions, described below.
  # The module implements a key/value store using a named Agent.
  # 
  # The  API is
  # 
  # start_link()
  # - initializes the module
  # 
  # add(key, value)
  # - add or replace an entry in the registry
  # 
  # get(key)
  # - return the value corresponding to key, or nil if the key isn't
  #   in the registry
  # 
  # to_upper(key)
  # - updates the registry, changing the string value corresponding to
  #   key to uppercase, and returns that value. Return nil if the key is
  #   not in the registry. You can assume the value associated with key
  #   is a string.


  defmodule Registry do
    def start_link do
    end

    def add(key, value) do
    end

    def get(key) do
    end

    def to_upper(key) do
    end
  end

  use ExUnit.Case

  test "registry" do
    Registry.start_link

    Registry.add(:name1, "address1")
    Registry.add(:name2, "address2")

    assert Registry.get(:name1) == "address1"
    assert Registry.get(:name2) == "address2"
    assert Registry.get(:name3) == nil

    assert Registry.to_upper(:name1) == "ADDRESS1"
    assert Registry.get(:name1)      == "ADDRESS1"

  end

end
