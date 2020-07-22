require 'assaydepot'

describe AssayDepot do
  context "when accessing the api via oauth2 client credentials" do
    before(:all) do
      site = "http://dev.scientist.com:3000"
      AssayDepot.configure do |config|
        config.access_token = AssayDepot::TokenAuth.get_token("QnUOe2yvmQACtvxtC_ksGBVCEV-ZQw", "2BoA_dxC0BCM0YsRxWyLK4Acknv4mEM2oJ9aiC1GNRvPlWTiVdN6IWOe", site)
        config.url = "#{site}/api/v2"
      end
    end

    context "and searching for wares matching \"antibody\"" do
      let(:wares) { AssayDepot::Ware.find("antibody") }

      it "should return a Ware object" do
        wares.class.should == AssayDepot::Ware
      end

      it "should return some wares" do
        wares.total.should > 1
      end

      context "and getting the details for the first ware" do
        let(:ware_result) { AssayDepot::Ware.get(wares.first["id"]) }

        it "should have a ware" do
          ware_result["ware"].should_not be_nil
        end

        it "should have a description" do
          ware_result["ware"]["description"].should_not be_nil
        end
      end
    end

    context "when searching for wares of type CustomService" do
      let(:wares) { AssayDepot::Ware.where(:ware_type => "CustomService") }

      it "should return facets" do
        wares.facets.should_not be_empty
      end

      it "should include the source facet" do
        wares.facets.should include("source")
      end

      it "should include the ware_type facet" do
        wares.facets.should include("ware_type")
      end

      # RR: replaced "available_provider_names"
      it "should include the technology facet" do
        wares.facets.should include("technology")
      end

      it "should include the certifications facet" do
        wares.facets.should include("certifications")
      end

      it "should include the countries facet" do
        wares.facets.should include("countries")
      end

      it "should include the protein_type facet" do
        wares.facets.should include("protein_type")
      end

      it "should include the clonality facet" do
        wares.facets.should include("clonality")
      end

      it "should include the cell_source facet" do
        wares.facets.should include("cell_source")
      end

      it "should include the species facet" do
        wares.facets.should include("species")
      end

      it "should include the tissue facet" do
        wares.facets.should include("tissue")
      end
    end

    context "when searching for wares using a chained query" do
      let(:wares) { AssayDepot::Ware.where(:ware_type => "CustomService").where(:source => "central") }

      it "should return wares" do
        wares.total.should > 0
      end

      it "the ware's name should be available" do
        wares.first["name"].should_not be_nil
      end
    end

    context "and searching for providers that start with the letter a" do
      let(:providers) { AssayDepot::Provider.where(:starts_with => "a").per_page(50) }

      it "should return a Provider object" do
        providers.class.should == AssayDepot::Provider
      end

      it "should return some providers" do
        providers.total.should > 1
      end

      context "and getting the details for the first provider" do
        let(:provider_result) { AssayDepot::Provider.get(providers.first["id"]) }

        it "should have a provider" do
          provider_result["provider"].should_not be_nil
        end

        it "should have a description" do
          provider_result["provider"]["description"].should_not be_nil
        end
      end
    end
  end
end
