require 'fileutils'

class DirectoryUtils
  def self.temporary_directory_for_project(project)
    tmp_dir = Dir.mktmpdir
    File.join(tmp_dir, project)
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

  def self.cleanup_temp_dir(dir)
    2.times { change_directory("..") }
    remove_directory(dir)
  end
end