class Mechanic < ApplicationRecord
  include WeixinMediaLoader
  belongs_to :user

  has_many :orders

  has_many :fellowships
  has_many :followed_users, through: :fellowships, source: :user

  has_one :user_group, through: :user

  as_enum :province, Province, persistence: true
  as_enum :city, City, persistence: true
  as_enum :district, District, persistence: true

  has_many :works ,:dependent => :destroy
  has_many :skills, through: :works
  
  has_and_belongs_to_many :services
  alias_attribute :service_cds, :service_ids
  as_enum :services, Service, persistence: true, accessor: :multiple
  #has_and_belongs_to_many :skills
  alias_attribute :skill_cds, :skill_ids
  as_enum :skills, Skill, persistence: true, accessor: :multiple
  as_enum :grade, one_star: 1, two_star: 2, three_star: 3, four_star: 4, five_star: 5

  # cache_column :user, :nickname
  # cache_column :user, :mobile
  # cache_column :user, :address
  # cache_column :user, :weixin_openid
  delegate :nickname, :mobile, :address, :weixin_openid, to: :user, prefix: true, allow_nil: true

  scope :shown, -> { includes(:user).where.not(users: { hidden: true }) }

  attr_accessor :_check, :_create

  def increase_total_income! amount
    increment!(:total_income, amount)
  end

  def skilled_orders skill_cd
    orders.availables.where(skill_cd: skill_cd)
  end

  def skilled_dones_orders skill_cd
    orders.dones.where(skill_cd: skill_cd)
  end
  
  def raw_professionality_average
    (orders.average(:professionality) || 4).round(2)
  end

  def raw_timeliness_average
    (orders.average(:timeliness) || 4).round(2)
  end

  def raw_available_orders_count
    orders.availables.count || 0
  end

  def raw_revoke_orders_count
    orders.merchant_revokes.count || 0
  end

  def raw_last_available_orders_count
    orders.last_availables.count || 0
  end

  def raw_last_done_orders_count
    orders.last_dones.count || 0
  end

  def raw_done_orders_count_rate
    if raw_available_orders_count>0
      (orders.dones.count*100.quo(raw_available_orders_count)).to_f.round(2)
    else
      100.round(2)
    end
  end


  def regular_client? user
    user = user.id if user.is_a? User
    orders.where(user_id: user).exists?
  end

  def self_withdrawal?
    orders.where(confirm_type_cd: Order.confirm_types[:confirm_no_withdrawal]).exists?
  end

  def location_name
    name = []
    name << province if province
    name << city if city && province != city
    name << district if district
    name.join(" ")
  end
  
  def get_work_by_skill_id(did)
    work = works.find_by_skill_id(did)
    work.nil?? nil : work
  end

  has_attached_file :mechanic_attach_1, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  has_attached_file :mechanic_attach_2, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  has_attached_file :mechanic_attach_3, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  has_attached_file :mechanic_attach_4, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  has_attached_file :mechanic_attach_5, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  def has_attach?
    mechanic_attach_1.present? || mechanic_attach_2.present? || mechanic_attach_3.present? || mechanic_attach_4.present? || mechanic_attach_5.present?
  end
  weixin_media_loaders :mechanic_attach_1, :mechanic_attach_2, :mechanic_attach_3, :mechanic_attach_4, :mechanic_attach_5

end
