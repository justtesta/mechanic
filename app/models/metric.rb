class Metric < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  serialize :data, Hash

  def self.audit user, source, method, data
    create(user_id: user.id, source: source, method: method, data: data)
  end

  def data_reason
  	data[:reason]
  end 

  def data_amount
  	data[:amount]
  end 

end
