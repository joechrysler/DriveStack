class Drive
  include DataMapper::Resource

  property :bn,   String, :key => true

  has 1, :drive_model
end

class DriveModel
  include DataMapper::Resource

  property :model_number,   String, :key => true
  property :brand,          Enum[:dell, :fujitsu, :seagate, :hitachi, :wd], :default => :seagate
  property :size,           Integer
  property :speed,          Integer
  property :interface,      Enum[:scsi_u3, :scsi_u320, :scsi_u160, :pata, :sata, :other], :default => :scsi_Ultra3

  belongs_to :drive

end
