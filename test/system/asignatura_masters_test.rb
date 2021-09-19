require "application_system_test_case"

class AsignaturaMastersTest < ApplicationSystemTestCase
  setup do
    @asignatura_master = asignatura_masters(:one)
  end

  test "visiting the index" do
    visit asignatura_masters_url
    assert_selector "h1", text: "Asignatura Masters"
  end

  test "creating a Asignatura master" do
    visit asignatura_masters_url
    click_on "New Asignatura Master"

    fill_in "Creditos", with: @asignatura_master.creditos
    fill_in "Curso", with: @asignatura_master.curso
    fill_in "Master", with: @asignatura_master.master_id
    fill_in "Nombre", with: @asignatura_master.nombre
    fill_in "Tipo", with: @asignatura_master.tipo
    click_on "Create Asignatura master"

    assert_text "Asignatura master was successfully created"
    click_on "Back"
  end

  test "updating a Asignatura master" do
    visit asignatura_masters_url
    click_on "Edit", match: :first

    fill_in "Creditos", with: @asignatura_master.creditos
    fill_in "Curso", with: @asignatura_master.curso
    fill_in "Master", with: @asignatura_master.master_id
    fill_in "Nombre", with: @asignatura_master.nombre
    fill_in "Tipo", with: @asignatura_master.tipo
    click_on "Update Asignatura master"

    assert_text "Asignatura master was successfully updated"
    click_on "Back"
  end

  test "destroying a Asignatura master" do
    visit asignatura_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Asignatura master was successfully destroyed"
  end
end
