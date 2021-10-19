class NewCar < ApplicationRecord
  belongs_to :brand
  has_many :specifications
  has_one :blog
  has_many :reviews
  has_many :equipment_descriptions
  has_many :equipments, :through => :equipment_descriptions
  has_many :taxis
  
  mount_uploaders :colors, NewcarColorUploader
  mount_uploaders :images, NewcarImagesUploader
  mount_uploaders :images_interior, NewcarImagesUploader
  mount_uploaders :images_available, NewcarImagesUploader
  mount_uploaders :images360, Newcar360Uploader

  before_save :generate_url

  def to_param
    url
  end


  def generate_url
    unless self.url
      self.url = self.name.parameterize
      if self.old
        self.url = self.url + '-old'
      end
    end
  end

  def discount_count(e = self.equipments.where('equipment.hide = FALSE').order(price: :asc).first)
    #self.discount.to_i + self.discount_tradein_3.to_i + self.discount_credit_3.to_i + 50000 + 30000 +(e.price * 0.1).to_i
    self.discount_3.to_i + self.discount_tradein_3.to_i + self.discount_credit_3.to_i + 40000
  end

  def count_price(e = self.equipments.where('`equipment`.`hide` = ?', 0).minimum(:price),reg_discount = 0)
    price = e
    #discount = self.discount.to_i + self.discount_tradein_3.to_i + self.discount_credit_3.to_i + 50000 + 30000 + (e * 0.1).to_i
    discount = self.discount_3.to_i + self.discount_tradein_3.to_i + self.discount_credit_3.to_i + 40000
    if (discount + reg_discount) < price * 4/10
      min_discount_e = discount + reg_discount
    else
      min_discount_e = price*4/10
    end
    price - min_discount_e
  end


  #def count_min_price(reg_discount = 0)
  #  min_price = self.equipments.where('`equipment`.`hide` = ?', 0).minimum(:price)

  #  if (self.discount_count + reg_discount) < min_price * 4/10
  #    min_discount_e = self.discount_count + reg_discount
  # else
  #   min_discount_e = min_price*4/10
  # end
  # min_price - min_discount_e
  #end


  def count_min_price(reg_discount = 0)
    min_price = self.equipments.where('`equipment`.`hide` = ?', false).minimum(:price)

    min_price - discount_count
  end

  def count_min_price_no_sale(reg_discount = 0)
    min_price = self.equipments.where('`equipment`.`hide` = ?', false).minimum(:price)
  end

  def min_price_trans(transmission)
    trans = "LIKE '%еханическая%'"
    if transmission != 'MT'
      trans = "NOT LIKE '%еханическая%'"
    end

    NewCar.joins(:specifications)
        .joins('INNER JOIN equipment on specifications.id = equipment.specification_id')
        .where("specifications.transmission " + trans)
        .where(id: self.id)
        .where("equipment.hide = 0")
        .minimum('equipment.price')
  end

  scope :min_price_ordered, -> { joins(:equipments).group("new_cars.id").order('min(equipment.price)') }

#   SELECT min(equipment.price) as min_price,`new_cars`.* FROM `new_cars`
#   INNER JOIN `equipment_descriptions` ON `equipment_descriptions`.`new_car_id` = `new_cars`.`id`
# INNER JOIN `equipment` ON `equipment`.`equipment_description_id` = `equipment_descriptions`.`id`
# WHERE `new_cars`.`hide` = 0 AND `new_cars`.`id` != 291 AND equipment.price != 1 AND equipment.price < (900000 + `new_cars`.`discount_3` + `new_cars`.`discount_credit_3` + `new_cars`.`discount_tradein_3` )
# GROUP BY new_cars.id
# ORDER BY min_price DESC
# LIMIT 25

  #car_id

  scope :having_price_range, -> (range_lower,range_upper) do
    having('min_price BETWEEN ' + range_lower.to_s + ' AND ' + range_upper.to_s) if (range_upper.present?) && (range_lower.present?)
  end

  scope :price_range, -> (range_lower,range_upper) do
    select('(min(equipment.price) - `new_cars`.`discount_3` - `new_cars`.`discount_credit_3` - `new_cars`.`discount_tradein_3` - 30000) as min_price,`new_cars`.*')
        .joins(:equipments).where('new_cars.hide = ?', 0).where('equipment.hide = ?', 0)
    .group('new_cars.id')
    .having('(min_price) BETWEEN (' + range_lower.to_s + ') AND (' + range_upper.to_s + ')')
    .order('min_price DESC') if (range_upper.present?)&&(range_lower.present?)
  end

  scope :engine_type, -> (type) { joins(:specifications).where('specifications.enginetype = ?', type) if (type.present?) }
  scope :transmission, -> (transmission) { joins(:specifications).where("specifications.shorttransmission LIKE ?", "%#{transmission}%") if (transmission.present?) }
  scope :car_type, -> (type) { where(car_type: type) if (type.present?) }

end