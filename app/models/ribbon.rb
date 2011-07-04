class Ribbon < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :points
  default_scope :order => "points"
  belongs_to :collection

  scope :level, :conditions => "level is true"
  scope :regular, :conditions => "level is not true"

  has_attached_file :image,
    :styles => {
    :thumb => "64x64",
    :gallery => "200x200",
    :medium => "300x300"
  },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "#{self.to_s.tableize}/:attachment/:id/ribbons/:style.:extension"

  has_attached_file :large_image,
    :styles => {
    :thumb => "64x64",
    :gallery => "200x200",
    :medium => "300x300"
  },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "#{self.to_s.tableize}/:attachment/:id/ribbons/:style.:extension"

  has_many :comments, :as => :commentable

  def self.last_awarded
    self.last
  end

  def collection_name
    collection.name
  rescue
    nil
  end

  def self.have?(identity)
    self.all.collect(&:identity).include?(identity)
  end

  has_many :users, :dependent => :destroy
  has_many :users, :through => :business_ribbons

  def generate_image
    letters = %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}
    random_letter = letters.shuffle.first
    img = Magick::Image.read("#{RAILS_ROOT}/public/ribbons/layouts/#{rand(2) + 1}.png").first

    # Colorize to change colors of ribbon
    colorized = img.modulate(1,1 + (rand(6) / 10.to_f),1 + (rand(6) / 10.to_f))

    # first add a transaprent image so yuo can place the symbol on top (then resize it to fit demensions)
    symbol_image_canvas = Magick::Image.read("#{RAILS_ROOT}/public/ribbons/transparent.png").first
    symbol_image_canvas.background_color = "none"
    gc = Magick::Draw.new
    gc.align = Magick::CenterAlign
    gc.pointsize = 290
    # set the symbol color to equal the badge's border color!
    gc.fill = colorized.pixel_color(50,50)

    # randomly add white to the symbols!
    gc.fill = 'white' if rand(5) == 3
    gc.font = "/#{RAILS_ROOT}/public/ribbons/dingbats/artefekt.ttf"
    gc.annotate(symbol_image_canvas, 0, 0, 240, 320, random_letter)
    symbol_image_canvas.resize_to_fit!(340,390)

    result = colorized.composite(symbol_image_canvas, Magick::CenterGravity, Magick::OverCompositeOp)

    path_to_image_in_tmp_directory = "#{Rails.root}/tmp/ribbon-#{id}.png"
    result.write(path_to_image_in_tmp_directory)

    self.image = File.open(path_to_image_in_tmp_directory, "r")
    self.save
  end
end