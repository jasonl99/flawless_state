require "./flawless_state/*"

module FlawlessState
  class Exception < Exception
    @error_text : String
    def initialize(@error_text, state)
      raise @error_text
    end
  end


  struct State
    getter current_state = :new
    property state_pairs = Array(Tuple(Symbol,Symbol)).new

    # transitions are a `Hash(Symbol,Array(Symbol)` which reprsent
    # what a state is allowed to transitio to
    def initialize( transitions = self.defined_states)
      @state_pairs = build_transitions transitions
      @current_state = :initialized
    end

    # each key results in an array that can be transitioned into.
    # see `#build_transitions`
    def defined_states
      {
        :new				 => [:initialized, :ready, :complete],
        :initialized => [:ready, :complete],
        :ready       => [:complete],
        :complete    => [] of Symbol, 
        :error 			 => [] of Symbol,
      }

    end

    # A state is termimal if it is has no valid states to transition to (empty arrays in `#defined_states`)
    # States can be forced to other states with `#transition_to!`
    def terminal?( state : Symbol = @current_state)
      defined_states[state].none?
    end

    def is?( state : Symbol)
      current_state == state
    end

    def is_not?( state : Symbol)
      current_state != state
    end


    # if a transition is permitted, make it, otherwise raise an exception
    def transition_to( new_state : Symbol)
      unless @state_pairs.index( {current_state, new_state})
        Exception.new "Transition from #{current_state} to #{new_state} is not permitted.", self
      else
        transition_to!(new_state)
      end
    end

    # force a transition without checking the validity of the new state
    def transition_to!( new_state : Symbol)
      @current_state = new_state
    end

    # Create the @state_pairs array of tuples.  Each tuple is a from_state to a to_state. `#defined_states`
    # would produce the following pairs.  Each each is an allowed to-> from set of states.
    # ```
    # [{:new, :initialized},
    #  {:new, :ready},
    #  {:new, :complete},
    #  {:initialized, :ready},
    #  {:initialized, :complete},
    #  {:ready, :complete}]
    # ```
    def build_transitions(definitions : Hash(Symbol, Array(Symbol)) )
      definitions.each_with_object([] of Tuple(Symbol,Symbol)) do |(from_state, to_states), result |
        to_states.each {|to_state| result << {from_state, to_state} }
      end
    end


  end

end
