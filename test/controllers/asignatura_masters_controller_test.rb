require "test_helper"

class AsignaturaMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asignatura_master = asignatura_masters(:one)
  end

  test "should get index" do
    get asignatura_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_asignatura_master_url
    assert_response :success
  end

  test "should create asignatura_master" do
    assert_difference('AsignaturaMaster.count') do
      post asignatura_masters_url, params: { asignatura_master: { creditos: @asignatura_master.creditos, curso: @asignatura_master.curso, master_id: @asignatura_master.master_id, nombre: @asignatura_master.nombre, tipo: @asignatura_master.tipo } }
    end

    assert_redirected_to asignatura_master_url(AsignaturaMaster.last)
  end

  test "should show asignatura_master" do
    get asignatura_master_url(@asignatura_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_asignatura_master_url(@asignatura_master)
    assert_response :success
  end

  test "should update asignatura_master" do
    patch asignatura_master_url(@asignatura_master), params: { asignatura_master: { creditos: @asignatura_master.creditos, curso: @asignatura_master.curso, master_id: @asignatura_master.master_id, nombre: @asignatura_master.nombre, tipo: @asignatura_master.tipo } }
    assert_redirected_to asignatura_master_url(@asignatura_master)
  end

  test "should destroy asignatura_master" do
    assert_difference('AsignaturaMaster.count', -1) do
      delete asignatura_master_url(@asignatura_master)
    end

    assert_redirected_to asignatura_masters_url
  end
end
