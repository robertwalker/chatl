require 'spec_helper'

describe DataFile do
  it "should create a new instance given valid attributes" do
    data_file = Factory.build(:data_file)
    data_file.should be_valid
    data_file.should have(:no).errors
  end

  it "should require 'comment'" do
    data_file = Factory.build(:data_file, :comment => nil)
    data_file.should_not be_valid
    data_file.errors.should_not be_empty
  end

  it "should require 'name'" do
    data_file = Factory.build(:data_file, :name => nil)
    data_file.should_not be_valid
    data_file.errors.should_not be_empty
  end

  it "should require 'content_type'" do
    data_file = Factory.build(:data_file, :content_type => nil)
    data_file.should_not be_valid
    data_file.errors.should_not be_empty
  end

  describe "uploading a file" do
    before :each do
      @docs_dir = "#{Rails.root}/public/system/documents"
      @data_file = Factory.build(:data_file, :name => nil)
    end

    it "should sanitize original filename" do
      uploaded_file = mock(ActionController::UploadedStringIO).as_null_object
      uploaded_file.stub!(:original_filename).and_return('@test!.txt')
      uploaded_file.stub!(:read).and_return("Some content")
      @data_file.uploaded_file = uploaded_file 
      @data_file.name.should == "_test_.txt"
    end

    it "should set an appropriate content type" do
      uploaded_file = mock(ActionController::UploadedStringIO).as_null_object
      uploaded_file.stub!(:original_filename).and_return('test.txt')
      uploaded_file.stub!(:content_type).and_return('text/plain')
      uploaded_file.stub!(:read).and_return("Some content")
      @data_file.uploaded_file = uploaded_file 
      @data_file.content_type.should == "text/plain"
    end

    it "should save uploaded file using original filename" do
      uploaded_file = mock(ActionController::UploadedStringIO).as_null_object
      uploaded_file.stub!(:original_filename).and_return('test.txt')
      uploaded_file.stub!(:read).and_return("Some content")
      @data_file.uploaded_file = uploaded_file 
      @data_file.name.should == "test.txt"
      File.exist?("#{@docs_dir}/#{@data_file.name}").should == true
    end

    after :each do
      test_files = [ "#{@docs_dir}/test.txt", "#{@docs_dir}/_test_.txt" ]
      test_files.each { |f| File.delete(f) if File.exist?(f) }
    end
  end

  describe "destroying an uploaded file" do
    before :each do
      @docs_dir = "#{Rails.root}/public/system/documents"
      @data_file = Factory.build(:data_file, :name => "test.txt")
    end

    it "should delete the file on disk before destroying record" do
      uploaded_file = mock(ActionController::UploadedStringIO).as_null_object
      uploaded_file.stub!(:original_filename).and_return('test.txt')
      uploaded_file.stub!(:read).and_return("Some content")
      @data_file.uploaded_file = uploaded_file 
      @data_file.name.should == "test.txt"
      File.exist?("#{@docs_dir}/#{@data_file.name}").should == true
      @data_file.destroy
      File.exist?("#{@docs_dir}/#{@data_file.name}").should == false
    end

    after :each do
      test_files = [ "#{@docs_dir}/test.txt" ]
      test_files.each { |f| File.delete(f) if File.exist?(f) }
    end
  end
end
