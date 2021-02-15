require 'support/pages/home'

module RspecSupportWithUser
  MOCK_NAMESPACE = 'github'
  MOCK_UID_NUMBER = '1235'
  MOCK_UID = "#{MOCK_NAMESPACE}|#{MOCK_UID_NUMBER}"

  def with_auth_mock
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        MOCK_NAMESPACE.to_sym,
        uid: MOCK_UID_NUMBER,
        info: {
          name: 'John McFoo'
        }
      )
    end

    after do
      OmniAuth.config.test_mode = false
    end
  end

  def with_logged_in_user
    with_auth_mock

    before do
      Pages::Home.new.tap do |page|
        page.open
        page.login
      end
    end
  end

end

RSpec.configure { |c| c.extend RspecSupportWithUser }
