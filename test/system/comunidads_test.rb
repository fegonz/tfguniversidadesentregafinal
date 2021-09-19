require "application_system_test_case"

class ComunidadsTest < ApplicationSystemTestCase
  setup do
    @comunidad = comunidads(:one)
  end

  test "visiting the index" do
    visit comunidads_url
    assert_selector "h1", text: "Comunidads"
  end

  test "creating a Comunidad" do
    visit comunidads_url
    click_on "New Comunidad"

    fill_in "Nombre", with: @comunidad.nombre
    click_on "Create Comunidad"

    assert_text "Comunidad was successfully created"
    click_on "Back"
  end

  test "updating a Comunidad" do
    visit comunidads_url
    click_on "Edit", match: :first

    fill_in "Nombre", with: @comunidad.nombre
    click_on "Update Comunidad"

    assert_text "Comunidad was successfully updated"
    click_on "Back"
  end

  test "destroying a Comunidad" do
    visit comunidads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Comunidad was successfully destroyed"
  end
end
