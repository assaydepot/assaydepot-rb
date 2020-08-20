require 'assaydepot'
require 'dotenv'
Dotenv.load

puts "Yes!"
describe AssayDepot do
  context "scientist_api backoffice tests" do
    before(:all) do
      AssayDepot.configure do |config|
        config.access_token = ENV['BACKOFFICE_ACCESS_TOKEN']
        config.url = "#{ENV['BACKOFFICE_SITE']}/api/v2"
      end
    end

    context "info" do
      let(:info) { AssayDepot::Info.get() }

      it "info version V2" do
        info["api_version"].should == "V2"
      end
    end

    context "quoted wares" do
      let(:qw) { AssayDepot::QuotedWare.get() }

      it "get all quoted wares" do
        qw.is_a?(Array).should == true
      end
    end
  end
end
