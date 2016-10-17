ExUnit.start


defmodule Exercise do

  # Write a module called PagedOutput. Its job is to accept
  # lines of text and write them to a device. After every 5
  # lines, it will start a new page of output. There will
  # only be one PagedOutput on a node, so it should register
  # itself by name.
  #
  # The `device` is passed in as a module. This module implements
  # two functions, `write` and `new_page`. You don't need to worry
  # about the implementation of this.
  #
  # The API will be:
  #
  # - start_link(device)
  #   initialize the PagedOutput module. This will create a background
  #   agent, and store the device and the current line number in it.
  #
  # - puts(line)
  #   write the line to the device by calling `device.write(line)`.
  #   If this is the 50th line on the current page, call
  #   `device.new_page`. Returns the number of lines left
  #   on the current page
  #
  # PagedOutput will be implemented using an Agent.

                                ####################
                                # start of your code #
                                ####################
  
  defmodule PagedOutput do

    def start_link(device) do
    end

    def puts(line) do
    end

  end


                                ####################
                                # end of your code #
                                ####################



  use ExUnit.Case

  defmodule MockDevice do

    @me __MODULE__

    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, [], name: @me)
    end

    def write(line) do
      GenServer.cast(@me, {:add, line})
    end

    def new_page() do
      GenServer.cast(@me, {:add, :np})
    end

    def lines do
      GenServer.call(@me, {:lines})
    end

    def init(_) do
      { :ok, [] }
    end

    def handle_cast({:add, line}, lines) do
      { :noreply, [ line | lines ] }
    end

    def handle_call({:lines}, _, lines) do
      { :reply, Enum.reverse(lines), lines }
    end
  end


  def setup do
    maybe_kill(MockDevice)
    maybe_kill(PagedOutput)
    MockDevice.start_link
    PagedOutput.start_link(MockDevice)
  end

  def maybe_kill(mod) do
    pid = Process.whereis(mod)
    if pid, do: GenServer.stop(mod)
  end

  test "puts" do
    setup
    PagedOutput.puts :l1
    PagedOutput.puts :l2
    assert MockDevice.lines == [ :l1, :l2 ]
  end

  test "pages after 5" do
    setup
    [ :l1, :l2, :l3, :l4, :l5 ] |> Enum.each(&PagedOutput.puts/1)
    assert MockDevice.lines == [ :l1, :l2, :l3, :l4, :l5, :np ]
  end

  test "pages after 5 with extra lines" do
    setup
    [ :l1, :l2, :l3, :l4, :l5, :l6, :l7 ] |> Enum.each(&PagedOutput.puts/1)
    assert MockDevice.lines == [ :l1, :l2, :l3, :l4, :l5, :np, :l6, :l7 ]
  end

  test "pages 1000 lines" do
    setup
    1..1000 |> Enum.each(fn _ -> PagedOutput.puts(:l) end)

    lines = MockDevice.lines
    assert length(lines) == 1000 + div(1000, 5)

    pages = Enum.chunk(lines, 6)
    assert length(pages) == 200

    pages |> Enum.each(fn page ->
      assert page == [ :l, :l, :l, :l, :l, :np ]
    end)
  end


  def write_100_lines(n) do
    1..100 |> Enum.each(fn _ -> PagedOutput.puts(n) end)
  end

  test "parallel access" do
    setup
    1..100
    |> Enum.map(&Task.async(fn -> write_100_lines(&1) end))
    |> Enum.each(&Task.await/1)

    line_count = 100*100

    lines = MockDevice.lines
    assert length(lines) == line_count + div(line_count, 5)

    pages = Enum.chunk(lines, 6)
    assert length(pages) == div(line_count, 5)

    pages |> Enum.each(fn page ->
      assert [ _, _, _, _, _, :np ] = page
    end)
  end
end
