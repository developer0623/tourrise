# frozen_string_literal: true

class FrontofficeSettingDecorator
  def self.full_address
    "#{FrontofficeSetting.company_name} #{FrontofficeSetting.address_line_1} #{FrontofficeSetting.zip_code} #{FrontofficeSetting.city}"
  end
end
