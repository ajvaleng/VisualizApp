require "spec_helper"

describe RecorridosController do
  describe "routing" do

    it "routes to #index" do
      get("/recorridos").should route_to("recorridos#index")
    end

    it "routes to #new" do
      get("/recorridos/new").should route_to("recorridos#new")
    end

    it "routes to #show" do
      get("/recorridos/1").should route_to("recorridos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/recorridos/1/edit").should route_to("recorridos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/recorridos").should route_to("recorridos#create")
    end

    it "routes to #update" do
      put("/recorridos/1").should route_to("recorridos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/recorridos/1").should route_to("recorridos#destroy", :id => "1")
    end

  end
end
