require 'test_helper'

class CreateCitiesControllerTest < ActionController::TestCase
  setup do
    @create_city = create_cities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:create_cities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create create_city" do
    assert_difference('CreateCity.count') do
      post :create, create_city: { gmaps: @create_city.gmaps, latitude: @create_city.latitude, longitude: @create_city.longitude, name: @create_city.name, population: @create_city.population, state: @create_city.state }
    end

    assert_redirected_to create_city_path(assigns(:create_city))
  end

  test "should show create_city" do
    get :show, id: @create_city
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @create_city
    assert_response :success
  end

  test "should update create_city" do
    put :update, id: @create_city, create_city: { gmaps: @create_city.gmaps, latitude: @create_city.latitude, longitude: @create_city.longitude, name: @create_city.name, population: @create_city.population, state: @create_city.state }
    assert_redirected_to create_city_path(assigns(:create_city))
  end

  test "should destroy create_city" do
    assert_difference('CreateCity.count', -1) do
      delete :destroy, id: @create_city
    end

    assert_redirected_to create_cities_path
  end
end
