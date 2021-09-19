require "application_system_test_case"

class GradosTest < ApplicationSystemTestCase
  setup do
    @grado = grados(:one)
  end

  test "visiting the index" do
    visit grados_url
    assert_selector "h1", text: "Grados"
  end

  test "creating a Grado" do
    visit grados_url
    click_on "New Grado"

    fill_in "Nombre", with: @grado.nombre
    fill_in "Universidad", with: @grado.universidad_id
    fill_in "Url", with: @grado.url
    click_on "Create Grado"

    assert_text "Grado was successfully created"
    click_on "Back"
  end

  test "updating a Grado" do
    visit grados_url
    click_on "Edit", match: :first

    fill_in "Nombre", with: @grado.nombre
    fill_in "Universidad", with: @grado.universidad_id
    fill_in "Url", with: @grado.url
    click_on "Update Grado"

    assert_text "Grado was successfully updated"
    click_on "Back"
  end

  test "destroying a Grado" do
    visit grados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Grado was successfully destroyed"
  end
end
