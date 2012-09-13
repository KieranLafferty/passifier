require 'helper'

class TestPass < Test::Unit::TestCase

  include Passifier

  def test_to_image_files
    pass = Helper.new_pass

    assert_not_nil pass
    assert_not_empty pass.image_files
    assert pass.image_files.all? { |file| [StaticFile, UrlSource].include?(file.class) }
    assert_equal Helper.new_images.size, pass.image_files.size
  end

  def test_files_for_archive
    pass = Helper.new_pass

    assert_not_nil pass
    assert_not_empty pass.files_for_archive
    assert_equal 11, pass.files_for_archive.size
  end

  def test_create_archive_class_method
    archive = Helper.create_archive_through_pass

    assert File.exists?(Helper.zip_path)
    assert File.size(Helper.zip_path) > 0

    archive.destroy
  end

  def test_create_archive
    pass = Helper.new_pass
    archive = pass.create_archive(Helper.zip_path, :scratch_directory => Helper.scratch_directory)

    assert File.exists?(Helper.zip_path)
    assert File.size(Helper.zip_path) > 0

    archive.destroy
  end

end


