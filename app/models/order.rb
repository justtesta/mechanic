class Order < ApplicationRecord
  include Order::State
  include WeixinMediaLoader

  PendingTimeout = 10.minutes
  PayingTimeout = 60.minutes
  ConfirmingTimeout = 2.days
  FinishedTimeout = 7.days

  belongs_to :user
  belongs_to :mechanic
  belongs_to :selectmechanic, class_name: "Mechanic", foreign_key: "selectmechanic_id"                         
  belongs_to :merchant
  has_one :mechanic_user, through: :mechanic, source: :user
  has_one :store, through: :merchant
  #belongs_to :repick_merchant, class_name: "Merchant", foreign_key: "repick_by" 

  belongs_to :bid
  has_many :bids
  has_many :numbers
  has_many :partchecks

  as_enum :skill, Skill, persistence: true
  as_enum :brand, Brand, persistence: true
  as_enum :series, Series, persistence: true

  as_enum :province, Province, persistence: true
  as_enum :city, City, persistence: true

  scope :assigneds, -> { paids.where.not(mechanic_id: nil) }
  scope :unassigneds, -> { paids.where(mechanic_id: nil) }

  scope :hostings, -> { where(hosting: true) }
  scope :unfinisheds, -> { where("state_cd=6 or state_cd=7 or state_cd=8 ") }
  scope :paids_and_workings, -> { where("state_cd=6 or state_cd=7") }
  scope :emergencys, -> { where(emergency: true) }
  scope :finished_all_nochecks, -> { where("id in(select order_id From numbers where status=0) and id not in(select order_id From numbers where status=1)  and state_cd>8 and orders.created_at>'2017-09-13'") }
  scope :finished_part_nochecks, -> { where("id in(select order_id From numbers where status=0) and id in(select order_id From numbers where status=1)  and state_cd>8 and orders.created_at>'2017-09-13'") }
  scope :unfinished_all_checks, -> { where("id in(select order_id From numbers where status=1) and id not in(select order_id From numbers where status=0) and state_cd<8 and orders.created_at>'2017-09-13'") }
  scope :unfinished_part_checks, -> { where("id in(select order_id From numbers where status=1) and id in(select order_id From numbers where status=0) and state_cd<8 and orders.created_at>'2017-09-13'") }
  
  def offline?
    price.zero? || (offline && ["1", 1, true].include?(offline)) || false
  end

  def assigned?
    !!mechanic_id
  end
  def selected?
    (selectmechanic_id!=0)&&!!selectmechanic_id
  end

  def unassigned?
    !mechanic_id
  end

  def mobile?
    !merchant_id
  end

  def merchant?
    !!merchant_id
  end

  def hosting?
    hosting && ["1", 1, true].include?(hosting)
  end

  def appointing?
    appointing && ["1", 1, true].include?(appointing)
  end

  def emergency?
    emergency && ["1", 1, true].include?(emergency)
  end

  def automatic?
    automatic && ["1", 1, true].include?(automatic)
  end

  def automatic_confirm?
    automatic_confirm && ["1", 1, true].include?(automatic_confirm)
  end

  def sendpay?
     ordersign[110]=="1"||ordersign[110]=="3" if ordersign && ordersign.length>120
  end 

  def partcheck_order?
    partcheck_order && ["1", 1, true].include?(partcheck_order)
  end

  has_attached_file :mechanic_attach_1, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  has_attached_file :mechanic_attach_2, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :mechanic_attach_1, :content_type => /\Aimage\/.*\Z/
  has_attached_file :user_attach_1, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :user_attach_1, :content_type => /\Aimage\/.*\z/
  has_attached_file :user_attach_2, styles: { medium: "300x300>", thumb: "100x100#" }
  validates_attachment_content_type :user_attach_1, :content_type => /\Aimage\/.*\z/

  def has_attach?
    done? && (mechanic_attach_1.present? || mechanic_attach_2.present?)
  end

  weixin_media_loaders :mechanic_attach_1, :mechanic_attach_2, :user_attach_1, :user_attach_2

  validates_numericality_of :quoted_price, greater_than_or_equal_to: 0
  validates_numericality_of :quoted_price, greater_than_or_equal_to: 1, if: :mobile?
  validates_presence_of :skill_cd, :brand_cd, :series_cd, :quoted_price
  validates_presence_of :contact_mobile, if: :merchant?
  validates_format_of :contact_mobile, with: /\A\d{11}\z/, if: :merchant?
  validate :validate_location, on: :create
  def validate_location
    return if custom_location_present?

    if lbs_id.present?
      location = LBS.find(lbs_id)

      case location
      when District
        city = location.parent
      when City
        city = location
      when Province
        raise ArgumentError
      end

      province = city.parent

      self.province_cd = province.id
      self.city_cd = city.id
    else
      result = LBS.geocoder(address)
      raise result["message"] unless result["status"] == 0

      self.lng = result["result"]["location"]["lng"]
      self.lat = result["result"]["location"]["lat"]

      province_name = result["result"]["address_components"]["province"]
      city_name = result["result"]["address_components"]["city"]

      province = Province.where(fullname: province_name).first!
      city = province.cities.where(fullname: city_name).first!

      self.lbs_id = city.lbs_id
      self.province_cd = province.id
      self.city_cd = city.id
    end
  rescue
    errors.add(:address, "无法定位，请打开GPS定位或输入自定义技师用人信息发送范围")
  end

  validate :validate_procedure_price, on: :update
  def validate_procedure_price
    if procedure_price > quoted_price
      errors.add(:procedure_price, "应低于订单标价")
    end
  end


  cache_method :user, :available_orders_count
  cache_method :mechanic, :available_orders_count
  cache_method :mechanic, :revoke_orders_count
  cache_method :mechanic, :professionality_average
  cache_method :mechanic, :timeliness_average
  cache_method :mechanic, :last_available_orders_count
  cache_method :mechanic, :last_done_orders_count
  cache_method :mechanic, :done_orders_count_rate

  # cache_column :user, :nickname
  # cache_column :user, :mobile
  delegate :nickname, :mobile, to: :user, prefix: true

  # cache_column :mechanic_user, :nickname, cache_column: :mechanic_nickname
  # cache_column :mechanic_user, :mobile, cache_column: :mechanic_mobile
  delegate :nickname, :mobile, to: :mechanic_user, prefix: :mechanic, allow_nil: true
  # cache_column :merchant, :nickname
  # cache_column :merchant, :mobile
  delegate :nickname, :mobile, to: :merchant, prefix: true, allow_nil: true
  # cache_column :store, :nickname
  # cache_column :store, :hotline
  delegate :nickname, :hotline, to: :store, prefix: true, allow_nil: true

  attr_accessor :custom_location
  def custom_location_present?
    ["1", 1, true].include?(custom_location) && province_cd.present? && city_cd.present?
  end

  after_initialize do
    if persisted?
      if pending? && Time.now - created_at >= PendingTimeout
        if mechanic_sent_count > 0
          cancel! :pending_timeout
        else
          cancel! :user_abstain
        end
      elsif paying? && Time.now - updated_at >= PayingTimeout
        cancel! :paying_timeout
      elsif confirming? && Time.now - updated_at > ConfirmingTimeout
        confirm!
      elsif finished? && Time.now - updated_at > FinishedTimeout
        review!
      end
    else
      self.appointing = true if self.assigned?
    end
  end

  after_create do
    unless appointing?
      if hosting?
        pick!
      else
        pending!
      end
    end
  end

  before_validation :ensure_contact_mobile_format
  def ensure_contact_mobile_format
    self.contact_mobile.strip! if contact_mobile
  end

  def contact
    contact_nickname.presence
  end

  def settings
    FallbackScopedSettings.for_things self, self.store
  end

  # ###########################
  # price 用户支付金额
  # quoted_price 用户报价
  # markup_price 技师加价
  # commission 堂主分成
  # procedure_price 汽车堂分成
  # mechanic_income 技师实际收入
  # pre_procedure_price 预设手续费
  # profit 利润
  def price
    quoted_price + markup_price
  end

  def commission
    @commission ||= ((quoted_price - procedure_price) * (mobile? ? settings.mobile_commission_percent.to_f :
      settings.commission_percent.to_f) / 100).round(2)
  end

  def mechanic_income
    price - commission - procedure_price
  end
  
  def pre_procedure_price
    if(!procedure_price.nil?)
      if(procedure_price!=0)
      return procedure_price
      end
    end
    _quantity=1
    if(!quantity.nil?)
    _quantity=quantity
    end
    if (selectmechanic.works.find_by(skill_id:skill_cd).nil?)
      0
    else
      if(selectmechanic.works.find_by(skill_id:skill_cd).price.nil?)
      0
      else
      price - selectmechanic.works.find_by(skill_id:skill_cd).price * _quantity 
      end 
    end
  end

  def client_commission
    (commission * settings.client_commission_percent.to_f / 100).round(2)
  end

  def mechanic_commission
    (commission * settings.mechanic_commission_percent.to_f / 100).round(2)
  end

  def profit
    if self.partcheck_order?
      0 
    else
      if self.procedure_price.nil?
        0
      else
        procedure_price
      end
    end
  end
  
  def pre_remark
    "完工微信联系【17319724003】或【17734794849】结算工时费；施工完让车主给门店好评；要京东消费码或者验证码。"
  end 

  def title
    "汽车堂#{skill}订单"
  end

  def contact_display_mobile
    contact_mobile || user.mobile
  end

  def contact_display_name
    [contact_nickname.presence, contact_mobile.presence].compact.join(" ")
  end

  def update_timestamp column, update, force
    if force || (!send(column) && update)
      update_attribute(column, Time.now)
    end
  end

  def out_trade_no force = false
    update_timestamp :paid_at, true, force
    "#{paid_at.strftime("%Y%m%d")}#{"%06d" % id}"
  end

  def out_refund_no force = false
    update_timestamp :refunded_at, true, force
    "#{refunded_at.strftime("%Y%m%d")}#{"%06d" % id}"
  end

  def out_numbers
    self.numbers.map {|n| n.out_left_number }.join("、")
  end

  def out_repick_by_merchant_name
    if self.automatic? 
      "自动派单"
    else
      self.repick_by_merchant_name
    end
  end

  def out_confirm_by_merchant_name
    if self.automatic_confirm?
      "自动确认"
    else
      self.confirm_by_merchant_name
    end
  end

end
