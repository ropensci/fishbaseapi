require_relative 'spec_helper'

describe API do
  subject { get '/heartbeat'; last_response }
  it { is_expected.to be_ok }
end
