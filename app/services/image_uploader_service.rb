class ImageUploaderService
  # I know it would have been better of to let
  # active storage handle all the image uploads
  # I just want to queue them up inside jobs

  def self.upload_model_image(image:, model_class:, model_id:, attribute_name:)
    image_url = upload(image)
    model = model_class.find(model_id)
    model.update!(attribute_name => image_url)
    image_url
  rescue StandardError => e
    Rails.logger.error("Error uploading image: #{e.message}")
  end

  private

  def self.upload(image)
    response =
      Cloudinary::Uploader.upload(
        image,
        options = {
          folder: "airbnb-clone/items",
          width: 1000,
          height: 500,
          crop: "limit"
        }
      )
    response["url"]
  end
end
