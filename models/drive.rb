class Drive
  include DataMapper::Resource

  property :id,                 Serial
  property :bn,                 String
  property :mn,                 String

  has 1, :drivemodel
end

class DriveModel
  include DataMapper::Resource

  property :id,         Serial
  property :mn,         String
  property :brand,      Enum[:dell, :fujitsu, :seagate, :hitachi, :wd], :default => :seagate
  property :size,       Integer
  property :speed,      Integer
  property :interface,  Enum[:scsi_u3, :scsi_u320, :scsi_u160, :pata, :sata, :other], :default => :scsi_Ultra3

  belongs_to :Drive

end
