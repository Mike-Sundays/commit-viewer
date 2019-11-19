require 'fileutils'

class DirectoryUtils
  def self.create_temporary_directory
    Dir.mktmpdir
  end

  def self.change_directory(path)
    Dir.chdir(path)
  end

  def self.remove_directory(path)
    FileUtils.remove_entry path
  end

  def self.directory_exists?(dir)
    File.directory?(dir)
  end
end