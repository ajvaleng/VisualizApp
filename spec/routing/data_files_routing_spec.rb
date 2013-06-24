require "spec_helper"

describe DataFilesController do
  describe "routing" do

    it "routes to #index" do
      get("/data_files").should route_to("data_files#index")
    end

    it "routes to #new" do
      get("/data_files/new").should route_to("data_files#new")
    end

    it "routes to #show" do
      get("/data_files/1").should route_to("data_files#show", :id => "1")
    end

    it "routes to #edit" do
      get("/data_files/1/edit").should route_to("data_files#edit", :id => "1")
    end

    it "routes to #create" do
      post("/data_files").should route_to("data_files#create")
    end

    it "routes to #update" do
      put("/data_files/1").should route_to("data_files#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/data_files/1").should route_to("data_files#destroy", :id => "1")
    end

  end
end
