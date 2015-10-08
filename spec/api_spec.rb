require_relative 'spec_helper'

describe API do
  $routes.each do |route|
    context route do
      subject { get route; last_response }
      it { is_expected.to be_ok }
    end
  end
end
