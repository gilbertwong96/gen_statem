# GenStatem

An Elixir implementation of the `gen_statem` behavior from Erlang/OTP.

## Features

- Co-located state code (`state_functions` mode)
- Arbitrary term state (`handle_event_function` mode)
- Event postponing
- Self-generated events
- State time-outs
- Multiple generic named time-outs
- Absolute time-out time
- Automatic state enter calls
- Reply from other state than the request
- Multiple replies
- Changing the callback module

## Installation

Add `gen_statem` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gen_statem, "~> 0.1.0"}
  ]
end
```

## Usage

### Callback Modes

Two callback modes are supported:

1. `state_functions` - For finite-state machines where states must be atoms and each state has its own callback function
2. `handle_event_function` - Allows states to be any term and uses a single callback function for all states

### Example Pushbutton Implementation

Here's a simple pushbutton example using `state_functions` mode:

```elixir
defmodule PushButton do
  use GenStatem

  defp name, do: :pushbutton_statem

  # API
  def start, do: GenStatem.start(__MODULE__, [], name: name())
  def push, do: GenStatem.call(name(), :push)
  def get_count, do: GenStatem.call(name(), :get_count)
  def stop, do: GenStatem.stop(name())

  # Callbacks
  def init([]) do
    {:ok, :off, 0}
  end

  def callback_mode(), do: :state_functions

  # State callbacks
  def off({:call, from}, :push, data) do
    {:next_state, :on, data + 1, [{:reply, from, :on}]}
  end
  def off(event_type, event_content, data) do
    handle_event(event_type, event_content, data)
  end

  def on({:call, from}, :push, data) do
    {:next_state, :off, data, [{:reply, from, :off}]}
  end
  def on(event_type, event_content, data) do
    handle_event(event_type, event_content, data)
  end

  # Common event handler
  defp handle_event({:call, from}, :get_count, data) do
    {:keep_state, data, [{:reply, from, data}]}
  end
  defp handle_event(_event_type, _event_content, data) do
    {:keep_state, data}
  end
end
```

### Starting the Server

Start the server using one of:

```elixir
GenStatem.start(module, init_arg, options)
GenStatem.start_link(module, init_arg, options)
GenStatem.start_monitor(module, init_arg, options)
```

### Making Calls

Synchronous call:
```elixir
GenStatem.call(server_ref, request, timeout \\ :infinity)
```

Asynchronous cast:
```elixir
GenStatem.cast(server_ref, msg)
```

### Transition Actions

State callbacks can return actions like:

- `{:next_state, new_state, new_data}`
- `{:reply, from, reply}`
- `{:postpone, true}`
- `{:timeout, time, content}`
- `{:state_timeout, time, content}`
- And more...

## Comparison with GenServer

| Feature          | GenStatem | GenServer |
|-----------------|-----------|-----------|
| State handling  | Explicit states with callbacks | Implicit in server data |
| Event handling  | Built-in event queue and postponing | Manual handling |
| Performance     | Optimized for state transitions | General purpose |
| Use cases       | Complex workflows, protocols | General server needs |

## Troubleshooting

### Common Issues

1. **State not changing**: Ensure you return `{:next_state, ...}` not `{:keep_state, ...}`
2. **Events not processed**: Check if events are being postponed accidentally
3. **Timeouts not firing**: Verify no other events are canceling them

## Documentation

For complete documentation, see the [module docs](https://hexdocs.pm/gen_statem).
