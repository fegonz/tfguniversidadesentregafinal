require "test_helper"

class GradosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grado = grados(:one)
  end

  test "should get index" do
    get grados_url
    assert_response :success
  end

  test "should get new" do
    get new_grado_url
    assert_response :success
  end

  test "should create grado" do
    assert_difference('Grado.count') do
      post grados_url, params: { grado: { nombre: @grado.nombre, universidad_id: @grado.universidad_id, url: @grado.url } }
    end

    assert_redirected_to grado_url(Grado.last)
  end

  test "should show grado" do
    get grado_url(@grado)
    assert_response :success
  end

  test "should get edit" do
    get edit_grado_url(@grado)
    assert_response :success
  end

  test "should update grado" do
    patch grado_url(@grado), params: { grado: { nombre: @grado.nombre, universidad_id: @grado.universidad_id, url: @grado.url } }
    assert_redirected_to grado_url(@grado)
  end

  test "should destroy grado" do
    assert_difference('Grado.count', -1) do
      delete grado_url(@grado)
    end

    assert_redirected_to grados_url
  end
end
