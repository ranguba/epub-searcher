class MainControllerTest < Test::Unit::TestCase
  def test_get_index
    get '/'

    assert last_response.ok?
  end

  def test_get_index_form
    visit '/'

    assert page.has_selector?('form input[type="search"]')
  end

  def test_get_index_query
    omit_on_travis

    get '/?q=test'

    assert last_response.ok?
  end

  def test_get_index_query_form
    omit_on_travis

    visit "/?q=%3C"

    assert_equal '<', find('form input[type="search"]').value
  end
end
