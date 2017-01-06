# flawless_state

FlawlessState is a shard that you can include in your objects to provide a simple state machine.  It's written as a Struct in order to keep it as fast as possible.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  flawless_state:
      github: jasonl99/flawless_state
      ```

## Usage

```crystal
require "flawless_state"
```

Create an instance property as follows:
```crystal
property state = FlawlessState::State.new
```

The default out-of-the-box configuration provides five states. The format is simply:  each state as a key has a value of states that can be transitioned into

```crystal
{
	:new =>         [:initialized, :ready, :complete],
	:initialized => [:ready, :complete],
	:ready =>       [:complete],
	:complete =>    [] of Symbol, 
	:error =>       [] of Symbol
}
```

If you'd like to use your own states on your object's property, it can be overriden using `property state = FlawlessState::State.new(my_states)`


To transition between states, provide the new state:
```crystal
class MyObject
	def complete
  	state.transition_to :completed
  end
end
```

If a state cannot transition to the new state, a FlawlessState::Exception is raised.  You can force a state transition by uisng the force method: 
```crystal
class MyObject
  def error
    state.transition_to! :error
  end
end
```

You can test if a state is terminal:
```crystal
my_instantce.state.terminal?
```

Or get its current value
```crystal
my_instance.state.current_state
```

Check to see if it's possible to transition
```crystal
my_instance.state.transition? :completed
```


## Development
The goal of FlawlessState is to remain as simple as possible, providing a simple but effective state machine.  This is very early release, and I'm new to crystal, so I'm sure there'js lots to improve.


## Contributing

1. Fork it ( https://github.com/[your-github-name]/flawless_state/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jasonl99](https://github.com/jasonl99) Jason Landry - creator, maintainer

