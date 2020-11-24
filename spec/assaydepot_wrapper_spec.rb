require 'assaydepot'
require 'dotenv'
Dotenv.load

describe AssayDepot do
  context "scientist_api tests" do
    before(:all) do
      AssayDepot.configure do |config|
        config.access_token = ENV['ACCESS_TOKEN']
        config.url = "#{ENV['SITE']}/api/v2"
      end
    end

    context "info" do
      let(:info) { AssayDepot::Info.get() }

      it "info version V2" do
        info["api_version"].should == "V2"
      end
    end

    context "categories" do
      let(:categories) { AssayDepot::Category.get() }
      it "get all categories" do
        categories[AssayDepot::Category.ref_name].is_a?(Array).should == true
      end

      it "get specific category" do
        category = AssayDepot::Category.get(id: categories[AssayDepot::Category.ref_name].first[:id])
        categories[AssayDepot::Category.ref_name][0][:id].should == category[:id]
      end
    end

    context "organizations" do
      let(:organizations) { AssayDepot::Organization.get() }

      it "get all organizations" do
        organizations.is_a?(Array).should == true
      end

      it "get specific organization" do
        organization = AssayDepot::Organization.get(id: organizations.first["id"])
        organizations.first["id"].should == organization["id"]
      end
    end

    context "providers" do
      let(:providers) { AssayDepot::Provider.get() }

      it "get all providers" do
        providers[AssayDepot::Provider.ref_name].is_a?(Array).should == true
      end

      it "get specific provider" do
        id = providers[AssayDepot::Provider.ref_name].first["id"]
        provider = AssayDepot::Provider.get(id: id)
        id.is_a?(Integer).should == true
        id.should == provider["provider"]["id"]
      end

      it "get wares for a specific provider" do
        id = providers[AssayDepot::Provider.ref_name].first["id"]
        ware = AssayDepot::ProviderWare.get(id: id)
        ware[AssayDepot::ProviderWare.ref_name].is_a?(Array).should == true
      end

      it "update specific provider attribute" do
        id = providers[AssayDepot::Provider.ref_name].first["id"]
        num_employees = rand(1000)
        response = AssayDepot::Provider.put(id: id, body: { number_of_employees: num_employees });
        response["code"].should == "forbidden"
      end

    end

    context "quote groups" do
      let(:qg) { AssayDepot::QuoteGroup.mine }

      it "quote groups mine" do
        qg[AssayDepot::QuoteGroup.ref_name].is_a?(Array).should == true
      end

      it "quote groups specific id" do
        id = qg[AssayDepot::QuoteGroup.ref_name].first["id"]
        response = AssayDepot::QuoteGroup.get( id: id )
        response["id"].should == id
      end

      it "quote group add note" do
        id = qg[AssayDepot::QuoteGroup.ref_name].first["id"]
        title_text = "This is some #{rand(1000)} text."
        body_text = "This is some #{rand(1000)} body text."
        response = AssayDepot::AddNote.post(id: id, body: {
          note: {
            title: title_text,
            body: body_text
          }
        })
        response["code"].should == "unprocessable_entity"
      end
    end

    context "users" do
      let(:users) { AssayDepot::User.get() }
      let(:profile) { AssayDepot::User.profile }

      it "get all users" do
        users[AssayDepot::User.ref_name].is_a?(Array).should == true
      end

      it "get my user profile" do
        profile["user"]["first_name"].is_a?(String).should == true
      end
    end

    context "wares" do
      let(:wares) { AssayDepot::Ware.get() }

      it "get all wares" do
        wares[AssayDepot::Ware.ref_name].is_a?(Array).should == true
      end

      it "get specific ware" do
        ware = AssayDepot::Ware.get( id: wares[AssayDepot::Ware.ref_name].first["id"] )
        wares[AssayDepot::Ware.ref_name].first["id"].should == ware["ware"]["id"]
      end

      it "get providers for a ware id" do
        response = AssayDepot::WareProvider.get( id: wares[AssayDepot::Ware.ref_name].first["id"] )
        response[AssayDepot::WareProvider.ref_name].is_a?(Array).should == true
      end
    end

    context "wares providers" do

      before(:all) do
        wares = AssayDepot::Ware.get()
        providers = AssayDepot::Provider.get()
        @ware_id = wares[AssayDepot::Ware.ref_name].first["id"]
        @provider_id = providers[AssayDepot::Provider.ref_name].first["id"]
        @provider_name = providers[AssayDepot::Provider.ref_name].first["name"]
        sleep(1)
        @delete = AssayDepot::WareProvider.delete( id: [@ware_id, @provider_id] )
        @ware_provider_response = AssayDepot::WareProvider.post( id: [@ware_id, @provider_id] )
        # TODO: this should not be needed
        sleep(2)
        @ware_provider = AssayDepot::WareProvider.get( id: @ware_id )
        @provider_ware = AssayDepot::ProviderWare.get( id: @provider_id )
        @clean_up = AssayDepot::WareProvider.delete( id: [@ware_id, @provider_id] )
        @provider_clean_up = AssayDepot::WareProvider.get( id: @ware_id )
        @ware_clean_up = AssayDepot::ProviderWare.get( id: @provider_id )
      end

      it "make sure provider is not published" do
        (@delete["status"] != nil || @delete["message"] != nil).should == true
      end

      it "publish provider with ware" do
        @ware_provider_response["result"].should == "OK"
      end

      it "get posted provider for ware" do
        @ware_provider[AssayDepot::WareProvider.ref_name].select { |el|
          el["name"] == @provider_name
        }.length.should == 1
      end

      it "get posted ware for provider" do
        @provider_ware[AssayDepot::ProviderWare.ref_name].select { |el|
          el["id"] == @ware_id
        }.length.should == 1
      end

      it "delete ware provider association" do
        @clean_up["result"].should == "OK"
      end

      it "verify provider is removed from ware" do
        @provider_clean_up[AssayDepot::WareProvider.ref_name].select { |el|
          el["reference_of_id"] == @ware_id
        }.length.should == 0
      end

      it "verify ware is removed from provider" do
        @ware_clean_up[AssayDepot::ProviderWare.ref_name].select { |el|
          el["name"] == @provider_name
        }.length.should == 0
      end
    end

    context "quoted wares" do
      let(:qw) { AssayDepot::QuotedWare.get() }

      it "deny quoted wares" do
        qw.is_a?(Array).should == false
      end
    end

    context "webhooks" do
      it "create a web hook for this user" do
        response = AssayDepot::Webhook.put(body: {
          name: "This is another new 'name'.",
          bogus_key: "ignore_me"
        })

        response[AssayDepot::Webhook.ref_name]["name"].should == "Applied"
        response[AssayDepot::Webhook.ref_name]["bogus_key"].should == "Ignored"
      end

      it "create a web hook for this user (patch) and verify (get)" do
        response = AssayDepot::Webhook.patch(body: {
          name: "And another new 'name'.",
          bogus_key: "ignore_me"
        })

        response[AssayDepot::Webhook.ref_name]["name"].should == "Applied"
        response[AssayDepot::Webhook.ref_name]["bogus_key"].should == "Ignored"
        playback = AssayDepot::Webhook.get();
        playback["name"].should == "And another new 'name'."
      end

      it "delete a web hook for this user (delete)" do
        response = AssayDepot::Webhook.delete();
        response["status"].should == "ok"
        response = AssayDepot::Webhook.get();
        response["code"].should == "not_found"
      end
    end
  end
end
