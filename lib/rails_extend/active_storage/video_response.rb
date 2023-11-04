# frozen_string_literal: true

# should include manually
module RailsExtend::VideoResponse
  extend ActiveSupport::Concern

  included do
    after_action :wrap_video
  end

  def wrap_video
    if ['video/mp4'].include? self.response.media_type
      add_range_headers
    end
  end

  def add_range_headers
    file_size = self.response.body.size
    match = request.headers['range'].to_s.match(/bytes=(\d+)-(\d*)/)
    match = Array(match)
    file_begin = match[1].presence
    file_end = match[2].presence
    if file_begin && file_end
      response.header['Content-Range'] = 'bytes ' + file_begin.to_s + '-' + file_end.to_s + '/' + file_size.to_s
      response.header['Content-Length'] = (file_end.to_i - file_begin.to_i + 1).to_s
      response.status = 206
    end
  end

end
