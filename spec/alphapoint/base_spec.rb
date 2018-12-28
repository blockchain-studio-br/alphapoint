require "spec_helper"

RSpec.describe Alphapoint::Base do

  describe 'handle_response' do

  	it "expect to exists in Alphapoint::Base" do 
  		obj = Alphapoint::Base.new

  		expect(obj.methods).to include(:handle_response)
  	end

  	it "expect to exists in Alphapoint::Base with payload" do 
  		obj = Alphapoint::Base.new({})

  		expect(obj.methods).to include(:handle_response)
  	end

  	it "expect to exists in Alphapoint::Base with payload and type" do 
  		obj = Alphapoint::Base.new({})

  		expect(obj.methods).to include(:handle_response)
  	end

  end


  describe 'mount_frame' do

  	it "expect to exists in Alphapoint::Base" do 
  		obj = Alphapoint::Base.new

  		expect(obj.methods).to include(:mount_frame)
  	end

  	it "expect to exists in Alphapoint::Base with payload" do 
  		obj = Alphapoint::Base.new({})

  		expect(obj.methods).to include(:mount_frame)
  	end

  	it "expect to exists in Alphapoint::Base with payload and type" do 
  		obj = Alphapoint::Base.new({})

  		expect(obj.methods).to include(:mount_frame)
  	end

  	it "expect to return a Hash" do 
  		obj = Alphapoint::Base.new({})

  		expect(obj.mount_frame.class).to be(Hash)
  	end

  end

end


