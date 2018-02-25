module LBS
  Config = YAML.load(ERB.new(File.read("#{Rails.root}/config/lbs.yml")).result)[Rails.env]
  Key = "3GXBZ-IZYRO-YNJWO-SIBU2-4XZFJ-3XBR2"

  class << self
    def district_list
      JSON.parse RestClient.get("http://apis.map.qq.com/ws/district/v1/list", params: { key: Key })
    end

    def geocoder address
      JSON.parse RestClient.get("http://apis.map.qq.com/ws/geocoder/v1", params: { address: address, key: Key })
    end

    def find lbs_id
      location = District.where(lbs_id: lbs_id).first ||
        City.where(lbs_id: lbs_id).first ||
        Province.where(lbs_id: lbs_id).first
      raise ActiveRecord::RecordNotFound, "Couldn't find Location with 'id'=#{lbs_id}" unless location
      location
    end
  end
end
