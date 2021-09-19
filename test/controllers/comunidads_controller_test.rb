require "test_helper"

class ComunidadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comunidad = comunidads(:one)
  end

  test "should get index" do
    get comunidads_url
    assert_response :success
  end

  test "should get new" do
    get new_comunidad_url
    assert_response :success
  end

  test "should create comunidad" do
    assert_difference('Comunidad.count') do
      post comunidads_url, params: { comunidad: { nombre: @comunidad.nombre } }
    end

    assert_redirected_to comunidad_url(Comunidad.last)
  end

  test "should show comunidad" do
    get comunidad_url(@comunidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_comunidad_url(@comunidad)
    assert_response :success
  end

  test "should update comunidad" do
    patch comunidad_url(@comunidad), params: { comunidad: { nombre: @comunidad.nombre } }
    assert_redirected_to comunidad_url(@comunidad)
  end

  test "should destroy comunidad" do
    assert_difference('Comunidad.count', -1) do
      delete comunidad_url(@comunidad)
    end

    assert_redirected_to comunidads_url
  end
end
