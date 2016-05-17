require 'spec_helper'
describe 'aws_module_prereqs' do

  context 'with default values for all parameters' do
    it { should contain_class('aws_module_prereqs') }
  end
end
