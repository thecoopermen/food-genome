class PhotosController < ApplicationController
  respond_to :json

  def index
    photos = flickr.photos.search(text: params[:q]).map do |photo|
      "http://farm#{photo["farm"]}.staticflickr.com/#{photo["server"]}/#{photo["id"]}_#{photo["secret"]}_z.jpg"
    end
    respond_with photos
  end
end
