class CreateComfyGallery < ActiveRecord::Migration
  def self.up 
    create_table :gallery_galleries do |t|
      t.string  :title,               :null => false
      t.string  :identifier,          :null => false
      t.text    :description
      t.integer :full_width,          :null => false, :default => 640
      t.integer :full_height,         :null => false, :default => 480
      t.boolean :force_ratio_full,    :null => false, :default => false
      t.integer :thumb_width,         :null => false, :default => 150
      t.integer :thumb_height,        :null => false, :default => 150
      t.boolean :force_ratio_thumb,   :null => false, :default => true
      t.timestamps
    end
    add_index :gallery_galleries, :identifier, :uniq => true
    
    create_table :gallery_photos do |t|
      t.integer :gallery_id, :null => false
      t.string  :title
      t.text    :description
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.integer :position, :null => false, :default => 0
      t.timestamps
    end
    add_index :gallery_photos, [ :gallery_id, :position ]
  end
  
  def self.down
    drop_table :gallery_photos
    drop_table :gallery_galleries
  end
end