require "./spec_helper"

describe FlawlessState do
  # TODO: Write tests
  state = FlawlessState::State.new

  it "creates an object" do
    state.current_state.should eq(:initialized)
  end

  it "allows change of state" do
    state.transition_to(:complete).should eq(:complete)
  end

  it "catches invalid transition" do
    expect_raises FlawlessState::Exception do
      state.transition_to(:nothing)
    end
  end

  it "recongizes terminal state" do
    state.terminal?.should eq(true)
  end

  it "can query state" do
    state.is?(:complete).should eq(true)
    state.is_not?(:complete).should eq(false)
  end


end
